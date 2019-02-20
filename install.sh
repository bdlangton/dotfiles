# Install ohmyzsh.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Install composer.
if [ ! -x "$(command -v composer)" ]; then
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
fi

# Install composer global packages.
composer global require behat/behat
composer global require drupal/coder
composer global require drupal/console-launcher
composer global require drush/drush
composer global require phploc/phploc
composer global require phpmetrics/phpmetrics
composer global require phpmd/phpmd
composer global require phpunit/phpunit:^7.0
composer global require sebastian/phpcpd

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
gem install tmuxinator
