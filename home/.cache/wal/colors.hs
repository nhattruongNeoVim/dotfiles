--Place this file in your .xmonad/lib directory and import module Colors into .xmonad/xmonad.hs config
--The easy way is to create a soft link from this file to the file in .xmonad/lib using ln -s
--Then recompile and restart xmonad.

module Colors
    ( wallpaper
    , background, foreground, cursor
    , color0, color1, color2, color3, color4, color5, color6, color7
    , color8, color9, color10, color11, color12, color13, color14, color15
    ) where

-- Shell variables
-- Generated by 'wal'
wallpaper="/home/albedo/dotfiles/home/Pictures/wallpapers/night_anime.jpg"

-- Special
background="#090a0c"
foreground="#9eaabc"
cursor="#9eaabc"

-- Colors
color0="#090a0c"
color1="#384358"
color2="#3A4E6A"
color3="#4C4F61"
color4="#3D5E85"
color5="#3F6187"
color6="#4F6689"
color7="#9eaabc"
color8="#6e7683"
color9="#384358"
color10="#3A4E6A"
color11="#4C4F61"
color12="#3D5E85"
color13="#3F6187"
color14="#4F6689"
color15="#9eaabc"