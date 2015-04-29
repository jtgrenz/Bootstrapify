

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
    totalterminal
    sococo
  '

# Binaries to be pulled from brew
export Binaries='
    graphicsmagick
    ffmpeg
    python
    node
    tree
    git
    npm
    rbenv
    ruby-build
    bash
    zsh
    findutils
    coreutils
'


export Gems='
    shopify-theme
'

export Misc='
    solarize
    oh-my-zsh
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
    echo '##### Installing Formula '$bin'...'
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

echo "#### Verifying Sublime Install"
if [[ -e "$HOME/Library/Application Support/Sublime Text 2/Packages" ]]; then
  echo "#### Found Sublime Text 2. Installing Bootstrapify Packages..."
  ln -nsf $config_dir/sublime_packages/*  "$HOME/Library/Application Support/Sublime Text 2/Packages"
else
  echo "#### Error! Sublime Text 2 is not installed. Better check Brew Cask settings."
  echo "#### Skipping Sublime Package Install"
fi


