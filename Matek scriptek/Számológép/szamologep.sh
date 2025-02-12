#!/bin/sh
#Csucsu, megy a flex


# Segítség függvény
segitseg()
{
cat << EOF
  A számológép támogatja az alábbiakat:


	a + b		  a + b összege
	a - b		  a - b különbsége
	a / b		  a / b hányadosa
	a % b       a / b maradéka
	s(x)        x szinusza (x radiánban)
	c(x)        x koszinusza (x radiánban)
	a(x)        x arkusz tangense (radiánban ad vissza)
	l(x)        x természetes alapú logaritmusa
	e(x)        Euler-féle szám x-re hatványozása
	a^x		  a x. hatványa
	sqrt(x)	  x négyzetgyöke
	e(l(x)/n)   n. gyök x

  
EOF
}

printf "Kérlek add meg hány tizedesjegyre szeretnél kerekíteni!\n"


# Amíg nem ad be 0-9 egész számot (integert), addig bekérünk.

while [[ $kerekit != [0-9] ]]
do

read kerekit
printf "Helytelen bemenet! Kérlek 0 és 9 között adj meg egész értékeket!\n"


done



clear
echo "Üdv a szamológépben! Írj segitseg-et vagy ?-t a segítségért, kilepes-t vagy exit-et a kilepeshez."


# Számológép függvényben
szamolo()
{



zjelbal=`echo "$parancs" | grep -o '(' | wc -l` #Megszámolja hány '(' van az argumentumban
zjeljobb=`echo "$parancs" | grep -o ')' | wc -l` #Megszámolja hány ')' van az argumentumban






# Ha az argumentum tartalmaz számot akkor számol, ha nem tartalmaz vagy a felhasználó nem írt be semmit, hibás a bemenet

if echo "$parancs" | grep '[0-9]' >/dev/null; then       






# Összehasonlítja a nyitó/záró zárójelek előfordulásának számát, ha nem egyenlő a kettő, hibás a bemenet

if [ $zjelbal != $zjeljobb ]													
then echo Zárójelezési hiba! Kérem ellenőrizze a nyitó és záró zárójeleket!







# Máskülönben a számológép számol
else


temp=$(echo "$parancs" | bc -l)



# Ha az output tartalmaz pontot, elé szurjunk 0-át

if [[ ${temp:0:1} == '.' ]]; then

	temp=$(echo $temp | sed 's/^/0/')
	
	printf %.$(echo $kerekit)f "$temp"
	printf "\n"
else


# Kerekítés


if [[ $temp == *"."* ]]; then





printf %.$(echo $kerekit)f "$temp"
printf "\n"

else
	echo "$parancs" | bc -l

fi
fi
fi



else
echo A bemenet hibás vagy üres!
fi



}




#Konzol rész





echo -n ""$"calc> "



#Folyamatosan beolvassa a felhasználó által beírt argumentumot, ha talál egyezést aszerint jár el
while read parancs
do
  case $parancs
  in
    kilepes|exit) echo Viszlát!; exit;;
    segitseg|\?)   segitseg;;
    *)         szamolo
  esac

  echo -n "calc> "
done


exit
