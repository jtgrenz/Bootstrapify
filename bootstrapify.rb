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
   @@homebrew_install_list = ["bash", "zsh" ]
   @@homebrew_cask_install_list = ["recordit", "atom", "visual-studio-code", "alfred", "firefox", 'slack', 'zoom', 'tunnelbear', ]
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
      `brew tap caskroom/cask`
      @@homebrew_install_list.each do |recipie|
         brew_install recipie
      end
      success "Homebrew Setup Complete"
   end

   def install_homebrew_gui_recipes
      # Homebrew Cask installs GUI apps like normal brew. We don't want to
      # duplicate apps if they are already installed in /Applications
      msg "Installing Homebrew Cask Recipies"
      applications = (Dir.entries('/Applications').map { |e| e.downcase }).join(",")
      @@homebrew_cask_install_list.each do |app|
         unless applications.include? app.gsub("-", " ")
            brew_cask_install app
         else
            msg "#{app.gsub("-", " ")} already installed in /Applications"
         end
      end
      success "Homebrew Cask Setup Complete"
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

   def read_ssh_pub_key
      key_file = File.open("#{ENV['HOME']}/.ssh/id_rsa.pub", 'rb')
      key = key_file.read
      key_file.close
      return key
   end

   def install_themekit 
    msg "Installing Themekit"
     `curl -s https://raw.githubusercontent.com/Shopify/themekit/master/scripts/install | sudo python`
    if $?.success?
      success "Themekit installed"
    else
        error "Themekit could not be installed"
        @@exit_message.push "Themekit could not be installed. Please see https://shopify.github.io/themekit/#installation for details"
    end
   end

   def print_final_github_instructions
      success "Setup Complete"
      instruct "This concludes the Bootstrapify setup. There are just a few final things you need to do."
      instruct "Go to #{@@github_ssh_url.underline} to upload the SSH keys we generated. Click #{"New SSH Key".yellow.underline} and paste the following:"
      puts
      instruct read_ssh_pub_key.chomp
      puts
      instruct "Make sure you are authorized to access Shopify's Github Repos by going to #{@@authme_url.underline}"
      instruct "Ping your squad lead to make sure you have been added to the Shopify Themes team on gitub via the Spy bot."
      puts
      instruct "#{'spy github add user <GITHUB_USERNAME> to Crafters'.underline} and #{'spy github add user <GITHUB_USERNAME> to PSFED'.underline}"
      puts
      `open #{@@github_ssh_url}`
      `open #{@@authme_url}`
      check_for_monosnap
   end

   def check_for_monosnap
    applications = (Dir.entries('/Applications').map { |e| e.downcase }).join(",")
    unless applications.include?('monosnap')
     `open macappstores://itunes.apple.com/ru/app/monosnap/id540348655`
    end
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
      install_oh_my_zsh
      install_themekit
      change_shell('zsh')
      print_final_github_instructions
      if @@exit_message.size > 0
         warn "The following warnings were noted during the install. Read over them"
         @@exit_message.each do |msg|
            instruct msg
         end
      end
      msg "Exiting Bootstrapify and installing dev"
      `eval "$(curl -sS https://dev.shopify.io/up)"`
   end
 end

Bootstrapify.run
