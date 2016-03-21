module Colorize
  module ClassMethods

    #
    # Property to disable colorization
    #
    def disable_colorization(value = nil)
      if value.nil?
        @disable_colorization || false
      else
        @disable_colorization = (value || false)
      end
    end

    #
    # Setter for disable colorization
    #
    def disable_colorization=(value)
      @disable_colorization = (value || false)
    end

    #
    # Return array of available colors used by colorize
    #
    def colors
      color_codes.keys
    end

    #
    # Return array of available modes used by colorize
    #
    def modes
      mode_codes.keys
    end

    #
    # Display color samples
    #
    def color_samples
      colors.permutation(2).each do |background, color|
        sample_text = "#{color.inspect.rjust(15)} on #{background.inspect.ljust(15)}"
        puts "#{sample_text.colorize(:color => color, :background => background)} #{sample_text}"
      end
    end

    #
    # Method removed, raise NoMethodError
    #
    def color_matrix(txt = '')
      fail NoMethodError, '#color_matrix method was removed, try #color_samples instead'
    end
  
    # private

    #
    # Color codes hash
    #
    def color_codes
      {
        :black   => 0, :light_black    => 60,
        :red     => 1, :light_red      => 61,
        :green   => 2, :light_green    => 62,
        :yellow  => 3, :light_yellow   => 63,
        :blue    => 4, :light_blue     => 64,
        :magenta => 5, :light_magenta  => 65,
        :cyan    => 6, :light_cyan     => 66,
        :white   => 7, :light_white    => 67,
        :default => 9
      }
    end

    #
    # Mode codes hash
    #
    def mode_codes
      {
        :default   => 0, # Turn off all attributes
        :bold      => 1, # Set bold mode
        :underline => 4, # Set underline mode
        :blink     => 5, # Set blink mode
        :swap      => 7, # Exchange foreground and background colors
        :hide      => 8  # Hide text (foreground color would be the same as background)
      }
    end
    
    #
    # Generate color and on_color methods
    #
    def color_methods
      colors.each do |key|
        next if key == :default

        define_method key do
          colorize(:color => key)
        end

        define_method "on_#{key}" do
          colorize(:background => key)
        end
      end
    end

    #
    # Generate modes methods
    #
    def modes_methods
      modes.each do |key|
        next if key == :default

        define_method key do
          colorize(:mode => key)
        end
      end
    end
  end
