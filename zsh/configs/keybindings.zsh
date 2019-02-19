# Bind keys for moving forward and backward.
bindkey "[D" backward-word
bindkey "[C" forward-word
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line

# Git and fzf key bindings for searching git commits/tags/branches/remotes/files
# in a git repo.
bind-git-helper f t b g r
unset -f bind-git-helper
