#! /usr/bin/env nix-shell
#! nix-shell -p "haskellPackages.ghcWithPackages (p: with p; [turtle optparse-applicative])" -i runghc
-- Usage: hey [global-options] [command] [sub-options]

-- Available Commands:
--   check                  Run 'nix flake check' on your dotfiles
--   gc                     Garbage collect & optimize nix store
--   generations            Explore, manage, diff across generations
--   help [SUBCOMMAND]      Show usage information for this script or a subcommand
--   rebuild                Rebuild the current system's flake
--   repl                   Open a nix-repl with nixpkgs and dotfiles preloaded
--   rollback               Roll back to last generation
--   search                 Search nixpkgs for a package
--   show                   [ARGS...]
--   ssh HOST [COMMAND]     Run a bin/hey command on a remote NixOS system
--   swap PATH [PATH...]    Recursively swap nix-store symlinks with copies (and back).
--   test                   Quickly rebuild, for quick iteration
--   theme THEME_NAME       Quickly swap to another theme module
--   update [INPUT...]      Update specific flakes or all of them
--   upgrade                Update all flakes and rebuild system

-- Options:
--     -d, --dryrun                     Don't change anything; perform dry run
--     -D, --debug                      Show trace on nix errors
--     -f, --flake URI                  Change target flake to URI
--     -h, --help                       Display this help, or help for a specific command
--     -i, -A, -q, -e, -p               Forward to nix-env

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}


import Options.Applicative
import Data.Semigroup ((<>))
import Data.Text (Text, unwords, split, pack, unpack)
import Data.Text.IO (writeFile)
import Language.Haskell.TH.Syntax (loc_filename, qRunIO, runIO, location)
import Data.Bool (bool)
import Data.Maybe (fromMaybe)
import System.Environment (getExecutablePath, lookupEnv, setEnv)
import System.Directory (canonicalizePath)
import System.FilePath (takeDirectory, (</>))
import Control.Monad (liftM)
import Turtle hiding (switch, update, FilePath, (</>))
import Prelude hiding (unwords, writeFile, (</>))


data GlobalOptions = GlobalOptions
  { dryRunGO :: Bool
  , debugGO :: Bool
  , flakeGO :: Maybe Text
  } deriving (Show)

data SanitizedOptions = SanitizedOptions
  { dryRunSO :: Bool
  , debugSO :: Bool
  , flakeSO :: Text
  , hostSO :: Text
  } deriving (Show)

data GenArgs = GenDiff Int Int | GenList | GenSwitch Int | GenRemove [Text]
  deriving (Show)

data RebuildArgs = RebuildArgs
  {
    buildhostRA :: Maybe Text
  , buildtargetRA :: Maybe Text
  , userRA :: Bool
  , fastRA :: Bool
  } deriving (Show)

data Command
  = Check
  | Gc { gc_all :: Bool, gc_system :: Bool }
  | Generations GenArgs
  | Rebuild RebuildArgs
  | Repl [Text]
  | Rollback
  | Search [Text]
  | Show
  | Ssh Text (Maybe Text)
  | Swap [Text]
  | Test [Text]
  | Theme Text
  | Update [Text]
  | Upgrade
  deriving (Show)

globalOptions :: Parser GlobalOptions
globalOptions = GlobalOptions
  <$> switch
    ( long "dryrun"
   <> short 'd'
   <> help "Don't change anything; perform dry run" )
  <*> switch
    ( long "debug"
   <> short 'D'
   <> help "Show trace on nix errors" )
  <*> optional (strOption
    ( long "flake"
   <> short 'f'
   <> help "Change target flake to URI" ))

mkCmd :: String -> String -> Parser a -> Mod CommandFields a
mkCmd name desc parser = command name (info parser (progDesc desc))

withArgs = many (strArgument (metavar "ARGS..."))

