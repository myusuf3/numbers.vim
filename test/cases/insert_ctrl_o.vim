" Regression test for issue #45: i_CTRL-O runs one normal-mode command from
" insert mode, firing InsertLeave and InsertEnter around it. The numbers used
" to flip to relative and straight back, which is very visible for anyone with
" insert-mode mappings built on <C-o>.
source <sfile>:h/../assert.vim

edit /tmp/numbers-test-a.txt

" Sampled after the plugin's own handler, since this autocmd is defined later.
let g:samples = []
augroup sample
    au!
    autocmd InsertLeave * call add(g:samples, &relativenumber)
augroup END

if has('nvim') || has('gui_running')
    execute "normal! i\<C-o>whello\<Esc>"

    call Assert('#45 numbers stay absolute across CTRL-O',
                \ 'rnu=0', 'rnu=' . g:samples[0])
    call Assert('the real insert exit still restores relative',
                \ 'rnu=1', 'rnu=' . g:samples[-1])
    call AssertNumbers('and the window ends up hybrid', 1, 1)
else
    " Vim's silent Ex mode reports mode() as "ce" regardless of the real mode,
    " so the insert-pending state cannot be observed here. Verified by hand
    " under a pty instead: vim 9.2 reports niI exactly like Neovim.
    call Skip('#45 CTRL-O -- mode() is not meaningful in silent Ex mode')
endif

call TestDone()
