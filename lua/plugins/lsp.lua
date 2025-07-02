return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"pyrefly",
			},
			automatic_installation = true,
			handlers = {
				pyrefly = nil,
			},
			automatic_enable = false,
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Disable LSP progress notifications in favor of lualine display
			vim.lsp.handlers["$/progress"] = function() end

			-- LSP servers are configured in their respective profile loaders
		end,
	},
}
