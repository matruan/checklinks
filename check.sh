cadena="";
c="";
cont=0;
contUrl=0;
contEnlaces=0;
enlacesVacios=0;
urls="";
lenghtHref=0;
paginasEncontradas=0;
paginasNoEncontradas=0;
while read -n1 c;
do
  cadena=$cadena$c
done < $1
tamanyo=${#cadena}
while [ $cont -lt $tamanyo ];
do
  if [ "${cadena:cont:4}" == "href" ]
  then
    contUrl=$((cont+6));
    while [ "${cadena:contUrl:1}" != "\"" ]
    do
       ((contUrl++))
    done
    lenghtHref=`expr $contUrl - $((cont+6))`;
    if [ $lenghtHref != 0 ]
    then 
      url=${cadena:$((cont+6)):$lenghtHref};
      respuesta=$(curl -Is $url | head -n 1);
      urls=$urls$url"\t"$respuesta"\n";
      echo -e $url
      echo -e $respuesta
    else
      echo -e "\e[31mEnlace "$((contEnlaces+1))" vacio!\e[0m"
      ((enlacesVacios++))
    fi
    ((contEnlaces++))
  fi
  ((cont++))
done
echo
echo -e "\e[1m"$contEnlaces" enlaces analizados\e[0m"
paginasEncontradas=$(echo -e $urls | grep -v "HTTP...4.." | wc -l);
echo -e "\e[1m"$paginasEncontradas" paginas encontradas\e[0m"
echo -e $urls | grep -v "HTTP...4.."
echo
paginasNoEncontradas=$(echo -e $urls | grep "HTTP...4.." | wc -l);
echo -e "\e[31m"$paginasNoEncontradas" paginas no encontradas\e[0m"
echo -e $urls | grep "HTTP...4.." 
echo
echo -e "\e[31m"$enlacesVacios" enlaces vacios\e[0m"
echo