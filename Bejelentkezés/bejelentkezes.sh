#!/bin/bash
#Csucsu, megy a flex


# Ha van ':' a bemenetben, akkor dátumot adtak meg és aszerint megyünk tovább

if [[ $(echo $1) == *":"* ]]; then

# Az elválasztó (In File Separator) ekkor ':' lesz

IFS=":"



bemenet=$1



# Kiszedjük a bemenetből a hónapot,

honap=${bemenet:0:2}



if [[ ${honap:0:1} -eq 0 ]]; then



	honap=${honap:1}

fi


# Majd megvizsgáljuk, és aszerint állítjuk be amit kaptunk (ha 1 lett akkor az január és így tovább)


case "$honap" in





1)

honap=Január

hszam=01;;

2)

honap=Február

hszam=02;;

3)

honap=Március

hszam=03;;

4)

honap=Április

hszam=04;;

5)

honap=Május

hszam=05;;

6)

honap=Június

hszam=06;;

7)

honap=Július

hszam=07;;

8)

honap=Augusztus

hszam=08;;

9)

honap=Szeptember

hszam=09;;

10)

honap=Október

hszam=10;;

11)

honap=November

hszam=11;;

12)

honap=December

hszam=12;;

*)

echo Hibás adat!

exit;;



esac




# Majd ezt a nappal is megcsináljuk


nap=${bemenet:2:3}

nap=${nap:1}







if [[ ${nap:0:1} -eq 0 ]]; then



	nap=${nap:1}

fi


# Ha a bemenetben a nap résznél 31-nél nagyobb vagy 1-nél kisebbet kapnánk, hibát írunk majd kilépünk
# (Ugyanis egy hónap nem lehet se 0 napos, se 32 napos)


if [[ $nap -gt 31 ]] || [[ $nap -lt 1 ]] ;  then



echo Hibás adat!

exit



fi






# Leválasztjuk az órát a bemenetről




ora=${bemenet:6:6}





ora=${ora:0:2}


# Mivel a digitális óra 0 és 23 között van, amennyiben 23-tól nagyobb az óra értéke,
# hibát jelzünk majd kilépünk

if [[ $ora -gt 23 ]];  then



echo Hibás adat!

exit



fi







# Szintén ugyan így leválasztjuk a percet is



perc=${bemenet: -2}



# Ha a bemenetben a perc nagyobb mint 59, akkor hibás az adat és kilépünk
# (Hiszen 60 perc már 1 óra)


if [[ $perc -gt 59 ]];  then



echo Hibás adat!

exit



fi


# Kiírjuk, majd egybefűzzük a kiszűrt adatokat


echo $honap $nap.-én/án $ora óra $perc perckor bent tartózkodott:



masodperc=00

egyben=2022$hszam$nap$ora$perc$masodperc




# A 'last' parancs információkat jelenít meg az utoljára bejelentkezett felhasználókról,
# így megkapjuk ki mikor volt bent


last -t $egyben





exit





# Ha nem tartalmaz a bemenet ':'-t akkor a bemenet egy felhasználónév lesz

else



user=$1





# A 'last' parancs 38 sornyi szöveggel tér vissza amennyiben van olyan nevű felhasználó, mint a bemenet
# Ha kevesebb sor van, nincs olyan felhasználó, ezt jelezzük majd kilépünk


echo $(last $user) > most.txt



teszt=$(echo $(wc -c < most.txt))



if [[ $teszt -lt 38 ]]; then



	echo $user "felhasználó nem található!"

	rm most.txt

	exit



fi

fi

rm most.txt



# Egyéb esetben haladunk tovább a felhasználóval

echo Felhasználó: $user



printf "\n"


# Egy szövegbe tároljuk a last parancs kimenetét, majd
# felbontjuk a felhasználó adatait a szövegből


last $user > minden.txt

ossz=$(cat minden.txt)



# Sorokra bontunk, kivesszük a másodpercet és a percet, ez kell majd később az átlagos időhöz



sor=$(echo "$ossz" | wc -l)



masodperc=0

perc=0



for (( i=2; i<=$((sor-1)); i++ ))

do



	jelensor=$(head -n $i minden.txt | tail -1 | sed -e "s/(//g " | sed -e "s/)//g")







	jelensori=$(echo ${jelensor: -7})

			

	

	jelensorp=${jelensori:0:2}







	jelensormp=${jelensori: -2}



	

	

	if [[ ${jelensormp:0:1} -eq 0 ]]; then

		

		jelensormp=${jelensormp:1}

		

	fi





	

	

	masodperc=$((masodperc + jelensormp))

	

	

	

	

	

	if [[ ${jelensorp:0:1} -eq 0 ]]; then

		jelensorp=${jelensorp:1}

		

	fi





	perc=$((perc + jelensorp))

	



done



rm minden.txt


# Kiszedjük a last parancs kimenetéből, hogy mikor volt bejelentkezve az adott felhasználó, és kiírjuk


mikor=$(last $user | sed -n '1p' | awk '{print $7}')



echo Utolsó bejelentkezés: $mikor

printf "\n"




# Kiszedjük a last parancs kimenetéből, hogy hol volt bejelentkezve az adott felhasználó, és kiírjuk




honnan=$(last $user | sed -n '1p' | awk '{print $2}')









echo Gépnév: $honnan



printf "\n"


# A 'finger' egy felhasználó információkereső parancs, amely szintén a felhasználóról ad meg adatot, csak máshogy mint a last
# A finger parancs kimenetéből kiszedjük az időt hogy ki tudjuk írni később


ido=$(finger $user | head -4 | tail -n 1 | sed "s/hours/óra/g" | sed "s/hour/óra/g" | sed "s/minutes/perc/g" | sed "s/minute/perc/g" | sed "s/seconds/másodperc/g" | sed "s/idle//g")







perc=$((perc*60))


# A kiszedett időkből összerakjuk az átlag időt, és kiíratjuk


atlag=$((perc + $masodperc))

atlag=$((atlag/sor))





echo $user eddig átlagosan $atlag percet töltött belépve.


# A kiszedett idő pedig maga az eddig bejelentkezve töltött idő


echo Jelenleg bejelentkezve töltött idő: $ido



printf "\n"