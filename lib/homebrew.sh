# Homebrew install setup


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


# Check for Homebrew
if test ! $(which brew); then
  echo -e "$FORMAT #### Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo -e "$FORMAT #### Updating homebrew"
brew update && brew cleanup

echo -e "$FORMAT #### Preparing to install homebrew formula"


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



