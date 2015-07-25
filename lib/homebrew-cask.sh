# Homebrew Cask install setup

# Apps to be pulled from brew-cask
export Apps='
    sublime-text
    slack
    github
    alfred
    google-chrome
    firefox
    textexpander
    recordit
    sococo
  '

if test ! $(which brew-cask); then
  echo "$FORMAT #### Installing homebrew-cask"
  brew install caskroom/cask/brew-cask
fi

echo "$FORMAT #### Updating homebrew and homebrew-cask"
brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup


# Install Apps
for app in $Apps
do
  tmp=`brew cask list | grep $app`
  if [[ ! $tmp ]]; then
    echo ''
    echo "$FORMAT ##### Installing $RED $app ..."
    brew cask install $app
  fi
done
