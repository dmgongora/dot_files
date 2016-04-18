import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
    xmproc <- spawnPipe "xmobar"	-- Fire up xmobar and pass to it a command-line argument
    xmonad $ defaultConfig
        { terminal = "xfce4-terminal"
	, manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
	, logHook = takeTopFocus <+> dynamicLogWithPP xmobarPP 
	  	  {	  ppOutput = hPutStrLn xmproc	-- transmit data via a pipe to xmobar
	  	  ,	  ppTitle = xmobarColor "green" "" . shorten 50
		  }
	, modMask = mod4Mask	    -- Rebind Mod to the Windows key
	, startupHook = do
	      spawn "/home/dan/fix_scr_res.sh"
        }
