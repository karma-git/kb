FROM linuxserver/code-server:4.0.1-focal

RUN code-server --install-extension redhat.vscode-yaml \
  && code-server --install-extension yzhang.markdown-all-in-one \
  && code-server --install-extension bierner.markdown-mermaid \
  && code-server --install-extension mhutchie.git-graph \
  && cp -r /config/.local/share/code-server/extensions /config/extensions \
  && apt-get update \
  && apt-get install -y zsh python3-pip -y \
  && pip3 install --no-cache-dir \
    mkdocs-material~=8.1 \
    mkdocs-mermaid2-plugin~=0.5 \
    pygments~=2.11.2

COPY ./ /config/workspace/README.md
