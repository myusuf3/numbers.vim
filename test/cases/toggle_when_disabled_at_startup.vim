" SETUP: let g:enable_numbers = 0 | set number
" Regression test for issue #63: with the plugin disabled in the vimrc, the
" first :NumbersToggle used to be a no-op because the cached s:mode disagreed
" with the actual gutter, so it took two calls to reach relative numbering.
source <sfile>:h/../assert.vim

edit /tmp/numbers-test-a.txt
call AssertNumbers('startup leaves plain number', 1, 0)

NumbersToggle
call AssertNumbers('#63 first toggle switches immediately', 1, 1)
NumbersToggle
call AssertNumbers('#63 second toggle switches back', 1, 0)

call TestDone()
