#!/bin/bash
#Csucsu, megy a flex


# Üdvözlés

printf "Üdv az arcsin / arccos számolóban!\n\n"


# Segítség kiíratás függvényben

helpp()
{
cat << EOF

  Ide
  Irj
  Helpet
  
EOF
}


# Faktoriális számító
fakt()
{
    if (( $1 <= 1 )); then
        echo 1
    else
        last=$(fakt $(( $1 - 1 )))
        echo $(( $1 * last ))
    fi
}


# arcsin számolás függvényben

arcsin ()
{
printf "A választott művelet arcsin számolás\n\n"


f=$(fakt $n)
szamlalo=$(fakt 2*$n)


nev=`echo "(4^$n*$f^2)" | bc -l`
nv=`echo "(2*$n+1)" | bc -l`
c=`echo "$nev*$nv" | bc -l`


taylorarcsin=`echo "$szamlalo / $c*$kif^(2*n+1)" | bc -l`
fok=`echo "a(sqrt((1/(1-($kif^2)))-1))/0.017453293" | bc -l`
kerekit=`echo $fok | awk '{print int($fokk+0.5)}'`


printf "arcsin $kerekit fok = $taylorarcsin\n"

}



# arccos számolás függvényben

arccos ()
{
printf "A választott művelet arccos számolás\n\n"


f=$(fakt $n)
szamlalo=$(fakt 2*$n)


nev=`echo "(4^$n*$f^2)" | bc -l`
nv=`echo "(2*$n+1)" | bc -l`
c=`echo "$nev*$nv" | bc -l`


taylorarcsin=`echo "$szamlalo / $c*$kif^(2*n+1)" | bc -l`

piperketto=`echo "4*a(1)/2" | bc -l`



taylorarccos=`echo "$piperketto-$taylorarcsin" | bc -l`


fok=`echo "a(sqrt((1/($kif^2))-1))/0.017453293" | bc -l`
kerekit=`echo $fok | awk '{print int($fokk+0.5)}'`

printf "arccos $kerekit fok = $taylorarccos\n"


}

if [ $1 == "-h" ]
then helpp
exit
fi



a=`echo "$2" | bc -l`
b=1

if (( $(echo "$a <= $b" | bc -l) )); then
if echo "$2" | grep '[0-9]' >/dev/null; then

kif=$2

fi

else
printf "A 2. argumentum hibás! '$2' Vagy nem szám, vagy nagyobb mint 1, vagy üres!\n"
exit

fi


if [ -z "$3" ]
then n=3

elif echo "$3" | grep '[0-9]' >/dev/null; then
n=$3

else
printf "A 3. argumentum hibás! '$3' nem szám!\n"
exit

fi




if [ $1 == "arcsin" ]
then arcsin

elif [ $1 == "arccos" ]
then arccos

else
echo Hibás argumentum! [ $1 ] Írjon -h -t a segítségért.
exit
fi







