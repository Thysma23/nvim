local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader> ", function()
	vim.lsp.buf.code_action()
end, vim.tbl_extend("force", opts, { desc = "Get code actions" }))

vim.keymap.set("n", "<leader>o", function()
	vim.lsp.buf.code_action({
		filter = function(action)
			return action.kind and action.kind:match("source.organizeImports")
		end,
		apply = true,
	})
end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
