
import Control.Monad (liftM2)
import System.IO
import System.Exit
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.CopyWindow
import XMonad.Actions.MouseGestures
import XMonad.Actions.SpawnOn
import XMonad.Actions.Warp
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Script
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.MultiToggle
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.NamedScratchpad
import qualified XMonad.Layout.IndependentScreens as LIS
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import Data.String.Utils


------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "gnome-terminal --hide-menubar"

scratchpads = [
    NS "term" "gnome-terminal --hide-menubar --role=scratchpad" (role =? "scratchpad") (customFloating $ W.RationalRect (1/12) (1/12) (5/6) (5/6)),
    NS "afs" "gnome-terminal -e 'bash' --hide-menubar --role=afs" (role =? "afs") (customFloating $ W.RationalRect (1/12) (1/12) (5/6) (5/6)),
    NS "irc" "gnome-terminal --role=irc" (role =? "irc") (customFloating $ W.RationalRect (1/12) (1/12) (5/6) (5/6)),
    NS "applaunch" "xfce4-appfinder -c" (title =? "Application Finder") defaultFloating ,
    NS "notes" "gvim --role notes ~/Dropbox/notes/notes.otl" (role =? "notes") (customFloating $ W.RationalRect (0) (1/20) (2/4) (9/10))]
        where role = stringProperty "WM_WINDOW_ROLE"

------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = map show [1..9]


------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
{-myManageHook = composeAll
    [ resource  =? "desktop_window"   --> doIgnore
    , className =? "stalonetray"      --> doIgnore
    , className =? "plank"            --> doIgnore
      -- Below gets chrome_app_list to properly float
    , (stringProperty "WM_WINDOW_ROLE") =? "bubble"  --> doFloat
    , (stringProperty "WM_WINDOW_ROLE") =? "pop-up"  --> doFloat
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]
-}


myManageHook = composeAll
    ([ 
    -- className =? "Chromium"       --> doShift (browser)
    className =? "Dwb"          --> doShift (browser)
    , resource  =? "desktop_window" --> doIgnore
    -- , className =? "Vlc"             --> doShift (media)
    -- , className =? "Vlc"             --> viewShift (media)
    -- , className =? "MPlayer"        --> doShift (media)
    -- , className =? "mpv"             --> doShift (media)
    -- , className =? "mpv"             --> viewShift (media)
    -- , className =? "MPlayer"        --> viewShift (media)
    -- , className =? "MPlayer"        --> doFloat
    , className =? "Deluge"        --> doShift (myWorkspaces!!4)
    -- , resource  =? "gpicview"       --> doFloat
    , className =? "Vlc"            --> doFloat
    , className =? "mpv"            --> doFloat
    , className =? "Xfce4-appfinder"--> doFloat
    , className =? "VirtualBox"     --> doShift (myWorkspaces!!7)
    , className =? "Thunderbird"     --> doShift (myWorkspaces!!6)
    , className =? "Gnucash"     --> doShift (myWorkspaces!!5)
    , className =? "Thunar"     --> doShift (files)
    , className =? "ROX-Filer"     --> doShift (files)
    , className =? "ROX-Filer"     --> viewShift (files)
    , className =? "MuPDF"     --> doShift (pdfview)
    , className =? "MuPDF"     --> viewShift (pdfview)
    , className =? "Xchat"          --> doShift "5:media"
    , className =? "stalonetray"    --> doIgnore
    , className =? "Orage"    --> doFloat
    , className =? "Xfce4-notifyd" --> doF W.focusDown <+> doF copyToAll
    , stringProperty "WM_NAME" =? "File Operation Progress" --> doFloat
    , stringProperty "WM_NAME" =? "LastPass Site Search" --> doFloat
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]) 
    where
      viewShift = doF . liftM2 (.) W.greedyView W.shift
      browser = myWorkspaces!!1
      pdfview = myWorkspaces!!2
      media = myWorkspaces!!12
      files = myWorkspaces!!9

------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    tabbedBottom shrinkText myTabConfig |||
    -- simpleTabbedBottom |||
    Full |||
    spiral (6/7)) |||
    tabbedBottom shrinkText myTabConfig |||
    noBorders (fullscreenFull Full)


------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the ir_black theme.
--
myNormalBorderColor  = "#181818"
myFocusedBorderColor = "#C0C0C0"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
myTabConfig = defaultTheme {
    activeBorderColor = "#181818",
    activeTextColor = "#FF8500",
    activeColor = "#181818",
    inactiveBorderColor = "#000000",
    inactiveTextColor = "#DDDDDD",
    inactiveColor = "#000000"
}

-- Color of current window title in xmobar.
xmobarTitleColor = "#DDD"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#FF8500"

-- Width of the window border in pixels.
myBorderWidth = 1


------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "super key" is usually mod4Mask.
--
myModMask = mod5Mask

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask .|. shiftMask, xK_Return),
     spawn $ XMonad.terminal conf)

  -- Start EMACS
  , ((modMask, xK_e),
     spawn "emacsclient -c -s /tmp/emacs1000/server")

  -- Start Blender
  , ((modMask, xK_b),
     spawn "blender")

  -- Start GIMP
  , ((modMask, xK_g),
     spawn "gimp")
    
  -- Start Chrome Browser
  , ((modMask, xK_w),
     spawn "google-chrome-stable")
    
  -- Start Vivaldi Browser
  , ((modMask, xK_v),
     spawn "vivaldi")
    
  , ((modMask, xK_c),
     spawn "networkmanager_dmenu")

  -- Lock the screen using xscreensaver.
  , ((modMask .|. controlMask, xK_l),
  --   spawn "gnome-screensaver-command -l")
     spawn "xscreensaver-command -lock")

