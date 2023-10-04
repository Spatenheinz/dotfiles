module SystemVar where
import XMonad

xmonadBin, propLight, propSound, propLeft :: String
xmonadBin = "$DOTFILES_BIN/xmonad/"
propLight = "_XMONAD_LOG_LIGHT"
propSound = "_XMONAD_LOG_SOUND"
propLeft = "_XMONAD_LOG_TOP_LEFT"

myModMask, altMask :: KeyMask
myModMask = mod4Mask
altMask = mod1Mask -- Setting this for use in xprompts

myFont, myFontSmall :: String
myFont = "xft:Iosevka:weight=bold:size=14:antialias=true:hinting=true"
myFontSmall = "xft:Iosevka:weight=bold:size=9:antialias=true:hinting=true"

myTerminal, myEditor :: String
myTerminal = "kitty"
myEditor = "emacsclient -c -a emacs "

myBorderWidth :: Dimension
myBorderWidth = 0

myClickJustFocuses :: Bool
myClickJustFocuses = False

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myWorkspaces :: [String]
myWorkspaces    = [ "1", "2", "3", "4", "5", "6", "7", "8", "9"]
