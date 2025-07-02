return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		triggers = {
			{ "go", mode = { "n", "v" } },
			{ "<leader>", mode = { "n", "v" } },
		},
	},
	keys = {
		-- {
		-- "<leader>",
		-- function()
		-- require("which-key").show({ global = false })
		-- end,
		-- desc = "Buffer Local Keymaps (which-key)",
		-- },
	},
}