end
module Colorize
  module InstanceMethods

    #
    # Change color of string
    #
    # Examples:
    #
    #   puts "This is blue".colorize(:blue)
    #   puts "This is light blue".colorize(:light_blue)
    #   puts "This is also blue".colorize(:color => :blue)
    #   puts "This is light blue with red background".colorize(:color => :light_blue, :background => :red)
    #   puts "This is light blue with red background".colorize(:light_blue ).colorize( :background => :red)
    #   puts "This is blue text on red".blue.on_red
    #   puts "This is red on blue".colorize(:red).on_blue
    #   puts "This is red on blue and underline".colorize(:red).on_blue.underline
    #   puts "This is blue text on red".blue.on_red.blink
    #   puts "This is uncolorized".blue.on_red.uncolorize
    #
    def colorize(params)
      return self if self.class.disable_colorization
      require_windows_libs
      scan_for_colors.inject('') do |str, match|
        defaults_colors(match)
        colors_from_params(match, params)
        str << "\033[#{match[0]};#{match[1]};#{match[2]}m#{match[3]}\033[0m"
      end
    end

    #
    # Return uncolorized string
    #
    def uncolorize
      scan_for_colors.inject('') do |str, match|
        str << match[3]
      end
    end

    #
    # Return true if string is colorized
    #
    def colorized?
      scan_for_colors.inject([]) do |colors, match|
        colors << match.tap(&:pop)
      end.flatten.compact.any?
    end

    private

    #
    # Set default colors
    #
    def defaults_colors(match)
      match[0] ||= mode(:default)
      match[1] ||= color(:default)
      match[2] ||= background_color(:default)
    end

    #
    # Set color from params
    #
    def colors_from_params(match, params)
      case params
      when Hash then colors_from_hash(match, params)
      when Symbol then color_from_symbol(match, params)
      end
    end

    #
    # Set colors from params hash
    #
    def colors_from_hash(match, hash)
      match[0] = mode(hash[:mode]) if mode(hash[:mode])
      match[1] = color(hash[:color]) if color(hash[:color])
      match[2] = background_color(hash[:background]) if background_color(hash[:background])
    end

    #
    # Set color from params symbol
    #
    def color_from_symbol(match, symbol)
      match[1] = color(symbol) if color(symbol)
    end

    #
    # Color for foreground (offset 30)
    #
    def color(color)
      self.class.color_codes[color] + 30 if self.class.color_codes[color]
    end

    #
    # Color for background (offset 40)
    #
    def background_color(color)
      self.class.color_codes[color] + 40 if self.class.color_codes[color]
    end

    #
    # Mode
    #
    def mode(mode)
      self.class.mode_codes[mode]
    end

    #
    # Scan for colorized string
    #
    def scan_for_colors
      scan(/\033\[([0-9;]+)m(.+?)\033\[0m|([^\033]+)/m).map do |match|
        split_colors(match)
      end
    end

    def split_colors(match)
      colors = (match[0] || "").split(';')
      Array.new(4).tap do |array|
        array[0], array[1], array[2] = colors if colors.length == 3
        array[1] = colors                     if colors.length == 1
        array[3] = match[1] || match[2]
      end
    end

    #
    # Require windows libs
    #
    def require_windows_libs
      begin
        require 'Win32/Console/ANSI' if RUBY_VERSION < "2.0.0" && RUBY_PLATFORM =~ /win32/
      rescue LoadError
        raise 'You must gem install win32console to use colorize on Windows'
      end
    end
  end
end
#
# Colorize String class extension.
#
class String
  extend Colorize::ClassMethods
  include Colorize::InstanceMethods

  color_methods
  modes_methods
end
# requires colorize
module FormatableMessage
   def format_msg(msg, color, header_length=60)
       puts "*".colorize(color.intern) * header_length unless header_length == 0
       puts msg.colorize(color.intern)
       puts "*".colorize(color.intern) * header_length unless header_length == 0
       puts
     end

     def warn(msg)
       format_msg(msg, "yellow")
     end

     def msg(msg)
       format_msg(msg, "cyan")
     end

     def instruct(msg)
       puts msg.cyan
     end

     def prompt(msg)
       print msg.cyan
     end

     def success(msg)
       format_msg(msg, "green")
     end

     def error(msg)
       format_msg(msg, "red")
     end
 end
# requires colorize
module InstallHelpers
def on_path?(bin)
    `which #{bin}`
    $?.success?
  end

  def npm_install(bin="", options="")
    install("npm install", bin, options)
  end

  def gem_install(bin="", options="")
    install("gem install", bin, options)
  end

  def bundle_install(bin="", options="")
    install("bundle install", bin, options)
  end

  def install(install_cmd, bin="", options="")
    begin
      `#{install_cmd} #{bin} #{options}`
      if $?.success?
        unless bin == ""
          success "#{bin} installed"
        else
          success "Install Completed. Please note any errors above, if any"
        end
      end
    rescue Exception => e
      error e.message
      exit 1
    end
  end

  def brew_cask_install(bin="", options="")
      install("brew cask install", bin, options)
  end

  def brew_install(bin="", options="")
      install("brew install", bin, options)
  end

  def directories_containing(file_name)
    paths = []
    # Find what themes contain gulpfile.js and add them to the gulp_themes list
    Dir.foreach(".") do |path|
      if FileTest.directory?(path) and !path.start_with? "."
        Dir.glob("#{path}/*").each do |entry|
          paths << path if entry.include? file_name
        end
      end
    end
    paths
  end
end
#!/usr/bin/env ruby

require 'fileutils'
include FileUtils
include FormatableMessage
include InstallHelpers

 module Bootstrapify
   extend self

   @@github_ssh_url = "https://github.com/settings/keys"
   @@authme_url = "https://authme.shopify.com/"
   @@atom_dark_theme_url = "https://raw.githubusercontent.com/jtgrenz/Bootstrapify/master/AtomDark.terminal"
   @@homebrew_install_list = ["node", "bash", "zsh", "caskroom/cask/brew-cask"]
   @@homebrew_cask_install_list = ["sublime-text", "recordit", "atom", "alfred", "firefox"]
   @@ruby_gem_install_list = ["bundler", "colorize"]
   @@node_install_list = ["gulp"]

   @@bashrc = "#{ENV['HOME']}/.bash_profile"
   @@zshrc = "#{ENV['HOME']}/.zshrc"
   @@exit_message = []

   def install_xcode
      msg "Checking for Xcode commandline tools"
      xcode_path = `xcode-select -p`.chomp
      if xcode_path == "/Applications/Xcode.app/Contents/Developer" or xcode_path == "/Library/Developer/CommandLineTools"
         success "Xcode installed"
      else
         warn "Xcode not installed. Please enter your password at the next prompt and install Xcode. Then run this script again "
         `xcode-select --install`
         exit 0

      end
   end

   def set_git_config
      git_username = `git config --global user.name`.chomp
      git_email = `git config --global user.email`.chomp

      if git_username == ""
         instruct "git username not found"
         instruct "Enter your first and last name and press enter :"
         git_username = STDIN.gets.chomp
         `git config --global user.name #{git_username}`
      end

      if git_email == "" or !git_email.include? "@shopify.com"
         instruct "git email not found or is not a shopify email"
         while git_email.include? "@shopify.com" == false
            instruct "Enter your @shopify.com email address and press enter:"
            git_email = STDIN.gets.chomp
         end
         `git config --global user.email #{git_email}`
      end
      success "Git defaults set to name: #{git_username} email: #{git_email}"
   end

   def generate_SSH_keys
      msg "Checking for existing SSH keys"
      if File.exist? "#{ENV['HOME']}/.ssh/id_rsa" and File.exist? "#{ENV['HOME']}/.ssh/id_rsa.pub"
         success "Found id_rsa and id_rsa.pub"
      else
         warn "Exisitng SSH Keys not found"
         msg "Generating fresh SSH keys for GitHub.com"
         `ssh-keygen -b 1024 -t rsa -f #{ENV['HOME']}/.ssh/id_rsa -P ""`
         success "Generated ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub"
      end

   end

   def install_homebrew
      msg "Checking for Homebrew"
      unless on_path? ("brew")
         warn "Homebrew not found. Installing Homebrew"
         `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
         if $?.success?
            success "Homebrew installed"
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
      msg "Installing Ruby Gems"
      @@ruby_gem_install_list.each do |bin|
         gem_install bin
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

   def symlink_sublime_text
      msg "Symlinking Sublime Text for commandline use"
      if File.exist? "/Applications/Sublime Text 2.app"
         ln_sf "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl", "#{ENV['HOME']}/Applications/subl"
      elsif File.exist? "/Applications/Sublime Text.app"
         ln_sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl", "#{ENV['HOME']}/Applications/subl"
      elsif File.exist? "#{ENV['HOME']}/Applications/Sublime Text 2.app"
         ln_sf File.exist? "#{ENV['HOME']}/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl", "#{ENV['HOME']}/Applications/subl"
      elsif File.exist? "#{ENV['HOME']}/Applications/Sublime Text.app"
         ln_sf "#{ENV['HOME']}/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl", "#{ENV['HOME']}/Applications/subl"
      else
         warn "Sublime Text not found. Unable to symlink"
         @@exit_message.push "Was Unable to Symlink Sublime Text. Make sure its instlled and refer to Manual install instructions for details"
      end
   end

   def configure_profiles
      msg "Configuring Bash and ZSH profiles"
      symlink_sublime_text
      `echo "export EDITOR='atom -w'" >> #{ENV['HOME']}/.bashrc`
      `echo "export EDITOR='atom -w'" >> #{ENV['HOME']}/.zshrc`
   end

   def install_terminal_theme
      msg "Installing Atom Dark Terminal Theme"
       `curl -O #{@@atom_dark_theme_url}`
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
      instruct "Go to #{@@github_ssh_url} to upload the SSH keys we generated. Click new key and paste the following"
      puts
      instruct read_ssh_pub_key.chomp
      puts
      instruct "Make sure you are authorized to access Shopify's Github Repos by going to #{@@authme_url}"
      instruct "Ping your squad lead to make sure you have been added to the Shopify Themes team on gitub via the Spy bot."
      puts
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
      install_ruby_gems
      install_oh_my_zsh
      install_terminal_theme
      configure_profiles
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
