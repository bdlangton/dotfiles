# Things to do pre install:
# Have to download this repo from git, which also means installing xcode tools,
# and adding github ssh key
# Install xcode: xcode-select --install

# Things to do post install:
# Need to set up karabiner-elements
# - simple modification to map caps lock to escape and vice versa.
# Need to set iterm
# - to use solarized dark theme
# - text to use font MesloLGS NF
#   - if not already, run 'p10k configure' to install the above font and test
#     that you can see the icons
# - profile -> keys, set left and right option keys to Esc+
# Manual installations
# - todoist, bear, flow, pocket
# Configure Cloudflare/pi-hole as DNS server: https://1.1.1.1/dns/
# - Update in System Preferences → Network → DNS
#   - Put pi-hole first, then cloudflare (1.1.1.1, 1.0.0.1)
# - Firefox: go to Preferences → Network Settings
#   - Set DNS over HTTPS. Use Cloudflare or set to pi-hole IP address.
# - Brave & Chrome: go to Preferences → Privacy and Security → Security
#   - Set Secure DNS with Cloudflare
# Create/update/install all needed SSH keys
# Add caldav and carddav to Internet Accounts in Mac
# Add sites to Saka blacklist (Firefox)

info() {
  echo "$@"
}

quietly_brew_bundle() {
  brew bundle --file="$1" | \
    grep -vE '^(Using |Homebrew Bundle complete)' || \
    true
}

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

info "Installing oh-my-zsh if not already installed..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
  info "Already installed"
fi

info "\nChecking for command-line tools..."
if [ ! -x "$(command -v xcodebuild)" ]; then
  xcode-select --install
else
  info "Already installed"
fi

info "\nInstalling composer global packages if not already installed..."
composer global install
phpcs --config-set installed_paths ~/.composer/vendor/drupal/coder/coder_sniffer
phpcs --config-set default_standard Drupal
phpcs --config-set ignore_warnings_on_exit 1
phpcs --config-set colors 1
info "Finished composer global packages"

info "\nInstalling git repos if not already installed..."
[ ! -d "$HOME/git/git" ] && git clone https://github.com/git/git "$HOME/git/git"
[ ! -d "$HOME/git/tmuxinator" ] && git clone https://github.com/tmuxinator/tmuxinator "$HOME/git/tmuxinator"
[ ! -d "$HOME/git/githud" ] && git clone https://github.com/gbataille/githud "$HOME/git/githud"
[ ! -d "$HOME/git/git-fuzzy" ] && git clone https://github.com/bigH/git-fuzzy.git "$HOME/git/git-fuzzy"
[ ! -d "$HOME/git/vimwiki" ] && git clone git@github.com:bdlangton/vimwiki.git "$HOME/git/vimwiki"
[ ! -d "$HOME/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
info "Finished git repos"

info "\nInstalling npm packages if not already installed..."
for command in 'tldr' 'eslint' 'remark-lint' 'remark-cli' 'remark-preset-lint-recommended' 'prettier' 'prettier-plugin-elm' 'eslint-plugin-prettier' 'eslint-config-airbnb' 'stylelint' 'babel-eslint' 'elm-format' 'elm-oracle' 'elm-test' 'git-guilt'
do
  if [ ! -x "$(command -v $command)" ]; then
    npm i -g $command
  fi
done
info "Finished npm packages"

info "\nInstalling gems if not already installed..."
for command in 'tmuxinator' 'overcommit'
do
  if [ ! -x "$(command -v $command)" ]; then
    gem install $command
  fi
done
info "Finished gems"

info "\nInstalling pip packages if not already installed..."
for command in 'gitlint' 'yamllint' 'vim-vint' 'pathlib' 'typing' 'enum34' 'unique' 'markdown-toc'
do
  if [ ! -x "$(command -v $command)" ]; then
    pip install $command
  fi
done
info "Finished pip"

info "\nInstalling vim bundles if not already installed..."
mkdir -p "$HOME/.vim/bundle"
cd "$HOME/.vim/bundle" || return
[ ! -d "vim-colors-solarized" ] && git clone git://github.com/altercation/vim-colors-solarized.git
[ ! -d "lightline.vim" ] && git clone https://github.com/itchyny/lightline.vim
info "Finished vim bundles"

# Create vim swap directory.
mkdir -p "$HOME/.vim/tmp"

info "\nInstalling remaining brew functionality if not already installed..."
[ ! -x "$(command -v fzf)" ] && "$(brew --prefix)"/opt/fzf/install
[ ! -x "$(command -v vim)" ] && brew install vim --with-python3 && brew services
info "Finished remaining brew functionality"

info "\nConfiguring PowerLevel10k..."
p10k configure
info "Finished configuring PowerLevel10k"

if ! echo "$SHELL" | grep -Fq zsh; then
  info "\nYour shell is not Zsh. Changing it to Zsh..."
  chsh -s /bin/zsh
fi

info "\nSetting up and compiling YouCompleteMe..."
sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
cd ~/.vim/bundle/YouCompleteMe
python3 install.py --all
cd -
info "Finished setting up YouCompleteMe"

if [ ! -f "$HOME/.rcrc" ]; then
  # Before `rcup` runs, there is no ~/.rcrc, so we must tell `rcup` where to look.
  # We need the rcrc because it tells `rcup` to ignore thousands of useless Vim
  # backup files that slow it down significantly.
  info "\nLinking dotfiles into ~..."
  RCRC=rcrc rcup
  info "Done linking dotfiles"
fi

info "\nInstalling oh-my-zsh plugins and themes if not already installed..."
[ ! -d "$HOME/.oh-my-zsh/plugins/fz" ] && git clone https://github.com/changyuheng/fz.git $HOME/.oh-my-zsh/plugins/fz
[ ! -d "$HOME/.oh-my-zsh/plugins/tldr" ] && mkdir -p $HOME/.oh-my-zsh/plugins/tldr && curl https://raw.githubusercontent.com/tldr-pages/tldr-node-client/master/bin/completion/zsh/_tldr -o $HOME/.oh-my-zsh/plugins/tldr/_tldr
[ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
[ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
[ ! -d "$HOME/.oh-my-zsh/themes/powerlevel10k" ] && git clone https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/themes/powerlevel10k
info "Finished oh-my-zsh plugins and themes"
