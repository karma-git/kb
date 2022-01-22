FROM linuxserver/code-server:4.0.1-focal

RUN code-server --install-extension redhat.vscode-yaml \
  && code-server --install-extension yzhang.markdown-all-in-one \
  && code-server --install-extension bierner.markdown-mermaid \
  && code-server --install-extension mhutchie.git-graph \
  && cp -r /config/.local/share/code-server/extensions /config/extensions \
  && apt-get update \
  && apt-get install -y wget zsh python3-pip -y \
  && pip3 install --no-cache-dir \
    mkdocs-material~=8.1 \
    mkdocs-mermaid2-plugin~=0.5 \
    pygments~=2.11.2 \
  && sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" \
  && sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes \
  && echo 'eval "$(starship init zsh)"' >> /config/.zshrc

COPY ./ /config/workspace/
