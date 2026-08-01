" SETUP: let g:numbers_exclude = ['tagbar', 'myplugin']
" Setting g:numbers_exclude replaces the default list rather than extending it.
source <sfile>:h/../assert.vim

edit /tmp/numbers-test-a.txt

new
setf myplugin
call AssertNumbers('a user-listed filetype is excluded', 0, 0)
bwipeout!

new
setf tagbar
call AssertNumbers('a kept default is still excluded', 0, 0)
bwipeout!

new
setf nerdtree
call AssertNumbers('a dropped default is no longer excluded', 1, 1)
bwipeout!

call TestDone()
