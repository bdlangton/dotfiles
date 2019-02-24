# Without oh-my-zsh, ctrl-e on the command line (along with other commands) no
# longer worked. Adding back until I can figure out how to remove it without
# issues.
export ZSH=/Users/barrett/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Thefuck.
eval $(thefuck --alias)

# Zplug.
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug 'mafredri/zsh-async'
zplug 'sindresorhus/pure'
zplug "zsh-users/zsh-autosuggestions", from:github
zplug "zsh-users/zsh-syntax-highlighting", from:github, defer:3
zplug "rupa/z", from:github, use:z.sh
zplug "tmuxinator/tmuxinator", from:github, use:completion/tmuxinator.zsh
zplug "junegunn/fzf", from:github, hook-build:"./install"

zplug load

# Load custom executable functions.
for function in ~/.zsh/functions/*; do
  source $function
done

# Extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*~*.zwc(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/(pre|post)/*|*.zwc)
          :
          ;;
        *)
          . $config
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*~*.zwc(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

export PATH="$HOME/.bin:$HOME/.rbenv/shims:/usr/local/sbin:$PATH:$HOME/.composer/vendor/bin"

# Directory colors for solarized (has to be after sources).
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

# Aliases.
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
