#!/bin/bash
#Csucsu, megy a flex


seged()
{
cat << EOF

  Levelező kliens
  
  A program indítása után a felsorolásból válasszon!
  A program képes e-mailek olvasására, írására,
	(melléklet csatolására is van lehetőség)
  illetve meglévő levelekre is lehet válaszolni.
  
  
  
  
EOF
}


level=() # Itt vannak a levelek eltárolva

olvasas(){ 
	#Ha érkezett új levél bemásoljuk a cur mappába
	if [ "$(ls -A $HOME/Maildir/new/)" ]; then
    	mv $HOME/Maildir/new/* $HOME/Maildir/cur/
	else
		echo "Nincs új beérkezett levél"
	fi

	# Levél lekérdezés
	if [ ${#level[@]} -eq 0 ]; then
    	level+=( $(ls $HOME/Maildir/cur))
	fi

	i=0
	for level in ${level[@]} 
	do
		echo '--------------------'
		echo $i')' $(cat $HOME/Maildir/cur/$level | grep -E -o "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}" | head -1)	# Regexet használtam ami kiválasztja az e-mail címet
		i=$((i+1))
	done

	echo '--------------------'

	echo Melyiket szeretné elolvasni?
	read valasztott_level

	cat  $HOME/Maildir/cur/${level[$valasztott_level]}

		
menu
}

valasz() {
	if [ ${#level[@]} -eq 0 ]; then
    	echo Előbb az 'olvasás' menüponttal kérje le a leveleket!
		menu
	fi
	echo Melyikre szeretne válaszolni?
	read valasztott_level
	LEVEL=$HOME/Maildir/cur/${level[$valasztott_level]}

	reply=$(cat $LEVEL | grep -E -o "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}" | head -1) # Ugyanúgy regex
	subject=$(cat $LEVEL | grep Subject | sed 's/^Subject:\s//')
	echo Mit szeretne hozzáírni?
	read valasz

	sed -e "s/^/ > /" -e "1s/^/$valasz\n/" $LEVEL | mutt -s "Re:$subject" $reply # Válasznál a levél beljebb tolódik

menu
}

ujlevel(){
	echo Adja meg az e-mail címet!
	read email
	echo Adja meg az e-mail tárgyát!
	read targy
	echo Írja meg az e-mail szövegét:
	read szoveg
	echo "Van melléklet? (y/n)"
	read melleklet
	mellekletk=$(echo "$melleklet" | tr '[:upper:]' '[:lower:]')
	if [[ $mellekletk == "y" ]]; then
		db=0
		utvonalak=()
		echo Hány darab melléklet lesz?
		while [ $db -lt 1 ] 
		do
			read db
			if [ "$db" -lt 1 ]; then
				echo "Ha már azt választotta hogy legyen melléklet, adjon meg legalább egyet!"
			fi
		done
	
		for x in db 
		do
			echo Kérem adja meg a melléklet útvonalát!
			read utvonal 
			utvonalak+=$utvonal
		done
		utvonalak_egyben=$(echo ${utvonalak[@]} | tr '[:upper:]' '[:lower:]')
		echo Útvonalak egyben: $utvonalak_egyben
		echo  $szoveg | mutt -c $email -s $targy -a $utvonalak_egyben
	
	elif [[ $mellekletk == "n" ]]; then
		echo  $szoveg | mutt -c $email -s $targy
	else [[ $mellekletk == *""* ]] 
		echo "Hibás bemenet!" 
		menu
	fi
menu
}


# Menü függvény (rekurzív)
menu () {
	printf "Üdv a Levelezőben!\nKérem válasszon az alábbi lehetőségek közül:\n\n"
	lehetosegek=("Olvasás" "Válaszolás" "Új levél írása" "Segítség" "Kilépés")
	select opt in "${lehetosegek[@]}"
	do
		case $opt in
				"Olvasás")
					olvasas
					break
					;;
				"Válaszolás")
					valasz
					break
					;;
				"Új levél írása")
					ujlevel
					break
					;;
				"Segítség")
					seged
					;;
				"Kilépés")
					printf "Viszlát!\n";
					exit
					;;
				*) echo "Válasszon a listából!";;
		esac
	done
}

menu