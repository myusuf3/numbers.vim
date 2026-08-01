" Core contract: relative while navigating, absolute while typing or away.
source <sfile>:h/../assert.vim

edit /tmp/numbers-test-a.txt
call AssertNumbers('startup is hybrid', 1, 1)

call TypeSomething()
call AssertNumbers('back to hybrid after leaving insert', 1, 1)

doautocmd InsertEnter
call AssertNumbers('insert mode is absolute', 1, 0)
doautocmd InsertLeave
call AssertNumbers('normal mode is hybrid', 1, 1)

" Real focus events cannot be produced headlessly.
doautocmd FocusLost
call AssertNumbers('unfocused window is absolute', 1, 0)
doautocmd FocusGained
call AssertNumbers('refocused window is hybrid', 1, 1)

split
wincmd j
call AssertNumbers('entered window is hybrid', 1, 1)
wincmd k
call AssertNumbers('other window is hybrid once entered', 1, 1)

call TestDone()
