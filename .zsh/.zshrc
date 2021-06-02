# configuring the prompt
## autocompletion for git
autoload -Uz compinit && compinit
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '%b'
NEWLINE=$'\n'
PROMPT='%F{62} '\$vcs_info_msg_0_$NEWLINE"%f%F{239} %n@%f %F{92}%~%f > "
# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle :compinstall filename '/Users/dguim/work/infra/.zsh/.zshrc'
# making my life easier
alias ll='ls -axlt'
# The following third party configurations should be configured by the
# application itself.

