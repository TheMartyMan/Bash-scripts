#!/bin/bash
#Csucsu, megy a flex


if [[ $1 == "-u" ]]; then

echo $2  >> adatbazis.txt

echo $2 hozzáadva az adatbázishoz!
exit

fi



if [[ $1 == "-h" ]]; then

printf "Fájlkereső.\n\nA program indítása után kérem adja meg a fájl nevét,\na program ellenőrzi, hogy létezik-e a fájl az adatbázisban,\nés ha igen, akkor megjeleníti róla az adatokat, ha nem,\nakkor pedig külső (teljes fájlrendszeres) keresést indít.\n\n-h kapcsolóval ezt a segítséget lehet elérni, -u kapcsolóval az adatbázishoz lehet útvonalat hozzáadni.\n"
exit



fi


# Egész fájlrendszerben keresés

a=0


kulso()


{


echo Keresés az egész fájlrendszerben...




# Telepítsük a locate parancsot - fájlkereséshez
sudo apt install locate

# updatedb - enumerál: 'Beindexeli' úgymond az összes fájlt az egész gépen (mert így valóban teljes fájlrendszeres a keresés)
sudo updatedb


# Megkeressük mindenhol a beolvasott fájlnevet, az eredményt eltároljuk

locate -A $valasz > eredmeny.txt



# Megszámoljuk a sorait az eredménynek

sorok=$(cat "eredmeny.txt" | wc -l)



# Ha nincs sor, a fájl nem található


if [[ $sorok -eq 0 ]]; then

echo A keresett fájl nem található!
rm eredmeny.txt

exit

fi








# Ha 1 sor van,



if [[ $sorok -eq 1 ]]; then



echo 1 fájl található ezzel a névvel: $valasz

echo

# Útvonal: Az eredmeny.txt első sora
# head sorokra bont, tail -n 1-el összekapcsolva pedig csak az első sort fogja kiadni.


echo A fájl elérési útvonala: $(echo $(head -n 1 eredmeny.txt | tail -n 1))
fajl=$(echo $(head -n 1 eredmeny.txt | tail -n 1))




# Kiiratjuk az adatokat
# az awk kiszedi a parancs outputjából az x. sort

echo
tipus1=$(file $fajl | awk '{print $2}')
tipus2=$(file $fajl | awk '{print $3}' | sed 's/,//')




echo Tipus: $tipus1 $tipus2

echo
tulaj=$(ls -l $fajl | awk '{print $3}')

echo Tulajdonos: $tulaj

echo
meret=$(ls -l $fajl | awk '{print $5}')

echo Méret: $meret bájt




# Eltároljuk a talált fájlt tartalmazó mappát az adatbázisban.


echo $(head -n $v eredmeny.txt | tail -n 1) | sed -e "s|/$valasz||g"  >> adatbazis.txt



# Töröljük az eredmény.txt-t hogy később ne okozzon konfliktust.
rm eredmeny.txt

exit

















# ha viszont több sor van, akkor több fájl is. Végigmegyünk,


elif [[ $sorok -gt 1 ]]; then

echo $sorok fájl található ezzel a névvel: $valasz



# kiiratjuk a talált fájlokat,

echo

for ((i=1;i<=$sorok;i++))

do

	
	echo
	echo $i')' $(echo $(head -n $i eredmeny.txt | tail -n 1))
	echo
	

done


# megkérdezzük a felhasználót, melyik fájlt szeretné megnézni


while [[ $v == "" ]] || [[ $v -lt 1 ]] || [[ $v -gt $sorok ]]

	do

		echo Melyik fájlról szeretnél adatokat megtekinteni?

		read v

	done




# Létrehozzuk a változókat és eltároljuk az adatokat, amiket utána kiiratunk
# head sorokra bont, tail -n 1-el összekapcsolva pedig csak az első sort fogja kiadni.


fajl=$(echo $(head -n $v eredmeny.txt | tail -n 1))

echo A fájl elérési útvonala: $(echo $(head -n $v eredmeny.txt | tail -n 1))

# awk kiszedi a parancs outputjából az x. sort

echo
tipus1=$(file $fajl | awk '{print $2}')
tipus2=$(file $fajl | awk '{print $3}' | sed 's/,//')




echo Tipus: $tipus1 $tipus2

echo
tulaj=$(ls -l $fajl | awk '{print $3}')

echo Tulajdonos: $tulaj

echo
meret=$(ls -l $fajl | awk '{print $5}')

echo Méret: $meret bájt

# Eltároljuk a talált fájlt tartalmazó mappát az adatbázisban.


echo $(head -n $v eredmeny.txt | tail -n 1) | sed -e "s|/$valasz||g"  >> adatbazis.txt


# Töröljük az eredmény.txt-t hogy később ne okozzon konfliktust.

rm eredmeny.txt
exit

fi



}




# Adatbázisban keresés



# Bekérjük a keresett fájl nevét

while [[ $valasz == "" ]]



	do

		echo Kérem adja meg a keresett fájl nevét!

		read valasz

	done


# Ha nem létezik az adatbázis, létrehozzuk,

if [ ! -f "adatbazis.txt" ]; then

echo Az adatbázis nem létezik! Létrehozás...

touch adatbazis.txt



fi



# ha pedig üres, egyből 'külső' (teljes fájlrendszeres) keresésre váltunk


sor=$(cat "adatbazis.txt" | wc -l)



if [[ $sor < 1 ]]; then



echo Az adatbázis üres!
echo

kulso


else


# Egyébként pedig minden sorát megnézzük az adatbázisnak, és egyesével megnézzük tartalmazza-e a fájlt az adott sor (mappa)


for ((i=1;i<=$sor;i++))

	do
	
		# Ha tartalmazza (létezik), akkor OK legyen 0, egyébként OK legyen 1.
		
		if test -f "$(echo $(head -n $i adatbazis.txt | tail -n 1))/$valasz"; then
		
		OK=0
		
		else
		OK=1
		fi
		

		# Ha OK=0, akkor menjen végig azon amin a fenti parancsok is végigmennek: útvonal, tipus stb. tulajdonságok kinyerése és kiiratása.
		
		if [[ $OK -eq 0 ]]; then
		
		
				echo Megtaláltam a fájlt az adatbázisban!
				echo
				
				
				fajl=$(echo $(head -n $i adatbazis.txt | tail -n 1))/$valasz

				echo A fájl elérési útvonala: $(echo $(head -n $i adatbazis.txt | tail -n 1))/$valasz

				echo
				tipus1=$(file $fajl | awk '{print $2}')
				tipus2=$(file $fajl | awk '{print $3}' | sed 's/,//')




				echo Tipus: $tipus1 $tipus2

				echo
				tulaj=$(ls -l $fajl | awk '{print $3}')

				echo Tulajdonos: $tulaj

				echo
				meret=$(ls -l $fajl | awk '{print $5}')

				echo Méret: $meret bájt
				
		else
		
		# Számoljuk meg hány sor nem talált.
		
			a=$((a+1))
			
		fi
		
	done

fi


# Ha egy sor sem talált, akkor nincs az adatbázisban a fájl, váltunk 'külső' (teljes fájlrendszeres) keresésre.
if [[ $a -eq $sor ]]; then

	echo A fájl nem található az adatbázisban!
	echo 
	kulso
	
fi
