#!/bin/bash
#Csucsu, megy a flex


#Sh és ch számoló

e=2.7182818284590452353602874713526624977


echo Írjon be egy számot, a program megadja a sinusz/koszinusz hiperbolikuszát!
read kif



se=`echo "$e^$kif-$e^-$kif" | bc -l`
s=`echo "$se/2" | bc -l`


ce=`echo "$e^$kif+$e^-$kif" | bc -l`
c=`echo "$ce/2" | bc -l`




printf "\nA beírt adat $kif.\n\n"
printf "sinh($kif) = $s\n"
printf "cosh($kif) = $c\n"