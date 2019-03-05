info() {
  echo "$@"
}

quietly_brew_bundle() {
  brew bundle --file="$1" | \
    grep -vE '^(Using |Homebrew Bundle complete)' || \
    true
}

info "Installing oh-my-zsh if not already installed..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
  info "Already installed"
fi

info "\nInstalling Homebrew if not already installed..."
if [ ! -x "$(command -v brew)" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  info "Already installed"
fi

info "\nInstalling Homebrew packages..."
brew tap homebrew/bundle
quietly_brew_bundle "Brewfile"
info "Finished Homebrew packages"

info "\nChecking for command-line tools..."
if [ ! -x "$(command -v xcodebuild)" ]; then
  xcode-select --install
else
  info "Already installed"
fi

info "\nInstalling composer if not already installed..."
if [ ! -x "$(command -v composer)" ]; then
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  php composer-setup.php
  mv composer.phar $HOME/.bin/composer
  php -r "unlink('composer-setup.php');"
else
  info "Already installed"
fi

info "\nInstalling composer global packages if not already installed..."
for package in 'behat/behat' 'drupal/coder' 'drupal/console-launcher' 'drush/drush' 'phploc/phploc' 'phpmetrics/phpmetrics' 'phpmd/phpmd' 'phpunit/phpunit' 'sebastian/phpcpd'
do
  if [ ! -d "$HOME/.composer/vendor/$package" ]; then
    composer global require $package
  fi
done
[ ! -d "$HOME/.composer/vendor/phpunit/phpunit" ] && composer global require phpunit/phpunit:^7.0
info "Finished composer global packages"

info "\nInstalling git repos if not already installed..."
[ ! -d "$HOME/git/git" ] && git clone https://github.com/git/git $HOME/git/git
[ ! -d "$HOME/git/tmuxinator" ] && git clone https://github.com/tmuxinator/tmuxinator $HOME/git/tmuxinator
[ ! -d "$HOME/git/githud" ] && git clone https://github.com/gbataille/githud $HOME/git/githud
info "Finished git repos"

info "\nInstalling npm packages if not already installed..."
for command in 'git-stats' 'tldr'
do
  if [ ! -x "$(command -v $command)" ]; then
    npm i -g $command
  fi
done
info "Finished npm packages"

info "\nInstalling gems if not already installed..."
if [ ! -x "$(command -v tmuxinator)" ]; then
  sudo gem install tmuxinator
else
  info "Already installed"
fi

info "\nInstalling vim bundles if not already installed..."
mkdir -p $HOME/.vim/bundle
cd $HOME/.vim/bundle
[ ! -d "vim-colors-solarized" ] && git clone git://github.com/altercation/vim-colors-solarized.git
[ ! -d "lightline.vim" ] && git clone https://github.com/itchyny/lightline.vim
info "Finished vim bundles"

# Create vim swap directory.
mkdir -p $HOME/.vim/tmp

info "\nInstalling remaining brew functionality if not already installed..."
[ ! -x "$(command -v fzf)" ] && $(brew --prefix)/opt/fzf/install
[ ! -x "$(command -v vim)" ] && brew install vim --with-python3 && brew services
info "Finished remaining brew functionality"

info "\nInstalling oh-my-zsh plugins and themes if not already installed..."
[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
[ ! -d "$HOME/.oh-my-zsh/custom/plugins/fz" ] && git clone https://github.com/changyuheng/fz.git ~/.oh-my-zsh/custom/plugins/fz
[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel9k" ] && git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
info "Finished oh-my-zsh plugins and themes"
