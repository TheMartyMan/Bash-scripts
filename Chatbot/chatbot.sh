#!/bin/bash
#Csucsu, megy a flex

# Ha az első argumentum "-h", írjon ki helpet,

if [[ $1 == "-h" ]]; then

echo 'Chatbot! LED Lámpa termék kezelés: Hibabejelentés, értékelés'
echo 'A kiírt fájlban (chat.txt) követni lehet hogy éppen mikor kezdődött/zárult a beszélgetés,'
echo 'illetve minden visszajelzés időponthoz van kötve és nyomonkövetkető hogy éppen a chatbot, vagy a felhasználó írt'
exit

fi


# ha nem, menjünk tovább.






# Információ a termékről, újrahívható függvény

A()
{

# A menüben megadott választ unseteljük, már nincs értéke
unset valasz


# A választ addig olvassuk, amíg a válasz nem "A", vagy "a",

while [[ $valasz != ["Aa"] ]]




# majd szépen formázottan kiírjuk külön fájlba (chat.txt) hogy mit reagált a chatbot, arra hogyan a felhasználó, stb.

do

	echo "" >> chat.txt && echo "" >> chat.txt && echo '    Chatbot - '$(date +"%T") >> chat.txt && cat A.txt >> chat.txt

# megnyitjuk a fájlt hogy konzolban lássa a felhasználó

	cat A.txt
	
	
	

	
	
	
	read valasz && echo "" && echo "" >> chat.txt >> chat.txt && echo '    Felhasználó - '$(date +"%T") >> chat.txt && echo '$> '$valasz >> chat.txt
		
		case $valasz in
		
		
		# menu függvény hívása
		
		[Aa]) menu;;
		
		
		# egyébként írja ki hogy érvénytelen a bemenet
		
		*)

		echo ""
		echo Kérem a listából válasszon!
		
		
		echo "" >> chat.txt && echo "" >> chat.txt && echo '    Chatbot - '$(date +"%T") >> chat.txt && echo Kérem a listából válasszon! >> chat.txt;;
		esac
		
	done


}







# Hibajelentés, újrahívható függvény

B()
{


# Ugyan az mint A-nál, annyi
unset valasz


# hogy itt A-D vannak a lehetőségek,


while [[ $valasz != ["AaBbCcDd"] ]]

# és aszerint válaszol/jár el a program:



do

echo "" >> chat.txt && echo "" >> chat.txt && echo '    Chatbot - '$(date +"%T") >> chat.txt && cat B.txt >> chat.txt

	cat B.txt


	read valasz && echo "" >> chat.txt && echo "" >> chat.txt && echo '    Felhasználó - '$(date +"%T") >> chat.txt && echo '$> '$valasz >> chat.txt


		# Exit egyértelműen a kilépés, de előtte szépen formázottan kiíratjuk a fájlba (chat.txt) a beszélgetés végét

		
		case $valasz in

		[Aa])

		echo Rendben, a hibabejelentést rögzítettük és továbbítottuk a futárszolgálatnak.
		echo Az okozott kellemetlenségekért bocsánatot kérünk!
		echo "" >> chat.txt && echo "" >> chat.txt && echo '    Chatbot - '$(date +"%T") >> chat.txt && echo Rendben, a hibabejelentést rögzítettük és továbbítottuk a futárszolgálatnak. >> chat.txt && echo Az okozott kellemetlenségekért bocsánatot kérünk! >> chat.txt && echo "" >> chat.txt  && echo "" >> chat.txt && echo '***** BESZÉLGETÉS VÉGE: '$(date +"%Y.%m.%d, %A - %T") ' *****' >> chat.txt                                                    
		exit;;
        
        [Bb])
		
		echo Rendben, a hibabejelentést rögzítettük és továbbítottuk az illetékes kollégáknak.
		echo Az okozott kellemetlenségekért bocsánatot kérünk!
		echo "" >> chat.txt && echo "" >> chat.txt && echo '    Chatbot - '$(date +"%T") >> chat.txt && echo Rendben, a hibabejelentést rögzítettük és továbbítottuk az illetékes kollégáknak. >> chat.txt && echo Az okozott kellemetlenségekért bocsánatot kérünk! >> chat.txt && echo "" >> chat.txt  && echo "" >> chat.txt && echo '***** BESZÉLGETÉS VÉGE: '$(date +"%Y.%m.%d, %A - %T") ' *****' >> chat.txt
		exit;;
		
		
		[Cc])
		echo Rendben, a hibabejelentést rögzítettük, kérelmet vettünk fel az ügy kivizsgálásához. Mihamarabb értesítjük!
		echo Az okozott kellemetlenségekért bocsánatot kérünk!
		echo "" >> chat.txt && echo "" >> chat.txt && echo '    Chatbot - '$(date +"%T") >> chat.txt && echo Rendben, a hibabejelentést rögzítettük, kérelmet vettünk fel az ügy kivizsgálásához. Mihamarabb értesítjük! >> chat.txt && echo Az okozott kellemetlenségekért bocsánatot kérünk! >> chat.txt && echo "" >> chat.txt  && echo "" >> chat.txt && echo '***** BESZÉLGETÉS VÉGE: '$(date +"%Y.%m.%d, %A - %T") ' *****' >> chat.txt
		exit;;
		
		[Dd])
		unset valasz
		menu;;
		
		*)
		
		echo ""
		echo Kérem a listából válasszon!
		
		echo "" >> chat.txt && echo "" >> chat.txt && echo Kérem a listából válasszon! >> chat.txt;;
		esac
		
	done


}



