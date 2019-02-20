# Path to your oh-my-zsh installation.
export ZSH=/Users/barrett/.oh-my-zsh
plugins=(docker encode64 git-prompt npm osx zsh-autosuggestions)
export UPDATE_ZSH_DAYS=30

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Thefuck.
eval $(thefuck --alias)

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

# Local config.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Aliases.
[[ -f ~/.aliases ]] && source ~/.aliases

# Source files.
source $ZSH/oh-my-zsh.sh
source $HOME/git/z/z.sh
source $HOME/git/tmuxinator/completion/tmuxinator.zsh
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Directory colors for solarized (has to be after sources).
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
