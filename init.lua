-- zpc config

-- Leader configuration
vim.keymap.set('n', '<Space>', '<Nop>', { remap = false } )
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Standard tee is no longer supplied with neovim despite neovim
-- being dependent on it; use rust coreutils tee instead
vim.opt.shellpipe = '2>&1| coreutils tee'

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
--vim.opt.path:append('C:/Work/pipedream/**')
vim.opt.path:append('C:/Program\\ Files\\ (x86)/Windows\\ Kits/10/Include/10.0.26100.0/ucrt/')
vim.opt.path:append('C:/Program\\ Files/Microsoft\\ Visual\\ Studio/2022/Community/VC/Tools/MSVC/14.44.35207/include/')
vim.opt.path:append('C:/Program\\ Files\\ (x86)/Windows\\ Kits/10/Include/10.0.26100.0/um/')
vim.opt.path:append('C:/Program\\ Files\\ (x86)/Windows\\ Kits/10/Include/10.0.26100.0/shared/')

-- Use Ripgrep
vim.opt.grepprg = 'rg -S -n --column --vimgrep --no-require-git'
vim.opt.grepformat = '%f:%l:%c:%m'

-- Local build script
vim.opt.makeprg = 'build.bat'

-- Theme and Font
vim.cmd.colorscheme("fogbell_lite")
vim.opt.guifont = { 'Iosevka SS06:h12' }
vim.opt.guicursor = { 'n-v-c-sm:block-Cursor/Cursor,i-ci-ve:ver25-Cursor/Cursor,r-cr-o:hor20-Cursor/Cursor' }
vim.cmd.highlight( { "Cursor", "guifg=White", "guibg=Red" } )

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

