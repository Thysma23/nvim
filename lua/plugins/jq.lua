return {
	"gennaro-tedesco/nvim-jqx",
	init = function()
		local jqx = require("nvim-jqx.config")
		jqx.geometry.border = "single"
		jqx.geometry.width = 0.7

		jqx.query_key = "X" -- keypress to query jq on keys
		jqx.sort = false -- show the json keys as they appear instead of sorting them alphabetically
		jqx.show_legend = true -- show key queried as first line in the jqx floating window
		jqx.use_quickfix = false -- if you prefer the location list
	end,
}
