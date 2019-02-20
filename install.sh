# Install git repos.
[ ! -d "$HOME/git/git" ] && git clone https://github.com/git/git $HOME/git/git
[ ! -d "$HOME/git/z" ] && git clone https://github.com/rupa/z $HOME/git/z
[ ! -d "$HOME/git/tmuxinator" ] && git clone https://github.com/tmuxinator/tmuxinator $HOME/git/tmuxinator
[ ! -d "$HOME/git/githud" ] && git clone https://github.com/gbataille/githud $HOME/git/githud

# NPM installs.
npm i -g git-stats
npm i -g tldr

# Gem installs.
gem install tmuxinator
