" SETUP: let g:numbers_exclude_buftypes = ['help', 'nofile', 'terminal']
" Shortening the list lets numbers back into a kind of window.
source <sfile>:h/../assert.vim

edit /tmp/numbers-test-a.txt

call setqflist([{'filename': '/tmp/numbers-test-a.txt', 'lnum': 1, 'text': 'x'}])
copen
call AssertNumbers('quickfix keeps numbers when dropped from the list', 1, 1)
cclose

help
call AssertNumbers('help is still excluded', 0, 0)
close

call TestDone()
