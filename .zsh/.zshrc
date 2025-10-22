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
# The following lines were added by compinstall, make sure zsh is less "smart"!
zstyle ':completion:*' completer _complete 
zstyle :compinstall filename '/Users/dguim/work/infra/.zsh/.zshrc'
setopt noautomenu

# making my life easier
## hooks
function poetryenv() {
    if [[ -f "pyproject.toml" ]]; then
        echo $(poetry env info --path)
    else
        echo "No pyproject.toml found in the current directory."
        return 1
    fi
}
function chpwd {
  if ! [ -z $(git rev-parse --git-dir 2>/dev/null) ];
  then export BRANCH=$(git rev-parse --abbrev-ref HEAD)
  fi
}
# smarter grep
sgrep() {
  # Default values
  local ext=""
  local pattern=""

  # Parse command-line arguments using getopts
  while getopts "e:p:" opt; do
    case "$opt" in
      e) ext="$OPTARG" ;;    # -e flag for file extension
      p) pattern="$OPTARG" ;;  # -p flag for search pattern
      *) echo "Usage: search_files -e <extension> -p <pattern>"; return 1 ;;
    esac
  done

  # Ensure both extension and pattern are provided
  if [ -z "$ext" ] || [ -z "$pattern" ]; then
    echo "Usage: search_files -e <extension> -p <pattern>"
    return 1
  fi

  # Perform the search
  for file in $(find ./ -name "*.$ext"); do
    if grep -q "$pattern" "$file"; then 
      echo "==> $file"
      grep "$pattern" "$file" 
    fi
  done
}
## aliases
alias ll='ls -al | awk '\''{ if ($1 ~ /^d/) print $0 }'\'' ; ls -al | awk '\''{ if ($1 !~ /^d/) print $0 }'\'''

# The following third party configurations should be configured by the
# application itself.
emacs(){
  nohup emacs "$@" &
}

## hook direnv into the shell
eval "$(direnv hook zsh)"

## GCP util
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dguim/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dguim/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dguim/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dguim/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
