#!/bin/sh
#Csucsu, megy a flex


scale=2

segitseg()
{
cat << EOF
'sh' parancs után:
Adjon meg egy kifejezést, a program kiszámítja az adott érték sh-ját!


'ch' parancs után:
Adjon meg egy kifejezést, a program kiszámítja az adott érték ch-ját!


EOF
}


e=2.7182818284590452353602874713526624977

printf "Üdv a sh/ch számolóban!\nÍrj 'help'-et vagy ?-t a segítségért, írj 'exit'-et vagy 'kilepes'-t a kilepeshez.\nSzámoláshoz írd be hogy 'ch' vagy 'sh'!\n\n"

echo -n ""$"szog> "

while read parancs args

do
  case $parancs
  in
    kilepes|exit) printf "\n\nViszlát!\n" ; exit 0                                   ;;
    segitseg|\?)   segitseg                            ;;
	sh) printf "Adjon meg egy kifejezést!\n"
	read kif
	

se=`echo "$e^$kif-$e^-$kif" | bc -l`
s=`echo "$se/2" | bc -l`


printf "\n\nsh ($kif) = $s\n" ;;



ch) printf "Adjon meg egy kifejezést!\n"
read kif


ce=`echo "$e^$kif+$e^-$kif" | bc -l`
c=`echo "$ce/2" | bc -l`

printf "\n\nch ($kif) = $c\n" ;;


cth) printf "Adjon meg egy kifejezést!\n"
read kif


cthe=`echo "$e^$kif+$e^-$kif" | bc -l`
cth=`echo "$ce/$e^2$kif-1" | bc -l`

printf "\n\nch ($kif) = $cth\n" ;;




  esac

  echo -n "szog> "
done


