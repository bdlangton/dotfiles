# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"

# Set CLICOLOR if you want Ansi Colors in iTerm2.
export CLICOLOR=1

# Set xterm 256 colors.
export TERM=xterm-256color

# Set autosuggest color to something other than my default background.
# See: https://github.com/zsh-users/zsh-autosuggestions/issues/243
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=yellow'

# Powerlevel9k settings. Use nerdfont.
POWERLEVEL9K_MODE='nerdfont-complete'

# Powerlevel9k custom settings.
DISABLE_AUTO_TITLE="true"
POWERLEVEL9K_HIDE_BRANCH_ICON=true
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"
POWERLEVEL9K_STATUS_VERBOSE=false
export DEFAULT_USER="$USER"

# Put the prompt on second line and add a new line before showing the next
# prompt.
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# Elements for the left and right prompt, and git hooks.
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status command_execution_time os_icon custom_project dir vcs time)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind git-tagname)

# Disable dir icons.
POWERLEVEL9K_HOME_ICON=''
POWERLEVEL9K_HOME_SUB_ICON=''
POWERLEVEL9K_FOLDER_ICON=''

# Command execution time.
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='black'
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='yellow'

# VCS custom colors.
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='black'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='blue'

# Project language identifier based on git repo type.
POWERLEVEL9K_CUSTOM_PROJECT="project_type"
POWERLEVEL9K_CUSTOM_PROJECT_BACKGROUND='black'
POWERLEVEL9K_CUSTOM_PROJECT_FOREGROUND='white'

# VCS settings.
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='cyan'
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='black'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='green'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='black'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'
POWERLEVEL9K_VCS_GIT_ICON='\uF296 '
# POWERLEVEL9K_VCS_STAGED_ICON='\u00b1'
# POWERLEVEL9K_VCS_UNTRACKED_ICON='\u25CF'
# POWERLEVEL9K_VCS_UNSTAGED_ICON='\u00b1'
# POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='\u2193'
# POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='\u2191'

# Time settings.
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"
POWERLEVEL9K_TIME_ICON=''
POWERLEVEL9K_TIME_FOREGROUND='white'
POWERLEVEL9K_TIME_BACKGROUND='black'

# Ruby settings.
POWERLEVEL9K_RVM_FOREGROUND='black'
POWERLEVEL9K_RVM_BACKGROUND='white'
POWERLEVEL9K_RVM_VISUAL_IDENTIFIER_COLOR='red'

# Multiline prefixes.
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%{%F{249}%}\u250f"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%F{249}%}\u2517%{%F{default}%} "

# vim:ft=sh
