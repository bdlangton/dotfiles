# Set history size.
export HISTSIZE=10000
export SAVEHIST=10000

# Ignore duplicates.
setopt hist_ignore_all_dups

# Share history across multiple zsh sessions.
setopt share_history

# Append to history.
setopt append_history

# Remove blank lines from history.
setopt hist_reduce_blanks
