#!/bin/bash

# Version: 0.0.1.5 ?
# by Knaku

# Custom install and customization script

######################### VARIABLES #########################

gitDir="/tmp"
scriptDir="$(dirname "$(readlink -f "$0")")"      # directort of script
VAR="FALSE"                       # used to check if variabes is used,
                                    # if not display short help message

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
    --debug)                    # turn on debuging
    DEBUG=YES
    VAR="true"
    shift # past argument
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

############   Debugging   ############
if [ "${DEBUG}" == "YES" ]; then
  printf "%b\n\nScript directory is set to "
  printf %s "$scriptDir"
  printf "%b, and options have been processed\n\n"
fi
############   Debugging   ############

##################### ARGUEMNT CHECKING #####################

if [ "$DIRECTORY" != '' ]; then
############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\n\nCustom directory option set\n\n"
  fi
############   Debugging   ############

  true="false"
  while [ "$true" = "false" ]; do
    if [ ! -d "$DIRECTORY" ]; then

############   Debugging   ############
      if [ "${DEBUG}" == "YES" ]; then
        printf "%b\n\nCustom directory not found, asking for other solutionsn\n"
      fi
############   Debugging   ############
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

  setDir=$DIRECTORY
  VAR="true"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\n\nCustom directory option enabled, directory setDir to"
    printf %s "$setDir"
    printf "%b\n\n"
  fi
############   Debugging   ############

elif [ $VAR != "true" ]; then
  scriptDir="$(dirname "$(readlink -f "$0")")"
  clear
  printf "%b\n\nUsing default directory "
  printf %s "$scriptDir. Use option -h ($0 -h)"
  printf "\nto get the help menu with options and explinations. \
    \n\nTo abort press Ctrl+C"
  sleep 5
  clear

else
  printf "\nNo directory set, choosing directory at script root\n"
  setDir=$scriptDir
fi

if [ "$DEFAULT" == "YES" ]; then
  setDir=$scriptDir

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\n\nDefault option enabled, directory setDir to"
    printf %s "$setDir"
    printf "%b\n\n"
  fi
############   Debugging   ############

fi

if [ "$home" = "YES" ]; then
  setDir=$HOME

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\n\nHome folder option enabled, setting directory to"
    printf %s "$setDir"
    printf "%b\n\n"
  fi
############   Debugging   ############

fi

if [ "$GIT" = "YES" ]; then
  gitDir=$scriptDir/"git"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\n\nGit in directory option enabled, directory setDir to"
    printf %s "$gitDir"
    printf "%b\n\n"
  fi
############   Debugging   ############

fi

if [ "$GIT" = "HOME" ]; then
  gitDir=$HOME/"git"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\n\nGit in home folder option enabled, directory setDir to"
    printf %s "$gitDir"
    printf "%b\n\n"
  fi
############   Debugging   ############

fi

######################### DIRECTORIES #########################

  # check if directories exists, if not, create them

dir=$setDir/"Installeroo"
configDir=$scriptDir/"config"
downloadsDir=$dir/"downloads"
backgroundDir=$dir/"backgrounds"
themesDir=$dir/"themes"



############   Debugging   ############
if [ "${DEBUG}" == "YES" ]; then
  printf "%b\n\nDirectories are: \n\t"
  printf %s "$setDir"
  printf "%b\n\t"
  printf %s "$dir"
  printf "%b\n\t"
  printf %s "$configDir"
  printf "%b\n\t"
  printf %s "$downloadsDir"
  printf "%b\n\t"
  printf %s "$backgroundDir"
  printf "%b\n\t"
  printf %s "$backgroundDir"
  printf "%b\n\n"
fi
############   Debugging   ############


if [ ! -d "$dir" ]; then
  mkdir "$dir"

############   Debugging   ############
if [ "${DEBUG}" == "YES" ]; then
    printf "%b\n\nCould not find the main directory, created one at"
    printf %s "$dir"
    printf "%b\n\n"
  fi
