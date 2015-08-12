# General configurations

bashrc="$HOME/.bash_profile"
zshrc="$HOME/.zshrc"

echo "$FORMAT #### Checking for Sublime Text 2"
if [[ -e "$HOME/Library/Application Support/Sublime Text 2/Packages" ]]; then
  echo "$FORMAT #### Found Sublime Text 2. Would you like to overwrite existing packages with Bootstrapify packages? (Y or N)"
  read input
  if [[$input == Y ]]; then
    mv "$HOME/Library/Application Support/Sublime Text 2/Packages" "$HOME/Library/Application Support/Sublime Text 2/pre-bootstrapify-packages"
    cp -r $config_dir/sublime_packages/*  "$HOME/Library/Application Support/Sublime Text 2/Packages"
  fi
else
  echo "$FORMAT #### Sublime Text 2 Packages not found. Installing Packages"
  mkdir -p "$HOME/Library/Application Support/Sublime Text 2/Packages"
  cp -r $config_dir/sublime_packages/*  "$HOME/Library/Application Support/Sublime Text 2/Packages"
fi

echo "$FORMAT #### Linking Subl "
  mkdir $HOME/.bin
  ln -s "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" ~/.bin/subl


echo "$FORMAT #### Installing Oh-My-Zsh"
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

echo "$FORMAT #### Updating Bash and zsh settings"
# sets up ~/.bin folder for sublime symlink. 
echo "###### Bootstrapify Additions added $(date)  ###### "
echo ""
echo "export PATH=$HOME/.bin:$PATH" >> $bashrc
echo "export PATH=$HOME/.bin:$PATH" >> $zshrc
# Sets up path to accept rbenv properly.
echo "export PATH='~/.rbenv/shims:~/.rbenv/bin:$PATH'" >> $bashrc
echo "export PATH='~/.rbenv/shims:~/.rbenv/bin:$PATH'" >> $zshrc
echo "eval "$(rbenv init -)"" >> $zshrc
echo "eval "$(rbenv init -)"" >> $bashrc
# Sets sublime text to be the default editor instead of nano or vim
echo "export EDITOR='subl -w'" >> $bashrc
echo "export EDITOR='subl -w'" >> $zshrc
echo ""
echo "###### End of Bootstrapify Additions added $(date)  ###### "
echo ""



# echo "$FORMAT #### Setting up FileVault2 Disk Encryption"
# echo "$FORMAT #### We are now enabling disk encryption on your mac. Your mac will restart
# and you will be prompted for your login password again. When you log back in, there
# will be a file called Filevault_recovery.plist on your desktop. Save it somewhere
# safe thats not this mac (email it to yourself or use dropbox). It contains
# a recovery password if you forget your password. Delete the file from the desktop
# once you made a copy. "
# echo "$FORMAT Press any key to continue"
# read input
# sudo fdesetup enable -defer $HOME/Desktop/FileVault_recovery.plist
# echo "$FORMAT #### Restarting now"
# sudo shutdown -r now




