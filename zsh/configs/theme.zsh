# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
export ZSH_THEME="powerlevel9k/powerlevel9k"

# Set CLICOLOR if you want Ansi Colors in iTerm2.
export CLICOLOR=1

# Set xterm 256 colors.
export TERM=xterm-256color

# Set autosuggest color to something other than my default background.
# See: https://github.com/zsh-users/zsh-autosuggestions/issues/243
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=yellow'

# Powerlevel9k settings. Use nerdfont.
export POWERLEVEL9K_MODE='nerdfont-complete'

# Powerlevel9k custom settings.
export DISABLE_AUTO_TITLE="true"
export POWERLEVEL9K_HIDE_BRANCH_ICON=true
export POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"
export POWERLEVEL9K_STATUS_VERBOSE=false
export DEFAULT_USER="$USER"

# Put the prompt on second line and add a new line before showing the next
# prompt.
export POWERLEVEL9K_PROMPT_ON_NEWLINE=true
export POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# Elements for the left and right prompt, and git hooks.
export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status command_execution_time os_icon custom_project dir vcs time)
export POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
export POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind git-tagname)

# Disable dir icons.
export POWERLEVEL9K_HOME_ICON=''
export POWERLEVEL9K_HOME_SUB_ICON=''
export POWERLEVEL9K_FOLDER_ICON=''

# Command execution time.
export POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
export POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
export POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='black'
export POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='yellow'

# VCS custom colors.
export POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='black'
export POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='blue'

# Project language identifier based on git repo type.
export POWERLEVEL9K_CUSTOM_PROJECT="project_type"
export POWERLEVEL9K_CUSTOM_PROJECT_BACKGROUND='black'
export POWERLEVEL9K_CUSTOM_PROJECT_FOREGROUND='white'

# VCS settings.
export POWERLEVEL9K_VCS_CLEAN_BACKGROUND='cyan'
export POWERLEVEL9K_VCS_CLEAN_FOREGROUND='black'
export POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='green'
export POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='black'
export POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
export POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'
export POWERLEVEL9K_VCS_GIT_ICON='\uF296 '
# POWERLEVEL9K_VCS_STAGED_ICON='\u00b1'
# POWERLEVEL9K_VCS_UNTRACKED_ICON='\u25CF'
# POWERLEVEL9K_VCS_UNSTAGED_ICON='\u00b1'
# POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='\u2193'
# POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='\u2191'

# Time settings.
export POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"
export POWERLEVEL9K_TIME_ICON=''
export POWERLEVEL9K_TIME_FOREGROUND='white'
export POWERLEVEL9K_TIME_BACKGROUND='black'

# Ruby settings.
export POWERLEVEL9K_RVM_FOREGROUND='black'
export POWERLEVEL9K_RVM_BACKGROUND='white'
export POWERLEVEL9K_RVM_VISUAL_IDENTIFIER_COLOR='red'

# Multiline prefixes.
export POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%{%F{249}%}\u250f"
export POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%F{249}%}\u2517%{%F{default}%} "

# vim:ft=sh
