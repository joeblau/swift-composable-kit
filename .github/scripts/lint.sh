#!/bin/sh
# Pre project generation script

which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    brew update
fi

# Homebrew dependencies
brew bundle --file .github/brew/Brewfile


# Run linters and formatters
if [[ -f ".swiftformat" ]]; then
    swiftformat .
fi

if [[ -f ".swiftlint" ]]; then
    swiftlint autocorrect
fi