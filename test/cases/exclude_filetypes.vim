" Excluded filetypes show no numbers at all.
"
" Issues #55, #48 and #59 were all the same failure: plugin windows set their
" filetype after BufNewFile has already fired, so the exclude list was checked
" against an empty 'filetype'. These cases set the filetype late on purpose --
" that is what the FileType autocmd exists to catch.
source <sfile>:h/../assert.vim

edit /tmp/numbers-test-a.txt
call AssertNumbers('normal buffer is hybrid', 1, 1)

new
call AssertNumbers('new scratch buffer starts with numbers', 1, 1)
setf nerdtree
call AssertNumbers('#59 filetype set late is still excluded', 0, 0)
bwipeout!

new
setf buffergator
call AssertNumbers('#48 buffergator is excluded by default', 0, 0)
bwipeout!

new
setf easybuffer
call AssertNumbers('#55 easybuffer is excluded by default', 0, 0)
bwipeout!

new
setf text
call AssertNumbers('an ordinary filetype keeps its numbers', 1, 1)
bwipeout!

call TestDone()
