pacman_u=`checkupdates | wc -l`
aur_u=`cower -u --threads=1 | wc -l`

if [ $pacman_u -ge "1" ]; then
    echo "Updates: <fc=#FF0000>$pacman_u ($aur_u)</fc>"
elif [ $aur_u -ge "1" ]; then
    echo "Updates: <fc=#CCCC00>$pacman_u ($aur_u)</fc>"
else 
    echo "Updates: <fc=#4c9700>$pacman_u ($aur_u)</fc>"
fi
