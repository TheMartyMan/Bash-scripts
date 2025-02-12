#!/bin/sh
#Csucsu, megy a flex


# URL-ek tömbben, bővíthető.
URL=(https://hvg.hu/ https://index.hu/ https://24.hu/)

printf "\n"


# For ciklus, csinálja do és done között a dolgokat megadott tömb elemszámszor.
# Végigmegyünk az URL tömbön, és minden elemén (hirportálon) megnézzük hogy honnan van a hír, illetve mik a hírek URL-jei.

for i in "${URL[@]}"
	do

		# Elválasztás " -ként.
		IFS='"'
		printf "\n"
	
	
	
		# Kiszedjük az összes címet. (Ami tartalmaz <=title -t az után mindig cím szerepel.)
		hir=$(curl --silent $i | grep -Po '(?<=title=")[^"]*')
	
	
	
		# Kiszedjük az összes URL-t. (Ami <a href= , az után mindig URL van.)
		hir2=$(curl --silent $i | grep -Po '(<a href=")[^"]*')
	
	
	
	
		# Kiiratjuk a hir változót, azzal már nincs dolgunk.
		echo Forrás: $hir
		
		
		
		
		
		# Elválasztás, hogy szép legyen
		printf "\n\n-----------------------------------\n\n"
		
		echo Link:
		printf "\n"
		
		
		
		
		# Mivel alapvetően a hir2 változó még tartalmazza a <a href substringet is, ezt most levesszük belőle, majd kiiratjuk.
		echo $hir2 | sed -e 's#^<a href=##'
		
		
		printf "\n\n-----------------------------------\n\n"
	
	done
# For ciklus vége

