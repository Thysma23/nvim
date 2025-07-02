return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			" __    __                     __     __  __               ",
			"|  \\  |  \\                   |  \\   |  \\|  \\              ",
			"| $$\\ | $$  ______    ______ | $$   | $$ \\$$ ______ ____  ",
			"| $$$\\| $$ /      \\  /      \\| $$   | $$|  \\|      \\    \\ ",
			"| $$$$\\ $$|  $$$$$$\\|  $$$$$$\\\\$$\\ /  $$| $$| $$$$$$\\$$$$\\",
			"| $$\\$$ $$| $$    $$| $$  | $$ \\$$\\  $$ | $$| $$ | $$ | $$",
			"| $$ \\$$$$| $$$$$$$$| $$__/ $$  \\$$ $$  | $$| $$ | $$ | $$",
			"| $$  \\$$$ \\$$     \\ \\$$    $$   \\$$$   | $$| $$ | $$ | $$",
			" \\$$   \\$$  \\$$$$$$$  \\$$$$$$     \\$     \\$$ \\$$  \\$$  \\$$",
			"                                                          ",
		}

		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
			dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
			dashboard.button("t", "  Find text", ":Telescope live_grep<CR>"),
			dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
			dashboard.button("c", "  Config", ":e ~/AppData/Local/nvim/init.lua<CR>"),
			dashboard.button("q", "  Quit", ":qa<CR>"),
		}

		dashboard.section.footer.val = "Config by Mathys M ✨"
		alpha.setup(dashboard.config)
	end,
}
