#!/bin/bash
#Csucsu, megy a flex





# Fhelp függvény, hívható, kiírja a benne lévő adatokat echo-val

Fhelp()
{
	# Segítség a felhasználó számára a helyes adatbevitel módjáról
	echo ""
	echo "Használat: $(basename $0) <datum>"
	echo ""
	echo "Peldaul:"
	echo "     $(basename $0) 13.12 (December 13)"
	echo "     $(basename $0) 22.07 (Július 22)"
	echo "     $(basename $0) 01.03 (Március 1)"
}





# Ha az első argumentum "-h" vagy "-help", hívja meg az Fhelpet, majd kilép

if [[ $1 == "-h" ]] || [[ $1 == "-help" ]]; then

Fhelp
exit

fi





# Ha üres az első argumentum, akkor írja ki hogy nincs dátum megadva stb.

if test -z "$1"
then
	usedate=$(date "+%d.%m")
        echo "Nincs dátum megadva - A mai napot használom! ( $usedate )"
		
		
	

	
		
# Egyébként pedig regexel nézzük meg hogy szám.szám formátumú-e a beírt adat,
# és ha nem akkor meghívja az fhelpet és kilép

else
	if ! echo "$1" | grep "^[0-9][0-9]\.[0-9][0-9]$" &> /dev/null
	then
		echo "Rossz dátum formátum!" 
		
		
		Fhelp
		exit
	else
	
	# Egyéb esetben jó minden, tovább megyünk
	
		usedate="$1"
	fi
fi





# Ha az "${usedate:0:2}" nagyobb mint 31, akkor hibás mert max 31 lehet

if [ "${usedate:0:2}" -gt "31" ]
then
	echo "Rossz dátum formátum!"
	Fhelp
	exit
fi



# Ha az "${usedate:3:2}" nagyobb mint 12, akkor hibás mert max 12 lehet

if [ "${usedate:3:2}" -gt "12" ]
then
	echo "Rossz dátum formátum!"
	Fhelp
	exit
fi







# Ha grepelhető "^${usedate:0:2}" "${usedate:3:2}"-ból, akkor írja ki az adatokat abból a napból

if grep "^${usedate:0:2}" "${usedate:3:2}" &> /dev/null
then
	echo "Esemenyek "$usedate"-án/én:"
	echo ""
	
	
	
	
	# Úgy greppel hogy kivágja a ; -ket
	
	grep "^${usedate:0:2}" "${usedate:3:2}" | cut -d ";" -f2
	
	
	
	
	
	
	
# Ha nem, akkor ugye nem talált eseményt stb.
	
	
else
	echo "Nem találtam eseményt "$usedate"-án/én."
	echo "Események a ${usedate:3:2}. hónapban:"
	echo ""
	
	
	# Megszámoljuk a megadott fájl sorait
	
	sorok=$(cat "${usedate:3:2}" | wc -l)





	# Végigmegyünk a megadott fájlon,
	
	for ((i=1;i<=$sorok;i++))



	do

		# elmentünk minden sort, kicseréljük a ;-t vesszőre,
		sor=$(echo $(head -n $i ${usedate:3:2} | sed -e 's/;/ - /g' | tail -n 1))
		
		# és egyesével kivonjuk a sor első két karakteréből a napot, (bc-vel) és eltároljuk
		
		napok=$(echo "${sor:0:2}-${usedate:3:2}" | bc)
		
	
		# Ha a kiszámolt napok minuszban vannak (tartalmaznak kötőjelet), az azt jelenti hogy már elmúlt az a nap,
		# ekkor kiszedjük a minuszt a változóból (ez a sed-es rész), ás azt íratjuk ki hogy "x nappal ezelőtt",
		# egyébként pedig most fog jönni, tehát akkor azt írjuk hogy "x nap múlva. Így szebb."
		
		
		if [[ $napok == *"-"* ]]; then
		napok=$(echo $napok | sed -e 's/-//g')
		
		echo $sor {$napok nappal ezelőtt}
		
		else
		echo $sor {$napok nap múlva}
		
		fi

	done
	
	
fi
