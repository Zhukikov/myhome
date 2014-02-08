#!/bin/bash

myhome=`pwd`
dotfiles=$myhome/dotfiles

timestamp=`date +%s`
dotfiles_old=$myhome/dotfiles_bak/$timestamp

cd "$dotfiles"

for f in *; do
  # Move existing dotfiles
  if [ -a ~/.$f ]; then
    mkdir -p "$dotfiles_old"
    mv ~/.$f $dotfiles_old/$f
  fi

  ln -s "$dotfiles/$f" ~/.$f
done

cd "$myhome"

# Move and symlink ~/.vim directory
if [ -a ~/.vim ]; then
  mkdir -p "$dotfiles_old"
  mv ~/.vim $dotfiles_old/vim
fi

ln -s "$myhome/vim" ~/.vim
