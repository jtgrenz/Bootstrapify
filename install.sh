#!/usr/bin/env sh

##############################################################
################## Configuration #############################
##############################################################

# Variables

bootstrap_dir=$HOME/.bootstrapify
config_dir=$bootstrap_dir/lib
bootstrapify=Bootstrapify
git_master=https://github.com/jtgrenz/Bootstrapify.git
xcode_path='$(xcode-select -p)'

# important commands

FORMAT='\e[44m '


##############################################################
################## Begin Install Script ######################
##############################################################


# clear terminal
clear

# print welcome
cat << "EOF"


                          Welcome to
##############################################################
______             _       _                   _  __
| ___ \           | |     | |                 (_)/ _|
| |_/ / ___   ___ | |_ ___| |_ _ __ __ _ _ __  _| |_ _   _
| ___ \/ _ \ / _ \| __/ __| __| '__/ _` | '_ \| |  _| | | |
| |_/ / (_) | (_) | |_\__ \ |_| | | (_| | |_) | | | | |_| |
\____/ \___/ \___/ \__|___/\__|_|  \__,_| .__/|_|_|  \__, |
                                        | |           __/ |
                                        |_|          |___/

##############################################################


EOF

echo -e "$FORMAT This script will install everything you need to get started on the Shopify
Support team."
echo -e "$FORMAT First we will check if Xcode is installed. If its not, we will try to
install it, but you will need to run this script again when its done"
echo -e "$FORMAT Did you want to continue ? (Y / N)"
read input
if [ $input != "Y" ]; then
  echo -e "$FORMAT Maybe another time then. Goodbye!"
  exit 0
fi

echo -e "$FORMAT #### Checking for Xcode commandline tools..."
echo

# check for xcode
if [[  $(xcode-select -p) != "/Applications/Xcode.app/Contents/Developer" ]]  && [[ $(xcode-select -p) != "/Library/Developer/CommandLineTools" ]] ; then

  echo ' !! You must install xcode commandline tools first. '
  echo ' !! Click agree on the prompt to install and run this script again'
  xcode-select --install
  exit 1
else
  echo '#### Xcode comandline tools found. Proceeding with bootstrap...'
fi

# Get sudo and keep alive
echo -e "$FORMAT #### Please Enter your login password (you should be the admin)"
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# Check for install type

echo -e "$FORMAT #### Did you want to run experimental full install or theme support CLI only?"
proceed=false

while [$proceed == false ]
echo -e "$FORMAT #### Enter FULL or CLI to continue or control + c to abort the installer"
    read install_type
  if [[ "$install_type" == "FULL" || "$install_type" == "CLI" ]]; then
    proceed=true
  fi
done

# Setup Git Global Config
echo -e "$FORMAT #### Checking for git setup"
if [ "$(git config --global user.name)" != "" ] && [ "$(git config --global user.email)" != ""]; then
  echo -e "$FORMAT #### Git Configured Already"
else
  echo -e "$FORMAT #### Setting up git"
  echo -e "$FORMAT Enter your first and last name and press [ENTER]"
  read name
  echo -e "$FORMAT Enter your SHOPIFY email address and press [ENTER]"
  read email
  git config --global user.name "$name"
  git config --global user.email "$email"
fi
 echo -e "$FORMAT Git User and Email setup as:"
  git config --get user.name
  git config --get user.email

echo -e "$FORMAT #### Checking for existing SSH Keys"

if [[ ! -e $HOME/.ssh/id_rsa ]]; then
  echo -e "$FORMAT id_rsa not found. Generating new ssh key"
      mkdir -p $HOME/.ssh && cd $HOME/.ssh
     ssh-keygen -b 1024 -t rsa -f id_rsa -P ""
  else
    echo -e "$FORMAT SSH key found"
fi


echo -e "$FORMAT #### Checking for existing $bootstrapify install"
if [[ ! -d $bootstrap_dir ]]; then
  echo -e "$FORMAT #### $bootstrapify not found"
  echo -e "$FORMAT #### Downloading $bootstrapify..."
  echo
  git clone $git_master $bootstrap_dir
  echo
else
  echo -e "$FORMAT #### $bootstrapify found"

  echo
fi

echo -e "$FORMAT changing to bootstrap directory..."
cd $bootstrap_dir
git pull origin master
pwd


# import config file

 source $config_dir/homebrew.sh
 if [[ "$install_type" == "FULL" ]]; then
  source $config_dir/homebrew-cask.sh
 fi
 source $config_dir/npm-install.sh
 source $config_dir/general.sh
 # source $config_dir/ruby.sh







