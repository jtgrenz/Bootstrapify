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
  echo "$FORMAT #### Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "$FORMAT #### Updating homebrew"
brew update && brew cleanup

echo "$FORMAT #### Preparing to install homebrew formula"


# Install Binaries
for bin in $Binaries
do
  tmp=`brew list | grep $bin`
  if [[ ! $tmp ]]; then
    echo ''
    echo "$FORMAT ##### Installing $RED $bin..."
    brew install $bin
  fi
done



