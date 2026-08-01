" Issue #62: :14y addresses an absolute line, but the gutter was relative
" while typing it, so people kept acting on the wrong line. The command line
" now shows absolute numbers.
source <sfile>:h/../assert.vim

let g:samples = []

" <C-r>= evaluates while the command line is still open, which is the only
" moment worth sampling.
function! Sample() abort
    call add(g:samples, &relativenumber)
    return ''
endfunction

edit /tmp/numbers-test-a.txt
call AssertNumbers('startup is hybrid', 1, 1)

if exists('##CmdlineEnter')
    call feedkeys(":\<C-r>=Sample()\<CR>\<CR>", 'x')
    call Assert('#62 the : command line shows absolute numbers',
                \ 'rnu=0', 'rnu=' . g:samples[0])
    call AssertNumbers('#62 relative comes back afterwards', 1, 1)

    " Searches take no line number, so they are deliberately left alone. The
    " search has to match something real: an empty pattern raises E35, and
    " cancelling with <Esc> hangs a headless editor.
    call setline(1, ['alpha', 'beta', 'gamma'])
    let g:samples = []
    call feedkeys("/beta\<C-r>=Sample()\<CR>\<CR>", 'x')
    call Assert('#62 searching does not switch',
                \ 'rnu=1', 'rnu=' . g:samples[0])
    call AssertNumbers('and the window is still hybrid', 1, 1)
else
    call Skip('#62 command line -- editor has no CmdlineEnter event')
endif

call TestDone()
