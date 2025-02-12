#!/bin/bash
#Csucsu, megy a flex


if [[ $1 == "-h" ]]; then

printf "Családfa\n\nA program a scriptet tartalmazó mappában elhelyezett 'Adatok' mappával működik,\ncsak a többi fájl mintája szerint bővíthető!\n"

exit

fi 



# A script futtatási helye
gyoker="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"



exec 2> /dev/null
cd Adatok/Csalad/Gyerek/1.gyerek



z=0

keres()
{

cd $gyoker/Adatok

while [[ $valasz == "" ]]
	do
		printf "Kérlek írd be a keresendő adatot!\n"
		read valasz
	done


find . -type f -print0 | xargs -0 grep -l "$valasz" > talalatok.data


sorok=$(cat "talalatok.data" | wc -l)




if [[ $sorok -eq 0 ]]; then
	
	printf "A családfában nem található ilyen adat.\n"
	rm talalatok.data
	unset valasz
	menu
	
elif [[ $sorok -eq 1 ]]; then
	
	printf "Egy személyt találtam: "
	path=talalatok.data
	fajl=$(echo $path)
	fajl=$(echo $(head -n 1 "$fajl" | tail -n 1))
	fajll=$(echo $(head -n 2 "$fajl" | tail -n 1))



fajl_o=$(echo $fajll | sed "s/Név: //g")


	
		echo $fajl_o


	unset valasz
	rm talalatok.data
	megnez
	
	
else

printf "\n\n\nTöbb személyt is találtam ezzel az adattal: " 
echo $valasz



printf "\n\n"


for ((i=1;i<=$sorok;i++))
do

	path=talalatok.data

	
	
	fajl=$(echo $path)

	
	fajl=$(echo $(head -n $i "$fajl" | tail -n 1))
	

	fajl=$(echo $(head -n 2 "$fajl" | tail -n 1))

	
	
		echo $i')' $fajl | sed "s/Név: //g"
		printf "\n"	

	
done

v=0
while [[ $v -lt 1 ]] || [[ $v -gt $sorok ]] || [[ $v == "" ]]
	do
		echo Melyik személyt választod?
		read v
	done

path=talalatok.data
fajl=$(echo $path)
fajl=$(echo $(head -n $v "$fajl" | tail -n 1))




fajll=$(echo $(head -n 2 "$fajl" | tail -n 1))



fajl_o=$(echo $fajll | sed "s/Név: //g")
z=1

rm talalatok.data
megnez

fi



rm talalatok.data
unset valasz
unset v

}



