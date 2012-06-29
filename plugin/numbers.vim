""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File:           numbers.vim
" Maintainer:     Mahdi Yusuf yusuf.mahdi@gmail.com
" Version:        0.1.0
" Description:    vim global plugin for better line numbers.
" Last Change:    26 June, 2012
" License:        MIT License
" Location:       plugin/numbers.vim
" Website:        https://github.com/myusuf3/numbers.vim
"
" See numbers.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help numbers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:numbers_version = '0.1.0'

"Allow use of line continuation
let s:save_cpo = &cpo
set cpo&vim

if exists("g:numbers") || v:version < 703 || &cp
    let &cpo = s:save_cpo
    echom 'Requires Vim 7.3+'
    echom 'Failed loading numbers.vim'
    finish
endif

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
        let g:mode = 0
        set relativenumber
    else
        let g:mode = 1
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
augroup NumbersAug
    au!
    autocmd InsertEnter * :call SetNumbers()
    autocmd InsertLeave * :call SetRelative()
    autocmd BufNewFile  * :call ResetNumbers()
    autocmd BufReadPost * :call ResetNumbers()
    autocmd FocusLost   * :call Uncenter()
    autocmd FocusGained * :call Center()
augroup END

" Commands
command! -nargs=0 NumbersToggle call NumbersToggle()

" reset &cpo back to users setting
let &cpo = s:save_cpo
