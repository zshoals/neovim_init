-- zpc config



-- Lead on
vim.keymap.set('n', '<Space>', '<Nop>', { remap = false } )
vim.g.mapleader = " "
vim.g.maplocalleader = " "



-- Standard tee is no longer supplied with neovim despite neovim
-- being dependent on it; use rust coreutils tee instead
vim.opt.shellpipe = '2>&1| coreutils tee'

vim.opt.wildignore:append('*.dll')
vim.opt.wildignore:append('*.lib')
vim.opt.wildignore:append('*.exe')
vim.opt.wildignore:append('*.pdb')
vim.opt.wildignore:append('*.obj')
vim.opt.wildignore:append('*.ilk')
vim.opt.wildignore:append('*.rdi')
vim.opt.wildignore:append('*.exp')

vim.opt.tag:append('./ucrt_tags;/')

vim.opt.path = { '.' }
vim.opt.path:append(',')
vim.opt.path:append('C:/Work/pipedream/**')
vim.opt.path:append('C:/Program Files (x86)/Windows Kits/10/Include/10.0.26100.0/ucrt/')
vim.opt.path:append('C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/include/')
vim.opt.path:append('C:/Program Files (x86)/Windows Kits/10/Include/10.0.26100.0/um')
vim.opt.path:append('C:/Program Files (x86)/Windows Kits/10/Include/10.0.26100.0/shared')

-- Use Ripgrep
vim.opt.grepprg = 'rg -S -n --column --vimgrep --no-require-git'
vim.opt.grepformat = '%f:%l:%c:%m'

-- Local build script
vim.opt.makeprg = 'build.bat'



-- Theme and Font
vim.cmd.colorscheme("fogbell_lite")
vim.opt.guifont = { 'Iosevka SS06:h12' }
vim.opt.guicursor = { 'n-v-c-sm:block-Cursor/Cursor,i-ci-ve:ver25-Cursor/Cursor,r-cr-o:hor20-Cursor/Cursor' }
vim.cmd.highlight( {"Cursor", "guifg=White", "guibg=Red" } )



-- Editor preferences
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.switchbuf = { "useopen" }
vim.opt.splitright = true
vim.opt.signcolumn = "yes"
vim.opt.shiftwidth = 0
vim.opt.tabstop = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.cmd("filetype plugin indent on")



-- Split equalization (50/50 splits)
function equalize_buffers()
	vim.cmd("set ead=hor ea noea")
	vim.cmd("echo")
end
-- Actually execute split equalization on startup,
--   as buffers are not
--   initially equalized meaning this doesn't
--   normalize splits the first time it is used
equalize_buffers()



-- Disable all folding
vim.opt.foldmethod = "manual"
vim.opt.foldcolumn = "0"
vim.opt.foldnestmax = 2
vim.api.nvim_create_autocmd( {"BufWinEnter"}, {
	pattern = { "*" },
	command = "silent! :%foldopen!",
})



-- Do not allow modifications to read only buffers
local no_mod_when_readonly = vim.api.nvim_create_augroup('nomodreadonly', { clear = true })
vim.api.nvim_create_autocmd( {"BufRead" }, {
	pattern = "*",
	group = "nomodreadonly",
	command = "let &l:modifiable = !&readonly",
})




-- Disable indenting inside extern C blocks
vim.opt.cinoptions = { "E-s" }
-- Disable curly bracket errors for compound literals
vim.g.c_no_curly_error = 1

vim.g.netrw_liststyle = 3
vim.filetype.add({ extension = { inc = 'cpp' } })




-- Bindings
function noremap_bind(lhs, rhs)
	vim.keymap.set('n', lhs, rhs, { remap = false } )
end

function norm_bind(lhs, rhs)
	vim.keymap.set('n', lhs, rhs, { remap = true } )
end

function ins_noremap_bind(lhs, rhs)
	vim.keymap.set('i', lhs, rhs, { remap = false } )
end

-- Exit insert mode
ins_noremap_bind('kj<Leader>', '<Escape>')
ins_noremap_bind('KJ<Leader>', '<Escape>')

-- Paste from clipboard
noremap_bind('<Leader><Leader><Leader>p', '"+P')

-- Swap first word and true start of line keys
noremap_bind('0', '_')
noremap_bind('_', '0')

--Clear highlighting
noremap_bind('<Leader><Enter>', ':noh<Enter>:<Backspace><Esc>')

--vim.keymap.set('n', '<Leader>w', '/\d\+/<Enter>', { noremap = true } )
--vim.keymap.set('n', '<Leader>r', '/[{}]/<Enter>', { noremap = true } )
--vim.keymap.set('n', '<Leader>s', '/["\'{}()<>]/<Enter>', { noremap = true } )

