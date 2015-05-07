# Homebrew install setup
#TODO create monosnap cask

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
    totalterminal
  '

# Binaries to be pulled from brew
export Binaries='
    node
    tree
    git
    rbenv
    ruby-build
    bash
    zsh
'

export NPM='
  grunt-cli
  gulp
'


# Check for Homebrew
if test ! $(which brew); then
  echo "#### Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if test ! $(which brew-cask); then
  echo "#### Installing homebrew-cask"
  brew install caskroom/cask/brew-cask
fi

echo "#### Updating homebrew and homebrew-cask"
brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup



echo "#### Preparing to install homebrew formula"

# Install Binaries
for bin in $Binaries
do
  tmp=`brew list | grep $bin`
  if [[ ! $tmp ]]; then
    echo ''
    echo '##### Installing '$bin'...'
    brew install $bin
  fi
done

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

# Install Apps
for app in $Apps
do
  tmp=`brew cask list | grep $app`
  if [[ ! $tmp ]]; then
    echo ''
    echo '##### Installing '$app'...'
    brew cask install $app
  fi
done

# Use Install Grunt
for app in $NPM
do
  tmp=`npm list -g | grep $app`
  if [[ ! $tmp ]]; then
    echo ''
    echo '##### Installing '$app'...'
    npm install $app -g
  fi
done


