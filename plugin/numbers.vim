"   if exists('g:numbers')  || v:version <= 703 || &cp
"       finish
"   endif

let g:numbers=1
let g:mode=0
let g:center=1 

function! SetNumbers()
    let g:mode = 1
    call ResetNumbers()
endfunc

function! SetRelative()
    let g:mode = 0
    call ResetNumbers()
endfunc

function! NumbersToggle()
    if (g:mode == 1)
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
    call ResetNumbers()
endfunc

function! Uncenter()
    let g:center = 0
    call ResetNumbers()
endfunc

" Triggers mode based on events
autocmd InsertEnter * :call SetNumbers()
autocmd InsertLeave * :call SetRelative()
autocmd BufNewFile  * :call ResetNumbers()
autocmd BufReadPost * :call ResetNumbers()
autocmd FocusLost   * :call Uncenter()
autocmd FocusGained * :call Center()

