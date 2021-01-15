#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Install homebrew if it is not installed
which brew 1>&/dev/null
if [ ! "$?" -eq 0 ] ; then
	echo "Homebrew not installed. Attempting to install Homebrew"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	if [ ! "$?" -eq 0 ] ; then
		echo "Something went wrong. Exiting..." && exit 1
	fi
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Coreutil
brew install coreutils

# Cask
brew install cask

# Other
brew install bash-completion
brew install git
brew install bash-git-prompt
brew install docker-compose docker-machine
brew install z
brew install contacts
brew install speedtest-cli
brew install gh
brew install helm

# Cask
brew install docker --cask
brew install slack --cask
brew install google-chrome --cask
brew install discord --cask

# Java
brew tap AdoptOpenJDK/openjdk
brew install adoptopenjdk/openjdk/adoptopenjdk8 --cask 
brew install adoptopenjdk/openjdk/adoptopenjdk11 --cask 
brew install adoptopenjdk/openjdk/adoptopenjdk12 --cask 
brew install adoptopenjdk/openjdk/adoptopenjdk14 --cask

# Jetty
brew install jetty

# Maven
brew install maven
brew install maven-completion

# iTerm2
brew install iterm2 --cask

# zsh
brew install zsh