-- Do not allow modifications to anything in program files
vim.api.nvim_create_autocmd( { "BufRead" }, {
	pattern = "c:/program*",
	group = "nomodreadonly",
	callback = function()
		vim.o.readonly = true
		vim.o.modifiable = false
	end,
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

function vis_noremap_bind(lhs, rhs)
	vim.keymap.set('v', lhs, rhs, { remap = false } )
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

-- Cycle the quickfix and location lists
noremap_bind('<Leader>[', ':lprev<Enter>zz')
noremap_bind('<Leader>]', ':lnext<Enter>zz')
noremap_bind('<Leader>9', ':cprev<Enter>zz')
noremap_bind('<Leader>0', ':cnext<Enter>zz')

-- Maximize and equalize buffers
noremap_bind('<Leader>m', '<C-w><Bar>')
noremap_bind('<Leader>n', equalize_buffers)

-- Cycle windows
-- Note: Due to limitations with Vim, rebinding just Tab
-- overrides CTRL-i with whatever Tab is bound to.
--
-- TODO: C-h/j/k are all empty. l is redraw screen
-- bind to some cool stuff?
noremap_bind('<S-Tab>', '<C-w>w')

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
	vim.cmd(":vsplit ~/AppData/Local/nvim/init.lua")
	equalize_buffers()
end
noremap_bind('<Leader><Leader>i', open_config_file)
noremap_bind('<Leader><Leader>l', ':luafile $MYVIMRC<Enter>')

-- Start searches for braces/numbers
noremap_bind('<Leader>w', '/\\d\\+/<Enter>')
noremap_bind('<Leader>r', '/[{}]/<Enter>')
noremap_bind('<Leader>s', '/["\'{}()<>]/<Enter>')






-- Program Build Related
--
--
-- Rebuild ctags data
noremap_bind('<Leader><Leader>t', ':! ctags_regenerate.bat<Enter>')

-- Compile and Debug

function qferror()
	local qf = vim.fn.getqflist()

	local function has_cpp_standard_error(l)
		return (l.valid ~= 0)
	end

	local function has_cpp_include_error(l)
		return (string.find(l.text, "Cannot open include file:") ~= nil)
	end

	for i, l in ipairs(qf) do
		if (has_cpp_standard_error(l)) then
			return true
		elseif (has_cpp_include_error(l)) then
			return true
		end
	end

	return false
end

function build_try_compile_and_rebuild_dll()
	vim.cmd("silent make")

	if (qferror()) then
		vim.cmd("vert copen")
		vim.cmd(".cc")
		equalize_buffers()
	else
		vim.cmd("cclose")
		equalize_buffers()
	end
end

function build_try_compile_and_debug()
	vim.cmd("silent make")

	if (qferror()) then
		vim.cmd("vert copen")
		equalize_buffers()
		vim.cmd(".cc")
		vim.cmd("normal zz")
	else
		vim.cmd("cclose")
		equalize_buffers()
		vim.cmd("call jobstart('raddbg --auto_run')")
	end
end

noremap_bind('<Leader><Leader>r', build_try_compile_and_rebuild_dll)
noremap_bind('<Leader><Leader>e', build_try_compile_and_debug)
noremap_bind('<Leader><Leader>d', ':call jobstart(\'raddbg --auto_run\')<Enter>')






-- Plugin management
-- uh oh

-- Most of this is ripped from kickstart.lua
--
-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)


function fzf_use_existing_buffer(sel, opts)
	if not require("fzf-lua").actions.file_switch({ sel[1] }, opts) then require("fzf-lua").actions.file_edit({ sel[1] }, opts) end
end

require("lazy").setup({
	spec = {

		"kana/vim-niceblock",
		"tpope/vim-surround",

		"neovim/nvim-lspconfig",

		{
			'smoka7/hop.nvim',
			version = "*",
			opts = {
				keys = 'etovxqpdygfblzhckisuran'
			}
		},

		{
			"gbprod/substitute.nvim",
			opts = {
				highlight_substituted_text = {
					enabled = false,
					timer = 0
				},
			},
		},



		-- {
		--   "ibhagwan/fzf-lua",
		--   -- optional for icon support
		--   dependencies = { "nvim-tree/nvim-web-devicons" },
		--   -- or if using mini.icons/mini.nvim
		--   -- dependencies = { "nvim-mini/mini.icons" },
		--   branch = "2413",
		--
		--   opts = {
		-- 	  defaults = 
		-- 	  {
		-- 		  file_icons = false,
		-- 		  color_icons = false,
		-- 		  multiprocess = false,
		-- 	  },
		-- 	  actions = {
		-- 		  files = {
		-- 			  true,
		-- 			  ["enter"] = fzf_use_existing_buffer
		-- 		  },
		-- 		  buffers = {
		-- 			  ["enter"] = fzf_use_existing_buffer
		-- 		  },
		-- 		  grep = {
		-- 			  ["enter"] = fzf_use_existing_buffer
		-- 		  },
		-- 	  },
		--    },
		-- },

		{
			"nvim-mini/mini.nvim", 
			version = false,
		},

		{
			"nvim-treesitter/nvim-treesitter",
			branch = "master",
			lazy = false,
			build = ":TSUpdate",
			opts = {
				ensure_installed = {
					"c",
					"cpp",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
				},
				auto_install = false,
				highlight = { enable = false },
				indent = { enable = false },
			},
		},
	
	},
	checker = { enabled = true },
})

-- Plugin Binds
--
-- hop
function justhop()
	require("hop").hint_words( { multi_windows = true } )
end

noremap_bind('s', justhop)

-- fzf-lua
-- noremap_bind('<Leader>fx', [[:lua require("fzf-lua").builtin()<CR>]])
-- noremap_bind('<Leader>fp', [[:lua require("fzf-lua").files()<CR>]])
-- noremap_bind('<Leader>fb', [[:lua require("fzf-lua").buffers()<CR>]])
-- noremap_bind('<Leader>fa', [[:lua require("fzf-lua").grep()<CR>]])
-- noremap_bind('<Leader>ft', [[:lua require("fzf-lua").treesitter()<CR>]])
-- noremap_bind('<Leader>ff', [=[:lua require("fzf-lua").treesitter()<CR>[function] ]=])
-- noremap_bind('<Leader>fs', [=[:lua require("fzf-lua").treesitter()<CR>[type] ]=])
-- require('fzf-lua').setup({ { "max-perf", "border-fused" } })

-- mini.pick / mini.extra
local mpick = require("mini.pick")

local win_config = function()
	local height = math.floor(0.618 * vim.o.lines)
	-- local width = math.floor(0.618 * vim.o.columns)
	local width = 80
	return {
	  anchor = 'NW', height = height, width = width,
	  row = math.floor(0.5 * (vim.o.lines - height)),
	  col = math.floor(0.5 * (vim.o.columns - width)),
	}
end

mpick.setup(
	{ 
		-- Disable icons in the file picker
		source = { show = mpick.default_show },
		delay = { busy = 16 },
		window = { config = win_config },
		options = { use_cache = true },
	}
)

require("mini.extra").setup({ })

local function grep_live(opts)
	local dir = vim.fn.expand("%:p:h")
	vim.print(dir)
	MiniPick.builtin.grep_live({}, { source = { cwd = dir } })
end
vim.keymap.set("n", "<Leader>fp", MiniPick.builtin.files, { remap = false })
vim.keymap.set("n", "<Leader>fb", MiniPick.builtin.buffers, { remap = false })
vim.keymap.set("n", "<Leader>fa", grep_live, { remap = false })

-- substitute
vim.keymap.set("x", "<C-p>", require("substitute").visual, { remap = false })
vim.keymap.set("x", "<C-s>", require("substitute.exchange").visual, { remap = false })

-- glaregun
vim.keymap.set("n", "<C-l>", ":lua require('degauss_loader').try_load()<CR>", { remap = false })
vim.keymap.set("n", "<Leader><C-l>", ":lua require('degauss_loader').shutdown()<CR>", { remap = false })
-- vim.cmd("hi NormalFloat guibg=#ff4400")
