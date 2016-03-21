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
