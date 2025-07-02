return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"zbirenbaum/copilot.lua",
			"zbirenbaum/copilot-lualine",
		},
		event = "VeryLazy",
		config = function()
			vim.o.laststatus = 3

			local function lsp_status_component()
				local ok, lsp_status = pcall(require, "lsp-status")
				if ok then
					local status = lsp_status.status()
					if status and status:match("%S") then
						return "🔄 " .. status
					end
				end

				local clients = vim.lsp.get_active_clients()
				if #clients == 0 then
					return ""
				end

				local names = {}
				for _, client in ipairs(clients) do
					if client.name ~= "null-ls" and client.name ~= "copilot" then
						table.insert(names, client.name)
					end
				end

				return #names > 0 and ("✓ LSP: " .. table.concat(names, ", ")) or ""
			end

			local function lsp_status_color()
				local ok, lsp_status = pcall(require, "lsp-status")
				if ok and lsp_status.status():match("%S") then
					return { fg = "#FFB86C" } -- loading
				end
				return { fg = "#50FA7B" } -- ready
			end

			require("lualine").setup({
				options = {
					theme = "monokai-pro",
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
				sections = {
					lualine_y = {
						{
							lsp_status_component,
							color = lsp_status_color,
							icon = "",
						},
					},
					lualine_x = {
						{
							function()
								local ok, copilot_api = pcall(require, "copilot.api")
								if not ok then
									return ""
								end

								local status = copilot_api.status.data
								local icons = {
									[""] = " ", -- Normal/Ready
									["Normal"] = " ",
									["InProgress"] = " ",
									["Warning"] = " ",
									["offline"] = " ",
								}

								local colors = {
									[""] = "#50FA7B", -- Vert
									["Normal"] = "#50FA7B", -- Vert
									["InProgress"] = "#FFB86C", -- Orange
									["Warning"] = "#FF5555", -- Rouge
									["offline"] = "#6272A4", -- Gris
								}

								return (icons[status.status] or " ") .. " Copilot"
							end,
							color = function()
								local ok, copilot_api = pcall(require, "copilot.api")
								if not ok then
									return { fg = "#6272A4" }
								end

								local status = copilot_api.status.data.status
								local colors = {
									[""] = "#50FA7B",
									["Normal"] = "#50FA7B",
									["InProgress"] = "#FFB86C",
									["Warning"] = "#FF5555",
									["offline"] = "#6272A4",
								}

								return { fg = colors[status] or "#6272A4" }
							end,
						},
					},
					lualine_z = { "encoding", "fileformat", "filetype" },
				},
			})
		end,
	},
}
