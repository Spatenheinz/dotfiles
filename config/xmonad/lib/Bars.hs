{-# LANGUAGE BangPatterns #-}
module Bars(statusBars) where

import XMonad
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.NamedScratchpad (scratchpadWorkspaceTag)
import XMonad.Util.Loggers

import Theme
import SystemVar
import XMonad.Hooks.Modal (logMode)

statusBars :: StatusBarConfig
statusBars = xmobarTopL <> xmobarTopC <> xmobarTopR

xmobarTopL, xmobarTopC, xmobarTopR :: StatusBarConfig
xmobarTopL =
  let !cfg = mkXmobarInstance  "~/dotfiles/config/xmobar/xmobarTopLeft" ""
  in statusBarPropTo propLeft cfg (pure ppTopLeft)
xmobarTopC =
  let !cfg = mkXmobarInstance  "~/dotfiles/config/xmobar/xmobarTopMid" ""
  in statusBarProp cfg (pure ppTopLeft)
xmobarTopR =
  let !cfg = mkXmobarInstance "~/dotfiles/config/xmobar/xmobarTopRight" ""
      properties = [propLight, propSound]
      pretty = map pure [ppLight, ppVol]
  in statusBarPropToList (zip properties pretty) cfg

-- | Like 'statusBarPropTo', but lets you define multiple properties
statusBarPropToList :: [(String, X PP)] -- ^ Properties and Pretty printing option
                                        --   to write the string to
                    -> String           -- ^ The command line to launch the status bar
                    -> StatusBarConfig
statusBarPropToList props cmd =
  statusBarGeneric cmd $ mapM_ (\(p,pp) -> pp >>= dynamicLogString >>= xmonadPropLog' p) props

mkXmobarInstance :: String -> String -> String
mkXmobarInstance configFile template =
  let bgStr = "-B " ++ asStrLit bg
      fgStr = "-F " ++ asStrLit fg
      monitor = "-x 0"
      t = if null template then "" else "-t " ++ asStrLit template
  in unwords ["xmobar", bgStr, fgStr, monitor, t, configFile]

myXmobarModifier :: Int -> String -> String -> String -> String
myXmobarModifier fmt fg bg = xmobarFont fmt . xmobarColor fg bg

ghostIcon :: String
ghostIcon = "\xf6e2 "

fishIcon :: String
fishIcon = "\xf578 "

exclamIcon :: String
exclamIcon = "\xf06a"

ppTopLeft :: PP
ppTopLeft =
  filterOutWsPP [scratchpadWorkspaceTag] $
  def
  {
    ppCurrent = const $ myXmobarModifier 2 magenta mempty fishIcon,
    ppHidden  = const $ myXmobarModifier 2 cyan mempty fishIcon,
    ppHiddenNoWindows = const $ myXmobarModifier 3 yellow mempty ghostIcon,
    ppUrgent = const $ myXmobarModifier 2 red mempty exclamIcon,
    ppExtras = [logMode],
    ppOrder = \(ws : _ : _ : ex) -> ws:ex
 }



-- Volume
myVol :: Logger
myVol = logCmd "$DOTFILES_BIN/xmonad/volume_get"

ppVol :: PP
ppVol =
  def
  {
    ppExtras = [myVol],
    ppOrder = \(_:_:_:exs) -> exs,
    ppSep = ""
  }

-- Light
myLight :: Logger
myLight = logCmd "$DOTFILES_BIN/xmonad/brightness_get"

ppLight :: PP
ppLight =
  ppVol
  {
    ppExtras = [myLight]
  }

-- Utils
asStrLit :: String -> String
asStrLit s = "\"" ++ s ++ "\""