########################
megnez()
{
while [[ $c -ne 7 ]]
do


 printf "\n\nVálaszd ki mit szeretnél tenni.\n\n\n1. Anya adatai\n2. Apa adatai \n3. Első gyerek adatai\n4. Második gyerek adatai\n5. Feleség(ei)/férj(ei) adatai\n6. Összes adat megtekintése\n7. Vissza a főmenübe\n\n"
 echo Jelenlegi személy: $fajl_o | sed "s/Név: //g"
        read c # Opció kiválasztása
		
		case "$c" in
	1)
	cd Anya
	if [ $? -eq 0 ]; then
	
	
	fajl=anya.data
	
	sorok=$(cat $fajl | wc -l)
	
	
	fajl_o=$(echo $(head -n 2 "$fajl" | tail -n 1))

	
	
	echo $(head -n 2 $fajl | tail -n 1)
	megnez
	else
		printf "\n\n\nNincs további adat!"
		megnez
	fi;;
	
	
	
	
	
	
	2)
	cd Apa
	if [ $? -eq 0 ]; then
	
	
	fajl=apa.data
	
	sorok=$(cat $fajl | wc -l)
	
	
	fajl_o=$(echo $(head -n 2 "$fajl" | tail -n 1))
	

	
	
	echo $(head -n 2 $fajl | tail -n 1)
	megnez
	else
		printf "\n\n\nNincs további adat!"
		megnez
	fi;;
	
	
	
	
	
	3)
	sorok=$(cat $fajl | wc -l)
	
	ell=$(echo $(head -n 9 "$fajl" | tail -n 1))
	vane=$(echo $ell | sed 's/.*://')
	
	if [[ $vane == "" ]]; then
		printf "A kiválasztott személynek nincs gyereke!\n"
		megnez
	else
		
		cd $( dirname $fajl)

			cd ..
	
		
		ls -la > kivalaszt.data
		
		if grep -q gyerek kivalaszt.data; then
		
		fajl=gyerek.data

		sorok=$(cat $fajl | wc -l)
		fajl_o=$(echo $(head -n 2 "$fajl" | tail -n 1))
		
	
	
	
	
	echo $(head -n 2 $fajl | tail -n 1)
	megnez
	
	elif grep -q anya kivalaszt.data; then
	
	
		
		fajl=anya.data

		sorok=$(cat $fajl | wc -l)
		fajl_o=$(echo $(head -n 2 "$fajl" | tail -n 1))
		
	
	
	
	
	echo $(head -n 2 $fajl | tail -n 1)
	megnez
	else
	
		fajl=apa.data

		sorok=$(cat $fajl | wc -l)
		fajl_o=$(echo $(head -n 2 "$fajl" | tail -n 1))
		
	
	
	
	
	echo $(head -n 2 $fajl | tail -n 1)
	fi
	fi
	rm kivalaszt.data;;
	
	
	
	
	
	
	4)
	sorok=$(cat $fajl | wc -l)
	
	ell=$(echo $(head -n 10 "$fajl" | tail -n 1))
	vane=$(echo $ell | sed 's/.*://')
	
	if [[ $vane == "" ]]; then
		printf "A kiválasztott személynek nincs 2. gyereke!\n"
		megnez
	else
		
		cd $( dirname $fajl)
		cd ..
		ls -la > kivalaszt.data
		if grep -q gyerek kivalaszt.data; then
		
		fajl=gyerek.data

		sorok=$(cat $fajl | wc -l)
		fajl_o=$(echo $(head -n 2 "$fajl" | tail -n 1))
		
	
	
	
	
	echo $(head -n 2 $fajl | tail -n 1)
	megnez
	
	elif grep -q anya kivalaszt.data; then
	
	
		
		fajl=anya.data

		sorok=$(cat $fajl | wc -l)
		fajl_o=$(echo $(head -n 2 "$fajl" | tail -n 1))
		
	
	
	
	
	echo $(head -n 2 $fajl | tail -n 1)
	megnez
	else
	
		fajl=apa.data

		sorok=$(cat $fajl | wc -l)
		fajl_o=$(echo $(head -n 2 "$fajl" | tail -n 1))
		
	
	
	
	
	echo $(head -n 2 $fajl | tail -n 1)
	fi
	fi
	rm kivalaszt.data;;
	
	
	
	
	
	
	
	
	
	5)
	sorok=$(cat $fajl | wc -l)
	
	ell=$(echo $(head -n 11 "$fajl" | tail -n 1))
	vane=$(echo $ell | sed 's/.*://')
	
	if [[ $vane == "" ]]; then
		printf "A kiválasztott személy nem kötött házasságot!\n"
		megnez
	else



		i=1
		IFS=","
		f=( $vane )
		for f in ${f[@]} 
			do

				echo $i')' $f 
				i=$((i+1))
		
			done
			
	while [[ $v -lt 1 ]] || [[ $v -gt $i ]] || [[ $v == "" ]]
		do
		
			echo Melyik személyt választod?
			read v
			
		done
		
		v=$((v-1))
		f=( $vane )
		
		k=${f[$v]}
		
		
		
		
		k="Név:$k"
		
		
		
		cd $gyoker
		find . -type f -print0 | xargs -0 grep -l $k > talalatok.data
		
		sed -n -i '1p' talalatok.data
		path=talalatok.data
		fajl=$(cat $path)
		
		
		fajll=$(echo $(head -n 2 "$fajl" | tail -n 1))



		fajl_o=$(echo $fajll | sed "s/Név: //g")
	

		
		
	
	
	rm talalatok.data
	unset v
	unset k

		megnez

	fi
	rm talalatok.data
	megnez;;
	
	
	
	
	
	
	
	
	
	
	6)
	sorok=$(cat $fajl | wc -l)
	
	fajl_o=$(echo $(head -n 2 "$fajl" | tail -n 1))
	

	for ((i=2;i<=$sorok;i++))
	do

		echo $(head -n $i $fajl | tail -n 1) 

	done
	megnez;;
	
	
	
	
	
	
	7)
	menu;;

esac
done
}





########################
menu()
{

while [[ $c -ne 4 ]]
do
		
        printf "\n\nVálaszd ki mit szeretnél tenni.\n\n\n1. Személy adatinak megtekintése\n2. Adatkeresés\n3. Reset\n4. Kilépés\n\nA választott opció: "
        read c # Opció kiválasztása
		
		case "$c" in
    1)
	megnez;;
	2)
	keres;;
	
	3)
	cd $gyoker/Adatok/Csalad/Gyerek/1.gyerek
	fajl=gyerek.data
	fajl_o=$(echo $(head -n 2 "$fajl" | tail -n 1))
	unset v
	unset valasz
	clear
	
	cd $gyoker/Adatok/Csalad/Gyerek/1.gyerek

	fajl=gyerek.data
	fajl_o=$(echo $(head -n 2 "$fajl" | tail -n 1))



	sorok=$(cat $fajl | wc -l)


	for ((i=2;i<=$sorok;i++))
		do

			echo $(head -n $i $fajl | tail -n 1) 

	
		done;;
	
	
	4)
	echo Kilépés...
			
            exit;;
	esac
done
}

cd $gyoker/Adatok/Csalad/Gyerek/1.gyerek

fajl=gyerek.data
fajl_o=$(echo $(head -n 2 "$fajl" | tail -n 1))



sorok=$(cat $fajl | wc -l)


for ((i=2;i<=$sorok;i++))
do

	echo $(head -n $i $fajl | tail -n 1) 

	
done


menu