commandParser :: Parser Command
commandParser = hsubparser
  ( mkCmd "check" "Run 'nix flake check' on your dotfiles"
    (pure Check)
  <> mkCmd "gc" "Garbage collect & optimize nix store" (Gc <$>
       switch ( long "all"
             <> short 'a'
             <> help "Garbage collect all generations" )
      <*> switch ( long "system"
                 <> short 's'
                  <> help "Garbage collect system generations" )
      )
  <> mkCmd "generations" "Explore, manage, diff across generations"
    (Generations <$>
       subparser
         (  mkCmd "list" "List all generations"
            (pure GenList)
         <> mkCmd "remove" "Remove specific generations"
            (GenRemove <$> many (strArgument (metavar "GEN...")))
         <> mkCmd "switch" "Switch to a specific generation"
            (GenSwitch <$> argument auto (metavar "GEN"))
         <> mkCmd "diff" "Diff between two generations"
            (GenDiff <$> argument auto (metavar "GEN1") <*> argument auto (metavar "GEN2"))
         ))
  <> mkCmd "rebuild" "Rebuild the current system's flake"
    (Rebuild <$>
        (RebuildArgs
         <$> optional (strOption ( long "build-host"
                              <> short 'H'
                              <> help "Where to build the flake" ))
         <*> optional (strOption ( long "build-target"
                              <> short 'T'
                              <> help "Where to deploy the built derivation" ))
         <*> switch ( long "user"
                  <> short 'u'
                  <> help "Build as user, not as root" )
         <*> switch ( long "fast"
                  <> short 'f'
                  <> help "Equivalent to --no-build-nix --show-trace" ))
      )
  <> mkCmd "repl" "Open a nix-repl with nixpkgs and dotfiles preloaded" (Repl <$> withArgs)
  <> mkCmd "rollback" "Roll back to last generation" (pure Rollback)
  <> mkCmd "search" "Search nixpkgs for a package" (Search <$> withArgs)
  <> mkCmd "show" "" (pure Show)
  <> mkCmd "ssh" "Run a bin/hey command on a remote NixOS system"
    (Ssh <$> strArgument (metavar "HOST") <*> optional (strArgument (metavar "COMMAND")))
  <> mkCmd "swap" "Recursively swap nix-store symlinks with copies (and back)."
    (Swap <$> withArgs)
  <> mkCmd "test" "Quickly rebuild, for quick iteration"
    (Test <$> withArgs)
  <> mkCmd "theme" "Quickly swap to another theme module"
    (Theme <$> strArgument (metavar "THEME_NAME"))
  <> mkCmd "update" "Update specific flakes or all of them"
    (Update <$> withArgs)
  <> mkCmd "upgrade" "Update all flakes and rebuild system"
    (pure Upgrade)
  )

getHost :: IO Text
getHost = do
  host <- fmap pack <$> lookupEnv "HOST"
  host_alt <- hostname
  return $ fromMaybe host_alt host

-- | Get the directory of the source file at compile time
sourceDir :: FilePath
sourceDir = $(do
  loc <- location
  dir <- runIO $ canonicalizePath (takeDirectory (loc_filename loc))
  [| dir |]
  )

sanitizeOptions :: GlobalOptions -> IO SanitizedOptions
sanitizeOptions opts = do
  (flake, host) <- (case flakeGO opts of
                     Just f ->
                       let splitted = split (== '#') f
                       in case splitted of
                         (flake:host: _) -> return (flake, host)
                         _ -> (f, ) <$> getHost
                     Nothing -> do
                       echo "No flake specified, using default"
                       (pack $ sourceDir </> "../", ) <$> getHost)
  flake <- canonicalizePath . unpack $ flake
  return $ SanitizedOptions (dryRunGO opts) (debugGO opts) (pack flake) host


data Options = Options
  { globalOpts :: GlobalOptions
  , cmd :: Command
  } deriving (Show)

optsParser :: Parser Options
optsParser = Options
  <$> globalOptions
  <*> commandParser

handleCmd :: SanitizedOptions -> Command -> IO ExitCode
handleCmd opts Check = user ["nix flake check", flakeSO opts]
handleCmd _ c@Gc {} = garbageCollect c
handleCmd _ (Generations gs) = generations gs
handleCmd opts (Rebuild rs) = rebuild' opts rs
handleCmd opts (Repl args) = do
  let tmp = "/tmp/dotfiles-repl.nix"
  writeFile tmp $ unwords ["(builtins.getFlake", flakeSO opts, ")"]
  user $ ["nix repl", "<nixpkgs>", pack tmp] <> args
