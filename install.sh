#!/bin/bash
rm ~/.bash_profile
rm ~/.vimrc
rm ~/.tmux.conf
ln -s dotfiles/.bashrc ~/
ln -s dotfiles/.vimrc ~/
ln -s dotfiles/.tmux.conf
