return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = { "InsertEnter", "VeryLazy" }, -- Load on insert and also when Neovim is ready
		config = function()
			require("copilot").setup({
				panel = {
					enabled = true,
					auto_refresh = false,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom", -- | top | left | right
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					hide_during_completion = true,
					debounce = 50, -- Reduced debounce for faster suggestions
					keymap = {
						accept = false, -- Disabled, we handle this manually
						accept_word = false,
						accept_line = false,
						next = false, -- Disabled, we handle this manually
						prev = false, -- Disabled, we handle this manually
						dismiss = false, -- Disabled, we handle this manually
					},
				},
				filetypes = {
					yaml = false,
					markdown = true,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
				copilot_node_command = "node", -- Node.js version must be > 18.x
				server_opts_overrides = {},
			})
		end,
	},
	{ "AndreM222/copilot-lualine" },
}
