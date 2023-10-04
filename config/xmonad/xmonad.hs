-- Base
import XMonad

-- Hooks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (docks, manageDocks)
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar (withSB)
import XMonad.Hooks.Modal (modal)

    -- Utilities
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedActions hiding (showKm)

import Keybindings
import Bars
import Theme
import SystemVar
import Scratchpads
import Layout

myManageHook =
  composeAll
    [ className =? "Gimp" --> doFloat
    , className =? "file_progress"   --> doFloat
    , className =? "dialog"          --> doFloat
    , className =? "download"        --> doFloat
    , className =? "error"           --> doFloat
    , className =? "Yad"             --> doCenterFloat
    , className =? "rofi"            --> doCenterFloat
    , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat
    , isFullscreen --> doFullFloat
    , className =? "Modal-exe" --> doCenterFloat
    ] <+> namedScratchpadManageHook myScratchPads

myStartupHook :: X ()
myStartupHook = do
  spawnOnce $ xmonadBin <> "spotify"
  spawnOnce "/usr/bin/emacs --daemon &"
  spawnOnce "picom --config .xmonad/picom.conf &"
  -- spawnOnce "feh --bg-fill ~/.xmonad/mountain.png"
  spawnOnce "dunst -conf ~/.xmonad/bin/dunstrc &"
  spawnOnce "setxkbmap -layout us,dk -option grp:rwin_toggle -option ctrl:nocaps"
  setWMName "LG3D"

main :: IO ()
main = do
  xmonad $
    ewmh $
    docks $
    modal modalModes $
    withSB statusBars $
    addDescrKeys ((myModMask .|. shiftMask, xK_slash), yad) myKeys
      def
        {
          -- Simple
          terminal = myTerminal,
          borderWidth = myBorderWidth,
          modMask = myModMask,
          workspaces = myWorkspaces,
          normalBorderColor = Theme.border,
          focusedBorderColor = Theme.highlight,
          focusFollowsMouse = myFocusFollowsMouse,
          clickJustFocuses = myClickJustFocuses,
          -- Hooks
          manageHook = myManageHook <+> manageDocks,
          -- handleEventHook = fullscreenEventHook,
          startupHook = myStartupHook,
          layoutHook =  myLayoutHook, -- The layouts
          logHook = return ()
          }
