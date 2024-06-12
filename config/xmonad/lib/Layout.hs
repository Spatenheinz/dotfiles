{-# LANGUAGE FlexibleContexts #-}
module Layout where

import XMonad

-- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Decoration
import XMonad.Layout.SimpleDecoration
import XMonad.Layout.NoFrillsDecoration

import XMonad.Layout.BinarySpacePartition

import XMonad.Layout.Tabbed
import XMonad.Layout.MultiToggle (mkToggle, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import qualified XMonad.Layout.Dwindle as LD
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.WindowArranger (windowArrange)
import XMonad.Layout.ShowWName

import XMonad.Hooks.ManageDocks (avoidStruts)

import Theme
import SystemVar
import XMonad.Layout.Grid (Grid(..))
import XMonad.Layout.Circle

topBarTheme :: Theme
topBarTheme = def
  { fontName = myFontSmall
  , inactiveBorderColor = Theme.border
  , inactiveColor       = bg
  , inactiveTextColor   = fg
  , activeBorderColor   = Theme.border
  , activeColor         = yellow
  , activeTextColor     = bg
  , urgentBorderColor   = warning
  , urgentTextColor     = warning
  , decoHeight          = 10
  }

myTabTheme :: Theme
myTabTheme = def
  { fontName = myFontSmall
  , inactiveBorderColor = Theme.border
  , inactiveColor       = bg
  , inactiveTextColor   = fg
  , activeBorderColor   = orange
  , activeColor         = yellow
  , activeTextColor     = fg
  , urgentBorderColor   = red
  , urgentTextColor     = red
  }

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Iosevka:weight=bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = bg
    , swn_color             = fg
    }

type MyLayoutMod l a = ModifiedLayout Spacing l a
type MyLayoutDeco s l a = XMonad.Layout.LayoutModifier.ModifiedLayout (Decoration NoFrillsDecoration s) l a

mySpacing :: Integer -> l a -> MyLayoutMod l a
mySpacing i = spacingRaw True (Border i i i i) True (Border i i i i) True

tabs :: (Eq a,
 LayoutModifier (Decoration TabbedDecoration DefaultShrinker) a,
 LayoutModifier (Sublayout (ModifiedLayout SmartBorder Simplest)) a,
 LayoutClass l a, Show a, Read a) => l a -> ModifiedLayout
     (Decoration NoFrillsDecoration DefaultShrinker)
     (ModifiedLayout
        WindowNavigation
        (ModifiedLayout
           (Decoration TabbedDecoration DefaultShrinker)
           (ModifiedLayout
              (Sublayout (ModifiedLayout SmartBorder Simplest))
              (ModifiedLayout Spacing l))))
     a
tabs x = noFrillsDeco shrinkText topBarTheme         -- nice top theme
         $ windowNavigation                          -- maybe not necessary
         $ addTabs shrinkText myTabTheme             -- tabs on the sublayout
         $ subLayout [] (smartBorders Simplest)      -- simple sublayout as we want tabs
         $ mySpacing 7 x                              -- small gaps in windows

mySublayout :: l a -> ModifiedLayout
     (Sublayout (ModifiedLayout SmartBorder Simplest))
     (ModifiedLayout Spacing l)
     a
mySublayout = subLayout [] (smartBorders Simplest)      -- simple sublayout as we want tabs
       . mySpacing 7                               -- small gaps in windows

myLayoutHook =
  showWName' myShowWNameTheme $
    avoidStruts $
    mkToggle (NBFULL ?? EOT) $
    smartBorders $
    windowArrange $ tabs myDefaultLayout
  where
     myDefaultLayout = bsp
                       ||| fib
                       ||| Circle
                       ||| Grid
     bsp     = renamed [Replace "bsp"] emptyBSP
     fib     = renamed [Replace "spiral"] $ LD.Spiral LD.R  LD.CW 1.2 0.8
