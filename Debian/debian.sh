#!/bin/sh
#Csucsu, megy a flex


# Alkalmazások listázása, txt-be mentjük mert változóban szétesik és nehezebb vele dolgozni.
apt list --installed > appok.txt


# Megnyitjuk az appok.txt-t egy változóban, 
fajl=$(cat appok.txt)


# majd megszámláljuk a sorait, eltároljuk.
sor=$(echo "$fajl" | wc -l)


# Takarítás, ha esetleg megszakadna a for ciklus közben a program, törli a folyamat közben létrehozott fájlokat.
exitfn () {
    trap SIGINT
    echo; rm appok.txt dep.txt depgrep.txt fuggosegek.txt
    exit
}


# Ehhez módosítjuk a Ctrl + C jelet.
trap "exitfn" INT



# Script kezdés.
clear
printf "Üdvözöllek a Debian csomaglistázóban!\nSzeretnél a függőségeknél verziószámot látni? [I\N]\n"


read valasz
case "$valasz" in
    [Ii])
echo Rendben, látni fogod a verziószámokat. Jelenleg $sor alkalmazás van telepítve a rendszeren.
printf "\nAz első hány csomagot szeretnéd látni?\nÉrvénytelen vagy üres bemenet esetén az összes adat listázásra kerül.\n";;
	*)
	echo Rendben, nem fogod látni a verziószámokat. Jelenleg $sor alkalmazás van telepítve a rendszeren.
printf "\nAz első hány csomagot szeretnéd látni?\nÉrvénytelen (nem pozitív egész szám) vagy üres bemenet esetén az összes adat listázásra kerül.\n";;

esac


# /\ Ez itt fent Triviális, bekérjük hogy kér-e verziószámot, és a válasz alapján tájékoztatjuk a felhasználót. (Ha I vagy i akkor igen, egyébként nem.)


# Mivel nagyon sok alkalmazás van telepítve, bekérjük hogy az első hány adatot szeretné látni,
read sor
szamok='^[0-9]+$'
	if [[ $sor =~ $szamok ]]; then
		sor=$sor
	else
		sor=$(echo "$fajl" | wc -l)
	fi
	
echo $sor elem kiiratása...
sleep 1



# majd itt elkezdjük listázni, formázni a kapott adatokat:



# For ciklus eleje, az első sora az "apt list --installed" parancsnak mindig "Listing...", az nekünk nem kell, így i=2. (A fájl 2. sorától indulunk.)
for (( i=2; i<=$sor; i++ ))
	do
		
		# A jelenlegi sort kivágjuk,
		jelensor=$(head -n $i appok.txt | tail -1)
		
		# majd itt a jelenlegi sorból a / utáni részeket eltároljuk, ez lesz az alkalmazás neve.
		formazott=$(echo "$jelensor" | cut -d \/ -f 1)



		# Mivel a feladatkiírás szerint a függőségeket is meg kell mutatni, így azt is eltároljuk ugyanúgy mint ahogy fentebb is tettük:
		apt-cache showpkg $formazott > dep.txt
		
		
		
		# Ez a parancs viszont tartalmaz sok mást is a függőségeken kívül, ezért először mindent ami a "Dependencies:" és a "Provides:" közti részben van,
		# kivágjuk, és mivel még ez tartalmazza,  kitöröljük ezt a két szót is, így tisztán a függőségeket kapjuk.
		
		
		depgrep=$(sed -n -e '/Dependencies:/,/Provides:/ p' dep.txt)
		echo $depgrep > depgrep.txt
		cat depgrep.txt | sed "s/Dependencies: //g" | sed "s/ Provides://g" > fuggosegek.txt


				# Válasz igen esetén kértek verziószámot, így ekkor nem töröljük ki/formázzuk tovább a függőségeket.
				if [[ $valasz == [Ii] ]]; then
					echo $formazott : $(echo $(cat fuggosegek.txt))
					printf "\n"
					
				else
			
			
		# Válasz nem esetén nem kértek verziószámot, így ekkor töröljük/formázzuk tovább a függőségeket.
		# Kitörlünk mindent, ami nem csak és kizárólag a függőség neve (verziószámok, zárójelek, zárójelek közti rész, pontok stb.) 
	
		
		echo $formazott : $(echo $(cat fuggosegek.txt) | sed -e 's/([^()]*)/,/g' | sed -e "s/(0 ,)//g" | sed -e "s/-/, /g")
		printf "\n"
			
		fi
	done
# For ciklus vége.



# Takarítás: Ha végigért a ciklus, töröljük a létrehozott fájlokat.
rm appok.txt dep.txt depgrep.txt fuggosegek.txt




# Visszaállítjuk a Ctrl + C jelet alapértelmezettre.
trap SIGINT