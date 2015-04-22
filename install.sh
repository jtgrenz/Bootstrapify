#!/usr/bin/env sh

# import config file
source config.cfg

# check for xcode
if [ $(xcode-select -p) != "/Applications/Xcode.app/Contents/Developer" ]; then

  echo ' You must install xcode commandline tools first. '
  echo ' Click agree on the prompt to install and run this script again'
  xcode-select --install
  exit 1
else
  echo ' Xcode comandline tools found. Proceeding with bootstrap'
  exit 1
fi

# # Check for Homebrew
# if test ! $(which brew); then
#   echo "Installing homebrew..."
#   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# fi

# # Update homebrew
# brew update && brew upgrade brew-cask

# # Install GNU core utilities (those that come with OS X are outdated)
# brew install coreutils

# # Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
# brew install findutils

# # Install Bash 4
# brew install bash
# brew install zsh

# # Install more recent versions of some OS X tools
# brew tap homebrew/dupes
# brew install homebrew/dupes/grep

