#!/bin/bash
#Csucsu, megy a flex


# Értesítés, függvényben

ertesit() {
		
		
	# Megszámoljuk mennyi levél van
	
    darab=$(ls mailbox | wc -l)


    while :

    

    do 

	# Késleltetés
		
    sleep 5


	# Folyamatosan nézzük a mappa elemszámát, és ha a kezdetitől nagyobb ez a szám, akkor

    if [[ $darabszam < $(ls mailbox | wc -l) ]]; then



	# beállítjuk kezdetinek az új számot,

    darab=$(ls mailbox | wc -l)


	# kiszedjük a legutóbbi fájlt (levelet),

    LEVEL=$(ls mailbox -Art | tail -n 1)

  
	# regex segítségével a feladót és az időt kinyerjük a levélből,

    felado=$(cat mailbox/$LEVEL | grep From | sed 's/^From:\s//')

    ido=$(cat mailbox/$LEVEL | grep Date | sed 's/^Date:\s//')
	
	
	# majd értesítjük a kinyert adatokkal a felhasználót.
	
	

    notify-send "Új leveled érkezett!" "Feladó: $felado\nIdő: $ido"
	
	
	# Miután ez 1x lefutott, újrahívjuk rekurzívan a függvényt.

ertesit

 

# ha az elemszám nem változna, akkor is újrahívjuk addig amíg nem változik

    else ertesit

    fi

    done
   

}



# Leveleket eltároljuk a tömbben

level=()


# Levelek olvasása függvény

