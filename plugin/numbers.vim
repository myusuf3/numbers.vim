""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File:           numbers.vim
" Maintainer:     Mahdi Yusuf yusuf.mahdi@gmail.com
" Version:        0.4.0
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

let s:numbers_version = '0.4.0'

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

" Always set up auto command group so that s:mode and s:center are up to date.
augroup NumbersAug
    au!
    autocmd InsertEnter * :call s:set_number()
    autocmd InsertLeave * :call s:set_relativenumber()
    autocmd BufNewFile  * :call s:reset()
    autocmd BufReadPost * :call s:reset()
    autocmd FocusLost   * :call s:unset_center()
    autocmd FocusGained * :call s:set_center()
    autocmd WinEnter    * :call s:set_relativenumber()
    autocmd WinLeave    * :call s:set_number()
augroup END

function! s:relative_off()
    if v:version > 703 || (v:version == 703 && has('patch1115'))
        set norelativenumber
    else
        set number
    endif
endfunction

function! s:reset()
    if g:enable_numbers
        if(s:center == 0)
            call s:relative_off()
        elseif(s:mode == 0)
            set relativenumber
        else
            call s:relative_off()
        endif
    endif
endfunc

function! s:set_number()
    let s:mode = 1
    call s:reset()
endfunc

function! s:set_relativenumber()
    let s:mode = 0
    call s:reset()
endfunc

function! s:set_center()
    let s:center = 1
    call s:reset()
endfunc

function! s:unset_center()
    let s:center = 0
    call s:reset()
endfunc

function! NumbersToggle()
    " Toggle s:mode between 0 and 1
    let s:mode = (s:mode + 1) % 2

    " Use s:reset to do the work.
    call s:reset()
endfunc

function! NumbersEnable()
    let g:enable_numbers = 1

    " Remember the user's settings for nu and rnu so we can reset it later
    let s:old_number = &number
    let s:old_relativenumber = &relativenumber
endfunc

function! NumbersDisable()
    let g:enable_numbers = 0

    " Reset nu and rnu to what it was before NumbersEnable was called.
    let &number = s:old_number
    let &relativenumber = s:old_relativenumber
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
