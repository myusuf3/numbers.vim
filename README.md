numbers.vim
===========

numbers.vim is a plugin for intelligently toggling line numbers.

This plugin alternates between relative numbering (`relativenumber`) and
absolute numbering (`number`) for the active window depending on the mode
you are in. In a GUI, it also functions based on whether or not the app has
focus.

Numbers go absolute while you are in insert mode, while you are typing an Ex
command (so the line in `:14y` can be read off the gutter), in inactive
windows, and while the editor is unfocused. They are relative the rest of the
time.

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

If you see numbers where they don't belong like in the help menus or other vim plugins be sure to add the filetypes used by your plugins to the excludes list in your vimrc like so

    let g:numbers_exclude = ['tagbar', 'gundo', 'minibufexpl', 'nerdtree']

The plugin by default contains the following:

    let g:numbers_exclude = ['unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m', 'nerdtree', 'Mundo', 'MundoDiff', 'buffergator', 'easybuffer']

So be sure to include the superset in your vimrc or gvimrc

Plugin windows often leave `filetype` empty, which puts them out of reach of
that list. Those are excluded by `buftype` instead, which by default covers
every special buffer kind:

    let g:numbers_exclude_buftypes = ['acwrite', 'help', 'nofile', 'nowrite', 'popup', 'prompt', 'quickfix', 'terminal']

Shorten that list if you want line numbers back in one of those windows.

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

VSCode
------

Under the [vscode-neovim][vn] extension the plugin disables itself. VSCode draws
its own gutter, so switching `number` and `relativenumber` in Neovim has no
effect on screen there, and it used to shift the cursor several columns to the
right when entering insert mode.

VSCode has the same feature built in:

    "editor.lineNumbers": "relative"

Tests
-----

    ./test/run.sh            # every case, against both vim and neovim
    ./test/run.sh toggle     # a single case

Each case in `test/cases/` runs in its own editor process and asserts on
`number` and `relativenumber`. Editors that are not installed are skipped. CI
runs the same script.

[vn]: https://github.com/vscode-neovim/vscode-neovim
[p]: https://github.com/tpope/vim-pathogen
[v]: https://github.com/gmarik/vundle
