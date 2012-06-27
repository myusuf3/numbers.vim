numbers.vim
===========

numbers.vim is a vim plugin for better line numbers.

This plugin will alternate between relative numbering (normal mode) and absolute numbering (insert mode) depending on the mode you are in. 

Requirements
============
  - Vim 7.3+ 
  - pathogen


Installation
============
    
     $ git clone https://github.com/myusuf3/numbers.vim.git ~/.vim/bundle/numbers

Usage
=====
Add this to your .vimrc for a convenient keystroke

    nnoremap <F3> :NumbersToggle<CR>