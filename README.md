numbers.vim
===========

numbers.vim is a plugin for intelligently toggling line numbers.

This plugin alternates between relative numbering (`relativenumber`) and
absolute numbering (`number`) depending on the mode you are in. In a GUI, it
also functions based on whether or not the app has focus.

Commands are included for toggling the line numbering method and for enabling
and disabling the plugin.


Requirements
------------

  - Vim 7.3+


Installation
------------

Using [pathogen][p] or [vundle][v] for installation is recommended.

For pathogen users, clone the repo:

    git clone https://github.com/myusuf3/numbers.vim.git ~/.vim/bundle/numbers

For vundle users, add the following to your `.vimrc` and then run
a `:BundleInstall`:

    Bundle "myusuf3/numbers.vim"


Usage
-----

Once installed, no action is *required* on your part. But for convenience, you
may want to add mappings in your `.vimrc` for some of the commands, e.g.,

    nnoremap <F3> :NumbersToggle<CR>
    nnoremap <F4> :NumbersOnOff<CR>


[p]: https://github.com/tpope/vim-pathogen
[v]: https://github.com/gmarik/vundle
