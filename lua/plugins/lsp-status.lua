return {
	{
		"nvim-lua/lsp-status.nvim",
		config = function()
			local lsp_status = require("lsp-status")

			-- Configure lsp-status
			lsp_status.config({
				kind_labels = {},
				current_function = true,
				diagnostics = false,
				status_symbol = "",
				select_symbol = function(cursor_pos, symbol)
					if symbol.valueRange then
						local value_range = {
							["start"] = {
								character = 0,
								line = vim.fn.byte2line(symbol.valueRange[1]),
							},
							["end"] = {
								character = 0,
								line = vim.fn.byte2line(symbol.valueRange[2]),
							},
						}

						return require("lsp-status/util").in_range(cursor_pos, value_range)
					end
				end,
			})

			-- Register progress handler
			lsp_status.register_progress()

			-- Auto-register capabilities for LSP clients
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client then
						lsp_status.on_attach(client)
					end
				end,
			})
		end,
	},
}
