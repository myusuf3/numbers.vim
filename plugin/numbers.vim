if (exists('g:numbers') && g:numbers)  || v:version <= 703 || &cp
    finish
endif

let g:numbers = 1
let g:mode = 0
let g:center = 1 

" Triggers mode based on events
autocmd InsertEnter * :call SetNumbers()
autocmd InsertLeave * :call SetRelative()
autocmd BufNewFile  * :call ResetNumber()
autocmd BufReadPost * :call ResetNumber()
autocmd FocusLost   * :call Uncenter()
autocmd FocusGained * :call Center()


function! s:SetNumber()
    let g:mode = 1
    call ResetNumber()
endfunc

function! s:SetRelative()
    let g:mode = 0
    call ResetNumber()
endfunc

function! s:NumbersToggle()
    if (&number == 1)
        set relativenumber
    else
        set number
    endif
endfunc

function! ResetNumbers()
    if(g:center == 0)
        set number
    elseif(g:mode == 0)
        set relativenumber
    else
        set number
    end
endfunc

function! Center()
    let g:center = 1
    call ResetNumber()
endfunc

function! Uncenter()
    let g:center = 0
    call ResetNumber()
endfunc


command! -nargs=0 NumbersToggle call numbers#NumbersToggle()
