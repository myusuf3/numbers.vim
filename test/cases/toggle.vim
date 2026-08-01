" :NumbersToggle flips the numbering style; it does not disable the plugin.
source <sfile>:h/../assert.vim

edit /tmp/numbers-test-a.txt
call AssertNumbers('startup is hybrid', 1, 1)

NumbersToggle
call AssertNumbers('toggle goes absolute', 1, 0)
NumbersToggle
call AssertNumbers('toggle goes back to relative', 1, 1)
NumbersToggle
call AssertNumbers('toggle alternates on every call', 1, 0)

" Documented behaviour: contextual switching takes over again at the next
" mode change, so the toggle is momentary rather than sticky.
call TypeSomething()
call AssertNumbers('contextual switching resumes after toggle', 1, 1)

call TestDone()
