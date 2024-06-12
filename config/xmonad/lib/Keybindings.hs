module Keybindings(yad, myKeys, modalModes) where

import XMonad
import XMonad.Util.NamedActions
import XMonad.Util.Run (spawnPipe, hPutStr)
import System.IO (hClose)
import XMonad.Util.EZConfig
import SystemVar
import System.Exit (exitSuccess)
import XMonad.Util.NamedScratchpad (namedScratchpadAction)
import Prompts
import XMonad.Actions.CopyWindow
import XMonad.Actions.WithAll
import qualified XMonad.StackSet as W
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves
import XMonad.Hooks.ManageDocks (ToggleStruts(..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(..))
import XMonad.Layout.SubLayouts
import XMonad.Actions.Submap
import XMonad.Prelude
import Scratchpads
import Theme
import XMonad.Layout.WindowNavigation (Direction2D(..), Navigate (..))
import XMonad.Actions.EasyMotion
import qualified XMonad.Actions.EasyMotion as EM
import XMonad.Actions.PerLayoutKeys (bindByLayout)
import XMonad.Hooks.Modal

-- For the showing of KB
myKeys :: XConfig l -> [((KeyMask, KeySym), NamedAction)]
myKeys c = concat
            [ subtitle "XMonad Keys":xmonadkeys
            , subtitle "Terminal, Prompts and scratchpads":tps
            , subtitle "Windows":window
            , subtitle "Window Navigation":nav
            , subtitle "Layouts":layout
            , subtitle "Multimedia":media
            ]
  where
    mkNamedKeymap' = mkNamedKeymap c
    xmonadkeys = mkNamedKeymap'
                  [ ("M-S-r", addName "Recompile xmonad & restart server" $ spawn $ xmonadBin <> "xmonad_restart")
                  , ("M-<Escape>", addName "Manage session" $ spawn $ rofiBin <> "powermenu")
                  ]
    tps        = mkNamedKeymap'
                  [ ("M-<Return>",   addName "Terminal" $ spawn myTerminal)
                  , ("M-S-<Return>", addName "Run-prompt" $ spawn "rofi -show drun")
                  , ("M-C-<Return>", addName "Terminal scratchpad" $ namedScratchpadAction myScratchPads "terminal")
                  , ("M-C-\\",       addName "Spotify scrathpad"   $ namedScratchpadAction myScratchPads "spotify")
                  , ("M-S-\\",       addName "Search with clipboard" $ searchPrompts selectSearch)
                  , ("M-\\",         addName "Search by prompt"      $ searchPrompts promptSearch)
                  ]
    window     = mkNamedKeymap'
                  [ ("M-S-q", addName "kill 1" $ kill1)
                  , ("M-S-a", addName "Kill all" $ killAll)
                  , ("M-r", addName "Modal resize" $ setMode "Resize")
                  , ("M-S-w", addName "Window prompt" $ spawn "rofi -show window")
                  ]
    nav        = mkNamedKeymap'
                  [ ("M-m",           addName "Focus master"    $ windows W.focusMaster)
                  , ("M-k",           addName "Focus up"        $
                      bindByLayout [("Grid", sendMessage $ Go U), ("", windows W.focusUp)])
                  , ("M-j",           addName "Focus down"      $
                      bindByLayout [("Grid", sendMessage $ Go U), ("", windows W.focusDown)])
                  , ("M-w",           addName "Change window"
                      (selectWindow easyMotionCfg >>= (`whenJust` windows . W.focusWindow)))
                  , ("M-h",           addName "Focus left"      $ sendMessage $ Go L)
                  , ("M-l",           addName "Focus right"     $ sendMessage $ Go R)
                  -- one for window focus down
                  -- window focus up
                  , ("M-S-j",         addName "Swap next"       $ windows W.swapDown)
                  , ("M-S-k",         addName "Swap prev"       $ windows W.swapUp) -- Swap focused window with prev window
                  , ("M-<Backspace>", addName "Swap master"       promote) -- Moves focused window to master, others maintain order
                  , ("M1-S-<Tab>",    addName "rotate slaves"     rotSlavesDown) -- Rotate all windows except master and keep focus in place
                  ]
    layout     = mkNamedKeymap'
                  [ ("M-<Tab>", addName "Cycle layouts" $ sendMessage NextLayout)-- Switch to next layout
                  , ("M-<Space>", addName "Fullscreen"  $ sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts )-- Toggles noborder/full
                  , ("M-S-<Space>", addName "Toggle Full" $ sendMessage $ MT.Toggle NBFULL) -- Toggles struts
                  -- , ("M-h", addName "shrink width" $ sendMessage $ pushGroup L)
                  -- , ("M-l", addName "shrink width" $ sendMessage $ pushGroup R)
                  -- , ("M-l", addName "expand width" $ sendMessage Expand)
                  -- , ("M-C-j", addName "shrink height" $ sendMessage MirrorShrink)
                  -- , ("M-C-k", addName "expand height" $ sendMessage MirrorExpand)

                  , ("M-C-u", addName "Remove from group" $ withFocused (sendMessage . UnMerge))
                  , ("M-a", addName "MergeAll" $ withFocused $ sendMessage . MergeAll)
                  , ("M-\'",  addName "Cycle through tabs" $ bindOn LD [("Tabs", windows W.focusDown), ("", onGroup W.focusDown')])
                  , ("M-;",   addName "Cycle through tabs" $ bindOn LD [("Tabs", windows W.focusUp), ("", onGroup W.focusUp')])
                  ]
    media      = mkNamedKeymap'
                  [ ("<XF86AudioMute>",        addName "mute"     $ spawn $ unwords [xmonadBin <> "volume", "0" ,"toggle", propSound])
                  , ("<XF86AudioLowerVolume>", addName "incr vol" $ spawn $ unwords [xmonadBin <> "volume", "5" ,"down", propSound])
                  , ("<XF86AudioRaiseVolume>", addName "decr vol" $ spawn $ unwords [xmonadBin <> "volume", "3" ,"up", propSound])
                  -- TODO mic mute
                  , ("<XF86MonBrightnessUp>"  , addName "incr brightness" $ spawn $ unwords [xmonadBin <> "brightness", "5" ,"up", propLight])
                  , ("<XF86MonBrightnessDown>", addName "decr brightness" $ spawn $ unwords [xmonadBin <> "brightness", "5" ,"down", propLight])
                  -- TODO display
                  -- WLAN button can be for shifting keyboards.
                  -- MESSAGES should open some sort of chatting?
                  -- CALL AND HANGUP??
                  -- STAR for bookmarks?
                  ]

resizeMode :: Mode
resizeMode = mode "Resize" $
  mkKeysEz [ ("j", sendMessage Expand)
           , ("k", sendMessage Shrink)
           , ("h", xmessage "resize")
           ]

modalModes :: [Mode]
modalModes = [resizeMode]

data XCond = WS | LD
chooseAction :: XCond -> (String->X()) -> X()
chooseAction WS f = withWindowSet (f . W.currentTag)
chooseAction LD f = withWindowSet (f . description . W.layout . W.workspace . W.current)

bindOn :: XCond -> [(String, X())] -> X()
bindOn xc bindings = chooseAction xc $ chooser where
    chooser xc = case find ((xc==).fst) bindings of
        Just (_, action) -> action
        Nothing -> case find ((""==).fst) bindings of
            Just (_, action) -> action
            Nothing -> return ()

yad :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
yad x = addName "Show Keybindings" $ do
  yadin <- spawnPipe "yad --no-buttons --text-info --back=#282828 --fore=#ebdbb2 --geometry=1200x800"
  io $ do
    hPutStr yadin $ intercalate "\n" $ showKm x
    hClose yadin
  return ()

easyMotionCfg :: EasyMotionConfig
easyMotionCfg = def
  {
    txtCol = red
  , bgCol = bg
  , overlayF = fixedSize (10 :: Integer) (10 :: Integer)
  , borderCol = bg
  , emFont = myFont
  , borderPx = 0
  }
