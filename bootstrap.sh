#!/bin/sh

BLUE='\033[0;36m'
NC='\033[0m'

init () {
    echo "${BLUE}Initializing workspace${NC}"
    mkdir -pv ${HOME}/workspace
}

link () {
    echo "${BLUE}Initializing symlinks${NC}"
    echo "Proceed? (y/n)"
    read resp
    if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
        mkdir -pv "${HOME}/.config"
        mkdir -pv "${HOME}/.config/fish"
        ln -svf "$PWD/.aliases" "$HOME"
        ln -svf "$PWD/.exports" "$HOME"
        ln -svf "$PWD/.functions" "$HOME"
        ln -svf "$PWD/.vimrc" "$HOME"
        ln -svf "$PWD/.aliases" "$HOME"
        ln -svf "$PWD/config/.bash_profile" "$HOME/.bash_profile"
        ln -svf "$PWD/config/.zshenv" "$HOME/.zshenv"
        ln -svf "$PWD/config/.zshrc" "$HOME/.zshrc"
        ln -svf "$PWD/config/fish/config.fish" "$HOME/.config/fish/config.fish"
        ln -svf "$PWD/config/fish/alias.fish" "$HOME/.config/fish/alias.fish"
        ln -svf "$PWD/config/fish/local.fish" "$HOME/.config/fish/local.fish"
        ln -svf "$PWD/config/fish/export.fish" "$HOME/.config/fish/export.fish"
        ln -svf "$PWD/config/fish/completions" "$HOME/.config/fish/completions"
        ln -svf "$PWD/config/starship.toml" "$HOME/.config/starship.toml"
        echo "Symlinking complete"
    else
        echo "Symlinking cancelled"
        return 1
    fi
}

install_tools () {
    if [ $( echo "$OSTYPE" | grep 'darwin' ) ] ; then
        echo "${BLUE}Initializing homebrew${NC}"
        echo "Proceed? (y/n)"
        read resp
        if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
            echo "Installing useful stuff using brew. This may take a while..."
            sh brew-install.sh
        else
            echo "Brew installation cancelled by user"
        fi
    else
        echo "Skipping installations using Homebrew because MacOS was not detected..."
    fi
}

compile_exports () {
    echo "${BLUE}Setting compiled exports${NC}"
    sh compiled-exports.sh
}

set_zsh () {
    echo "${BLUE}Set ZSH to default?${NC} (y/n)"
    read resp
    if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
        echo "setting shell to zsh"
        chsh -s /usr/local/bin/zsh
    else
        echo "skipping chsh"
    fi
}

env_file () {
      echo "${BLUE}Create env file?${NC} (y/n)"
      read resp
      if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
            echo "creating env file"
            echo "SPRING_ARGS='--datasource.url=$oracleDbUrl --datasource.user=$oracleDbUser --datasource.password=$oracleDbPassword" > "$HOME/.env"
      else
          echo "skipping env file creation"
      fi
}

oh_my_zsh() {
    echo "${BLUE}Install oh my zsh?${NC} (y/n)"
    read resp
    if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
        echo "installing oh my zsh"
        sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
          ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    else
        echo "skipping oh my zsh"
    fi
}

init
link
install_tools
env_file
link