############   Debugging   ############

fi

if [ ! -d "$gitDir" ]; then
  mkdir "$gitDir"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\n\nCould not find the git directory, created one at"
    printf %s "$gitDir"
    printf "%b\n\n"
  fi
############   Debugging   ############

fi

if [ ! -d "$configDir" ]; then
  mkdir "$configDir"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\n\nCould not find the config directory, created one at"
    printf %s "$configDir"
    printf "%b\n\n"
  fi
############   Debugging   ############

fi

if [ ! -d "$backgroundDir" ]; then
  mkdir "$backgroundDir"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\n\nCould not find the background directory, created one at"
    printf %s "$backgroundDir"
    printf "%b\n\n"
  fi
############   Debugging   ############

fi

if [ ! -d "$themesDir" ]; then
  mkdir "$themesDir"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\n\nCould not find the themes directory, created one at "
    printf %s "$backgroundDir"
    printf "%b\n\n"
  fi
############   Debugging   ############

fi

if [ ! -d "$downloadsDir" ]; then
  mkdir "$downloadsDir"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\n\nCould not find the download directory, created one at"
    printf %s "$downloadsDir"
    printf "%b\n\n"
  fi
############   Debugging   ############

fi

######################### READ FROM FILE #########################

# Applications
  # read from file, if not exists, create the file user can add applications
if [ -f "$configDir/applications.conf" ]; then
  applicationsArray="$configDir/applications.conf"
  applicationsArray=$(grep -vE '^(\s*$|#)' "$applicationsArray")
  readarray applicationsArray <<< "$applicationsArray"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\nReading applications into Applications Array"
  fi
############   Debugging   ############

else
  touch "$configDir/applications.conf"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\nCould not find an applications config file,
\\\\\\created a new one at"
    printf %s "$configDir"
    printf "%b/applications.conf"
  fi
############   Debugging   ############

fi

# git repos
  # read from file, if not exists, create the file user can add git repos
if [ -f "$configDir/gitRepositories.conf" ]; then
  gitRepoConf="$configDir/gitRepositories.conf"
  gitReposArray=$(grep -vE '^(\s*$|#)' -- "$gitRepoConf")
  readarray gitReposArray <<< "$gitReposArray"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\nReading git repositories into Git Repository Array"
  fi
  ############   Debugging   ############

else
  touch "$configDir/gitRepositories.conf"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\nCould not find a git config file, created a new one at "
    printf %s "$configDir"
    printf "%b/themes.conf"
  fi
############   Debugging   ############

fi

# Custom Applications
  # read from file, if not exists, create the file user can add custom
  # applications installitions, e.g from downloaded gits
if [ -f "$configDir/customGitInstallation.conf" ]; then
  customGitInstallationArray="$configDir/customGitInstallation.conf"
  customGitInstallationArray=$(grep -vE '^(\s*$|#)' \
    "$customGitInstallationArray")
  readarray customGitInstallationArray <<< "$customGitInstallationArray"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\nReading custom commands into Git Installations Array"
  fi
############   Debugging   ############

else
  touch "$configDir/customGitInstallation.conf"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\nCould not find config config file, created a new one at"
    printf %s "$configDir"
    printf "%b/themes.conf"
  fi
############   Debugging   ############

fi

# Backgrounds
  # read from file, if not exists, create the file so
  # user can add backgrounds to download
if [ -f "$configDir/background.conf" ]; then
  backgroundsArray="$configDir/background.conf"
  backgroundsArray=$(grep -vE '^(\s*$|#)' "$backgroundsArray")
  readarray backgroundsArray <<< "$backgroundsArray"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\nReading backgrounds into Backgrounds Array"
  fi
############   Debugging   ############

else
  touch "$configDir/background.conf"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\nCould not find background config file, created a new one at "
    printf %s "$configDir"
    printf "%b/background.conf"
  fi
