# !/bin/bash

# Ask for the administrator password upfront.
sudo -v
# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install via brew
brew bundle --file=./Brewfile


################################### Symlink stuff ############################
################### (Backs up the previous versions if they exist) ###########
# symlinks

DOTFILES_ROOT="`pwd`"


cp "$HOME/.alliases" "$HOME/.alliases_bak" 2>/dev/null
cp "$HOME/.gitconfig" "$HOME/.gitconfig_bak" 2>/dev/null


ln -sf "$DOTFILES_ROOT/.alliases" "$HOME/.alliases"
ln -sf "$DOTFILES_ROOT/.gitconfig" "$HOME/.gitconfig"
