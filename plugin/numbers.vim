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

if exists("g:loaded_numbers") && g:loaded_numbers
    finish
endif
let g:loaded_numbers = 1

if (!exists('g:enable_numbers'))
    let g:enable_numbers = 1
endif

if v:version < 703 || &cp
    echomsg "numbers.vim: you need at least Vim 7.3 and 'nocp' set"
    echomsg "Failed loading numbers.vim"
    finish
endif


"Allow use of line continuation
let s:save_cpo = &cpo
set cpo&vim

let s:mode=0
let s:center=1

function! SetNumbers()
    let s:mode = 1
    call ResetNumbers()
endfunc

function! SetRelative()
    let s:mode = 0
    call ResetNumbers()
endfunc

function! NumbersToggle()
    if (s:mode == 1)
        let s:mode = 0
        set relativenumber
    else
        let s:mode = 1
        set norelativenumber
    endif
endfunc

function! ResetNumbers()
    if(s:center == 0)
        set norelativenumber
    elseif(s:mode == 0)
        set relativenumber
    else
        set norelativenumber
    end
endfunc

function! Center()
    let s:center = 1
    call ResetNumbers()
endfunc

function! Uncenter()
    let s:center = 0
    call ResetNumbers()
endfunc

function! NumbersEnable()
    let g:enable_numbers = 1
    augroup NumbersAug
        au!
        autocmd InsertEnter * :call SetNumbers()
        autocmd InsertLeave * :call SetRelative()
        autocmd BufNewFile  * :call ResetNumbers()
        autocmd BufReadPost * :call ResetNumbers()
        autocmd FocusLost   * :call Uncenter()
        autocmd FocusGained * :call Center()
    augroup END
endfunc

function! NumbersDisable()
    let g:enable_numbers = 0
    augroup NumbersAug
        au!
    augroup END
endfunc

function! NumbersOnOff()
    if (g:enable_numbers == 1)
        call NumbersDisable()
    else
        call NumbersEnable()
    endif
endfunc

" Commands
command! -nargs=0 NumbersToggle call NumbersToggle()
command! -nargs=0 NumbersEnable call NumbersEnable()
command! -nargs=0 NumbersDisable call NumbersDisable()
command! -nargs=0 NumbersOnOff call NumbersOnOff()

" reset &cpo back to users setting
let &cpo = s:save_cpo

if (g:enable_numbers)
    call NumbersEnable()
endif
