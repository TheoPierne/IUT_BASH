#!/bin/bash

touch scores.txt

#randomNumber=${RANDOM:0:2}
randomNumber=3
attemptUser=1
scoreSaved=true
read -p "Choisissez un nombre entre 1 et 99: " input

if [[ $input =~ "^[+-]?[0-9]+([.][0-9]+)?$" ]]; then
	echo "Vous n'avez pas entré de nombre !"
	exit 0
fi

while ((input!=randomNumber))
do
	((attemptUser++))
	read -p "Nombre incorrecte, choisissez en un autre: " input
done

echo "Nombre trouvé ! (${randomNumber} en ${attemptUser} essais)"
read -p "Choisisser un nom à enregistrer pour votre score: " name

if grep -q "${name}" scores.txt; then
	score=$(awk '{print(gensub("${name} ([0-9]+)", "\\1", "g"))}' scores.txt | awk -F" " '{print $2}')
	if [ $attemptUser -le $score ]; then
		sed -i -E "s/${name} [0-9]+/${name} ${attemptUser}/g" scores.txt
	else
		scoreSaved=false
	fi
else
	echo "${name} ${attemptUser}" >> scores.txt
fi

#declare -a allScores

#while read line
#do
#	value=$(echo "${line}" | awk -F" "  '{print $2}')
#	key=$(echo "${line}" | awk -F" " '{print $1}')
#	allScores["${key}"]="${value}"
#done < scores.txt

#echo "${allScores[@]}"
#for key in "${!allScores[@]}"; do echo "$key => ${allScores[$key]}"; done

if [ "${scoreSaved}" == true ]; then
	echo "Score sauvegardé !"
else
	echo "Partie terminée !"
	echo "Le score n'a pas été sauvegardé car vous n'avez pas battu votre record."
fi

exit 0
