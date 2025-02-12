#!/bin/bash
#Csucsu, megy a flex



#Sh és ch számoló

# e szám deklarálás
e=2.7182818284590452353602874713526624977


# Help
h()
{
cat << EOF

  Ide írj helpet
  Így fog megjelenni
  
EOF
}








# Faktoriális számoló
fakt()
{
    if (( $1 <= 1 )); then
        echo 1
    else
        last=$(fakt $(( $1 - 1 )))
        echo $(( $1 * last ))
    fi
}








# sinh számoló
sinh()
{


printf "A választott művelet sinh számítás, az argumentum $kifejezes\n\n"

shseged=`echo "$e^$kifejezes-$e^-$kifejezes" | bc -l`
fok=`echo "$shseged/2" | bc -l`
kerekites=`echo $fok | awk '{print int($fok+0.5)}'`

faktorialis=$(fakt 2*$n+1)


tseged=`echo "1/$faktorialis" | bc -l`
taylorsh=`echo "$tseged*$kifejezes^2*$n+1" | bc -l`


printf "sh $kerekites fok = $taylorsh\n"


}







# cosh számoló
cosh()
{



printf "A választott művelet cosh számítás, az argumentum $kifejezes\n\n"

chseged=`echo "$e^$kifejezes+$e^-$kifejezes" | bc -l`
fok=`echo "$chseged/2" | bc -l`
kerekites=`echo $fok | awk '{print int($fokk+0.5)}'`

faktorialis=$(fakt 2*$n)



tseged=`echo "1/$fok" | bc -l`
taylorch=`echo "$tseged*$kifejezes^2*$n" | bc -l`


printf "ch $kerekites fok = $taylorch\n"

}








echo Üdvözlöm a sinh / cosh számolóban!





# Ha az első argumentum "-h" akkor jelenítse meg a helpet
if [ $1 == "-h" ]
then h
exit
fi







# Ha a második argumentum szám, akkor tárolja el,
if echo "$2" | grep '[0-9]' >/dev/null; then

kifejezes=$2


# egyébként jelezzen hibát, lépjen ki
else
printf "A 2. argumentum hibás! Írjon -h -t a segítségért.\n"
exit
fi










# Ha a 3. argumentum üres, beállít alapértelmezetten 3-at kerekítési faktornak


if [ -z "$3" ]
then n=3

# Ha szám, eltároljuk, egyéb esetben jelezzen hibát, lépjen ki


elif echo "$3" | grep '[0-9]' >/dev/null; then
n=$3



else
printf "A 3. argumentum hibás! '$3' nem szám! Írjon -h -t a segítségért.\n"
exit

fi











# Ha az első argumentum nem "sh/sinh" vagy "ch/cosh" akkor hipát ír majd kilép, egyéb esetben aszerint jár el, amit megadtunk


if [ $1 == "sh" ] || [ $1 == "sinh" ]
then sinh

elif [ $1 == "ch" ] || [ $1 == "cosh" ]
then cosh


else
echo Hibás argumentum! Írjon -h -t a segítségért.
exit
fi
