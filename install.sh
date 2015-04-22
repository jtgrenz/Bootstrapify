#!/usr/bin/env sh

##############################################################
################## Configuration #############################
##############################################################

# Variables

bootstrap_dir=$HOME/.bootstrapify
config_dir=$bootstrap_dir/lib
bootstrapify=Bootstrapify
git_master=git@github.com:jtgrenz/bootstrapify.git

# important commands
install_homebrew=ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


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



echo "#### Checking for Xcode commandline tools..."
echo

# check for xcode
if [[ $(xcode-select -p) != "/Applications/Xcode.app/Contents/Developer" ]]; then

  echo ' !! You must install xcode commandline tools first. '
  echo ' !! Click agree on the prompt to install and run this script again'
  xcode-select --install
  exit 1
else
  echo '#### Xcode comandline tools found. Proceeding with bootstrap...'
fi



echo "#### Checking for existing $bootstrapify install"
if [[ ! -d $bootstrap_dir ]]; then
  echo "#### $bootstrapify not found"
  echo "#### Downloading $bootstrapify..."
  echo
  git clone $git_master $bootstrap_dir
  echo
else
  echo "#### $bootstrapify found"
  echo
fi

echo "changing to bootstrap directory..."
cd $bootstrap_dir
pwd

# import config file
source $config_dir/config.cfg

# Check for Homebrew
if test ! $(which brew); then
  echo "#### Installing homebrew..."
  $install_homebrew
fi

if test ! $(which brew-cask); then
  echo "#### Installinh homebrew-cask"
  brew install caskroom/cask/brew-cask
fi

echo "#### Updating homebrew and homebrew-cask"
brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup

# Install Binaries
for bin in $Binaries
do
  tmp=`brew list | grep $bin`
  if [[ ! $tmp ]]; then
    echo ''
    echo '##### Installing Formula '$bin'...'
    brew install $bin
  fi
done







