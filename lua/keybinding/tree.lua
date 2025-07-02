local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- toggle tree
map("n", "<leader>n", "<cmd>Neotree toggle<cr>", opts)
