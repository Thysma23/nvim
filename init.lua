-- Load options first
require("options")

-- Load keybindings
require("keybinding.go")
require("keybinding.tree")
require("keybinding.terminal")
require("keybinding.barbar")
require("keybinding.copilot-keys")

-- Load lazy.nvim configuration
require("config.lazy")

-- load commands
require("commands.format-workspace-lua")

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		require("profile_loader").setup()
	end,
})
