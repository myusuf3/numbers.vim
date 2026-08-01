" Special windows stay number-free. Regression test for issue #70, where
" numbers came back in a terminal window as soon as it was re-entered.
source <sfile>:h/../assert.vim

edit /tmp/numbers-test-a.txt
call AssertNumbers('normal buffer is hybrid', 1, 1)

help
call AssertNumbers('help window has no numbers', 0, 0)
close

call setqflist([{'filename': '/tmp/numbers-test-a.txt', 'lnum': 1, 'text': 'x'}])
copen
call AssertNumbers('quickfix window has no numbers', 0, 0)
cclose

if has('terminal') || has('nvim')
    split
    terminal
    call AssertNumbers('#70 fresh terminal has no numbers', 0, 0)
    wincmd j
    wincmd k
    call AssertNumbers('#70 terminal stays clean when re-entered', 0, 0)
    wincmd j
    wincmd k
    call AssertNumbers('#70 and stays clean on every re-entry', 0, 0)
else
    call Skip('#70 terminal cases -- editor built without +terminal')
endif

call TestDone()
