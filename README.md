numbers.vim
===========

numbers.vim is a plugin for intelligently toggling line numbers.

This plugin alternates between relative numbering (`relativenumber`) and
absolute numbering (`number`) for the active window depending on the mode
you are in. In a GUI, it also functions based on whether or not the app has
focus.

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

Numbers Don't Belong    
--------------------

If you see numbers where they don't belong like in the help menus or other vim plugins be sure to add your plugins to the excludes list in your vimrc like so

    let g:numbers_exclude = ['tagbar', 'gundo', 'minibufexpl', 'nerdtree']
    
The plugin by default contains the following:

    let g:numbers_exclude = ['unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m']$


So be sure to include the superset in your vimrc or gvimrc

Usage
-----

Once installed, no action is *required* on your part. But for convenience, you
may want to add mappings in your `.vimrc` for some of the commands, e.g.,

    nnoremap <F3> :NumbersToggle<CR>
    nnoremap <F4> :NumbersOnOff<CR>

Vim 7.4
-------
If you are lucky enough to be a Vim 7.4 user, you may experience unexpected
behaviour if `set number` is not present in your `~/.vimrc`.

[p]: https://github.com/tpope/vim-pathogen
[v]: https://github.com/gmarik/vundle
