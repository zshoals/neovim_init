"Using the following plugins:
"	niceblock.vim
"	surround.vim
"	commentary.vim
"	ctrlp.vim
"
"ctrlp support
set runtimepath^=~/Desktop/Programs/nvim-win64/extension/ctrlp.vim
set wildignore+=*.dll,*.lib,*.exe,*.pdb,*.obj,*.ilk

nnoremap <Space> <Nop>
let mapleader = " "

" Primary colorscheme: fogbell/fogbell_lite/fogbell_light
colorscheme fogbell_lite
set cursorline
set nowrap
set switchbuf=useopen
set splitright
set foldmethod=syntax
set foldcolumn=0
set foldnestmax=2
" Automatically unfold all folds when entering a new buffer
autocmd BufWinEnter * silent! :%foldopen!
set shiftwidth=4
set ignorecase
set smartcase
filetype plugin indent on

" Autocompile on write
" Don't use this thing, just make a real filewatcher :/
" If you decide to use this thing again, replace QUOTEHERE with actual quotes
" these were removed because they were messing up the commented out code
"vsplit termoutput
"autocmd BufWritePost *.c,*.h :execute <QUOTEHERE>normal :vert sb termoutput\<Enter>A\<Esc> :silent r! build_debug.bat\<Enter><QUOTEHERE>


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
" Cycle through the location/quickfix list
nnoremap <Leader>[ :lprev<Enter>zz
nnoremap <Leader>] :lnext<Enter>zz
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
nnoremap <Leader>k mtO<Esc>`tzz
nmap <Leader>g <Leader>j<Leader>k

" Create matching brackets
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>

" Search for types and function call declarations
" Note== this catches return func() too, this could be fixed
" Very nasty but works for C99 at least
nnoremap <Leader>u :lvimgrep /\(typedef\\|\(\w\+\)\s\(\w\+\)\((.*\));\\|}\s\+\w\+;\)/j %<Enter>
nnoremap <Leader>i :lvimgrepadd /\(typedef\\|\(\w\+\)\s\(\w\+\)\((.*\));\\|}\s\+\w\+;\)/j %<Enter>

" nnoremap <Leader>i :lvimgrepadd /\(typedef\\|\(\w\+\)\s\(\w\+\)\((.*\));\\|}.\+;\)/j %<Enter>
" nnoremap <Leader>u :lvimgrep /\(SDLCALL\\|typedef\)/j %<Enter> :above lopen<Enter> <C-w>j

" Open nvim configuration file
nnoremap <Leader><Leader>i :vsplit ~/AppData/Local/nvim/init.vim<Enter>

" Don't permit readonly buffers to be modified
augroup NoModWhenReadOnly
    autocmd!
    autocmd BufRead * let &l:modifiable = !&readonly
augroup END

