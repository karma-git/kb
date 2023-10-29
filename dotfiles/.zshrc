# zmodload zsh/zprof  # NOTE: enable zsh startup profiling

# Shell
## settings zsh; oh-my-zsh

export ZSH="${HOME}/.oh-my-zsh"
ZSH_DISABLE_COMPFIX=true
ZSH_ALIAS_FINDER_AUTOMATIC=true

plugins=(
  alias-finder
  docker
  docker-compose
  git
  kubectl
  vagrant
  zsh-autosuggestions
  zsh-syntax-highlighting
  )

export PATH=/opt/homebrew/bin:$PATH
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
source $ZSH/oh-my-zsh.sh

# ref:https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="aussiegeek"

eval "$(starship init zsh)"

# functions

function set_win_title(){
    echo -ne "\033]0; $(basename "$PWD") \007"
}

# window title
precmd_functions+=(set_win_title)

# kubernetes settings
export KUBECONFIG=${HOME}/.kube/work-kubeconfig.yml

function aws-ctx() {
  if [ $# -eq 0 ]
    then
      export AWS_PROFILE="$(aws configure list-profiles | fzf)"
      echo "Switched to profile ""$AWS_PROFILE""."
    else
      export AWS_PROFILE="$1"
  fi
}

# Aliases

# iac; terraform
alias tf='terraform'
alias tg='terragrunt'

# python
alias py='python3'
alias vc='python3 -m venv venv' # creates venv with a name of current dir
alias va='source venv/bin/activate' # activate venv in current dir
alias vd='deactivate' # deactivate venv

alias todo='rg "TODO"'
alias fixme='rg "FIXME"'

# NOTE: deprecated rust aliases
# alias cat=bat
# alias du=dust
# alias find=fd
# alias ls=exa
# alias grep=rg

[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
alias k=kubectl
complete -o default -F __start_kubectl k
alias kz=kustomize
alias kza="kustomize build . | kubectl apply –f -"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export GOPATH="$HOME/.it/go"
export PATH="$GOPATH/bin:$PATH"

# zprof # NOTE: enable zsh startup profiling

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/a.horbach/.settings/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/a.horbach/.settings/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/a.horbach/.settings/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/a.horbach/.settings/google-cloud-sdk/completion.zsh.inc'; fi

export PATH="/usr/local/bin/google-cloud-sdk/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# NOTE: typer autocomplete
autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc
compinit -D
