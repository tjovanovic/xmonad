-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

-- This is setup for dual 1920x1080 monitors, with the right monitor as primary
Config {
    bgColor = "#1E1E1E",
    fgColor = "#ffffff",
    font = "xft:Roboto:normal:size=10:antialias=true",lowerOnStart = True,
    commands = [
        Run Memory ["-t","Mem:<usedratio>%","-H","50","-L","10",
                    "-h","#FF8500","-l","#8CC4FF","-n","#8CC4FF"] 15,
        Run Cpu ["-t","CPU:<total>%","-H","60","-L","20","-h","#FF8500",
                 "-l","#8CC4FF","-n","#CCCC00"] 15,
        Run Network "wlp3s0" ["-t","Net:<rx>rx,<tx>tx","-H","500","-L","20",
                              "-h","#FF8500","-l","#8CC4FF","-n","#CCCC00"] 10,
        Run Date "%a    %Y-%m-%_d    %b   %H:%M" "date" 10,
        Run Com "/bin/sh" ["-c","~/.xmonad/battscript.sh"] "battery" 20,
        Run Com "/bin/sh" ["-c","~/.xmonad/volscript.sh"] "vol" 5,
        Run Com "/bin/sh" ["-c","~/.xmonad/wifiscript.sh"] "radio" 20,
        Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{"
    template = "    %StdinReader% }  %date%  {  %memory%    %cpu%",
    position = TopW C 100
}
