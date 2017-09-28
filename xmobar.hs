-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

-- This is setup for dual 1920x1080 monitors, with the right monitor as primary
Config {
    bgColor = "#1E1E1E",
    fgColor = "#FFFFFF",
    font = "xft:DejaVuSans:normal:size=10:antialias=true",lowerOnStart = True,
    commands = [
        Run Memory ["-t","Mem:<usedratio>%","-H","50","-L","10",
                    "-h","#FF8500","-l","#8CC4FF","-n","#8CC4FF"] 15,
        Run Cpu ["-t","CPU:<total>%","-H","60","-L","20","-h","#FF8500",
                 "-l","#8CC4FF","-n","#CCCC00"] 15,
        Run Network "enp0s31f6" ["-t","Net:<rx>rx,<tx>tx","-H","500","-L","20",
                              "-h","#FF8500","-l","#8CC4FF","-n","#CCCC00"] 10,
        Run Date "%a  %Y-%m-%_d  %b %H:%M" "date" 10,
        Run Com "/bin/sh" ["-c","~/.xmonad/battscript.sh"] "battery" 20,
        Run Com "/bin/sh" ["-c","~/.xmonad/volscript.sh"] "vol" 5,
        Run Com "/bin/sh" ["-c","~/.xmonad/wifiscript.sh"] "radio" 20,
        Run Com "/bin/bash" ["-c","python ~/.xmonad/userscript.py"] "users" 5,
        Run Com "/bin/sh" ["-c", "~/.xmonad/updatescript.sh"] "update" 600,
        Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "    %StdinReader% }  %date%  {  %memory%    %cpu%    %enp0s31f6%    %vol%    ",
    position = TopW C 100
}
