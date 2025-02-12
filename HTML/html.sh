#!/bin/bash
#Csucsu, megy a flex


nyit=("<a>" "<abbr>" "<acronym>" "<address>" "<applet>" "<area>" "<article>" "<aside>" "<audio>" "<base>" "<basefont>" "<bdi>" "<bdo>" "<big>" "<blockquote>" "<body>" "<br>" "<button>" "<center>" "<head>" "<html>" "<title>" "<p>")
zar=("</a>" "</abbr>" "</acronym>" "</address>" "</applet>" "</area>" "</article>" "</aside>" "</audio>" "</base>" "</basefont>" "</bdi>" "</bdo>" "</big>" "</blockquote>" "</body>" "</br>" "</button>" "</center>" "</head>" "</html>" "</title>" "</p>")


printf "Üdvözlöm a HTML szintaktika ellenörzőben/javítóban!\n\n"

segitseg()
{
cat << EOF

HTML Tag ellenőrző
			Segítség megtekintése a -h kapcsolóval.
			A program csak létező nemüres fájlokat fogad el.
			Hibajavítás során a visszajelzés hiánya a javítás sikertelenségét jelzi!
EOF
}



if [[ $1 == "-h" ]]; then
segitseg
exit

fi




if [ -z $1 ]; then
echo "Üres argumentum! Írj -h -t a segítséghez!"
exit
fi




if [ ! -f $1 ]; then
    echo $1 nem létezik, kérlek adj meg egy létező fájlt. Írj -h -t a segítséghez!
	exit
fi





if [ ! -s $1 ]; then

echo $1 üres! Kérlek adj meg egy másik fájlt, vagy töltsd fel HTML kóddal és próbáld újra. Írj -h -t a segítséghez!
exit
fi


if [[ $1 != *".html"* ]];
then
	printf "A megadott fájl nem HTML kiterjesztésű!\nSzeretnéd hogy átnevezzem HTML-re? [I\N]\n"
	read valasz
		if [[ $valasz == [Ii] ]]; then
			mv "$1" "${1%.*}.html"
			olvas="${1%.*}.html"

		fi
	fi
	

olvas=$1
fajl=$(cat $olvas)
sor=$(echo "$fajl" | wc -l)


declare -i zj=0
declare -i zb=0
jo=0
siker=0


for (( i=1; i<=$sor; i++ ))
	do
		uj=$(head -n $i $olvas | tail -1)
	
		zj+=$(echo "$uj" | grep -o '<' | wc -l)

		zb+=$(echo "$uj" | grep -o '>' | wc -l)

		
			if [ $zj -ne $zb ]; then
				echo Hiba a'(z)' $i. sorban!
				echo A hibás sor: $(head -n $i $olvas | tail -1)
				zj=0
				zb=0
				jo=$((jo+1))
				printf "Szeretnéd hogy kijavítsam? [I/N]\n"
				read v
				if [[ $v == [Ii] ]]; then
				
				
				
				
					if [[ "$uj" != *"/"* ]]; then
						for nyit in ${nyit[@]} 
							do

								if [[ "$nyit" == *"$uj"* ]] && [[ $v == [Ii] ]]; then
								sed -i "$i""s|.*|$nyit|" $olvas
								printf "\n\n***********************************\nA(z) $i. sor javítása sikeres volt.\n***********************************\n\n"
								continue
								fi
								
							done
						fi
					fi
					
					if [[ "$uj" == *"/"* ]]; then
						for zar in ${zar[@]} 
							do

								if [[ "$zar" == *"$uj"* ]] && [[ $v == [Ii] ]]; then
								sed -i "$i""s|.*|$zar|" $olvas
								printf "\n\n***********************************\nA(z) $i. sor javítása sikeres volt.\n***********************************\n\n"
								continue
								fi
								
							done
						fi
					fi						
done



for (( i=1; i<=$sor; i++ ))
	do
		uj=$(head -n $i $olvas | tail -1)
	
		zj+=$(echo "$uj" | grep -o '<' | wc -l)

		zb+=$(echo "$uj" | grep -o '>' | wc -l)

		
			if [ $zj -ne $zb ]; then
			zj=0
			zb=0
			siker=$((siker+1))
			
			fi
	done


if [ $jo -eq 0 ]; then
	printf "\nNem találtam hibát!\n"


elif [ $jo -ne 0 ] && [ $siker -eq 0 ]; then
	printf "\nA HTML kódban összesen $jo hibát találtam, azokat kijavítottam.\n"
	
elif [ $jo -ne 0 ] && [ $siker -ne 0 ]; then
	printf "\nA HTML kódban összesen $jo hibát találtam, azonban $siker hibát\nnem sikerült kijavítani ismeretlen tag vagy hibajavítás mellőzése miatt.\n"


fi
