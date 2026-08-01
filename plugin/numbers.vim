""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File:           numbers.vim
" Maintainer:     Mahdi Yusuf yusuf.mahdi@gmail.com
" Version:        0.7.0
" Description:    vim global plugin for better line numbers.
" Last Change:    1 August, 2026
" License:        MIT License
" Location:       plugin/numbers.vim
" Website:        https://github.com/myusuf3/numbers.vim
"
" See numbers.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help numbers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:numbers_version = '0.7.0'

if exists("g:loaded_numbers") && g:loaded_numbers
    finish
endif

" Under vscode-neovim the gutter belongs to VSCode, which draws its own line
" numbers. Switching them here changes nothing on screen and shifts the
" extension's cursor position, so there is nothing worth doing.
if exists('g:vscode')
    finish
endif

let g:loaded_numbers = 1

if (!exists('g:enable_numbers'))
    let g:enable_numbers = 1
endif

if (!exists('g:numbers_exclude'))
    let g:numbers_exclude = ['unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m', 'nerdtree', 'Mundo', 'MundoDiff', 'buffergator', 'easybuffer']
endif

" Every non-empty 'buftype' in Vim and Neovim: these buffers are number-free by
" default, and plugins that use them often leave 'filetype' empty, which puts
" them out of reach of g:numbers_exclude.
if (!exists('g:numbers_exclude_buftypes'))
    let g:numbers_exclude_buftypes = ['acwrite', 'help', 'nofile', 'nowrite', 'popup', 'prompt', 'quickfix', 'terminal']
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

" Vim 7.3 before patch 1115 treats 'number' and 'relativenumber' as mutually
" exclusive, so showing both at once is only possible after that.
function! s:HasHybrid()
    return has('nvim') || v:version > 703 || (v:version == 703 && has('patch1115'))
endfunction

function! NumbersRelativeOff()
    if has('nvim')
        set norelativenumber
        set number
    elseif v:version > 703 || (v:version == 703 && has('patch1115'))
        set norelativenumber
    else
        set number
    endif
endfunction

function! SetNumbers()
    let s:mode = 1
    call ResetNumbers()
endfunc

function! SetRelative()
    let s:mode = 0
    call ResetNumbers()
endfunc

" i_CTRL-O runs a single command in normal mode, firing InsertLeave and
" InsertEnter around it. Switching for that round trip flips the numbers twice
" while the user never really left insert mode. mode() reports the pending
" state as niI, niR or niV; older Vims report neither and keep the old
" behaviour.
function! LeaveInsert()
    if mode(1) =~# '^ni'
        return
    endif
    call SetRelative()
endfunc

" Branch on the live option, not s:mode: the cached mode disagrees with the
" gutter whenever the plugin never enabled itself (g:enable_numbers = 0).
function! NumbersToggle()
    if (&relativenumber)
        let s:mode = 1
        call NumbersRelativeOff()
    else
        let s:mode = 0
        set relativenumber
    endif
endfunc

function! ResetNumbers()
    if(s:center == 0)
        call NumbersRelativeOff()
    elseif(s:mode == 0)
        " Undo the setlocal nonumber below for a window that is no longer
        " excluded. Taken from the global value so that a user who turned
        " numbers off themselves is not overridden.
        if s:HasHybrid() && &g:number
            setlocal number
        endif
        set relativenumber
    else
        call NumbersRelativeOff()
    end
    if index(g:numbers_exclude, &ft) >= 0 || index(g:numbers_exclude_buftypes, &bt) >= 0
        setlocal norelativenumber
        setlocal nonumber
    endif
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
    set relativenumber
    set number
    augroup enable
        au!
        autocmd InsertEnter * :call SetNumbers()
        autocmd InsertLeave * :call LeaveInsert()
        autocmd BufNewFile  * :call ResetNumbers()
        autocmd BufReadPost * :call ResetNumbers()
        " Plugin windows often set 'filetype' after BufNewFile has already
        " fired, so re-check the exclude list once it is actually set.
        autocmd FileType    * :call ResetNumbers()
        autocmd FocusLost   * :call Uncenter()
        autocmd FocusGained * :call Center()
        autocmd WinEnter    * :call SetRelative()
        autocmd WinLeave    * :call SetNumbers()
        " Ex commands address absolute lines, so :14y should be able to read
        " line 14 off the gutter. Only the : command line: searches take no
        " line numbers, and switching for them would just be flicker. The
        " redraw is needed because opening the command line does not cause one.
        if exists('##CmdlineEnter')
            autocmd CmdlineEnter : :call SetNumbers() | redraw
            autocmd CmdlineLeave : :call SetRelative()
        endif
        " Opening a terminal enters no window, so nothing above fires and the
        " numbers linger until it is left and re-entered. Vim and Neovim spell
        " the event differently.
        if exists('##TerminalOpen')
            autocmd TerminalOpen * :call ResetNumbers()
        endif
        if exists('##TermOpen')
            autocmd TermOpen * :call ResetNumbers()
        endif
    augroup END
endfunc

function! NumbersDisable()
    let g:enable_numbers = 0
    set norelativenumber
    set number
    augroup enable
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
