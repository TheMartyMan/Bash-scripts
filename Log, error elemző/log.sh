#!/bin/bash

#Csucsu, megy a flex



h()
{
cat << EOF

  Szkript használata:
  1. paraméter: access/error
  2. paraméter: Fájl neve (útvonal)
  
EOF
}



if [ "$1" = "-h" ]; then
h
exit

elif [ "$1" != "access" ] && [ "$1" != "error" ]; then
        printf "Helytelen bemenet! Írjon be egy -h -t ha segítségre van szüksége!\n"
	exit
	
fi



if [ ! -f "$2" ] || [ -z $2 ]; then
	echo "A fájl nem található"
	echo "Írjon be egy -h -t ha segítségre van szüksége!"
	exit
fi




if [ "$1" = "access" ]; then
	echo
	echo ACCESS LOG elemzés
	echo
	
	
	if [[ -z "${@:3}" ]]; then
		echo "   IP			DÁTUM	       METÓDUS         KERES 	      STÁTUSZ  MÉRET"
	else		
		for sor in "${@:3}"
		do
			if [ "$sor" = "ip" ]; then
				printf "\tIP\t"
			elif [ "$sor" = "datum" ]; then
				printf "DATUM\t"
			elif [ "$sor" = "method" ]; then
				printf "METODUS\t"
			elif [ "$sor" = "keres" ]; then
				printf "KERES\t"
			elif [ "$sor" = "status" ]; then
				printf "STATUSZ\t"
			elif [ "$sor" = "meret" ]; then
				printf "MERET\t"
			fi
		done
		printf "\n"
	fi
	
	cat "$2" | while read logentry; do
		ip=`echo $logentry | awk '{print $1}'`
		datum=`echo $logentry | awk '{print $4}' | sed "s/\[//g"`
		method=`echo $logentry | awk '{print $6}'`
		keres=`echo $logentry | awk '{print $7}'`
		status=`echo $logentry | awk '{print $9}'`
		meret=`echo $logentry | awk '{print $10}'`
		
		if [[ -z "${@:3}" ]]; then
			printf "$ip\t$datum\t$method\t$keres\t$status\t$meret\n"
		else		
			for sor in "${@:3}"
			do
				if [ "$sor" = "ip" ]; then
					printf "$ip\t"
				elif [ "$sor" = "datum" ]; then
					printf "$datum\t"
				elif [ "$sor" = "method" ]; then
					printf "$method\t"
				elif [ "$sor" = "keres" ]; then
					printf "$keres\t"
				elif [ "$sor" = "status" ]; then
					printf "$status\t"
				elif [ "$sor" = "meret" ]; then
					printf "$meret\t"
				fi
			done
			printf "\n"
		fi
	done
fi

if [ "$1" = "error" ]; then
	echo
	echo ERROR LOG elemzés
	echo
	if [[ -z "${@:3}" ]]; then
		echo "IDŐPONT				  HIBA HELYE 			HIBAÜZENET"
	else		
		for sor in "${@:3}"
		do
			if [ "$sor" = "idopont" ]; then
				printf "\tIDŐPONT\t"
			elif [ "$sor" = "ip" ]; then
				printf "KLIENS IP\t"
			elif [ "$sor" = "hiba" ]; then
				printf "HIBA\t"
			fi
		done
		printf "\n"
	fi
	echo
	
	cat "$2" | while read logentry; do
		ev=`echo $logentry | awk '{print $5}' | sed "s/\]//g"`
		datum=`echo $logentry | awk '{print $2" "$3" "$4}'`
		client=`echo $logentry | awk '{print $10}' | cut -d ":" -f 1`
		hiba=`echo $logentry | cut -d "]" -f 5`
		
		if [[ -z "${@:3}" ]]; then
			printf "$ev $datum\t$client\t$hiba\n"
		else		
			for sor in "${@:3}"
			do
				if [ "$sor" = "idopont" ]; then
					printf "$ev $datum\t"
				elif [ "$sor" = "ip" ]; then
					printf "$client\t"
				elif [ "$sor" = "hiba" ]; then
					printf "$hiba\t"
				fi
			done
			printf "\n"
		fi
	done
fi