############   Debugging   ############

fi

# Themes
  # read from file, if not exists, create the file so
  # user can add themes to download
if [ -f "$configDir/themes.conf" ]; then
  themesArray="$configDir/themes.conf"
  themesArray=$(grep -vE '^(\s*$|#)' "$themesArray")
  readarray themesArray <<< "$themesArray"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\nReading themes into Themes Array"
  fi
############   Debugging   ############

else
  touch "$configDir/themes.conf"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\nCould not find config config file, created a new one at "
    printf %s "$configDir"
    printf "%b/themes.conf"
  fi
############   Debugging   ############

fi

# addons
  # read from file, if not exists, create the file so
  # user can add addons to download
if [ -f "$configDir/addons.conf" ]; then
  addonsArray="$configDir/addons.conf"
  addonsArray=$(grep -vE '^(\s*$|#)' "$addonsArray")
  readarray addonsArray <<< "$addonsArray"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\nReading addons into Addons Array\n\n\n"
  fi
############   Debugging   ############

else
  touch "$configDir/addons.conf"

############   Debugging   ############
  if [ "${DEBUG}" == "YES" ]; then
    printf "%b\nCould not find addons config file, created a new one at "
    printf %s "$configDir"
    printf "%b/addons.conf\n\n\n"
  fi
############   Debugging   ############

fi


######################### FUNCTIONS #########################

# Install applications
applications() {
  cd "$setDir" ||
  for i in "${applicationsArray[@]}"; do

############   Debugging   ############
    if [ "${DEBUG}" == "YES" ]; then
      printf "%b\nInstalling "
      printf %s "$i"
    fi
############   Debugging   ############
    apt-get install --assume-yes $i

  done
}

# git repos
git() {
  cd "$gitDir" || printf %s "Could not enter $gitDir" exit 1
  for i in "${gitReposArray[@]}"; do

############   Debugging   ############
    if [ "${DEBUG}" == "YES" ]; then
      printf "%b\nCloning git repository "
      printf %s "$i"
    fi
############   Debugging   ############
    exec git clone "$i"

  done
}

# Custom Applications
customGitInstallation() {
  cd "$gitDir" || printf %s "Could not enter $gitDir" exit 1
  for i in "${customGitInstallationArray[@]}"; do

############   Debugging   ############
    if [ "${DEBUG}" == "YES" ]; then
      printf "%b\nRunning custom command "
      printf %s "$i"
    fi
############   Debugging   ############
    "$i"

  done
}

# Backgrounds
backgrounds() {
  cd "$backgroundDir" || printf %s "Could not enter $backgroundDir" exit 1
  for i in "${backgroundsArray[@]}"; do

############   Debugging   ############
    if [ "${DEBUG}" == "YES" ]; then
      printf "%b\nDownloading background from "
      printf %s "$i"
    fi
############   Debugging   ############
    wget --content-disposition "$i"
    sleep 1

  done
  wait
}

# Themes
themes() {
  cd "$themesDir" || printf %s "Could not enter $themesDir" exit 1
  for i in "${themesArray[@]}"; do

############   Debugging   ############
    if [ "${DEBUG}" == "YES" ]; then
      printf "%b\nDownloading theme from "
      printf %s "$i"
    fi
############   Debugging   ############
    exec wget -i --content-disposition "$i"

  done
}

# Addons
addons() {
  cd "$downloadsDir" || printf %s "Could not enter $downloadsDir" exit 1
  for i in "${addonsArray[@]}"; do

############   Debugging   ############
      if [ "${DEBUG}" == "YES" ]; then
      printf "%b\nDownloading addon from "
      printf %s "$i"
    fi
############   Debugging   ############
    exec wget -i --content-disposition "$i"

  done
}

######################### MAIN #########################

applications
#git
#customGitInstallation
#backgrounds
#themes
#addons
