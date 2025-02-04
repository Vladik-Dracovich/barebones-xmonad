import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
import XMonad.Layout.ThreeColumns
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Spacing
import qualified XMonad.StackSet as W
import System.IO

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myFocusedBorderColor = "#690fad"



myLayout = tiled ||| Mirror tiled ||| Full ||| threeCol
  where
    threeCol = ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes


myStartupHook :: X ()
myStartupHook = do
  spawnOnce "xmobar ~/.xmobarrc"
  spawnOnce "nitrogen --restore &"
  spawnOnce "picom --config ~/.config/picom/picom.conf"
  spawnOnce " nm-applet --sm-disable& "
  spawnOnce "blueman-applet &"
  spawnOnce "trayer --edge top --align right --SetDockType true \
            \--SetPartialStrut true  --expand true --width 4 \
            \--transparent false --tint 0x000000 --height 16"

     
main = do
  xmproc <- spawnPipe "xmobar ~/.xmobarrc"
  xmonad $ ewmh def 
    { modMask = mod1Mask, 
      startupHook = myStartupHook,
      focusedBorderColor = myFocusedBorderColor,    
      terminal = "urxvt",
      manageHook = manageDocks <+> manageHook def,
      layoutHook = avoidStruts $ myLayout,    
      logHook = dynamicLogWithPP $ xmobarPP
                      {   ppOutput = hPutStrLn xmproc,
                          ppCurrent = xmobarColor "#690fad" "" . wrap "[" "]",
                          ppVisible = xmobarColor "#46a8c3" "" . wrap "" "",
                          ppHidden = xmobarColor "#890fad" "" . wrap "" "",
                          ppHiddenNoWindows = xmobarColor "#2f343f" "",
                          ppOrder = \(ws:l:t:ex) -> [ws,l]++ex++[t],
                          ppTitle = xmobarColor "#690fad" "" . shorten 50
                       } 
                    } 
                    `additionalKeysP` myKeys
            

--Helpful Xmonad Keybinds
--
--MODKEY + SHIFT + r = recompile Xmonad
--MODKEY + SHIFT + q = exit Xmonad
-- MODKEY + SPACE = Fullscreen Toggle
-- MODKEY + t = Change Floating Window back to Tile
-- MODKEY + h = shrink window
-- MODKEY + l = expand window
-- MODKEY + TAB = Rotate Layout
--MODKEY + j = windows focus down
--MODKEY + k = windows focus up
--MODKEY + SHIFT + j = windows swap down
--MODKEY + SHIFT + k = windows swap up
--MODKEY + SHIFT + ENTER = Spawn Terminal
--MODKEY + , or . = Switch windows between horizonal and vertical
--MODKEY + SHIFT + c = close focused window
--MODKEY + 1-9 = switch workspace






myKeys =           --Spawn Programs
           [ ("M-p", spawn "rofi -show window")
            , ("M-S-e",  spawn "emacs"        )
          , ("M-S-f"  , spawn "firefox"       )
          , ("M-S-a" , spawn "pavucontrol"    )
          , ("M-s" , spawn "steam"            )
          , ("M-S-t" , spawn "thunar"         )
          , ("M-S-n" , spawn "nitrogen"       )
          , ( "M-Shift-v" , spawn "virt-manager"  )
          , ("M-C-p" , spawn "PCSX2"          )
          , ("M-C-d" , spawn "dolphin-emu"    )
          , ("M-m"   , spawn "openmw-launcher")
          , ("M-S-v" , spawn "vlc"            )
         ]
