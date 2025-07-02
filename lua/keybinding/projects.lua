local projects_store = require("stores.projects_store")

local folders = projects_store.getFolders()

for _, folder in ipairs(folders) do
	local projects = projects_store.load(folder)

	local project_count = 0
	for _ in pairs(projects) do
		project_count = project_count + 1
	end

	for project_name, project in pairs(projects) do
		vim.keymap.set("n", "gop" .. (folder == "d" and "" or folder) .. project.shortcut, function()
			projects_store.open(folder, project.shortcut)
		end, { desc = "Open project: " .. project.name })
	end
end
