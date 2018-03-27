#!/bin/bash
rm -rf ~/.bash_profile
rm -rf ~/.vim
rm -rf ~/.tmux.conf
rm -rf ~/.vimrc
ln -s ~/dotfiles/.bash_profile ~/
ln -s ~/dotfiles/.vim ~/
ln -s ~/dotfiles/.tmux.conf ~/
ln -s ~/dotfiles/.vimrc ~/
