local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("i", "<Tab>", function()
	local copilot = require("copilot.suggestion")
	if copilot.is_visible() then
		copilot.accept()
		return ""
	else
		return "<Tab>"
	end
end, { expr = true, silent = true, desc = "Accept Copilot suggestion or Tab" })

map("i", "<C-l>", function()
	local copilot = require("copilot.suggestion")
	if copilot.is_visible() then
		copilot.accept_word()
	else
		vim.notify("No Copilot suggestion available", vim.log.levels.INFO)
	end
end, vim.tbl_extend("force", opts, { desc = "Accept Copilot next word" }))

map("i", "<C-o>", function()
	local copilot = require("copilot.suggestion")
	if copilot.is_visible() then
		copilot.accept_line()
	else
		vim.notify("No Copilot suggestion available", vim.log.levels.INFO)
	end
end, vim.tbl_extend("force", opts, { desc = "Accept Copilot line by line" }))

map("i", "<C-j>", function()
	local copilot = require("copilot.suggestion")
	copilot.prev()
end, vim.tbl_extend("force", opts, { desc = "Previous Copilot suggestion" }))

map("i", "<C-k>", function()
	local copilot = require("copilot.suggestion")
	copilot.next()
end, { expr = true, silent = true, desc = "Next Copilot suggestion" })

-- uz: Dismiss suggestion
map("i", "<C-z>", function()
	local copilot = require("copilot.suggestion")
	copilot.dismiss()
end, vim.tbl_extend("force", opts, { desc = "Dismiss Copilot suggestion" }))

map(
	"n",
	"<leader>U",
	":CodeCompanionChat Toggle<CR>",
	vim.tbl_extend("force", opts, { desc = "Open CodeCompanion Chat" })
)

map(
	"v",
	"<leader>U",
	":CodeCompanionChat Toggle<CR>",
	vim.tbl_extend("force", opts, { desc = "Open CodeCompanion Chat with selection" })
)

map(
	"n",
	"<leader>u",
	":CodeCompanion Actions<CR>",
	vim.tbl_extend("force", opts, { desc = "CodeCompanion inline actions" })
)

map(
	"v",
	"<leader>u",
	":CodeCompanion Actions<CR>",
	vim.tbl_extend("force", opts, { desc = "CodeCompanion inline actions with selection" })
)
