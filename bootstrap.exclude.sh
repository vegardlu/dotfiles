#!/bin/sh

BLUE='\033[0;36m'
NC='\033[0m'

init () {
    echo "${BLUE}Initializing workspace${NC}"
    mkdir -pv ${HOME}/workspace
    echo "${BLUE}Initilizing jetty dir${NC}"
    sh jetty.exclude.sh
}

link () {
    echo "${BLUE}Initializing symlinks${NC}"
    echo "Proceed? (y/n)"
    read resp
    if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
        for file in $( ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md' ) ; do
            ln -sv "$PWD/$file" "$HOME"
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

init
link
install_tools
compile_exports
set_zsh

