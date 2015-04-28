

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

# Setup Git Global Config

echo "#### Setting up git"
echo "Enter your first and last name and press [ENTER]"
read name
echo "Enter your email address and press [ENTER]"
read email
git congig --global "$name"
git config --global $email
echo "Git User and Email setup as:"
git config --get user.name
git config --get user.email
