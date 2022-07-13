#!/bin/bash
biptonumber(){
 typeset arr arr_seed seed cont control
 
 #Carrega arquivo no array
 IFS=$'\n'
 declare -a arr
 for word in $(cat english.txt); do
  arr+=($word)
 done

 #Calcula a seed numérica do usuário
 declare -a arr_seed
 declare -i cont control
 echo "---------------------------------------------------------------------------------"
 echo "Type your seed in order below:"
 control=0
 for i in $(seq $seed_size); do
  read -p "Word $i: " seed
  cont=1
  for j in ${arr[@]}; do
   if [ $j == $seed ]; then
    arr_seed+=($cont)
    control+=1
   fi
   cont+=1
  done
 done
 echo "---------------------------------------------------------------------------------"
 echo "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
 if [ $control == $seed_size ]; then
  echo "--------------------------------------------------------------------------------"
  echo "Your numeric seed is:"
  echo ${arr_seed[@]}
  echo "--------------------------------------------------------------------------------"
  echo "> Warning! Write it down (from left to right) and burn your computer."
  echo "> Bye!"
 else
  echo "---------------------------------------------------------------------------------"
  echo "> Sorry!"
  echo "> Some word doesn't match with bip39 english words!"
  echo "> Be careful with spaces! Try run it again!"
 fi
}
bip(){
 typeset file download hash file_hash arr
 file="english.txt"
 download="https://raw.githubusercontent.com/bitcoin/bips/master/bip-0039/english.txt"
 
 #Baixa arquivo
 if [ -s $file ]; then
  echo "> Hello," $file "alread exist!"
 else rm $file 2>/dev/null | wget -q $download
  if [ -s $file ]; then
   echo "> Good news," $file "was downloaded with success!"
  else echo "> Sorry, something is wrong!"
  fi
 fi
 
 #Checa arquivo
 hash="2f5eed53a4727b4bf8880d8f3f199efc90e58503646d9ff8eff3a2ed3b24dbda"
 file_hash=$(sha256sum english.txt | awk '{print $1}')
 if [ $hash == $file_hash ]; then
  echo "> Everything is good to proceed!"
  biptonumber
 else echo "> Bad news, check your english.txt or remove it and try again!"
 fi
}
help(){
 echo "Use: ./bip39number.sh [seed size]"
 echo "Example: ./bip39number.sh 12"
}
#Inicio
seed_size=$1
if ! [[ $seed_size =~ ^[0-9]+$ ]]; then
 echo "Invalid input: integer only."
 help
elif [ $# -ne 1 -o $seed_size == 0 ]; then
 help
else
 echo -n "You understand that you may be compromising your bitcoin seed by typing it? y/n: "
 read answer
 case "$answer" in
  y)
        bip
        ;;
  n)
        echo "Go study!"
        echo "Closing..."
        ;;
  *)
        echo "Type y for yes or n for no!"
        ;;
 esac
fi
