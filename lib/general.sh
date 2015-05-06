# General configurations


default_ruby='2.2.1'


echo "#### Checking for Sublime Text 2"
if [[ -e "$HOME/Library/Application Support/Sublime Text 2/Packages" ]]; then
  echo "#### Found Sublime Text 2. Would you like to overwrite exisiting packages with Bootstrapify packages? (Y or N)"
  read input
  if [[$input == Y ]]; then
    mv "$HOME/Library/Application Support/Sublime Text 2/Packages" "$HOME/Library/Application Support/Sublime Text 2/pre-bootstrapify-packages"
    cp -r $config_dir/sublime_packages/*  "$HOME/Library/Application Support/Sublime Text 2/Packages"
  fi
else
  echo "#### Sublime Text 2 Packages not found. Installing Packages"
  mkdir -p "$HOME/Library/Application Support/Sublime Text 2/Packages"
  cp $config_dir/sublime_packages/*  "$HOME/Library/Application Support/Sublime Text 2/Packages"
fi

echo "#### Linking Subl "
  mkdir $HOME/.bin
  ln -s "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" ~/.bin/subl

echo "#### Installing Ruby"
  rbenv install $default_ruby
  rbenv global $default_ruby

echo "#### Installing Shopify-Theme Gem"
  gem install shopify-theme

echo "#### Installing Oh-My-Zsh"
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

echo "#### Updating Bash and zsh settings"
echo "export PATH=$HOME/.bin:$PATH" >> .bash_profile
echo "export PATH=$HOME/.bin:$PATH" >> .zshrc
# Sets sublime text to be the default editor instead of nano or vim
echo "export EDITOR='subl -w'" >> .bash_profile
echo "export EDITOR='subl -w'" >> .zshrc


