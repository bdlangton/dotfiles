# These need sourced in .zshenv to be used with tmux/vim bindings that execute
# in the shell (using aliases).

# Load custom executable functions.
for function in ~/.zsh/functions/*; do
  source $function
done

# Aliases (has to be after sourcing oh-my-zsh).
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
