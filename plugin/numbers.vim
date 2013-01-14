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

let s:numbers_version = '0.2.0'

"Allow use of line continuation
let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_numbers") && g:loaded_numbers
    finish
endif
let g:loaded_numbers = 1

if v:version < 703 || &cp
    echomsg "numbers.vim: you need at least Vim 7.3 and 'nocp' set"
    echomsg "Failed loading numbers.vim"
    finish
endif

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

" To be technically correct this would be called on InsertLeave rather than
" on BufReadPost, because what happens when someone opens a file with 999
" lines and then adds one more? But I didn't have the heart to add overhead to
" every single mode shift for the sake of such a rare occurrence.
function! SetWidth()
    if(line("$") >= 10000)
        set numberwidth=6
    elseif(line("$") >= 1000)
        set numberwidth=5
    else
        set numberwidth=4
    end
endfunc

" Triggers mode based on events
augroup NumbersAug
    au!
    autocmd InsertEnter * :call SetNumbers()
    autocmd InsertLeave * :call SetRelative()
    autocmd BufNewFile  * :call ResetNumbers()
    autocmd BufReadPost * :call ResetNumbers()
    autocmd BufReadPost * :call SetWidth()
    autocmd FocusLost   * :call Uncenter()
    autocmd FocusGained * :call Center()
augroup END

" Commands
command! -nargs=0 NumbersToggle call NumbersToggle()

" reset &cpo back to users setting
let &cpo = s:save_cpo
