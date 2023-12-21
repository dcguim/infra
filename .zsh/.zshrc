# configuring the prompt
## autocompletion for git
autoload -Uz compinit && compinit
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '%b'
NEWLINE=$'\n'
PROMPT='%F{62} ('\${vcs_info_msg_0_}')'$NEWLINE"%f%F{239} %n@%f %F{92}%~%f %F{62}>%f "
# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle :compinstall filename '/Users/dguim/work/infra/.zsh/.zshrc'

# making my life easier
## hooks
function chpwd {
  if ! [ -z $(git rev-parse --git-dir 2>/dev/null) ];
  then export BRANCH=$(git rev-parse --abbrev-ref HEAD)
  fi
}
## aliases
alias ll='ls -axlt'
# The following third party configurations should be configured by the
# application itself.
emacs(){
  nohup emacs "$@" &
}
#  if [ -n "$1" ]; then
#    nohup emacs "$1" &
#  else
#    nohup emacs &
#  fi

## GCP util
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dguim/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dguim/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dguim/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dguim/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
