{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -Wno-missing-safe-haskell-mode #-}
module Paths_my_xmonad (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/jacob/dotfiles/config/xmonad/.stack-work/install/x86_64-linux-nix/adbcc41dda446ab59fdd676f62c04f24708f8a818c25cdf89bfa00089133be00/9.0.2/bin"
libdir     = "/home/jacob/dotfiles/config/xmonad/.stack-work/install/x86_64-linux-nix/adbcc41dda446ab59fdd676f62c04f24708f8a818c25cdf89bfa00089133be00/9.0.2/lib/x86_64-linux-ghc-9.0.2/my-xmonad-0.1.0.0-Fok57R93oPf3OAN1xJ3icS"
dynlibdir  = "/home/jacob/dotfiles/config/xmonad/.stack-work/install/x86_64-linux-nix/adbcc41dda446ab59fdd676f62c04f24708f8a818c25cdf89bfa00089133be00/9.0.2/lib/x86_64-linux-ghc-9.0.2"
datadir    = "/home/jacob/dotfiles/config/xmonad/.stack-work/install/x86_64-linux-nix/adbcc41dda446ab59fdd676f62c04f24708f8a818c25cdf89bfa00089133be00/9.0.2/share/x86_64-linux-ghc-9.0.2/my-xmonad-0.1.0.0"
libexecdir = "/home/jacob/dotfiles/config/xmonad/.stack-work/install/x86_64-linux-nix/adbcc41dda446ab59fdd676f62c04f24708f8a818c25cdf89bfa00089133be00/9.0.2/libexec/x86_64-linux-ghc-9.0.2/my-xmonad-0.1.0.0"
sysconfdir = "/home/jacob/dotfiles/config/xmonad/.stack-work/install/x86_64-linux-nix/adbcc41dda446ab59fdd676f62c04f24708f8a818c25cdf89bfa00089133be00/9.0.2/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "my_xmonad_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "my_xmonad_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "my_xmonad_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "my_xmonad_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "my_xmonad_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "my_xmonad_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
