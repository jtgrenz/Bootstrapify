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


## Apps and Tools Installed under CLI Mode

Via Homebrew.sh:
   - node
   - tree
   - git
   - rbenv
   - ruby-build
   - bash
   - zsh

Via  NPM-install.sh:
  - grunt-cli
  - gulp

Via General.sh:

Ruby version 2.2.1 (via rbenv's ruby-build)

Additionally, you will be prompted to link sublime packages if you installed sublime text. This isn't nesecary, but it will give you the solarized theme for sublime text as well as liquid syntax highlighting for .liquid, .js.liquid and .scss.liquid files. You can say yes or no to this when prompted and if you use text-mate or another editor, its irrelevant.

[![alt](https://screenshot.click/25-31-vgm89-cxnwe.jpg)](https://screenshot.click/25-31-vgm89-cxnwe.jpg) 
*solarized and sodaized theme for sublime text installed via the sublime packages option*


## Apps and Tools Installed under FULL Mode

The same as CLI with the following additions via homebrew-cask.sh:

    - sublime-text
    - slack
    - github
    - alfred
    - google-chrome
    - firefox
    - textexpander
    - recordit
    - sococo

## Recomended apps not included in either install

### Total Terminal
Having quick access to the terminal application is very convenient. To set terminal to slide down from the top of any screen via a hot key, install Total Terminal for free at http://totalterminal.binaryage.com/

### Solarized Color Scheme
The default black on white for the terminal can make your eyes want to bleed. Check out the popular Solarized theme for terminal (and other text editors) here http://ethanschoonover.com/solarized

### Alfred and the Alfred Powerpack
Alfred makes life easier and the powerpack lets you automate common tasks via a workflow. Grab the powerpack here http://www.alfredapp.com/powerpack/ and checkout the themesupport alfred workflows here https://github.com/Shopify/themes-alfred-workflows