handleCmd opts Rollback = rebuild user opts ["switch", "--rollback"]
handleCmd _ (Search args) = user $ ["nix search", "nixpkgs"] <> args
handleCmd opts Show = user ["nix", "show", flakeSO opts]
handleCmd _ (Ssh _ _) = die "Command not implemented"
handleCmd _ (Swap _) = die "Command not implemented"
handleCmd opts (Test args) = rebuild user opts $ ["--fast", "test"] <> args
handleCmd opts (Theme t) = do
  setEnv "THEME" (unpack t)
  rebuild user opts ["--fast", "test"]
handleCmd opts (Update args) = update args $ flakeSO opts
handleCmd opts Upgrade = update [] (flakeSO opts) >> rebuild user opts ["switch"]
-- handleCmd Gc = shell "nix-collect-garbage" empty

sudo :: [Text] -> IO ExitCode
sudo cmd = shell (unwords $ "sudo ":cmd) empty

user :: [Text] -> IO ExitCode
user cmd = shell (unwords cmd) empty

rebuild :: ([Text] -> IO ExitCode) -> SanitizedOptions -> [Text] -> IO ExitCode
rebuild cmd opts args = do
  cmd $ ["nixos-rebuild",
         "--flake", flakeSO opts <> "?submodules=1" <> "#" <> hostSO opts,
         "--impure"
        ] <> args

rebuild' :: SanitizedOptions -> RebuildArgs -> IO ExitCode
rebuild' opts rargs = do
  let args = [ "switch" ]
               <> maybe [] (\h -> ["--build-host", h]) (buildhostRA rargs)
               <> maybe [] (\t -> ["--build-target", t]) (buildtargetRA rargs)
               <> bool [] ["--show-trace"] (debugSO opts)
               <> bool [] ["--fast"] (fastRA rargs)
  rebuild (bool sudo user $ userRA rargs) opts args

generations :: GenArgs -> IO ExitCode
generations ga = let systemProfile = "/nix/var/nix/profiles/system"
  in case ga of
    GenList ->
      sudo ["nix-env", "--list-generations", "--profile", systemProfile]
    GenRemove gens -> do
      sudo $ ["nix-env", "--delete-generations", systemProfile] <> gens
    GenSwitch gen -> do
      echo "Switching to generation... (TODO)"
      return $ ExitFailure 1
    GenDiff a b ->
       if b <= a then do
         echo "Second generation must be greater than the first."
         return $ ExitFailure 1
       else do
         sudo ["nix-env", "--compare-generations", systemProfile, pack $ show a, pack $ show b]

garbageCollect (Gc all system) = do
  if all || system then do
    echo "Cleaning up system profile..."
    sudo ["nix-collect-garbage -d"]
    sudo ["nix-store --optimise"]
    -- TODO: clear out left-over secrets.
        -- if File.exists?("/run/secrets/*")
        --         sh %w{rm -rf /run/secrets/*}, sudo: true
        -- end
        -- # nix-collect-garbage is a Nix tool, not a NixOS tool. It won't delete old
        -- # boot entries until you do a nixos-rebuild (which means we'll always have
        -- # 2 boot entries at any time). Instead, we properly delete them by
        -- # reloading the current environment.
        -- sh %w{/nix/var/nix/profiles/system/bin/switch-to-configuration switch}, sudo: true
  else if all || not system then do
    echo "Cleaning up user profiles..."
    user ["nix-collect-garbage", "-d"]
  else do
    exit (ExitFailure 1)


update [] flake = do
  echo "Updating all flakes..."
  user ["nix flake update", flake, "--impure"]
update inputs flake = do
  user [ "nix flake lock", "--impure",
         flake,
         unwords $ map ("--update-input " <>) inputs
       ]

-- ssh args = do
--   let


main :: IO ExitCode
main = do
  parsed <- customExecParser (prefs showHelpOnEmpty) opts
  opts <- sanitizeOptions . globalOpts $ parsed
  exitCode <- handleCmd opts $ cmd parsed
  exit exitCode
  where
    opts = info (optsParser <**> helper)
      (  fullDesc
      <> progDesc "nix-sm - A command line tool for managing NixOS systems"
      )
