"Using the following plugins:
"	niceblock.vim
"	surround.vim
"	commentary.vim
"	ctrlp.vim
"
"ctrlp support
set runtimepath^=~/AppData/local/nvim/extension/ctrlp.vim
set wildignore+=*.dll,*.lib,*.exe,*.pdb,*.obj,*.ilk

set tag+=./ucrt_tags;/

" Actually search for include files within the working directory
set path+=~/Desktop/SDL_Program/*

" Prime the ripgrep function with:
" 	smartcase, numbered lines, columns,
" 	formatted for vim, and without requiring a git repository
set grepprg=rg\ -S\ -n\ --column\ --vimgrep\ --no-require-git
set grepformat=%f:%l:%c:%m

" Execute a default build script
set makeprg=build_debug.bat

nnoremap <Space> <Nop>
let mapleader = " "

" Primary colorscheme: fogbell/fogbell_lite/fogbell_light
colorscheme fogbell_lite
set cursorline
set nowrap
set switchbuf=useopen
set splitright
" Folding with syntax mode on makes editing large files (10k+ lines) VERY SLOW
" 	So forget about it...we weren't really using it anyway.
set foldmethod=manual
set foldcolumn=0
set foldnestmax=2
" Automatically unfold all folds when entering a new buffer
autocmd BufWinEnter * silent! :%foldopen!
set shiftwidth=0
set tabstop=4
set ignorecase
set smartcase
filetype plugin indent on

" Autocompile on write
" NOTE--It may be better just to manually trigger this...how does it function
" 	if we write to multiple buffers?
" autocmd BufWritePost *.c,*.h :silent make


" Dump header API to quicklist on buffer open
" Maybe this should just be done manually too :/
" augroup WriteAPIOnHeaderEnter
"     autocmd!
"     autocmd BufEnter *.h keepjumps lvimgrep /\(SDLCALL\|typedef\)/j%
" augroup END

" Disable indenting inside extern C blocks
set cinoptions=E-s

" Swap beginning of line jump
nnoremap 0 _
nnoremap _ 0
" Clear search
nnoremap <Leader><Enter> :noh<Enter>
" Cycle through the location list
nnoremap <Leader>[ :lprev<Enter>zz
nnoremap <Leader>] :lnext<Enter>zz
"Cycle through the quickfix list
nnoremap <Leader>9 :cprev<Enter>zz
nnoremap <Leader>0 :cnext<Enter>zz
" Open a tag or file in a vertical split
nnoremap <C-W><C-V>f :exec "vert norm <C-V><C-W>f"<CR>
nnoremap <C-W><C-V>[ :exec "vert norm <C-V><C-W>["<CR>
" Maximize buffer
nnoremap <Leader>m <C-w><Bar>
" Equalize buffers
" nnoremap <Leader>n <C-w>=  -----Equalizes horizontally and vertically
nnoremap <Leader>n :set ead=hor ea noea<Enter>
" Exit insert mode
inoremap kj<Leader> <Escape>
" Create gaps above or below the current line
nnoremap <Leader>j mto<Esc>`t
nnoremap <Leader>k mtO<Esc>`t
nmap <Leader>g <Leader>j<Leader>k
" Open and close the location list in various ways
nnoremap <Leader>lo :above lopen<Enter>
nmap <Leader>lvo :vert lopen<Enter><Leader>n<Leader>n
nmap <Leader>lc :lclose<Enter><Leader>n<Leader>n
" Open and close the quickfix list in various ways
nnoremap <Leader>co :above copen<Enter>
nmap <Leader>cvo :vert copen<Enter><Leader>n<Leader>n
nmap <Leader>cc :cclose<Enter><Leader>n<Leader>n

" Create matching brackets
" These are kind of annoying in practice
" inoremap \" \"\"<left>
" inoremap ' ''<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>

" Search for types and function call declarations
" Note== this catches return func() too, this could be fixed
" Very nasty but works for C99 at least
nnoremap <Leader>u :lvimgrep /\(typedef\\|\(\w\+\)\s\(\w\+\)\((.*\));\\|}\s\+\w\+;\)/j %<Enter>
nnoremap <Leader>i :lvimgrepadd /\(typedef\\|\(\w\+\)\s\(\w\+\)\((.*\));\\|}\s\+\w\+;\)/j %<Enter>
" nnoremap <Leader>i :lvimgrepadd /\(typedef\\|\(\w\+\)\s\(\w\+\)\((.*\));\\|}.\+;\)/j %<Enter>
" nnoremap <Leader>u :lvimgrep /\(SDLCALL\\|typedef\)/j %<Enter> :above lopen<Enter> <C-w>j

" Prime a search for anything in files
nnoremap <Leader>f :silent lgrep 

" Open nvim configuration file
nnoremap <Leader><Leader>i :vsplit ~/AppData/Local/nvim/init.vim<Enter>
" Regenerate ctags
nnoremap <Leader><Leader>t :! ctags_regenerate.bat<Enter>
" Build Debug
nnoremap <Leader><Leader>r :silent make<Enter>

" Don't permit readonly buffers to be modified
augroup NoModWhenReadOnly
    autocmd!
    autocmd BufRead * let &l:modifiable = !&readonly
augroup END

" Jump to a file whose extension corresponds to the extension of the current
" file. The `tags' file, created with:
" $ ctags --extra=+f -R .
" has to be present in the current directory.
function! JumpToCorrespondingFile()
    let l:extensions = { 'c': 'h', 'h': 'c', 'cpp': 'hpp', 'hpp': 'cpp', 'cc': 'hh', 'hh': 'cc' }
    let l:fe = expand('%:e')
    if has_key(l:extensions, l:fe)
        execute ':tag ' . expand('%:t:r') . '.' . l:extensions[l:fe]
    else
        call SwapExtPrintError(">>> Corresponding extension for '" . l:fe . "' is not specified") 
    endif
endfunct

" jump to a file with the corresponding extension (<C-F2> aka <S-F14>)
nnoremap <Leader>o :call JumpToCorrespondingFile()<CR>

" Print error message.
function! SwapExtPrintError(msg) abort
    execute 'normal! \<Esc>'
    echohl ErrorMsg
    echomsg a:msg
    echohl None
endfunction
