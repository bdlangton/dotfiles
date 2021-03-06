# Oh-my-zsh.
export ZSH=$HOME/.oh-my-zsh
plugins=(docker encode64 git-prompt npm osx zsh-autosuggestions zsh-syntax-highlighting z fz tmuxinator thefuck tldr)
export UPDATE_ZSH_DAYS=30

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

export PATH="$HOME/.bin:$HOME/.rbenv/shims:/usr/local/opt/python/libexec/bin:/usr/local/sbin:$PATH:$HOME/.composer/vendor/bin:$HOME/git/git-fuzzy/bin"

# Node path.
export NODE_PATH="/usr/local/lib/node_modules"

# Source files (oh-my-zsh source needs to be after zsh configs).
source $ZSH/oh-my-zsh.sh
if [ -d "/usr/local/opt/fzf" ]; then
  source /usr/local/opt/fzf/shell/completion.zsh
  source /usr/local/opt/fzf/shell/key-bindings.zsh
fi

# Source fzf.zsh if it exists in the home directory.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# Git and fzf key bindings for searching git commits/tags/branches/remotes/files
# in a git repo.
bind_git_helper f t b g r
unset -f bind_git_helper

# Set g to autocomplete like git (needs to be after oh-my-zsh).
compdef g=git

# Directory colors for solarized (has to be after sources).
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

# Aliases (has to be after sourcing oh-my-zsh).
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
