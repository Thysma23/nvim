local store = require("stores.urls_store")

local urls = store.load()

for shortcut, url in pairs(urls) do
	vim.keymap.set("n", "gou" .. shortcut, function()
		store.open(shortcut)
	end, { desc = "Open url: " .. url })
end
