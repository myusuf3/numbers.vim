" Regression test for issue #64: every route out of relative numbering used to
" lead back into it. :NumbersDisable in particular left 'relativenumber' on,
" trapping the user in relative-only numbering.
source <sfile>:h/../assert.vim

edit /tmp/numbers-test-a.txt
call AssertNumbers('startup is hybrid', 1, 1)

NumbersDisable
call AssertNumbers('#64 disable leaves plain absolute numbers', 1, 0)

call TypeSomething()
call AssertNumbers('#64 disable survives insert mode', 1, 0)

split
wincmd j
wincmd k
call AssertNumbers('#64 disable survives window switching', 1, 0)
only

NumbersEnable
call AssertNumbers('enable restores contextual switching', 1, 1)
doautocmd InsertEnter
call AssertNumbers('switching works again after enable', 1, 0)
doautocmd InsertLeave

NumbersOnOff
call AssertNumbers('onoff turns the plugin off', 1, 0)
NumbersOnOff
call AssertNumbers('onoff turns the plugin back on', 1, 1)

call TestDone()
