local store = require("stores.urls_store")

vim.api.nvim_create_user_command("UrlAdd", function()
	vim.ui.input({ prompt = "Shortcut : " }, function(shortcut)
		if not shortcut then
			return
		end
		vim.ui.input({ prompt = "URL : " }, function(url)
			if not url then
				return
			end
			store.add(shortcut, url)
			vim.keymap.set("n", "gou" .. shortcut, function()
				store.open(shortcut)
			end, { desc = "Open URL for shortcut '" .. shortcut .. "'" })
		end)
	end)
end, { desc = "Add url with a shortcut" })

vim.api.nvim_create_user_command("UrlDelete", function()
	vim.ui.input({ prompt = "Shortcut to delete :" }, function(shortcut)
		if shortcut then
			store.delete(shortcut)
			pcall(vim.keymap.del, "n", "gou" .. shortcut)
		end
	end)
end, { desc = "Delete a url from his shortcut" })
