-- Neovim Options Configuration
-- This file contains all the vim options and settings

local opt = vim.opt
local g = vim.g

-- Leader key (should be set before plugins)
g.mapleader = " "
g.maplocalleader = " "

opt.mouse = "a" -- Enable mouse support
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.swapfile = false -- Disable swap files
opt.completeopt = "menuone,noinsert,noselect"

-- UI/UX
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = true -- Highlight current line
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.showmode = false -- Don't show mode (handled by lualine)
opt.signcolumn = "yes" -- Always show sign column
opt.pumheight = 10 -- Maximum number of items in completion menu
opt.cmdheight = 1 -- Command line height
opt.laststatus = 3 -- Global statusline
opt.showtabline = 2 -- Always show tabline

-- Indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.softtabstop = 2 -- Number of spaces tabs count for in insert mode
opt.smartindent = true -- Smart auto-indenting
opt.autoindent = true -- Copy indent from current line
opt.shiftround = true -- Round indent to multiple of shiftwidth

-- Search
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Override ignorecase if search contains capitals
opt.incsearch = true -- Incremental search
opt.hlsearch = false -- Highlight search results

-- File handling
opt.updatetime = 300 -- Faster completion (default is 4000ms)
opt.timeoutlen = 500 -- Time to wait for mapped sequence
opt.autoread = true -- Automatically read file when changed outside
opt.hidden = true -- Allow background buffers

-- Text rendering
opt.encoding = "utf-8" -- String encoding
opt.fileencoding = "utf-8" -- File encoding
opt.scrolloff = 8 -- Lines to keep above/below cursor
opt.sidescrolloff = 8 -- Columns to keep left/right of cursor
opt.wrap = false -- Disable line wrapping
opt.linebreak = true -- Break lines at word boundaries
opt.breakindent = true -- Preserve indentation in wrapped text

-- Window management
opt.winwidth = 30 -- Minimum window width
opt.winheight = 1 -- Minimum window height
opt.equalalways = false -- Don't auto-resize windows

-- Folding
opt.foldmethod = "expr" -- Use expression for folding
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99 -- Don't fold by default
opt.foldlevelstart = 99 -- Don't fold when opening files
opt.foldenable = true -- Enable folding

-- Performance
opt.lazyredraw = false -- Don't redraw during macros (can cause issues)
opt.synmaxcol = 240 -- Max column for syntax highlight

-- Wildmenu
opt.wildmenu = true -- Enhanced command line completion
opt.wildmode = "longest:full,full" -- Command line completion mode
opt.wildignore = {
	"*.o",
	"*.obj",
	"*.dylib",
	"*.bin",
	"*.dll",
	"*.exe",
	"*/.git/*",
	"*/.svn/*",
	"*/__pycache__/*",
	"*/build/*",
	"*.jpg",
	"*.png",
	"*.jpeg",
	"*.bmp",
	"*.gif",
	"*.tiff",
	"*.svg",
	"*.ico",
	"*.pyc",
	"*.pkl",
	"*.DS_Store",
	"node_modules/*",
	"*.aux",
	"*.bbl",
	"*.blg",
	"*.brf",
	"*.fls",
	"*.fdb_latexmk",
	"*.synctex.gz",
	"*.xdv",
}

-- Shortmess
opt.shortmess:append("c") -- Don't show completion messages
opt.shortmess:append("I") -- Don't show intro message

-- Format options
opt.formatoptions:remove("cro") -- Don't auto-comment new lines

-- List characters (show whitespace)
opt.list = true
opt.listchars = {
	tab = "  ",
	trail = "·",
	nbsp = " ",
	extends = " ",
	precedes = " ",
}

-- Spell checking
opt.spell = false -- Disable spell checking by default
opt.spelllang = { "en", "fr" } -- Spell checking languages

-- Diff
opt.diffopt:append("vertical") -- Vertical diff splits

-- Session
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

-- Miscellaneous
opt.virtualedit = "block" -- Allow cursor beyond end of line in visual block mode
opt.title = true -- Set terminal title
opt.titlestring = "Neovim - %t" -- Terminal title format

-- Disable some built-in plugins
g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_matchit = 1
g.loaded_matchparen = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1

-- Platform specific settings for Windows
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
	-- Try to use Git Bash if available
	local git_bash_paths = {
		"C:\\Program Files\\Git\\bin\\bash.exe",
		"C:\\Program Files (x86)\\Git\\bin\\bash.exe",
	}

	local git_bash_found = false
	for _, path in ipairs(git_bash_paths) do
		if vim.fn.executable(path) == 1 then
			opt.shell = path
			opt.shellcmdflag = "-c"
			opt.shellredir = ">%s 2>&1"
			opt.shellpipe = "2>&1| tee"
			opt.shellquote = ""
			opt.shellxquote = ""
			git_bash_found = true
			break
		end
	end

	-- Fallback to PowerShell if Git Bash not found
	if not git_bash_found then
		opt.shell = "powershell"
		opt.shellcmdflag =
			"-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
		opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
		opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
		opt.shellquote = ""
		opt.shellxquote = ""
	end
end

-- Auto commands for options
local augroup = vim.api.nvim_create_augroup("OptionsAutoGroup", { clear = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400 })
	end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function()
		local line = vim.fn.line("'\"")
		if line > 1 and line <= vim.fn.line("$") then
			vim.cmd('normal! g`"')
		end
	end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.setpos(".", save_cursor)
	end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup,
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Auto-commands for relative line numbers
vim.api.nvim_create_autocmd("InsertEnter", {
	group = augroup,
	callback = function()
		vim.opt.relativenumber = false
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	group = augroup,
	callback = function()
		vim.opt.relativenumber = true
	end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = {
		"qf",
		"help",
		"man",
		"notify",
		"lspinfo",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"PlenaryTestPopup",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})
