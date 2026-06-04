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

# fix empty git repo fatal error
function chpwd {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if git rev-parse --abbrev-ref HEAD > /dev/null 2>&1; then
      export BRANCH=$(git rev-parse --abbrev-ref HEAD)
    fi
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

ll() {
  ls -alt "$@" | awk 'NR>1 && /^d/'
  ls -alt "$@" | awk 'NR==1 || (NR>1 && !/^d/)'
}

## hook direnv into the shell
eval "$(direnv hook zsh)"

treeprint() {
  # Check if we're in a git repository
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    git log --graph --decorate --color \
      --pretty=format:"%C(yellow)%h %C(green)%ad %C(cyan)%an%Creset - %C(white)%s" \
      --date=short
  else
    echo "❌ Not inside a git repository."
  fi
}

## GCP util
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dguim/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dguim/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dguim/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dguim/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export PNPM_HOME="/Users/dguim/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

source "/Users/dguim/.openclaw/completions/openclaw.zsh"
EMACS_APP="/Applications/emacs/nextstep/Emacs.app/Contents/MacOS"
emacs(){
  "$EMACS_APP/bin/emacsclient" -c -a "$EMACS_APP/Emacs" "${1:-.}" &>/dev/null &
}

# Initialize a Python project with virtualenv + direnv for Emacs LSP
pyinit() {
  local venv_name="${1:-venv}"
  if [ -f ".envrc" ]; then
    echo ".envrc already exists, skipping"
    return 0
  fi
  echo "Creating virtualenv '$venv_name'..."
  python3 -m venv "$venv_name" || { echo "Failed to create venv"; return 1; }
  echo "Writing .envrc for direnv..."
  cat > .envrc <<EOF
export VIRTUAL_ENV=\$PWD/$venv_name
PATH_add "\$VIRTUAL_ENV/bin"
EOF
  direnv allow .
  echo "Installing python-lsp-server for Emacs LSP..."
  "$venv_name/bin/pip" install python-lsp-server || { echo "Failed to install pylsp"; return 1; }
  echo "Done! Open a .py file here and LSP will use $venv_name."
}
