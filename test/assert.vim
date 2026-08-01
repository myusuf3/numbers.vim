" Assertion helpers shared by every case in test/cases/.
"
" Results go to stdout via writefile() because Vim's silent mode (-es), which
" the runner needs in order to capture output, discards :echo.

let g:t_results = []
let g:t_failed = 0

function! Assert(desc, expected, actual) abort
    if a:expected ==# a:actual
        call add(g:t_results, '  ok   ' . a:desc)
    else
        let g:t_failed += 1
        call add(g:t_results, printf('  FAIL %s -- expected %s, got %s',
                    \ a:desc, a:expected, a:actual))
    endif
endfunction

" The plugin's entire observable behaviour is these two window options.
function! AssertNumbers(desc, nu, rnu) abort
    call Assert(a:desc, printf('nu=%d rnu=%d', a:nu, a:rnu),
                \ printf('nu=%d rnu=%d', &number, &relativenumber))
endfunction

function! Skip(desc) abort
    call add(g:t_results, '  skip ' . a:desc)
endfunction

" Round trip through insert mode, firing the real InsertEnter/InsertLeave.
function! TypeSomething() abort
    execute "normal! ia\<Esc>"
endfunction

function! TestDone() abort
    call writefile(g:t_results, '/dev/stdout', 'a')
    if g:t_failed > 0
        cquit
    endif
    qall!
endfunction