# Értékelés, újrahívható függvény

C()
{

# Ugyan az mint A és B esetén, csak itt A-F vannak lehetőségek


unset valasz


while [[ $valasz != ["AaBbCcDdEeFf"] ]]



do

echo "" >> chat.txt && echo "" >> chat.txt && echo '    Chatbot - '$(date +"%T") >> chat.txt && cat C.txt >> chat.txt

	cat C.txt

	read valasz && echo "" >> chat.txt && echo "" >> chat.txt && echo '    Felhasználó - '$(date +"%T") >> chat.txt && echo '$> '$valasz >> chat.txt




		# A bemenet lényegtelen, minden esetben ugyan az lesz a válasz
		# Exit egyértelműen a kilépés, de előtte szépen formázottan kiíratjuk a fájlba (chat.txt) a beszélgetés végét
		
		case $valasz in

		[AaBbCcDdEe])

		echo Köszönjük értékelését!
		echo "" >> chat.txt && echo "" >> chat.txt && echo '    Chatbot - '$(date +"%T") >> chat.txt && echo Köszönjük értékelését! >> chat.txt && echo "" >> chat.txt  && echo "" >> chat.txt && echo '***** BESZÉLGETÉS VÉGE: '$(date +"%Y.%m.%d, %A - %T") ' *****' >> chat.txt
		exit;;
        
		
		[Ff]) menu;;
		
		*)
		
		echo ""
		echo Kérem a listából válasszon!
		
		echo "" >> chat.txt && echo "" >> chat.txt && echo Kérlek a listából válassz! >> chat.txt;;
		esac
		
	done


}
















# Menü, újrahívható függvény

menu ()
{

# Ugyan az mint A, B, és C esetén.
# Főfüggvény, ezzel indul a program, B/D pontja illetve A/A pontja esetén is ide térünk vissza



unset valasz
while [[ $valasz != ["AaBbCc"] ]]



do
	echo "" >> chat.txt && echo "" >> chat.txt && echo '    Chatbot - '$(date +"%T") >> chat.txt && cat menu.txt >> chat.txt

	cat menu.txt


	read valasz && echo "" >> chat.txt && echo "" >> chat.txt && echo '    Felhasználó - '$(date +"%T") >> chat.txt && echo '$> '$valasz >> chat.txt
	
		# Megnézzük mit válaszolt a felhasználó, aszerint haladunk tovább
		case $valasz in
		
		[Aa]) A;;
        
        [Bb]) B;;
		
		[Cc]) C;;
		
		*)

		echo ""
		echo Kérem a listából válasszon!
		
		
		echo "" >> chat.txt && echo "" >> chat.txt && echo '    Chatbot - '$(date +"%T") >> chat.txt && echo Kérlek a listából válassz! >> chat.txt;;
		esac
		
	done
	

}


# Igazából itt indul a script, eddig csak a függvények voltak megírva

# Szépen formázottan kiírjuk a fájlba (chat.txt) a beszélgetés kezdetét
echo '***** BESZÉLGETÉS KEZDETE: '$(date +"%Y.%m.%d, %A - %T") ' *****' >> chat.txt


# Indulás - menübe belépünk (meghívjuk a függvényt)

menu


