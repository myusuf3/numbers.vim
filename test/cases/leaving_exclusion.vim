" A window that stops being excluded gets its numbers back.
"
" Excluding a window uses setlocal nonumber, but the relative branch of
" ResetNumbers only ever re-applied 'relativenumber'. A window that had shown
" a sidebar filetype was left on relative-only numbering until it happened to
" be left and re-entered.
source <sfile>:h/../assert.vim

edit /tmp/numbers-test-a.txt
call AssertNumbers('normal buffer is hybrid', 1, 1)

new
setf nerdtree
call AssertNumbers('sidebar filetype is excluded', 0, 0)

setf text
call AssertNumbers('numbers come back with an ordinary filetype', 1, 1)

setf nerdtree
call AssertNumbers('excluded again', 0, 0)
edit! /tmp/numbers-test-b.txt
call AssertNumbers('and come back when a real file is opened there', 1, 1)
bwipeout!

" A window is only restored to what the user actually asked for: turning
" numbers off by hand has to stick.
set nonumber
new
setf nerdtree
call AssertNumbers('still excluded with numbers off globally', 0, 0)
setf text
call AssertNumbers('a global nonumber is not overridden', 0, 1)
bwipeout!

call TestDone()
