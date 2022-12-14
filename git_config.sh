#!/bin/bash

git config --global user.name "weitero"
git config --global user.email 112836181+weitero@users.noreply.github.com
git config --global core.editor nvim
git config --global init.defaultBranch master

git config --global color.ui.auto

#provided that git-lfs is installed
git lfs install

#to sign all commits by default in any local repository
# git config --global commit.gpgsign true
# git config --global gpg.program gpg
# git config --global user.signingkey [gpg_key_id]

#git pull --rebase --autostash
#https://cscheng.info/2017/01/26/git-tip-autostash-with-git-pull-rebase.html

#https://stackoverflow.com/questions/30208928/can-git-pull-automatically-stash-and-pop-pending-changes
git config --global pull.rebase true
git config --global rebase.autoStash true #the --autostash option only work with --rebase

# git config --global http.proxy http://127.0.0.1:[port]

