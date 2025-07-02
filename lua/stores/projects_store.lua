local M = {}

local function get_projects_file(folder)
	return vim.fn.stdpath("data") .. "/projects/" .. folder .. ".json"
end

function M.open(folder, shortcut)
	local data = M.load(folder)
	if not data then
		vim.notify("No projects found in folder '" .. folder .. "'", vim.log.levels.ERROR)
		return
	end

	for _, project in pairs(data) do
		if project.shortcut == shortcut then
			vim.cmd("cd " .. project.path)
			require("profile_loader").setup()
			vim.notify("Opened project: " .. project.name, vim.log.levels.INFO)
			return
		end
	end

	vim.notify("No project found with shortcut '" .. shortcut .. "'", vim.log.levels.ERROR)
end

function M.load(folder)
	local content = "{}"
	local file_path = get_projects_file(folder)
	local f = io.open(file_path, "r")
	if f then
		local file_content = f:read("*a")
		f:close()
		if file_content and file_content:match("%S") then
			content = file_content
		end
	else
		vim.notify("File not found: " .. file_path, vim.log.levels.WARN)
		if folder == "d" then
			local projects_dir = vim.fn.stdpath("data") .. "/projects"
			if vim.fn.isdirectory(projects_dir) == 0 then
				vim.fn.mkdir(projects_dir, "p")
			end
			local f_create = io.open(file_path, "w")
			if f_create then
				f_create:write("{}")
				f_create:close()
			end
		end
	end

	local success, result = pcall(vim.fn.json_decode, content)
	if success then
		if type(result) == "table" then
			local count = 0
			for k, v in pairs(result) do
				count = count + 1
			end
		end
		return result or {}
	else
		vim.notify("Error parsing JSON file: " .. file_path .. " - Error: " .. tostring(result), vim.log.levels.WARN)
		return {}
	end
end

local function save(folder, data)
	local file_path = get_projects_file(folder)

	local projects_dir = vim.fn.stdpath("data") .. "/projects"
	if vim.fn.isdirectory(projects_dir) == 0 then
		vim.fn.mkdir(projects_dir, "p")
	end

	local f = io.open(file_path, "w")
	if not f then
		vim.notify("Failed to open file for writing: " .. file_path, vim.log.levels.ERROR)
		return false
	end

	local json_data = vim.fn.json_encode(data)
	f:write(json_data)
	f:close()

	vim.notify("Saved project data to: " .. file_path, vim.log.levels.DEBUG)
	return true
end

function M.add(folder, name, path, custom_shortcut)
	if not folder or folder == "" then
		folder = "d" -- default folder
	end

	if not name or name == "" then
		vim.notify("Project name cannot be empty", vim.log.levels.ERROR)
		return
	end

	if not path or path == "" then
		path = vim.fn.getcwd()
	end

	local folders = M.getFolders()
	local data = M.load(folder)
	local shortcut = nil

	-- Vérifier les projets existants
	for _, project in pairs(data) do
		if project.name == name then
			vim.notify("The project: '" .. name .. "' already exist", vim.log.levels.ERROR)
			return
		end
		if project.path == path then
			vim.notify("The path: '" .. path .. "' already exist", vim.log.levels.ERROR)
			return
		end
	end

	-- Si un raccourci personnalisé est fourni, l'utiliser
	if custom_shortcut and custom_shortcut ~= "" then
		-- Vérifier que le raccourci personnalisé n'est pas déjà utilisé
		for _, project in pairs(data) do
			if project.shortcut == custom_shortcut then
				vim.notify("Shortcut '" .. custom_shortcut .. "' is already used", vim.log.levels.ERROR)
				return
			end
		end

		-- Vérifier que le raccourci n'est pas un nom de dossier existant (pour le dossier "d")
		if folder == "d" then
			for _, f in ipairs(folders) do
				if f == custom_shortcut then
					vim.notify("Shortcut '" .. custom_shortcut .. "' conflicts with folder name", vim.log.levels.ERROR)
					return
				end
			end
		end

		shortcut = custom_shortcut
	else
		-- Utiliser l'algorithme automatique
		local shortcutIndex = 1
		local shortcutMaj = "lower"
		local max_attempts = #name * 2
		local attempts = 0

		while shortcut == nil and attempts < max_attempts do
			attempts = attempts + 1

			if shortcutIndex > #name then
				if shortcutMaj == "lower" then
					shortcutMaj = "upper"
					shortcutIndex = 1
				else
					vim.notify("Unable to generate a unique shortcut for project: " .. name, vim.log.levels.ERROR)
					return
				end
			end

			if shortcutMaj == "lower" then
				shortcut = name:lower():sub(shortcutIndex, shortcutIndex)
			else
				shortcut = name:upper():sub(shortcutIndex, shortcutIndex)
			end

			if shortcut == "" or not shortcut:match("[a-zA-Z]") then
				shortcutIndex = shortcutIndex + 1
				shortcut = nil
				goto continue
			end

			for _, project in pairs(data) do
				if project.shortcut == shortcut then
					if shortcutIndex == #name then
						if shortcutMaj == "lower" then
							shortcutMaj = "upper"
							shortcutIndex = 0
						end
					end
					shortcutIndex = shortcutIndex + 1
					shortcut = nil
					break
				end
			end

			if shortcut and folder == "d" then
				for _, f in ipairs(folders) do
					if f == shortcut then
						if shortcutIndex == #name then
							if shortcutMaj == "lower" then
								shortcutMaj = "upper"
								shortcutIndex = 0
							end
						end
						shortcutIndex = shortcutIndex + 1
						shortcut = nil
						break
					end
				end
			end

			::continue::
		end

		if not shortcut then
			vim.notify(
				"Unable to generate a unique shortcut for project: " .. name .. " after " .. max_attempts .. " attempts",
				vim.log.levels.ERROR
			)
			return
		end
	end

	data = data or {}
	data[name] = {
		name = name,
		path = path,
		shortcut = shortcut,
	}

	local success = save(folder, data)
	if success then
		vim.notify(
			"Added " .. name .. " project on '" .. shortcut .. "' shortcut in folder '" .. folder .. "'",
			vim.log.levels.INFO
		)
		vim.keymap.set("n", "gop" .. (folder == "d" and "" or folder) .. shortcut, function()
			M.open(folder, shortcut)
		end, { desc = "Open project: " .. name .. (folder == "d" and "" or ("in folder " .. folder)) })
	else
		vim.notify("Failed to save project: " .. name, vim.log.levels.ERROR)
	end
