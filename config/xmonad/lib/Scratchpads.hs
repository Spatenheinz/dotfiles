module Scratchpads where
import XMonad
import XMonad.Util.NamedScratchpad
import SystemVar
import qualified XMonad.StackSet as W

myScratchPads :: [NamedScratchpad]
myScratchPads =
  [ NS "terminal" spawnTerm findTerm manageTerm,
    NS "spotify" "spotify" (appName =? "spotify") manageTerm
  ]
  where
    spawnTerm = myTerminal ++ " --class scratchpad_term"
    findTerm = resource =? "scratchpad_term"
    manageTerm = customFloating $ W.RationalRect l t w h
      where
        h = 0.9
        w = 0.9
        t = 0.95 - h
        l = 0.95 - w
