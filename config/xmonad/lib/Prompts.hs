{-# LANGUAGE LambdaCase #-}
module Prompts where

import XMonad
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Input
import qualified XMonad.Actions.Search as S

import Theme
import SystemVar
import Data.Char (toLower)
import qualified Data.Map.Strict as M
import Control.Arrow (first)
import qualified XMonad.StackSet as W

archwiki, reddit :: S.SearchEngine
archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="
reddit = S.searchEngine "reddit" "https://www.reddit.com/search/?q="
nixpkgs = S.searchEngine "nixpkgs" "https://search.nixos.org/packages?channel=23.05&sort=relevance&type=packages&query="
nixOptions = S.searchEngine "nixOptions" "https://search.nixos.org/options?channel=23.05&sort=relevance&type=packages&query="

searchList :: [(String, S.SearchEngine)]
searchList =
  [ ("a", archwiki),
    ("g", S.google),
    ("h", S.hoogle),
    ("r", reddit),
    ("y", S.youtube),
    ("m", S.multi),
    ("s", S.stackage),
    ("p", S.hackage),
    ("n", nixpkgs),
    ("o", nixOptions)

  ]

searchPrompts :: (String -> X ()) -> X ()
searchPrompts t = do
  inputPromptWithCompl myXPConfig "Engine" (complete searches) ?+ t

selectSearch :: String -> X ()
selectSearch str = (\case Just str' -> S.selectSearch str'; Nothing -> return ()) (lookup str searchList)

promptSearch :: String -> X ()
promptSearch str = (\case Just str' -> S.promptSearch myXPConfig' str'; Nothing -> return ()) (lookup str searchList)

searches :: [String]
searches = map createString searchList

createString :: (String, S.SearchEngine) -> String
createString (s,S.SearchEngine n _) = take 100 . unwords $ [s, " >> ", n] ++ replicate 100 " "

complete :: [String] -> String -> IO [String]
complete l "" = return l
complete _l x = if lowerX `elem` map fst searchList
                then return [lowerX] else return []
  where lowerX = map toLower x

myXPConfig :: XPConfig
myXPConfig =
  def
    { font = myFont,
      bgColor = bg,
      fgColor = fg,
      bgHLight = bg,
      fgHLight = fg,
      borderColor = Theme.border,
      promptBorderWidth = 0,
      promptKeymap = myXPKeymap,
      position = CenteredAt { xpCenterY = 0.3, xpWidth = 0.3 },
      height = 30,
      historySize = 256,
      historyFilter = id,
      defaultText = [],
      autoComplete = Just 100000, -- set Just 100000 for .1 sec
      showCompletionOnTab = False,
      searchPredicate = fuzzyMatch,
      alwaysHighlight = True,
      maxComplRows = Just 25 -- set to Just 5 for 5 rows
    }

-- The same config above minus the autocomplete feature which is annoying
-- on certain Xprompts, like the search engine prompts.
myXPConfig' :: XPConfig
myXPConfig' =
  myXPConfig
    { autoComplete = Nothing
    }

myXPKeymap :: M.Map (KeyMask, KeySym) (XP ())
myXPKeymap =
  M.fromList $
    map
      (first $ (,) controlMask) -- control + <key>
      [ (xK_z, killBefore), -- kill line backwards
        (xK_k, killAfter), -- kill line forwards
        (xK_a, startOfLine), -- move to the beginning of the line
        (xK_e, endOfLine), -- move to the end of the line
        (xK_m, deleteString Next), -- delete a character foward
        (xK_b, moveCursor Prev), -- move cursor forward
        (xK_f, moveCursor Next), -- move cursor backward
        (xK_BackSpace, killWord Prev), -- kill the previous word
        (xK_y, pasteString), -- paste a string
        (xK_g, quit), -- quit out of prompt
        (xK_bracketleft, quit)
      ]
      ++ map
        (first $ (,) altMask) -- meta key + <key>
        [ (xK_BackSpace, killWord Prev), -- kill the prev word
          (xK_f, moveWord Next), -- move a word forward
          (xK_b, moveWord Prev), -- move a word backward
          (xK_d, killWord Next), -- kill the next word
          (xK_n, moveHistory W.focusUp'), -- move up thru history
          (xK_p, moveHistory W.focusDown') -- move down thru history
        ]
      ++ map
        (first $ (,) 0) -- <key>
        [ (xK_Return, setSuccess True >> setDone True),
          (xK_KP_Enter, setSuccess True >> setDone True),
          (xK_BackSpace, deleteString Prev),
          (xK_Delete, deleteString Next),
          (xK_Left, moveCursor Prev),
          (xK_Right, moveCursor Next),
          (xK_Home, startOfLine),
          (xK_End, endOfLine),
          (xK_Down, moveHistory W.focusUp'),
          (xK_Up, moveHistory W.focusDown'),
          (xK_Escape, quit)
        ]
