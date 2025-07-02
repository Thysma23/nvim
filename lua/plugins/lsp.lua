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
				"lua_ls",
			},
			automatic_installation = true,
			handlers = {
				lua_ls = nil,
			},
			automatic_enable = false,
		},
	},
	{
		"neovim/nvim-lspconfig",
	},
}
