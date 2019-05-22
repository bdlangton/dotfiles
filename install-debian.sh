# Things to do pre install:
# Have to download this repo from git, which also means and adding github ssh
# key

info() {
  echo "$@"
}

info "Installing keys and apt-sources..."
wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
echo "deb https://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
info "Finished installing keys and apt-sources"

info "Installing packages from apt-get..."
sudo apt-get update
sudo apt-get remove vim
sudo apt-get install vim-nox build-essential cmake python3-dev
sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common
sudo apt-get install php php-xml php-mbstring git zsh exuberant-ctags rbenv nodejs fzf thefuck awscli htop nmap ncdu wrk zplug docker-ce rcm
info "Finished installing apt-get packages"

info "Installing oh-my-zsh if not already installed..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
  info "Already installed"
fi

info "Installing fzf..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
info "Finished installing fzf..."

info "\nInstalling composer global packages if not already installed..."
for package in 'behat/behat' 'drupal/coder' 'drush/drush' 'phploc/phploc' 'phpmetrics/phpmetrics' 'sebastian/phpcpd' 'squizlabs/PHP_CodeSniffer', 'friendsofphp/php-cs-fixer', 'phpstan/phpstan'
do
  if [ ! -d "$HOME/.composer/vendor/$package" ]; then
    composer global require $package
  fi
done
composer global require symfony/console
composer global require symfony/process
ln -s $HOME/.config/composer $HOME/.composer
phpcs --config-set installed_paths ~/.composer/vendor/drupal/coder/coder_sniffer
phpcs --config-set default_standard Drupal
info "Finished composer global packages"

info "\nInstalling drupal console launcher if not already installed..."
if [ ! -x "$(command -v drupal)" ]; then
  curl https://drupalconsole.com/installer -L -o drupal.phar
  sudo mv drupal.phar /usr/local/bin/drupal
  chmod +x /usr/local/bin/drupal
fi
info "Finished drupal console launcher"

info "\nInstalling git repos if not already installed..."
[ ! -d "$HOME/git/git" ] && git clone https://github.com/git/git $HOME/git/git
[ ! -d "$HOME/git/tmuxinator" ] && git clone https://github.com/tmuxinator/tmuxinator $HOME/git/tmuxinator
[ ! -d "$HOME/git/githud" ] && git clone https://github.com/gbataille/githud $HOME/git/githud
[ ! -d "$HOME/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
info "Finished git repos"

info "\nInstalling npm packages if not already installed..."
for command in 'git-stats' 'tldr'
do
  if [ ! -x "$(command -v $command)" ]; then
    npm i -g $command
  fi
done
info "Finished npm packages"

info "\nInstalling vim bundles if not already installed..."
mkdir -p $HOME/.vim/bundle
cd $HOME/.vim/bundle
[ ! -d "vim-colors-solarized" ] && git clone git://github.com/altercation/vim-colors-solarized.git
[ ! -d "lightline.vim" ] && git clone https://github.com/itchyny/lightline.vim
info "Finished vim bundles"

# Create vim swap directory.
mkdir -p $HOME/.vim/tmp

if ! echo "$SHELL" | grep -Fq zsh; then
  info "\nYour shell is not Zsh. Changing it to Zsh..."
  chsh -s /bin/zsh
fi

if [ ! -f "$HOME/.rcrc" ]; then
  # Before `rcup` runs, there is no ~/.rcrc, so we must tell `rcup` where to
  # look. We need the rcrc because it tells `rcup` to ignore thousands of
  # useless Vim backup files that slow it down significantly.
  info "\nLinking dotfiles into ~..."
  RCRC=rcrc rcup
  info "Done linking dotfiles"
fi

info "\nInstalling oh-my-zsh plugins and themes if not already installed..."
[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
[ ! -d "$HOME/.oh-my-zsh/custom/plugins/fz" ] && git clone https://github.com/changyuheng/fz.git ~/.oh-my-zsh/custom/plugins/fz
[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel9k" ] && git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
info "Finished oh-my-zsh plugins and themes"
