"Using the following plugins:
"	niceblock.vim
"	surround.vim
"	commentary.vim
"	ctrlp.vim
"	lspconfig + odin language server (ols)
"
"ctrlp support

" Standard tee is no longer supplied with neovim despite nv
" being dependent on it; use rust coreutils tee instead
set shellpipe=2>&1\|\ coreutils\ tee

"cd C:/Work

set wildignore+=*.dll,*.lib,*.exe,*.pdb,*.obj,*.ilk,*.rdi,*.exp,*/game_ideas/*,*/lib/kinc/Kinc/Backends/*

set tag+=./ucrt_tags;/

"CtrlP Configuration
let g:ctrlp_root_markers = ['root.proot']

" Actually search for include files within the working directory
" set path+=~/Desktop/SDL_Program/*
set path=.
set path+=,
set path+=C:/Work/pipedream/**
set path+=C:/Program\\\ Files\\\ (x86)/Windows\\\ Kits/10/Include/10.0.26100.0/ucrt/
set path+=C:/Program\\\ Files/Microsoft\\\ Visual\\\ Studio/2022/Community/VC/Tools/MSVC/14.44.35207/include/
set path+=C:/Program\\\ Files\\\ (x86)/Windows\\\ Kits/10/Include/10.0.26100.0/um
set path+=C:/Program\\\ Files\\\ (x86)/Windows\\\ Kits/10/Include/10.0.26100.0/shared

" Prime the ripgrep function with:
" 	smartcase, numbered lines, columns,
" 	formatted for vim, and without requiring a git repository
set grepprg=rg\ -S\ -n\ --column\ --vimgrep\ --no-require-git
set grepformat=%f:%l:%c:%m

" Execute a default build script
set makeprg=build.bat

" Configure netrw file explorer
let g:netrw_liststyle=3

nnoremap <Space> <Nop>
let mapleader = " "


" Primary colorscheme: fogbell/fogbell_lite/fogbell_light
colorscheme fogbell_lite
" set guifont=Terminus\ (TTF)\ for\ Windows:h9
set guifont=Iosevka\ SS06:h12

" NOTE--In order for guicursor highlighting to work in nvimqt in Windows
" 	:hi Cursor guifg=... and guibg...,
" 	a damned REGISTRY ENTRY for ext_linegrid needs to be set to true
" 	for nvimqt, in Software\nvim-qt\nvim-qt or something like that
" 	IT ISN'T SET ON BY DEFAULT!!!
" 	Check for ext_tabline, that's the same key where this entry needs to be
" 	:hi Cursor needs to be set, and
" 	the cursor itself needs to be informed to use the correct highlight group
" 	Cursor/Cursor
"
"   https://github.com/equalsraf/neovim-qt/issues/1069
set guicursor=n-v-c-sm:block-Cursor/Cursor,i-ci-ve:ver25-Cursor/Cursor,r-cr-o:hor20-Cursor/Cursor

"  hi Cursor guifg=White guibg=#f03535 // Duller red
hi Cursor guifg=White guibg=Red

" set guifont=Iosevka\ SS06:h12
set cursorline
set nowrap
set switchbuf=useopen
set splitright
set signcolumn=yes

" Folding with syntax mode on makes editing large files (10k+ lines) VERY SLOW
" 	So forget about it...we weren't really using it anyway.
set foldmethod=manual
set foldcolumn=0
set foldnestmax=2

" Automatically unfold all folds when entering a new buffer
autocmd BufWinEnter * silent! :%foldopen!
" Automatically switch to the C syntax highlighting, should work
" for...somethings
"
set shiftwidth=0
set tabstop=4
set ignorecase
set smartcase
filetype plugin indent on

" Disable indenting inside extern C blocks
set cinoptions=E-s

" Disable curly bracket errors for compound literals
let c_no_curly_error = 1

" Paste from clipboard
nnoremap <Leader><Leader><Leader>p "+P

" Swap beginning of line jump (my preference)
nnoremap 0 _
nnoremap _ 0

" Clear search
nnoremap <Leader><Enter> :noh<Enter>:<Backspace><Esc>

" Search for Numbers, Curly brackets, and any brackets
nnoremap <Leader>w /\d\+/<Enter>
nnoremap <Leader>r /[{}]/<Enter>
nnoremap <Leader>s /["'{}()<>]/<Enter>

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
nnoremap <Leader>n :set ead=hor ea noea<Enter>:echo<Enter>

" Exit insert mode
inoremap kj<Leader> <Escape>
inoremap KJ<Leader> <Escape>

" Create gaps above or below the current line
nnoremap <Leader>j mto<Esc>`t
nnoremap <Leader>k mtO<Esc>`t
nmap <Leader>g <Leader>j<Leader>k

" Open and close the location list in various ways
nnoremap <Leader>lo :top lopen<Enter>
nmap <Leader>lvo :vert lopen<Enter><Leader>n<Leader>n
nmap <Leader>lc :lclose<Enter><Leader>n<Leader>n

" Open and close the quickfix list in various ways
nnoremap <Leader>co :top copen<Enter>
nmap <Leader>cvo :vert copen<Enter><Leader>n<Leader>n
nmap <Leader>cc :cclose<Enter><Leader>n<Leader>n

" Note and Todo shortcuts
nnoremap <Leader><Leader>c :let @t=strftime('%m-%d-%Y ')<Enter>i//NOTE(zpc <Esc>"tpi):><Right><Esc>a
nnoremap <Leader><Leader>z :let @t=strftime('%m-%d-%Y ')<Enter>i//TODO(zpc <Esc>"tpi):><Right><Esc>a
nnoremap <Leader><Leader>x :let @t=strftime('%m-%d-%Y ')<Enter>i//PERFORMANCE(zpc <Esc>"tpi):><Right><Esc>a

" Center on jumping through files
nmap <C-i> <C-i>zz
nmap <C-o> <C-o>zz
nmap <C-]> <C-]>zz

" Experiment with centering on Next/Previous
nmap n nzz
nmap N Nzz

" Search for types and function call declarations (C99)
" Note== this catches return func() too, this could be fixed
" Very nasty but works for C99 at least
" nnoremap <Leader>u :lvimgrep /\(typedef\\|\(\w\+\\|\*\)\s\(\w\+\)\((.*\))\\|}\s\+\w\+;\)/j %<Enter>
" nnoremap <Leader>i :lvimgrepadd /\(typedef\\|\(\w\+\\|\*\)\s\(\w\+\)\((.*\))\\|}\s\+\w\+;\)/j %<Enter>
nnoremap <Leader>u :silent lvimgrep /\v(typedef\|^%(.*return)@!.*\zs\w+\s+\w+\(.+\)\;\|\w+\*+\w+\(.+\)\;\|}\s+\w+;\|^%((.*if)\|(.*else\s*if))@!.*\zs\w+\*=\w+\(.+\)\s*\{\|^%(.*else\s*if)@!.*\zs\w+\s+\w+\(.+\)\s*\n+\s*\{)/j %<Enter><Enter>
" nnoremap <Leader>u :silent lvimgrepadd /\v(typedef\|^%(.*return)@!.*\zs\w+\s+\w+\(.+\)\;\|\w+\*+\w+\(.+\)\;\|}\s+\w+;\|^%((.*if)\|(.*else\s*if))@!.*\zs\w+\*=\w+\(.+\)\s*\{\|^%(.*else\s*if)@!.*\zs\w+\s+\w+\(.+\)\s*\n+\s*\{)/j %<Enter>

" Prime a search for anything in files
nnoremap <Leader>f :silent lgrep 

" Open nvim configuration file
nnoremap <Leader><Leader>i :vsplit ~/AppData/Local/nvim/init.vim<Enter>
" Reload nvim configuration file
nnoremap <Leader><Leader>l :source $MYVIMRC<Enter>
" Regenerate ctags
nnoremap <Leader><Leader>t :! ctags_regenerate.bat<Enter>

" Build Debug
" Note-- Apparently pointless :BackspaceEnter is to workaround a bug
" 	regarding the cursor color resetting to a default value
" 	which is corrected on re-entering command mode
" nnoremap <Leader><Leader>r :wa<Enter>:silent make<Enter>:<Esc>:<Backspace><Esc>
  nnoremap <Leader><Leader>r :wa<Enter>:call TryCompileAndRebuildDLL()<Enter>:<Esc>:<Backspace><Esc>
" Execute raddebugger
nnoremap <Leader><Leader>d :call jobstart('raddbg --auto_run')<Enter>
" Build and debug
" Note-- Apparently pointless :BackspaceEnter is to workaround a bug
" 	regarding the cursor color resetting to a default value
" 	which is corrected on re-entering command mode
nnoremap <Leader><Leader>e :wa<Enter>:call TryCompileAndDebug()<Enter>:<Backspace><Esc>

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

function! TryCompileAndRebuildDLL()
	silent make
	if (QfError() == 0)
		cclose
		set ead=hor ea noea
	else
		vert copen
		set ead=hor ea noea
	endif
endfunction

function! TryCompileAndDebug()
	silent make
	if (QfError() == 0)
		cclose
		set ead=hor ea noea
		call jobstart('raddbg --auto_run')
	else
		vert copen
		set ead=hor ea noea
		.cc
		normal zz
	endif
endfunction

function! QfError() abort
	let l:qf = getqflist()
	let l:retval = 0

	for l:l in l:qf
		if l.valid
			let l:retval = 1
			break
		endif
	endfor

	return l:retval
endfunction

lua vim.filetype.add({ extension = { inc = 'cpp' } })
lua vim.keymap.set( 'c', '<CR>', function() return vim.fn.getcmdtype() == '/' and '<CR>zzzv' or '<CR>' end, { expr = true } )

