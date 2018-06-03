#!/bin/bash

# Version: 0.0.1 ?
# by Knaku

# Custom install and customization script

######################### VARIABLES #########################

gitDir="/tmp"
scriptDir="$(dirname "$(readlink -f "$0")")"
VAR="FALSE"

######################### ARGUEMENTS #########################

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in                      # options
    -d|--directory)               # choose script-directory
    DIRECTORY="$2"                # download/install folder
    shift # past argument
    shift # past value
    ;;
    -H|--home)                    # set script-directory to $HOME of
    home=YES                      # user running script
    VAR="true"
    shift # past argument
    ;;
    -g|--git)                     # set git-directory to $script-directory/git
    GIT=YES
    VAR="true"
    shift # past arguemnt
    ;;
    -gh|--githome)                # set git directory to $HOME/git
    GIT=HOME
    VAR="true"
    shift # past arguemnt
    ;;
    -h|--help)                    # show help menu
    VAR="true"
    printf "%b\n\nHELP MESSAGE HERE\n\n"
    exit 0
    ;;
    --default)                    # set to script-directorydownload/install
    DEFAULT=YES                   # folder at same path as the script
    VAR="true"
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

##################### ARGUEMNT CHECKING #####################

if [ "$DIRECTORY" != '' ]; then
  true="false"
  while [ "$true" = "false" ]; do
    if [ ! -d "$DIRECTORY" ]; then
      printf "%b\n\nSupplied directory; $DIRECTORY does not exist. \
        \n\n\t1)Enter path of existing directory 		   \
        \n\t2)Use the (d) the same path as the script 		   \
        \n\t3)Or the (h) HOME folder 				   \
        \n\n\tDirectory: "
      read -r tempDir

      case $tempDir in
        d)
          DIRECTORY="$(dirname "$(readlink -f "$0")")"
          ;;
        h)
          DIRECTORY=$HOME
          ;;
        *)
          DIRECTORY=$tempDir
          ;;
      esac

    else
      true="true"
    fi
  done
  scriptDir=$DIRECTORY
  VAR="true"

elif [ $VAR != "true" ]; then
  scriptDir="$(dirname "$(readlink -f "$0")")"
  clear
  printf "%b\n\nUsing default directory "
  printf %s "$scriptDir. Use option -h ($0 -h)"
  printf "\nto get the help menu with options and explinations. \
    \n\nTo abort press Ctrl+C"
  sleep 5
  clear
fi

if [ "$DEFAULT" == "YES" ]; then
  setDir="$scriptDir"
fi

if [ "$home" = "YES" ]; then
  setDir=$HOME
fi

if [ "$GIT" = "YES" ]; then
  gitDir=$scriptDir/"git"
fi

if [ "$GIT" = "HOME" ]; then
  gitDir=$HOME/"git"
fi

######################### DIRECTORIES #########################

  # check if directories exists, if not, create them

dir=$setDir/"installeroo"
configDir=$scriptDir/"config"
downloadsDir=$dir/"downloads"
backgroundDir=$dir/"backgrounds"
themesDir=$dir/"themes"

if [ ! -d "$dir" ]; then
  mkdir "$dir"
fi

if [ ! -d "$gitDir" ]; then
  mkdir "$gitDir"
fi

if [ ! -d "$configDir" ]; then
  mkdir "$configDir"
fi

if [ ! -d "$backgroundDir" ]; then
  mkdir "$backgroundDir"
fi

if [ ! -d "$themesDir" ]; then
  mkdir "$themesDir"
fi

if [ ! -d "$downloadsDir" ]; then
  mkdir "$downloadsDir"
fi

######################### READ FROM FILE #########################

# Applications
  # read from file, if not exists, create the file user can add applications
if [ -f "$configDir/applications.conf" ]; then
  applicationsArray="$configDir/applications.conf"
  applicationsArray=$(grep -vE '^(\s*$|#)' "$applicationsArray")
  readarray applicationsArray <<< "$applicationsArray"
else
  touch "$configDir/applications.conf"
fi

# git repos
  # read from file, if not exists, create the file user can add git repos
if [ -f "$configDir/gitRepositories.conf" ]; then
  gitRepoConf="$configDir/gitRepositories.conf"
  gitReposArray=$(grep -vE '^(\s*$|#)' -- "$gitRepoConf")
  readarray gitReposArray <<< "$gitReposArray"
else
  touch "$configDir/gitRepositories.conf"
fi

# Custom Applications
  # read from file, if not exists, create the file user can add custom
  # applications installitions, e.g from downloaded gits
if [ -f "$configDir/customApplications.conf" ]; then
  customApplicationsArray="$configDir/customApplications.conf"
  customApplicationsArray=$(grep -vE '^(\s*$|#)' "$customApplicationsArray")
  readarray customApplicationsArray <<< "$customApplicationsArray"
else
  touch "$configDir/customApplications.conf"
fi

# Backgrounds
  # read from file, if not exists, create the file so
  # user can add backgrounds to download
if [ -f "$configDir/themes.conf" ]; then
  backgroundsArray="$configDir/background.conf"
  backgroundsArray=$(grep -vE '^(\s*$|#)' "$backgroundsArray")
  readarray backgroundArray <<< "$backgroundArray"
else
  touch "$configDir/background.conf"
fi

# Themes
  # read from file, if not exists, create the file so
  # user can add themes to download
if [ -f "$configDir/themes.conf" ]; then
  themesArray="$configDir/themes.conf"
  themesArray=$(grep -vE '^(\s*$|#)' "$themesArray")
  readarray themesArray <<< "$themesArray"
else
  touch "$configDir/themes.conf"
fi

# addons
  # read from file, if not exists, create the file so
  # user can add addons to download
if [ -f "$configDir/addons.conf" ]; then
  addonsArray="$configDir/addons.conf"
  addonsArray=$(grep -vE '^(\s*$|#)' "$addonsArray")
  readarray addonsArray <<< "$addonsArray"
else
  touch "$configDir/addons.conf"
fi


######################### FUNCTIONS #########################

# Install applications
applications() {
  cd "$setDir" || 
  for i in "${!applicationsArray[@]}"; do
    echo "$i"
    apt-get install -y "$i"
  done
}

# git repos
git() {
  cd "$gitDir" || printf %s "Could not enter $gitDir" exit 1
  for i in "${gitReposArray[@]}"; do
    echo "$i"
    exec git clone "$i"

  done
}

# Custom Applications
customApplications() {
  cd "$gitDir" || printf %s "Could not enter $gitDir" exit 1
  for i in "${customApplicationsArray[@]}"; do
    "$i"
  done
}

# Backgrounds
backgrounds() {
  cd "$backgroundDir" || printf %s "Could not enter $backgroundDir" exit 1
  for i in "${backgroundsArray[@]}"; do
    echo "$i"
    echo " "
    echo " "
    wget --content-disposition "$i"
    sleep 1
    echo " "
    echo " "
  done
  wait
}

# Themes
themes() {
  cd "$themesDir" || printf %s "Could not enter $themesDir" exit 1
  for i in "${themesArray[@]}"; do
    echo "$i"
    exec wget -i --content-disposition "$i"
  done
}

# Addons
addons() {
  cd "$downloadsDir" || printf %s "Could not enter $downloadsDir" exit 1
  for i in "${addonsArray[@]}"; do
    echo "$i"
    exec wget -i --content-disposition "$i"
  done
}

######################### MAIN #########################

applications
#git
#customApplications
#backgrounds
#themes
#addons
