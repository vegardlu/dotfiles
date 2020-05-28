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

# Cask
brew cask install docker
brew cask install slack
brew cask install google-chrome

# Java
brew tap AdoptOpenJDK/openjdk
brew cask install adoptopenjdk/openjdk/adoptopenjdk8
brew cask install adoptopenjdk/openjdk/adoptopenjdk11
brew cask install adoptopenjdk/openjdk/adoptopenjdk12

# Jetty
brew install jetty

# Maven
brew install maven
brew install maven-completion

# iTerm2
brew cask install iterm2

# zsh
brew install zsh
