#!/bin/bash
rm -rf ~/.bash_profile
rm -rf ~/.vim
rm -rf ~/.tmux.conf
rm -rf ~/.vimrc
ln -s ~/git/dotfiles/.bash_profile ~/
ln -s ~/git/dotfiles/.vim ~/
ln -s ~/git/dotfiles/.tmux.conf ~/
ln -s ~/git/dotfiles/.vimrc ~/