end

function M.delete(folder, shortcut)
	local data = M.load(folder)
	local project_to_delete = nil
	for _, project in pairs(data) do
		if project.shortcut == shortcut then
			project_to_delete = project
			break
		end
	end
	if not project_to_delete then
		vim.notify("No project with shortcut '" .. shortcut .. "' to delete", vim.log.levels.WARN)
		return
	end
	for i, project in ipairs(data) do
		if project.shortcut == shortcut then
			table.remove(data, i)
			break
		end
	end
	save(folder, data)
	vim.notify(
		"Deleted '" .. project_to_delete.name .. "' project with shortcut '" .. shortcut .. "'",
		vim.log.levels.INFO
	)
	vim.keymap.del("n", "gop" .. (folder == "d" and "" or folder) .. shortcut)
end

function M.addFolder(folder)
	if folder == "" or folder == nil then
		vim.notify("Folder name cannot be empty", vim.log.levels.ERROR)
		return
	end

	if not (folder:len() == 1) then
		vim.notify("Folder name must be a single character", vim.log.levels.ERROR)
		return
	end
	local valid_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	if not folder:match("[" .. valid_chars .. "]") then
		vim.notify("Folder name must be a letter", vim.log.levels.ERROR)
		return
	end
	local existing_folders = M.getFolders()
	for _, existing_folder in ipairs(existing_folders) do
		if existing_folder == folder then
			vim.notify("Folder '" .. folder .. "' already exists", vim.log.levels.WARN)
			return
		end
	end
	local d_shortcuts = M.load("d")
	for _, project in pairs(d_shortcuts) do
		if project.shortcut == folder then
			vim.notify("Folder name not available", vim.log.levels.WARN)
			return
		end
	end

	local file_path = get_projects_file(folder)
	local f = io.open(file_path, "w")
	if f then
		f:write("{}")
		f:close()
		vim.notify("Created folder: " .. folder, vim.log.levels.INFO)
	else
		vim.notify("Failed to create folder '" .. folder .. "'", vim.log.levels.ERROR)
	end
end

function M.deleteFolder(folder)
	local file_path = get_projects_file(folder)
	if vim.fn.filereadable(file_path) == 1 then
		vim.fn.delete(file_path)
		vim.notify("Deleted folder: " .. folder, vim.log.levels.INFO)
	else
		vim.notify("Folder '" .. folder .. "' does not exist", vim.log.levels.WARN)
	end
end

function M.getFolders()
	local data_path = vim.fn.stdpath("data") .. "/projects"
	local folders = {}
	if vim.fn.isdirectory(data_path) == 1 then
		for _, file in ipairs(vim.fn.readdir(data_path)) do
			if file:match("%.json$") then
				local folder_name = file:gsub("%.json$", "")
				table.insert(folders, folder_name)
			end
		end
	end
	return folders
end

return M
