return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {
		indent = {
			highlight = {
				"RainbowDelimiterRed",
				"RainbowDelimiterYellow",
				"RainbowDelimiterBlue",
				"RainbowDelimiterOrange",
				"RainbowDelimiterGreen",
				"RainbowDelimiterViolet",
				"RainbowDelimiterCyan",
			},
			char = "│",
		},
		scope = {
			enabled = false, -- Disable scope highlighting to avoid coloring text
		},
	},
	dependencies = {
		"TheGLander/indent-rainbowline.nvim",
	},
	config = function(_, opts)
		-- Define the rainbow colors
		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })
		end)

		require("ibl").setup(opts)
	end,
}
