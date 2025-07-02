local M = {}

function M.setup()
	local dashboard = require("alpha.themes.dashboard")

	dashboard.section.header.val = {

		" __     __  __                    __                           ",
		"|  \\   |  \\|  \\                  |  \\                          ",
		"| $$   | $$ \\$$ ______ ____      | $$       __    __   ______  ",
		"| $$   | $$|  \\|      \\    \\     | $$      |  \\  |  \\ |      \\ ",
		" \\$$\\ /  $$| $$| $$$$$$\\$$$$\\    | $$      | $$  | $$  \\$$$$$$\\",
		"  \\$$\\  $$ | $$| $$ | $$ | $$    | $$      | $$  | $$ /      $$",
		"   \\$$ $$  | $$| $$ | $$ | $$ __ | $$_____ | $$__/ $$|  $$$$$$$",
		"    \\$$$   | $$| $$ | $$ | $$|  \\| $$     \\ \\$$    $$ \\$$    $$",
		"     \\$     \\$$ \\$$  \\$$  \\$$ \\$$ \\$$$$$$$$  \\$$$$$$   \\$$$$$$$",
		"                                                               ",
	}
	vim.opt.titlestring = "Vim.lua - %t"

	require("lspconfig").lua_ls.setup({
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						vim.fn.stdpath("config"),
						vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
						unpack(vim.api.nvim_get_runtime_file("", true)),
					},
					checkThirdParty = false,
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})
end

return M
