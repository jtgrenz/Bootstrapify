#!/usr/bin/env ruby

require 'fileutils'
include FileUtils
include FormatableMessage
include InstallHelpers

 module Bootstrapify
   extend self

   @@github_ssh_url = "https://github.com/settings/keys"
   @@authme_url = "https://authme.shopify.io"
   @@atom_dark_theme_url = "https://raw.githubusercontent.com/jtgrenz/Bootstrapify/master/AtomDark.terminal"
   @@homebrew_install_list = ["node", "bash", "zsh", 'rbenv','ruby-build', "caskroom/cask/brew-cask"]
   @@homebrew_cask_install_list = ["recordit", "atom", "alfred", "firefox"]
   @@ruby_gem_install_list = ["bundler", "colorize"]
   @@node_install_list = ["gulp"]

   @@bashrc = "#{ENV['HOME']}/.bash_profile"
   @@zshrc = "#{ENV['HOME']}/.zshrc"
   @@exit_message = []

   def install_xcode
      msg "Checking for Xcode commandline tools"
      begin
         xcode_path = `xcode-select -p`.chomp
         if xcode_path == "/Applications/Xcode.app/Contents/Developer" or xcode_path == "/Library/Developer/CommandLineTools"
            if xcode_path == "/Applications/Xcode.app/Contents/Developer"
               msg "Xcode Installed. Please enter your admin password to agree to the Xcode License agreement"
               @status == false
               while @status != true
                 msg "Please press space to scroll down and type #{"agree".green.underline} to accept."
                 system("sudo xcodebuild -license")
                 @status = $?.success?
               end
            end
            success "Xcode installed"
         else
            warn "Xcode not installed. Please enter your password at the next prompt and install Xcode. Then run this script again "
            `xcode-select --install`
            exit 0
         end
      rescue Exception => e
         error "An error has occured with Xcode and we are unable to continue"
         error e.message
         exit 1
      end
   end

   def set_git_config
      begin
         git_username = `git config --global user.name`.chomp
         git_email = `git config --global user.email`.chomp

         if git_username == ""
            instruct "git username not found"
            instruct "Enter your first and last name and press enter :"
            git_username = STDIN.gets.chomp
            `git config --global user.name "#{git_username}"`
         end

         if git_email == "" or !git_email.include? "@shopify.com"
            instruct "git email not found or is not a shopify email"
            while !git_email.include? "@shopify.com"
               instruct "Enter your @shopify.com email address and press enter:"
               git_email = STDIN.gets.chomp
            end
            `git config --global user.email #{git_email}`
         end
         success "Git defaults set to name: #{git_username} email: #{git_email}"
      rescue Exception => e
         error_msg = "Unable to set Git config. Please set these manually"
         error error_msg
         @@exit_message << error_msg
         error e.message
      end
   end

   def generate_SSH_keys
      msg "Checking for existing SSH keys"
      begin
         if File.exist? "#{ENV['HOME']}/.ssh/id_rsa" and File.exist? "#{ENV['HOME']}/.ssh/id_rsa.pub"
            success "Found id_rsa and id_rsa.pub"
         else
            warn "Exisitng SSH Keys not found"
            msg "Generating fresh SSH keys for GitHub.com"
            `ssh-keygen -b 1024 -t rsa -f #{ENV['HOME']}/.ssh/id_rsa -P ""`
            success "Generated ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub"
         end
      rescue Exception => e
         error_msg = "Unable to generate SSH Keys. Please generate manually following the manual instructions"
         error e.message
         @@exit_message << error_msg
      end
   end

   def install_homebrew
      msg "Checking for Homebrew"
      unless on_path? ("brew")
         warn "Homebrew not found. Installing Homebrew"
         system('ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
         status = $?.success?
         if status and on_path?('brew')
            success "Homebrew installed"
            return true
         else
            error "Homebrew not installed. Unknown error has occured"
            @@exit_message.push "Homebrew has not installed. Please check manual setup for details on what to do next."
            return false
         end
      else
         success "Homebrew pre-installed"
         return true
      end
   end

   def install_homebrew_recipies
      msg "Updating Homebrew"
      `brew update && brew cleanup`
      msg "Installing Homebrew Recipies"
      @@homebrew_install_list.each do |recipie|
         brew_install recipie
      end
      success "Homebrew Setup Complete"
   end

   def install_homebrew_gui_recipes
      # Homebrew Cask installs GUI apps like normal brew. We don't want to
      # duplicate apps if they are already installed in /Applications
      applications = (Dir.entries('/Applications').map { |e| e.downcase }).join(",")
      @@homebrew_cask_install_list.each do |app|
         unless applications.include? app.gsub("-", " ")
            brew_cask_install app
         else
            msg "#{app.gsub("-", " ")} already installed in /Applications"
         end
      end
   end

   def install_node
      msg "Checking for node"
      if on_path? "npm"
         success "node and npm found"
         return true
      else
         error "Node and Npm not found. This should have been installed by Homebrew.
         If homebrew had an error, thats why this also failed."
         @@exit_message.push "Node.js and NPM were not installed. Please see manual setup instructions for details on what to do next"
         return false
      end
   end

   def install_npm_list
      msg "Installing Node Globals"
      @@node_install_list.each do |bin|
         npm_install(bin, "-g")
      end
      success "Node Setup Complete"
   end

   def install_ruby_gems
      msg "Installing Ruby 2.3.0"
      if on_path? 'rbenv'
      `rbenv install 2.3.0`
      `rbenv global 2.3.0`
      end
      msg "Installing Ruby Gems"
      @@ruby_gem_install_list.each do |bin|
         install("#{ENV['HOME']}/.rbenv/shims/gem install", bin)
      end
      success "Ruby Gems Setup Compelte"
   end

   def install_oh_my_zsh
      msg "Installing Oh My ZSH!"
      `curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh`
      if $?.success?
         success "Oh my ZSH installed"
      else
         error "Oh my ZSH could not be installed."
         @@exit_message.push "Oh my ZSH could not be installed. Please see manual install instructions for details"
      end
   end

   def change_shell(shell)
      `chsh -s /bin/#{shell} $(whoami)`
   end

   # Transitiontioning away from Sublime Text in favor of Atom. Uncomment to bring
   # back symlinking for sublime text
   #
   # def symlink_sublime_text
   #    msg "Symlinking Sublime Text for commandline use"
   #    if File.exist? "/Applications/Sublime Text 2.app"
   #       ln_sf "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl", "#{ENV['HOME']}/Applications/subl"
   #    elsif File.exist? "/Applications/Sublime Text.app"
   #       ln_sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl", "#{ENV['HOME']}/Applications/subl"
   #    elsif File.exist? "#{ENV['HOME']}/Applications/Sublime Text 2.app"
   #       ln_sf "#{ENV['HOME']}/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl", "#{ENV['HOME']}/Applications/subl"
   #    elsif File.exist? "#{ENV['HOME']}/Applications/Sublime Text.app"
   #       ln_sf "#{ENV['HOME']}/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl", "#{ENV['HOME']}/Applications/subl"
   #    else
   #       warn "Sublime Text not found. Unable to symlink"
   #       @@exit_message.push "Was Unable to Symlink Sublime Text. Make sure its instlled and refer to Manual install instructions for details"
   #    end
   # end

   def configure_profiles
      msg "Configuring Bash and ZSH profiles"
      touch @@bashrc
      touch @@zshrc
      # symlink_sublime_text
      `echo "#rbenv" >> #{@@bashrc}`
      `echo "#rbenv" >> #{@@zshrc}`
      `echo 'export PATH=$HOME/.rbenv/bin:$PATH' >> #{@@bashrc}`
      `echo 'export PATH=$HOME/.rbenv/bin:$PATH' >> #{@@zshrc}`
      `echo 'eval "$(rbenv init -)"' >> #{@@bashrc}`
      `echo 'eval "$(rbenv init -)"' >> #{@@zshrc}`
      `echo 'export EDITOR="atom -w" >> #{@@bashrc}`
      `echo 'export EDITOR="atom -w"' >> #{@@zshrc}`
   end

   def install_terminal_theme
      msg "Installing Atom Dark Terminal Theme"
       `curl -O --metalink #{@@atom_dark_theme_url}`
      if File.exist? "atomdark.terminal"
         `open atomdark.terminal`
         `rm atomdark.terminal`
         `defaults write com.apple.Terminal "Default Window Settings" 'AtomDark'`
         `defaults write com.apple.Terminal "Startup Window Settings" 'AtomDark'`
         success "Installed Atom Dark Terminal theme. Your eyes will thank you"
      else
         warn "Could not auto install AtomDark Terminal theme. This is option. No worries!"
      end
   end

   def read_ssh_pub_key
      key_file = File.open("#{ENV['HOME']}/.ssh/id_rsa.pub", 'rb')
      key = key_file.read
      key_file.close
      return key
   end

   def print_final_github_instructions
      success "Setup Complete"
      instruct "This concludes the Bootstrapify setup. There are just a few final things you need to do."
      instruct "Go to #{@@github_ssh_url.underline} to upload the SSH keys we generated. Click #{"New SSH Key".yellow.underline} and paste the following"
      puts
      instruct read_ssh_pub_key.chomp
      puts
      instruct "Make sure you are authorized to access Shopify's Github Repos by going to #{@@authme_url.underline}"
      instruct "Ping your squad lead to make sure you have been added to the Shopify Themes team on gitub via the Spy bot."
      puts
      `open #{@@github_ssh_url}`
      `open #{@@authme_url}`
   end

   def run
      msg "Welcome to Bootstrapify"
      install_xcode
      set_git_config
      generate_SSH_keys
      if install_homebrew
         install_homebrew_recipies
         install_homebrew_gui_recipes
      end
      if install_node
         install_npm_list
      end
      install_oh_my_zsh
      install_terminal_theme
      configure_profiles
      install_ruby_gems
      change_shell('zsh')
      print_final_github_instructions
      if @@exit_message.size > 0
         warn "The following warnings were noted during the install. Read over them"
         @@exit_message.each do |msg|
            instruct msg
         end
      end
      msg "Exiting Bootstrapify"
   end
 end

Bootstrapify.run