--  , ((0, xK_grave), namedScratchpadAction scratchpads "term")

  , ((0, xK_F1), namedScratchpadAction scratchpads "term")

  , ((modMask, xK_F1), namedScratchpadAction scratchpads "afs")

  -- Launch dmenu.
  -- Use this to launch programs without a key binding.
  , ((modMask, xK_s),
     spawn "rofi -modi 'run,ssh' -show run")

  -- Take a screenshot in select mode.
  -- After pressing this key binding, click a window, or draw a rectangle with
  -- the mouse.
  --, ((modMask .|. shiftMask, xK_p),
  --   spawn "select-screenshot")

  -- Take full screenshot in multi-head mode.
  -- That is, take a screenshot of everything you see.
  --, ((modMask .|. controlMask .|. shiftMask, xK_p),
  --   spawn "screenshot")

  , ((mod1Mask, xK_space),
     spawn "google-chrome --show-app-list")

  -- MonBrightnessUp
  , ((0, 0x1008FF02),
     spawn "xbacklight -inc 10")

  -- MonBrightnessDown 0x1008FF02
  , ((0, 0x1008FF03),
     spawn "xbacklight -dec 5")

  -- Audio mute toggle
  , ((0, xK_F8 ),
     spawn "amixer -q set Master toggle")

  -- Audio Vol+
  , ((modMask, xK_bracketright ),
     spawn "amixer -q set Master 5%+")
    
  -- Audio Vol-
  , ((modMask, xK_bracketleft ),
     spawn "amixer -q set Master 5%-")

  -- Audio mute toggle (media key)
  , ((0, 0x1008FF12),
     spawn "amixer -q set Master toggle")

  -- Audio Vol+ (media key)
  , ((0, 0x1008FF13),
     spawn "amixer -q set Master 5%+")
    
  -- Audio Vol- (media key)
  , ((0, 0x1008FF11),
     spawn "amixer -q set Master 5%-")
    
  -- Audio previous.
  --, ((0, 0x1008FF16),
  --   spawn "")

  -- Play/pause.
  --, ((0, 0x1008FF14),
  --   spawn "")

  -- Audio next.
  --, ((0, 0x1008FF17),
  --   spawn "")

  -- Eject CD tray.
  --, ((0, 0x1008FF2C),
  --   spawn "eject")

  -- Cycle workspaces left and right
  , ((controlMask .|. mod1Mask, xK_Right),
     nextWS)

  , ((controlMask .|. mod1Mask, xK_Left),
     prevWS)

  -- Move focus to the next window with workspace-like keys
  , ((controlMask .|. mod1Mask, xK_Down),
     windows W.focusDown)

  -- Move focus to the previous window with workspace-like keys
  , ((controlMask .|. mod1Mask, xK_Up),
     windows W.focusUp  )
    
  , ((controlMask .|. mod1Mask .|. shiftMask, xK_Right),
     shiftToNext >> nextWS)

  , ((controlMask .|. mod1Mask .|. shiftMask, xK_Left),
     shiftToPrev >> prevWS)

  , ((modMask, xK_d ),
     windows copyToAll)

  , ((modMask .|. shiftMask, xK_d ),
     killAllOtherCopies)

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  , ((modMask .|. shiftMask, xK_c),
     kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space),
     sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  , ((0, xK_F2),
     setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  , ((modMask, xK_n),
     refresh)

  -- Move focus to the next window.
  , ((modMask, xK_Tab),
     windows W.focusDown)

  -- Move focus to the next window.
  , ((modMask, xK_j),
     windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k),
     windows W.focusUp  )

  -- Move focus to the master window.
  , ((modMask, xK_m),
     windows W.focusMaster  )

  -- Swap the focused window and the master window.
  , ((modMask, xK_Return),
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j),
     windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k),
     windows W.swapUp    )

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_t),
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period),
     sendMessage (IncMasterN (-1)))

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_q),
     io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask, xK_q),
     restart "xmonad" True)
  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
  -- ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  -- [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
  --    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
  --    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]


------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--


------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
myStartupHook :: X ()
myStartupHook = do
  spawn "xscreensaver -no-splash &"
  spawn "feh --bg-scale $HOME/.wall.jpg&"
  spawn "xsetroot -cursor_name left_ptr"
--  spawn "killall nautilus"
--  spawn "rm ~/.config/google-chrome/SingletonLock"
  spawn "setxkbmap us -variant altgr-intl -option ctrl:nocaps"
  spawn "(killall xcape; exit 0)"
  spawn "xcape -e 'Control_L=Escape' -t 500"
  spawn "xss-lock -- xscreensaver-command -lock &"
  spawn "$HOME/.startup_scripts/port_forward_grimes.sh"
  spawn "$HOME/.startup_scripts/port_forward_arbtracker.sh"

  {-spawn "killall stalonetray nm-applet pasystray; stalonetray --icon-size=16 --kludges=force_icons_size --geometry 2x1+3250 -bg \"#1E1E1E\"& nm-applet& pasystray&"-}
--  spawn "~/.dropbox-dist/dropboxd"
  setWMName "LG3D"


------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ defaults {
      logHook = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc . replace " NSP " " "
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = "   "
      }
      , manageHook = manageDocks <+> myManageHook <+> namedScratchpadManageHook scratchpads
      , startupHook = myStartupHook

  }


------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,

-- hooks, layouts
layoutHook         = smartBorders $ myLayout,
manageHook         = myManageHook,
startupHook        = myStartupHook
}
