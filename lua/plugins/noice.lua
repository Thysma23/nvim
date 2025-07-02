return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		notify = {
			enabled = true,
			view = "notify",
		},
		lsp = {
			-- Override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			progress = {
				enabled = false, -- Disable LSP progress notifications
			},
			message = {
				enabled = false, -- Disable LSP message notifications
			},
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "written" },
						{ find = "yanked" },
					},
				},
				opts = { skip = true },
			},
			-- Filter out LSP progress messages
			{
				filter = {
					event = "lsp",
					kind = "progress",
				},
				opts = { skip = true },
			},
			-- Filter out specific LSP messages
			{
				filter = {
					event = "notify",
					find = "LSP",
				},
				opts = { skip = true },
			},
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
	config = function(_, opts)
		require("notify").setup({
			background_colour = "#000000",
		})
		require("noice").setup(opts)
	end,
}