olvasas()
{ 


	# Ha a new mappában vannak fájlok, átmásoljuk a curbe

	if [ "$(ls -A $HOME/Maildir/new/)" ]; then

    	mv $HOME/Maildir/new/* $HOME/Maildir/cur/

	else

		echo Nincs új levele.

	fi




	# Ha a levelek tömb üres, akkor adjunk hozzá a jelenlegi mappából
	

	if [ ${#level[@]} -eq 0 ]; then

    	level+=( $(ls $HOME/Maildir/cur))

	fi






	# Végigmegyünk a tömbbön
	
	i=0

	for level in ${level[@]} 

	do
		# Kiiratjuk a levelek számát, és a feladó email címét
		echo

		echo $i $(cat $HOME/Maildir/cur/$level | grep -E -o "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}" | head -1)
		i=$((i+1))

	done

		echo


	# Bekérjük melyik levelet szeretné elolvasni
	
	echo Melyik levelet szeretné elolvasni?

	read v



	# megnyitjuk a választott levelet

	cat  $HOME/Maildir/cur/${level[$v]}



	# majd töröljük a választ, mert egyébként a függvény újrahívásánál ugyan ez futna le
	unset v

		

menu

}







# Válaszolás függvényben

valasz()
{


	# Ha a level tömb üres, akkor nem volt még beleolvasva, ezt közöljük a felhasználóval,
	
	if [ ${#level[@]} -eq 0 ]; then

    	echo Előbb kérje le a leveleket az Olvasás meüpontban!
		
		
		# és visszatérünk a menübe.
		menu

	fi


	# Egyébként megkérdezzük melyik levélre szeretne válaszolni,

	echo Melyikre szeretne válaszolni?

	read v

	# kijelöljük a választott levelet,

	LEVEL=$HOME/Maildir/cur/${level[$v]}


	# regexel kiszedjük az email címet,

	
	reply=$(cat $LEVEL | grep -E -o "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}" | head -1)
	
	
	# és a tárgyat,

	subject=$(cat $LEVEL | grep Subject | sed 's/^Subject:\s//')
	
	
	# majd megkérdezzük a felhasználót mit szeretne hozzáírni

	echo Mit szeretne hozzáírni?

	read valasz

	
	# az egész levelet >-el beljebb kezdjük, majd elküldjük a választ,

	sed -e "s/^/ > /" -e "1s/^/$valasz\n/" $LEVEL | mutt -s "Re:$subject" $reply



	# töröljük a válaszokat, mert egyébként a függvény újrahívásánál ugyan ez futna le,

	unset v
	unset valasz
	
	# ezután visszatérünk a főmenübe
	
menu

}




# Levélírás függvénye


leveliras()
{
	
	# Bekérjük az adatokat,
	
	echo Adja meg az e-mail címet!

	read email

	echo Adja meg az e-mail tárgyát!

	read targy

	echo Írja meg az e-mail szövegét:

	read szoveg



	# megkérdezzük van-e melléklet,

	echo Van melléklet? (I/N)

	read v

	
	# és ha "I" vagy "i" a válasz,

	if [[ $v == "I" ]] || [[ $v == "i" ]]; then

		db=0

		# (útvonal tömb, itt vannak eltárolva a mellékletek útvonalai)
		
		ut=()



		# akkor megkérdezzük a felhasználót hány darab melléklet lesz.

		echo Hány darab melléklet lesz?


		# Amíg nincs megadva legalább 1, bekérjük mennyi melléklet lesz,

		while [ $db -lt 1 ] 

		do

			read db

			if [ "$db" -lt 1 ]; then

				echo Ha már azt választotta hogy legyen melléklet, adjon meg legalább egyet!

			fi

		done

	
	
	# itt pedig az útvonalat/útvonalakat kérjük be.

		for x in db 

		do

			echo Kérem adja meg a melléklet útvonalát!

			read utvonal 

			ut+=$utvonal

		done
		
		
		# kisbetűssé tesszük a beolvasott adatot,

		ut_egyben=$(echo ${ut[@]} | tr '[:upper:]' '[:lower:]')

		echo Útvonalak egyben: $ut_egyben
		
		# majd elküldjük a beolvasott tárggyal a szöveget és a mellékletet a megadott címre.

		echo  $szoveg | mutt -c $email -s $targy -a $ut_egyben



		# Egyébként ha "N" vagy "n" a válasz akkor csak simán melléklet nélkül küldjük el az emailt.
	

	elif [[ $v == "N" ]] || [[ $v == "n" ]]; then

		echo  $szoveg | mutt -c $email -s $targy

	else [[ $v == *""* ]] 
	
	
	# Minden egyéb esetben a bemenet érvénytelen.

		echo Érvénytelen bemenet! 

	# töröljük a választ, mert egyébként a függvény újrahívásánál ugyan ez futna le,
	

		unset v
		
		
		# majd visszatérünk a menübe.
		menu



	fi

menu


}







# Itt a menü, ahonnan az egész program indul.
# Minden függvény végén meghívjuk, kivéve az értesítésnél, mert ott folyamatos ciklus szükséges


menu ()
{



	printf "Üdvözlöm a Levelezőben!\nKérem válasszon az alábbi lehetőségek közül:\n\n"

	lehetoseg=("Értesítés" "Olvasás" "Válaszolás" "Új levél írása" "Segítség" "Kilépés")


	# A lehetőségek tömb elemei kiválaszthatóak, és amelyiket a felhasználó megadja, aszerint járunk el:
	
	
	select kategoria in "${lehetoseg[@]}"

	do

		case $kategoria in

				"Értesítés")

					ertesit

					break

					;;

				"Olvasás")

					olvasas

					break

					;;

				"Válaszolás")

					valasz

					break

					;;

				"Új levél írása")

					leveliras

					break

					;;

				"Segítség")

					echo Értesítés - A program folyamatosan figyeli a beérkező leveleket, és értesítést küld ha jön új.
					echo Olvasás - A program beolvassa a leveleket, és lehetőséget ad az elolvasásukra.
					echo Válaszolás - A program a beolvasott levelek email címére ad válaszolási lehetőséget.
					echo Új levél írása - A program előkészíti a levelet, majd el is küldi a megadott email címre.

					;;

				"Kilépés")

					printf "Viszlát!\n";

					exit

					;;

				*) echo "Válasszon a listából!\n";;

		esac

	done
}


# Itt kezdődik a program, kezdésnél a menü függvénnyel indulunk.

menu