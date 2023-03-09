#/bin/bash
clear

# set variables
#username=$1
#token=$2
#repo=$3
comment=${1}
rama=${2}
clon2=${3}

# Validar estructura de Repositorio
   if [[ -z $comment ]]; then
      echo  '---------------------------------------------------------------------'
      echo "Ejemplo de Ejecucion"
      echo " sh pushGit.sh \"comentario\" \"rams\" \"clone\" "
      echo  '---------------------------------------------------------------------'
      echo -e "\--- Fin del Script -------------------------"
      read -p "Press [Enter] key to continue..." readEnterKey
      exit 1
   fi

# Configuracion gobal del repositorio
   git config --global user.email "giovanemere@gmail.com"
   git config --global user.name "giovanemere"
   git config --global core.autocrlf false

# Preguntar si desea Clonar
   read -p ">> Digite Y/N si desea clonar : " clone
   if [[ $clone =~ ^[Yy]$ ]]
   then
      git clone $clone
   fi
   
# Pasos de Clonacion
   #Imprimir Variables
      echo -e "--------------------------------------------"  
      echo "comentario :[$comment] | rama :[$rama]"
      echo -e "--------------------------------------------"  
   
   # Status
      echo "--------------------------------------------"   
      echo "inicia carga en git"
      echo "--------------------------------------------"   
         git status
         echo "- Reporte Status----------------------------"
      read -p "Press [Enter] key to continue..." readEnterKey

   # Add todo slo scambios de la carpeta actual
      echo "--------------------------------------------"   
         git add .
         echo "- Agregar cambios locales ------------------"
      read -p "Press [Enter] key to continue..." readEnterKey
   
   # Agregar Comentario
      echo "--------------------------------------------"   
         git commit -m "$comment"
         echo "- Agregar Comenatario ---------------------"
      read -p "Press [Enter] key to continue..." readEnterKey

   #Subir cambios a la rama remota
      echo "--------------------------------------------"   
         git push origin $rama
         echo "- Subir a $rama --------------------------"
      echo "--- Fin del Script -------------------------"
      read -p "Press [Enter] key to continue..." readEnterKey
   echo "Fin Script"
#Fin Script
