# CodeServer

- [chart](https://artifacthub.io/packages/helm/nicholaswilde/code-server)
- [repo](https://github.com/coder/code-server)

> linuxserver - guys who deliver the image with the codeserver

- [linuxserver-base-image](https://github.com/linuxserver/docker-baseimage-ubuntu)
- [linuxserver-code-server-gh](https://github.com/linuxserver/docker-code-server/blob/master/Dockerfile), [libuxserver-code-server-dh](https://hub.docker.com/r/linuxserver/code-server)
- [about extentions](https://github.com/coder/code-server/issues/171)
- [meramid](https://github.com/coder/code-server/issues/171#issuecomment-473690326)
- [zsh](https://www.tecmint.com/install-oh-my-zsh-in-ubuntu/#:~:text=Installation%20of%20Oh%20My%20Zsh,running%20the%20following%20apt%20command.&text=Next%2C%20install%20Oh%20My%20Zsh,curl%20or%20wget%20as%20shown.)
- [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
- [ohmyzsh-themes](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
- [startship](https://starship.rs/)

**Install extentsions**
```shell
code-server --install-extension \
    redhat.vscode-yaml \
    yzhang.markdown-all-in-one \
    vstirbu.vscode-mermaid-preview
```

## zsh
```shell
sudo apt-get update
sudo apt-get install zsh
sudo usermod -s /usr/bin/zsh 1000

sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

```

```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```
