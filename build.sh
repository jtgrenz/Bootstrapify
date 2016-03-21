#!/usr/bin/env sh

rm install.rb
touch install.rb
cat colorize/colorize/class_methods.rb >> install.rb
cat colorize/colorize/instance_methods.rb >> install.rb
cat colorize/colorize.rb >> install.rb
cat formatable_message.rb >> install.rb
cat install_helpers.rb >> install.rb
cat bootstrapify.rb >> install.rb
ruby install.rb
