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

source $ZSH/oh-my-zsh.sh

# ref:https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="aussiegeek"

eval "$(starship init zsh)"

# kubernetes settings
autoload -Uz compinit
compinit
export KUBECONFIG=${HOME}/.kube/work-kubeconfig.yml

# Aliases

alias cat=bat
alias du=dust
alias find=fd
alias ls=exa
alias grep=rg

alias 4g="sudo sysctl -w net.inet.ip.ttl=65"  # Change ttl for don't run router mode on ph
alias wifipwsh='f() {security find-generic-password -wa $1}; f' # sh wifi (SSID) pw -> you have to insert SSID name

alias gpw='python -c "import uuid; print(uuid.uuid4().hex)" # an example, how to generate key via python'  # generating password

alias vc='python3 -m venv venv' # creates venv with a name of current dir
alias va='source venv/bin/activate' # activate venv in current dir
alias vd='deactivate' # deactivate venv

alias vector='docker run -i -v $(pwd)/:/etc/vector/ --rm timberio/vector:0.25.2-debian'
alias todo='rg "TODO"'
alias fixme='rg "FIXME"'
# alias todo='// TODO | # TODO'

complete -F __start_kubectl k

alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '

# zprof # NOTE: enable zsh startup profiling
