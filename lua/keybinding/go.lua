local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "golg", function()
	local file = vim.fn.expand("%:t")

	-- Check if LazyGit command exists
	if vim.fn.exists(":LazyGit") == 0 then
		vim.notify("LazyGit plugin not loaded yet", vim.log.levels.WARN)
		return
	end

	vim.cmd("LazyGit")

	if file and file ~= "" then
		vim.defer_fn(function()
			-- Only try to search if we're in LazyGit
			local buf_name = vim.api.nvim_buf_get_name(0)
			if string.find(buf_name:lower(), "lazygit") then
				vim.api.nvim_feedkeys("/" .. file, "t", true)
				vim.api.nvim_input("<CR>")
				vim.api.nvim_input("<ESC>")
			end
		end, 500) -- Increased delay for Windows
	end
end, vim.tbl_extend("force", opts, { desc = "Git with file search" }))

-- Telescope bindings
map("n", "gof", "<cmd>Telescope find_files<cr>", vim.tbl_extend("force", opts, { desc = "Find files" }))
map("n", "got", "<cmd>Telescope live_grep<cr>", vim.tbl_extend("force", opts, { desc = "Grep text" }))
map("n", "goh", "<cmd>Telescope help_tags<cr>", vim.tbl_extend("force", opts, { desc = "Help tags" }))
map("n", "goo", "<cmd>Telescope oldfiles<cr>", vim.tbl_extend("force", opts, { desc = "Recent files" }))

-- Window split shortcuts
map("n", "<leader>sv", "<cmd>vsplit<cr>", vim.tbl_extend("force", opts, { desc = "Split vertical" }))
map("n", "<leader>sh", "<cmd>split<cr>", vim.tbl_extend("force", opts, { desc = "Split horizontal" }))

-- Format shortcuts
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<cr>", vim.tbl_extend("force", opts, { desc = "Format code" }))
map("v", "<leader>f", "<cmd>lua vim.lsp.buf.format()<cr>", vim.tbl_extend("force", opts, { desc = "Format selected" }))

-- LSP shortcuts
map("n", "gos", "<cmd>lua vim.lsp.buf.definition()<cr>", vim.tbl_extend("force", opts, { desc = "Definition" }))
map("n", "god", "<cmd>lua vim.lsp.buf.declaration()<cr>", vim.tbl_extend("force", opts, { desc = "Declaration" }))
map("n", "gor", "<cmd>lua vim.lsp.buf.references()<cr>", vim.tbl_extend("force", opts, { desc = "References" }))
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", vim.tbl_extend("force", opts, { desc = "Implementation" }))
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", vim.tbl_extend("force", opts, { desc = "Show hover info" }))
