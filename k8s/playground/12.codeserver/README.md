# code-server

Launch the container with vscode. Look inside the `docker-compose.yml`, you can override http and sudo passwords.

> read more about [hashed password](https://github.com/coder/code-server/blob/main/docs/FAQ.md#can-i-store-my-password-hashed)

```shell
docker-compose up
```

## preinstalled

### Extensions for the Visual Studio
- [yaml](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)
- [markdown](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
- [git-graph](https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph)
- [mermaid-preview](https://marketplace.visualstudio.com/items?itemName=vstirbu.vscode-mermaid-preview)

### Environment Toolz

- zsh
- ohmyzsh
- straship
- pip3
- mkdocs-materials and plugins

<details>
<summary>road so far</summary>

### CodeServer

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
- [customizing linux server containers](https://blog.linuxserver.io/2019/09/14/customizing-our-containers/)

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

</details>
