# Bootstrapify

This script help ease the setup of new computers to work with the rest of the team by making sure we are all running the same software.

## Install
To install, copy and paste this command into the terminal app. You can find terminal under `/Applications/Utilities` or by searching in spotlight (add it to your dock, it'll make life easier)

`ruby <(curl -L https://raw.githubusercontent.com/jtgrenz/Bootstrapify/master/install.rb)`

The first thing this script does is check if you have the xcode-CLI tools. If not, you will need to click install

[![alt](https://screenshot.click/25-09-zh10p-04684.jpg)](https://screenshot.click/25-09-zh10p-04684.jpg)

Once that is completed, you will need to run the command above once more and follow the remaining prompts as they popup.

## Contributing
In order to make this installer a simple one line command not requiring any sort of git clone or anything, we need to combine all modules into a single fine instead of using normal `require`s. If adding new files to this installer, the module must be added to the `build.sh` script which needs to be run prior to pushing to master. `build.sh` combines all files named and outputs `install.rb` which is run by the end user. General install instructions belong in `bootstrapify.rb`
