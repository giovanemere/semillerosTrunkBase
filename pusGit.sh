#/bin/bash
clear

# set variables
#username=$1
#token=$2
#repo=$3
comment=$1
rama=$2


git config --global user.email "giovanemere@gmail.com"
git config --global user.name "giovanemere"


# Ejecucion

   #    cd /home/giovanemere/Aprovisionamiento_Linux
   #   git clone https://$username:$token@github.com/$repo

   #if [[ $clone =~ ^[Yy]$ ]]
   #then
   #   git clone https://$username:$token@github.com/$repo
   #fi
    
    echo "comment [$comment] | rama [$rama]"
    echo "inicia carga en git"
       
    git status
    read -p "Press [Enter] key to continue..." readEnterKey

    git add .
    read -p "Press [Enter] key to continue..." readEnterKey
    
    git commit -m "$comment"
    read -p "Press [Enter] key to continue..." readEnterKey

    git push origin $rama
    echo -e "\n----- Fin del Script -----------------------------------------------------------"
    read -p "Press [Enter] key to continue..." readEnterKey
