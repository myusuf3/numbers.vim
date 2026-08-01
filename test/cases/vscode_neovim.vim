" SETUP: let g:vscode = 1
" Regression test for issue #76: under the vscode-neovim extension, toggling
" the numbers moved the cursor several columns right on entering insert mode.
" VSCode renders its own gutter, so the plugin stays out of the way entirely.
source <sfile>:h/../assert.vim

edit /tmp/numbers-test-a.txt

call Assert('#76 the plugin does not load under vscode-neovim',
            \ 'loaded=0', 'loaded=' . exists('g:loaded_numbers'))
call AssertNumbers('#76 the gutter is left exactly as VSCode set it', 0, 0)

doautocmd InsertEnter
call AssertNumbers('#76 entering insert mode changes nothing', 0, 0)
doautocmd InsertLeave
call AssertNumbers('#76 leaving insert mode changes nothing', 0, 0)

call TestDone()
