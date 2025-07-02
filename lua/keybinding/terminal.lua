-- Terminal keybindings and setup

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Toggle terminal with Windows-specific shell (Git Bash)
local terminal_cmd = "terminal"
if vim.fn.has("win32") == 1 then
	-- Try to find Git Bash in common locations
	local git_bash_paths = {
		"C:\\Program Files\\Git\\bin\\bash.exe",
		"C:\\Program Files (x86)\\Git\\bin\\bash.exe",
		"bash.exe", -- If it's in PATH
	}

	local git_bash_path = nil
	for _, path in ipairs(git_bash_paths) do
		if vim.fn.executable(path) == 1 then
			git_bash_path = path
			break
		end
	end

	if git_bash_path then
		terminal_cmd = "terminal " .. git_bash_path
	else
		-- Fallback to cmd if Git Bash not found
		terminal_cmd = "terminal cmd"
		vim.notify("Git Bash not found, using cmd as fallback", vim.log.levels.WARN)
	end
end

map("n", "<leader>tt", "<cmd>" .. terminal_cmd .. "<cr>", vim.tbl_extend("force", opts, { desc = "Open terminal" }))
map(
	"n",
	"<leader>tv",
	"<cmd>vsplit | " .. terminal_cmd .. "<cr>",
	vim.tbl_extend("force", opts, { desc = "Open terminal vertical" })
)
map(
	"n",
	"<leader>th",
	"<cmd>split | " .. terminal_cmd .. "<cr>",
	vim.tbl_extend("force", opts, { desc = "Open terminal horizontal" })
)

-- Terminal mode mappings
map("t", "<Esc>", "<C-\\><C-n>", vim.tbl_extend("force", opts, { desc = "Exit terminal mode" }))
map("t", "<C-h>", "<C-\\><C-n><C-w>h", vim.tbl_extend("force", opts, { desc = "Move left from terminal" }))
map("t", "<C-j>", "<C-\\><C-n><C-w>j", vim.tbl_extend("force", opts, { desc = "Move down from terminal" }))
map("t", "<C-k>", "<C-\\><C-n><C-w>k", vim.tbl_extend("force", opts, { desc = "Move up from terminal" }))
map("t", "<C-l>", "<C-\\><C-n><C-w>l", vim.tbl_extend("force", opts, { desc = "Move right from terminal" }))

-- Auto-commands for terminal
local augroup = vim.api.nvim_create_augroup("TerminalAutoGroup", { clear = true })

-- Start terminal in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
		vim.cmd("startinsert")
	end,
})

-- Return to insert mode when entering terminal buffer
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	pattern = "term://*",
	callback = function()
		vim.cmd("startinsert")
	end,
})
