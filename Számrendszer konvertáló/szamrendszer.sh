#!/bin/bash
#Csucsu, megy a flex


# Számrendszer konvertáló



segitseg()
{
cat << EOF

Számrendszer konvertáló

			Segítség megtekintése a -h kapcsolóval.
			A konvertálás a 'forrás' és 'cél' kapcsolókkal történik.
			Például: 'bash szamrendszer.sh -f 2 -c 10 1001' bemenet eredménye 9 lesz
			
			Ha nincs megadva forrás és cél számrendszer, akkor
			az alapértelmezett konvertálás során a forrás számot 10-es számrendszernek,
			a célszámot pedig 16-os számrendszernek tekinti a program.
			
EOF
}

if [[ $1 == '-' ]]; then

segitseg
exit

fi

if [[ $1 == "-h" || -z $1 || $1 == *['!'@#\$%^\&*()_+\.\?]* ]]; then

segitseg
exit

fi


if [[ -z $2 ]]; then
	
		szam=$(echo "obase=16; $1" | bc)
		echo && echo $1 10-es számrendszerből 16-os számrendszerbe váltva $szam && echo
		exit

fi



if [[ $1 == "-f" && $3 == "-c" ]]; then

	if [[ $2 == $4 ]]; then
		printf "\nNe legyen ugyan az a cél és a forrás számrendszer!\n\n"
		exit
	fi
	
	
	if [[ $2 != 2 && $2 != 8 && $2 != 10 && $2 != 16 ]]; then
		printf "\nHibás számrendszer! Csak 2, 8, 10 és 16-os számrendszerek elfogadottak!\n\n"
		exit
	fi
	
	
	if [[ $4 != 2 && $4 != 8 && $4 != 10 && $4 != 16 ]]; then
		printf "\nHibás számrendszer! Csak 2, 8, 10 és 16-os számrendszerek elfogadottak!\n\n"
		exit
	fi
	
	
	
	
	
	# Ellenőrzés hogy a 2-es számrendszernek megfelel-e a bemenet
	
	
	if [[ $2 -eq 2 ]]; then
	
		if [[ $5 == *"2"* || $5 == *"3"* || $5 == *"4"* || $5 == *"5"* || $5 == *"6"* || $5 == *"7"* || $5 == *"8"* || $5 == *"9"* || $5 =~ [A-Za-z] ]]; then
			echo && echo $5 nem 2-es számrendszerbeli szám! && echo
			exit
		fi
		
	fi
	
	# Ellenőrzés hogy a 8-as számrendszernek megfelel-e a bemenet
	
	if [[ $2 -eq 8 ]]; then
	
		if [[ $5 == *"8"* || $5 == *"9"* || $5 =~ [A-Za-z] ]]; then
			echo && echo $5 nem 8-as számrendszerbeli szám! && echo
			exit
		fi
		
	fi
	
	
	# Ellenőrzés hogy a 10-es számrendszernek megfelel-e a bemenet
	
	if [[ $2 -eq 10 ]]; then
	
		if [[ $5 =~ [A-Za-z] ]]; then
			echo && echo $5 nem 10-es számrendszerbeli szám! && echo
			exit
		fi
		
	fi
	
	
	# Ellenőrzés hogy a 16-os számrendszernek megfelel-e a bemenet
	
	if [[ $2 -eq 16 ]]; then
	
		if [[ $5 =~ [G-Zg-z] || $5 =~ [a-f] ]]; then
			echo && echo $5 nem 16-os számrendszerbeli szám!
			echo Kérlek vedd figyelembe, hogy csak nagybetűket tartalmazhat a szám!
			printf "(12a - nem jó, 12A - jó)\n" && echo
			exit
		fi
		
	fi
	
	
	
	# Kettesből nyolcasba váltás
	
	
	if [[ $2 -eq 2 && $4 -eq 8 ]]; then
		
	szam=0
	i=0
	tizes=0
	alap=$5

    for ((i=0; alap!=0; i++))
    do
        tizes=$((tizes+(alap%10)*(2**i)))
        alap=$((alap/10))
		
    done
	
    for((i=1; tizes!=0; i=i*10))
    do
        szam=$((szam+(tizes%8)*i))
        tizes=$((tizes/8))
    done
		
		echo && echo $5 2-es számrendszerből 8-asba váltva $szam && echo
		exit
	
	fi
	
	
	
	# Kettesből tizesbe váltás
	
	
	
	if [[ $2 -eq 2 && $4 -eq 10 ]]; then
	
			declare -i szam=0
			szam=2#$5
			
			echo && echo $5 2-es számrendszerből 10-es számrendszerbe váltva $szam && echo
			exit
	fi
	
	
	
	# Kettesből tizenhatosba váltás
	
	
	if [[ $2 -eq 2 && $4 -eq 16 ]]; then
	
		szam=$(echo "obase=16; ibase=2; $5" | bc)
		echo && echo $5 2-es számrendszerből 16-es számrendszerbe váltva $szam && echo
		exit
	fi
	
	
	
	
	
	# Nyolcasból kettesbe váltás
	
	if [[ $2 -eq 8 && $4 -eq 2 ]]; then
	
	n=${#5}
	szam=$5
	
	
	echo && echo -n $5 8-as számrendszerből 2-es számrendszerbe váltva && printf " "
	for ((i=0; i<=n; i++))
		do
		
			case ${szam:i:1} in

			"0")
			echo -n 000
			;;
			
			"1")
			echo -n 001
			;;

			"2")
			echo -n 010
			;;
			
			"3")
			echo -n 011
			;;
			
			"4")
			echo -n 100
			;;

			"5")
			echo -n 101
			;;
			
			"6")
			echo -n 110
			;;
			
			"7")
			echo -n 111
			;;

			esac
			
		done
		
		echo && echo
		exit
	
	fi



	# Nyolcasból tizesbe váltás
	
	if [[ $2 -eq 8 && $4 -eq 10 ]]; then
	
		declare -i szam=0
		szam=8#$5
		
		echo && echo $5 8-as számrendszerből 10-es számrendszerbe váltva $szam && echo
		exit
	fi
	
	
	
	# Nyolcasból tizenhatosba váltás
	
	
	if [[ $2 -eq 8 && $4 -eq 16 ]]; then
	
		szam=$(echo "obase=16; ibase=8; $5" | bc)
		echo && echo $5 8-as számrendszerből 16-es számrendszerbe váltva $szam && echo
		exit
	fi
	
	
	
	# Tizesből kettesre
	
	if [[ $2 -eq 10 && $4 -eq 2 ]]; then
	
		szam=$(echo "obase=2; $5" | bc)
		echo && echo $5 10-es számrendszerből 2-es számrendszerbe váltva $szam && echo
		exit
		
	fi
	
	
	# Tizesből nyolcasra
	
	if [[ $2 -eq 10 && $4 -eq 8 ]]; then
	
		szam=$(echo "obase=8; $5" | bc)
		echo && echo $5 10-es számrendszerből 8-as számrendszerbe váltva $szam && echo
		exit
		
	fi
	
	
	# Tizesből tizenhatosba
	
	if [[ $2 -eq 10 && $4 -eq 16 ]]; then
	
		szam=$(echo "obase=16; $5" | bc)
		echo && echo $5 10-es számrendszerből 16-os számrendszerbe váltva $szam && echo
		exit
		
	fi
	
	
	
	# Tizenhatosból kettesbe
	
	if [[ $2 -eq 16 && $4 -eq 2 ]]; then
	
		szam=$(echo "obase=2; ibase=16; $5" | bc)
		echo && echo $5 16-os számrendszerből 2-es számrendszerbe váltva $szam && echo
		exit
		
	fi
	
	# Tizenhatosból nyolcasba
	
	if [[ $2 -eq 16 && $4 -eq 8 ]]; then
	
		szam=$(echo "obase=8; ibase=16; $5" | bc)
		echo && echo $5 16-os számrendszerből 8-as számrendszerbe váltva $szam && echo
		exit
		
	fi
	
	# Tizenhatosból tizesbe
	
	if [[ $2 -eq 16 && $4 -eq 10 ]]; then
	
		declare -i szam=0
		szam=16#$5
		
		echo && echo $5 16-os számrendszerből 10-es számrendszerbe váltva $szam && echo
		exit
		
	fi
	
	
else 

printf "Helytelen bemenet! Kérlek használd a -h kapcsolót a segítséghez!\n\n"
exit

fi
	