-- zpc config (Linux)
vim.opt.grepprg = 'rg --vimgrep'

-- Leader configuration
vim.keymap.set('n', '<Space>', '<Nop>', { remap = false } )
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.shada = ''

-- Filetypes to exclude from searches
vim.opt.wildignore:append('*.dll')
vim.opt.wildignore:append('*.lib')
vim.opt.wildignore:append('*.exe')
vim.opt.wildignore:append('*.pdb')
vim.opt.wildignore:append('*.obj')
vim.opt.wildignore:append('*.ilk')
vim.opt.wildignore:append('*.rdi')
vim.opt.wildignore:append('*.exp')

-- Additional tags file to search, 
-- ucrt tags contains the msvc headers
vim.opt.tag:append('./ucrt_tags;/')

-- Path configuration for navigating headers and sources
vim.opt.path = { '.' }
vim.opt.path:append(',')

-- Use Ripgrep
-- vim.opt.grepprg = 'rg -S -n --column --vimgrep --no-require-git'
-- vim.opt.grepformat = '%f:%l:%c:%m'

-- Theme and Font
vim.cmd.colorscheme("fogbell_lite")
vim.opt.termguicolors = true
-- vim.opt.guifont = { 'Iosevka SS06:h12' }
vim.opt.guicursor = { 'n-v-c-sm:block-Cursor/Cursor,i-ci-ve:ver25-Cursor/Cursor,r-cr-o:hor20-Cursor/Cursor' }
vim.cmd.highlight( { "Cursor", "guifg=White", "guibg=Red" } )
vim.opt.guicursor:remove { 't:block-blinkon500-blinkoff500-TermCursor' }

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
vim.opt.iskeyword:remove( { "_" } )

-- Split equalization (50/50 splits)
function equalize_buffers()
	vim.cmd("set ead=hor noea ea")
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
local no_fold_group = vim.api.nvim_create_augroup('nofoldingever', { clear = true })
vim.api.nvim_create_autocmd( {"BufWinEnter"}, {
	pattern = { "*" },
	group = "nofoldingever",
	command = "silent! :%foldopen!",
})

-- Do not allow modifications to read only buffers
local no_mod_when_readonly = vim.api.nvim_create_augroup('nomodreadonly', { clear = true })
vim.api.nvim_create_autocmd( { "BufRead" }, {
	pattern = "*",
	group = "nomodreadonly",
	command = "let &l:modifiable = !&readonly",
})

-- Do not allow modifications to target paths
function block_path_modifications(path)
		vim.api.nvim_create_autocmd( { "BufRead" }, {
		pattern = path,
		group = "nomodreadonly",
		callback = function()
			vim.o.readonly = true
			vim.o.modifiable = false
		end,
	})
end

block_path_modifications("/home/zpc/containers/devbox/Odin/core/*")

-- Disable indenting inside extern C blocks
vim.opt.cinoptions = { "E-s" }
-- Disable curly bracket errors for compound literals
vim.g.c_no_curly_error = 1


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

function vis_noremap_bind(lhs, rhs)
	vim.keymap.set('v', lhs, rhs, { remap = false } )
end

function vis_bind(lhs, rhs)
	vim.keymap.set('v', lhs, rhs, { remap = true } )
end


-- Exit insert mode
ins_noremap_bind('kj<Leader>', '<Escape>')
ins_noremap_bind('KJ<Leader>', '<Escape>')

-- Copy to clipboard
vis_noremap_bind('<Leader><Leader><Leader>y', '"+y')
-- Paste from clipboard
noremap_bind('<Leader><Leader><Leader>p', '"+P')

-- Swap first word and true start of line keys
noremap_bind('0', '_')
noremap_bind('_', '0')

--Clear highlighting
noremap_bind('<Leader><Leader><Enter>', ':noh<Enter>:<Backspace><Esc>')

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
noremap_bind('<C-i>', '<C-i>zz')
noremap_bind('<C-o>', '<C-o>zz')
noremap_bind('<C-]>', '<C-]>zz')

-- Center screen on search
norm_bind('n', 'nzz')
norm_bind('N', 'Nzz')

-- This forces searches to immediately jump and center on the search target
vim.keymap.set('c', '<CR>', function() return vim.fn.getcmdtype() == '/' and '<CR>zzzv' or '<CR>' end, { expr = true } )

-- Fast grep
-- Invalidated by fzf-lua? Experiment without it for awhile
-- noremap_bind('<Leader>f', ':silent lgrep ')

-- Open and reload source files
function open_config_file()
	vim.cmd(":vsplit ~/.config/nvim/init.lua")
	equalize_buffers()
end
noremap_bind('<Leader><Leader>i', open_config_file)
noremap_bind('<Leader><Leader>l', ':luafile $MYVIMRC<Enter>')

-- Start searches for braces/numbers
noremap_bind('<Leader>w', '/\\d\\+/<Enter>')
noremap_bind('<Leader>r', '/[{}]/<Enter>')
noremap_bind('<Leader>s', '/["\'{}()<>]/<Enter>')



-- Note(ZPC): Plugins
-- Using without configuration:
--       Surround
--       Commentary
--       Niceblock

-- Note(ZPC): Hop Configuration
local hop = require('hop')
hop.setup({})
noremap_bind('<Leader><Enter>', function() hop.hint_words({ multi_windows = true}) end)
vis_noremap_bind('<Leader><Enter>', function() hop.hint_words({ multi_windows = true}) end)

-- Note(ZPC): fzf-lua Configuration
local fzf = require('fzf-lua')

function fzf_use_existing_buffer(sel, opts)
	if not require("fzf-lua").actions.file_switch({ sel[1] }, opts) then require("fzf-lua").actions.file_edit({ sel[1] }, opts) end
end

fzf.setup({
	defaults = {
		file_icons = false,
		color_icons = false,
	},
	actions = {
		files = {
			true,
			["enter"] = fzf_use_existing_buffer
		},
		buffers = {
			["enter"] = fzf_use_existing_buffer
		},
		grep = {
			["enter"] = fzf_use_existing_buffer
		},
	},
	fzf_colors = { false }
})

noremap_bind('<Leader>fx', [[:lua require("fzf-lua").builtin()<CR>]])
noremap_bind('<Leader>fp', [[:lua require("fzf-lua").files()<CR>]])
noremap_bind('<Leader>fb', [[:lua require("fzf-lua").buffers()<CR>]])
noremap_bind('<Leader>fa', [[:lua require("fzf-lua").grep()<CR>]])

-- Note(ZPC): Mini Configuration
-- Mini.operators for text swap (gx)
require('mini.operators').setup({
	-- Clear these prefixes as they conflict with Neovim LSP defaults
	-- and we are not using these operators anyway at present
	sort = {
		prefix = '',
	},
	replace = {
		prefix = '',
	},
})
vis_bind('<Leader>s', 'gx')

require('mini.splitjoin').setup({})
require('mini.align').setup({})
vis_bind('ga', 'gA')




-- Note(ZPC): LSP configurations
vim.lsp.config['odin'] = {
	cmd = { 'ols' },
	filetypes = { 'odin' },
	root_markers = { '.git' },
}
vim.lsp.enable('odin')

vim.diagnostic.config({
	virtual_text = false,
	signs = false,
	underline = false,
	virtual_lines = false,
	virtual_text = false,
})




-- Source a local nvim_project.lua that provides build commands and anything needed by
-- the specific project, like errorformats
if (vim.uv.fs_stat("nvim_project.lua") ~= nil) then
	vim.cmd("luafile nvim_project.lua")
	vim.cmd("echo('Found nvim_project.lua; loaded nvim_project extensions.')")
end

