# Install ohmyzsh.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Install composer.
if [ ! -x "$(command -v composer)" ]; then
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  php composer-setup.php
  mv composer.phar $HOME/.bin/composer
  php -r "unlink('composer-setup.php');"
fi

# Install composer global packages.
for package in 'behat/behat' 'drupal/coder' 'drupal/console-launcher' 'drush/drush' 'phploc/phploc' 'phpmetrics/phpmetrics' 'phpmd/phpmd' 'phpunit/phpunit' 'sebastian/phpcpd'
do
  if [ ! -d "$HOME/.composer/vendor/$package" ]; then
    composer global require $package
  fi
done
[ ! -d "$HOME/.composer/vendor/phpunit/phpunit" ] && composer global require phpunit/phpunit:^7.0

# Install git repos.
[ ! -d "$HOME/git/git" ] && git clone https://github.com/git/git $HOME/git/git
[ ! -d "$HOME/git/z" ] && git clone https://github.com/rupa/z $HOME/git/z
[ ! -d "$HOME/git/tmuxinator" ] && git clone https://github.com/tmuxinator/tmuxinator $HOME/git/tmuxinator
[ ! -d "$HOME/git/githud" ] && git clone https://github.com/gbataille/githud $HOME/git/githud

# NPM installs.
for command in 'git-stats' 'tldr'
do
  if [ ! -x "$(command -v $command)" ]; then
    npm i -g $command
  fi
done

# Gem installs.
if [ ! -x "$(command -v tmuxinator)" ]; then
  sudo gem install tmuxinator
fi

# Install vim bundles that are needed before
mkdir -p $HOME/.vim/bundle
cd $HOME/.vim/bundle
[ ! -d "vim-colors-solarized" ] && git clone git://github.com/altercation/vim-colors-solarized.git
[ ! -d "lightline.vim" ] && git clone https://github.com/itchyny/lightline.vim

# Create vim swap directory.
mkdir -p $HOME/.vim/tmp

# Install remaining brew functionality.
[ ! -x "$(command -v fzf)" ] && $(brew --prefix)/opt/fzf/install
[ ! -x "$(command -v vim)" ] && brew install vim --with-python3 && brew services

# Install oh-my-zsh plugins and themes.
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
$ git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
