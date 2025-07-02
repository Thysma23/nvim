-- Load options first
require("options")

-- Load keybindings
require("keybinding.urls")
require("keybinding.projects")
require("keybinding.go")
require("keybinding.tree")
require("keybinding.terminal")
require("keybinding.barbar")
require("keybinding.copilot-keys")
require("keybinding.lsp-keys")

-- Load lazy.nvim configuration
require("config.lazy")
require("config.update_nvim")

-- load commands
require("commands.format-workspace-lua")
require("commands.urls")
require("commands.projects")

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		require("profile_loader").setup()
	end,
})
