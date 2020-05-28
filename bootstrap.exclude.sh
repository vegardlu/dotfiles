#!/bin/sh

BLUE='\033[0;36m'
NC='\033[0m'

init () {
    echo "${BLUE}Initializing workspace${NC}"
    mkdir -pv ${HOME}/workspace
    echo "${BLUE}Initializing jetty dir${NC}"
    sh jetty.exclude.sh
}

link () {
    echo "${BLUE}Initializing symlinks${NC}"
    echo "Proceed? (y/n)"
    read resp
    if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
        for file in $( ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md' ) ; do
            ln -svf "$PWD/$file" "$HOME"
        done
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
            sh brew.exclude.sh
        else
            echo "Brew installation cancelled by user"
        fi
    else
        echo "Skipping installations using Homebrew because MacOS was not detected..."
    fi
}

compile_exports () {
    echo "${BLUE}Setting compiled exports${NC}"
    sh compiled-exports.exclude.sh
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

oh_my_zsh() {
    echo "${BLUE}Install oh my zsh?${NC} (y/n)"
    read resp
    if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
        echo "installing oh my zsh"
        sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    else
        echo "skipping oh my zsh"
    fi
}

jenv() {
    echo "${BLUE}Install jenv?${NC} (y/n)"
    read resp
    if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
        echo "installing jenv"
        sh jenv.exclude.sh
    else
        echo "skipping jenv"
    fi
}

init
link
install_tools
compile_exports
set_zsh
oh_my_zsh
jenv
link