-- Cycle the quickfix and location lists
noremap_bind('<Leader>[', ':lprev<Enter>zz')
noremap_bind('<Leader>]', ':lnext<Enter>zz')
noremap_bind('<Leader>9', ':cprev<Enter>zz')
noremap_bind('<Leader>0', ':cnext<Enter>zz')

-- Maximize and equalize buffers
noremap_bind('<Leader>m', '<C-w><Bar>')
noremap_bind('<Leader>n', equalize_buffers)

-- Create gaps above and below lines
noremap_bind('<Leader>j', 'mto<Esc>`t')
noremap_bind('<Leader>k', 'mtO<Esc>`t')
norm_bind('<Leader>g', '<Leader>j<Leader>k')

-- Open/Close Location List
function ll_open_top()
	vim.cmd("top lopen")
	equalize_buffers()
end

function ll_open()
	vim.cmd("vert lopen")
	equalize_buffers()
end

function ll_close()
	vim.cmd("lclose")
	equalize_buffers()
end

noremap_bind('<Leader>lo', ll_open_top)
noremap_bind('<Leader>lvo', ll_open)
noremap_bind('<Leader>lc', ll_close)

-- Open/Close Quickfix List
function qf_open_top()
	vim.cmd("top copen")
	equalize_buffers()
end

function qf_open()
	vim.cmd("vert copen")
	equalize_buffers()
end

function qf_close()
	vim.cmd("cclose")
	equalize_buffers()
end

noremap_bind('<Leader>co', qf_open_top)
noremap_bind('<Leader>cvo', qf_open)
noremap_bind('<Leader>cc', qf_close)

-- Fast Todo/Performance/Note comments
noremap_bind('<Leader><Leader>c', ':let @t=strftime(\'%m-%d-%Y \')<Enter>i//NOTE(zpc <Esc>"tpi):><Right><Esc>a')
noremap_bind('<Leader><Leader>z', ':let @t=strftime(\'%m-%d-%Y \')<Enter>i//TODO(zpc <Esc>"tpi):><Right><Esc>a')
noremap_bind('<Leader><Leader>x', ':let @t=strftime(\'%m-%d-%Y \')<Enter>i//PERFORMANCE(zpc <Esc>"tpi):><Right><Esc>a')

-- Center screen on jumping through files
norm_bind('<C-i>', '<C-i>zz')
norm_bind('<C-o>', '<C-o>zz')
norm_bind('<C-]>', '<C-]>zz')

-- Center screen on search
norm_bind('n', 'nzz')
norm_bind('N', 'Nzz')

-- Fast grep
noremap_bind('<Leader>f', ':silent lgrep ')

-- Open and reload source files
noremap_bind('<Leader><Leader>i', ':vsplit ~/AppData/Local/nvim/init.lua<Enter>')
noremap_bind('<Leader><Leader>l', ':source $MYVIMRC<Enter>')
-- This forces searches to immediately jump and center on the search target
vim.keymap.set('c', '<CR>', function() return vim.fn.getcmdtype() == '/' and '<CR>zzzv' or '<CR>' end, { expr = true } )




-- Program Build Related
--
--
-- Rebuild ctags data
noremap_bind('<Leader><Leader>t', ':! ctags_regenerate.bat<Enter>')

-- Compile and Debug
function qferror()
	local qf = vim.fn.getqflist()
	local error = false

	for i, l in ipairs(qf) do
		if (l.valid ~= 0) then
			error = true
			return retval
		end
	end

	return retval
end

function build_try_compile_and_rebuild_dll()
	vim.cmd("silent make")

	if (qferror()) then
		vim.cmd("vert copen")
		vim.cmd("set ead=hor ea noea")
	else
		vim.cmd("cclose")
		vim.cmd("set ead=hor ea noea")
	end
end

function build_try_compile_and_debug()
	vim.cmd("silent make")

	if (qferror()) then
		vim.cmd("vert copen")
		vim.cmd("set ead=hor ea noea")
		vim.cmd(".cc")
		vim.cmd("normal zz")
	else
		vim.cmd("cclose")
		vim.cmd("set ead=hor ea noea")
		vim.cmd("call jobstart('raddbg --auto_run')")
	end
end

noremap_bind('<Leader><Leader>r', build_try_compile_and_rebuild_dll)
noremap_bind('<Leader><Leader>e', build_try_compile_and_debug)
noremap_bind('<Leader><Leader>d', ':call jobstart(\'raddbg --auto_run\')<Enter>')


