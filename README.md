# Bootstrapify

This script help ease the setup of new computers to work with the rest of the team by making sure we are all running the same software.

When this script is run, there will be a series of prompts that you will need to answer. For the most part it runs by itself and saves you manually hunting down different things.

When you are prompted for your admin password, thats the password used to login to your OSX account. When asked if you want the experimental FULL or CLI (command line interface) only options, FULL will install a series of applications using Homebrew Cask, a package manager similar to the Mac App store, but third party and script-able. These apps wont be installed to your regular Applications folder and are store with the rest of Homebrew instead and will only be installed for your user account. Its a great system, but some people prefer to manually grab their apps and not install some things.

## Install
To install, copy and paste this command into the terminal app. You can find terminal under `/Applications/Utilities` or by searching in spotlight (add it to your dock, it'll make life easier)

`bash <(curl -L https://raw.githubusercontent.com/jtgrenz/Bootstrapify/master/install.sh)`

The first thing this script does is check if you have the xcode-CLI tools. If not, you will need to click install

[![alt](https://screenshot.click/25-09-zh10p-04684.jpg)](https://screenshot.click/25-09-zh10p-04684.jpg)

Once that is completed, you will need to run the command above once more and follow the remaining prompts as they popup. If you run into any issues, ping Jon Grenning on slack or google hangouts

