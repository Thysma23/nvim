local projects_store = require("stores.projects_store")

vim.api.nvim_create_user_command("ProjectAdd", function()
	vim.ui.input({ prompt = "Folder : " }, function(folder)
		if not folder or folder == "" then
			folder = "d"
		end
		vim.ui.input({ prompt = "Name : " }, function(name)
			if not name then
				return
			end
			vim.ui.input({ prompt = "Path : " }, function(path)
				if not path or path == "" then
					path = vim.fn.getcwd()
				end
				vim.ui.input({ prompt = "Custom shortcut (leave empty for auto): " }, function(custom_shortcut)
					projects_store.add(folder, name, path, custom_shortcut)
				end)
			end)
		end)
	end)
end, { desc = "Add a project with a shortcut" })

vim.api.nvim_create_user_command("ProjectDelete", function()
	vim.ui.input({ prompt = "Folder : " }, function(folder)
		if not folder or folder == "" then
			folder = "d"
		end
		vim.ui.input({ prompt = "Shortcut to delete :" }, function(shortcut)
			if shortcut then
				projects_store.delete(folder, shortcut)
				pcall(vim.keymap.del, "n", "gop" .. shortcut)
			end
		end)
	end)
end, { desc = "Delete a project from his shortcut" })

vim.api.nvim_create_user_command("ProjectFolderAdd", function()
	vim.ui.input({ prompt = "Folder name : " }, function(folder)
		if not folder or folder == "" or not (folder:len() == 1) then
			vim.notify("Folder name cannot be empty", vim.log.levels.ERROR)
			return
		end
		projects_store.addFolder(folder)
	end)
end, { desc = "Add a new project folder" })

vim.api.nvim_create_user_command("ProjectFolderDelete", function()
	vim.ui.input({ prompt = "Folder name to delete :" }, function(folder)
		if folder then
			projects_store.deleteFolder(folder)
		end
	end)
end, { desc = "Delete a project folder" })

vim.api.nvim_create_user_command("ProjectOpen", function()
	local has_telescope, telescope = pcall(require, "telescope")
	if not has_telescope then
		vim.notify("Telescope is not installed", vim.log.levels.ERROR)
		return
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local previewers = require("telescope.previewers")

	-- Collecter tous les projets de tous les dossiers
	local all_projects = {}
	local folders = projects_store.getFolders()

	for _, folder in ipairs(folders) do
		local projects = projects_store.load(folder)
		for project_name, project in pairs(projects) do
			table.insert(all_projects, {
				name = project.name,
				path = project.path,
				shortcut = project.shortcut,
				folder = folder,
				display = string.format(
					"[%s%s] %s - %s",
					folder == "d" and "" or folder,
					project.shortcut,
					project.name,
					project.path
				),
			})
		end
	end

	if #all_projects == 0 then
		vim.notify("No projects found", vim.log.levels.WARN)
		return
	end

	-- Créer le previewer pour afficher l'arborescence
	local tree_previewer = previewers.new_buffer_previewer({
		title = "Project Tree",
		define_preview = function(self, entry, status)
			local project = entry.value
			local path = project.path

			-- Vérifier que le chemin existe
			if vim.fn.isdirectory(path) == 0 then
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {
					"Directory not found:",
					path,
					"",
					"The project path may have been moved or deleted.",
				})
				return
			end

			-- Utiliser vim.fn.readdir pour lister seulement le premier niveau
			local items = vim.fn.readdir(path, function(item)
				-- Retourner tous les éléments (fichiers et dossiers)
				return 1
			end)

			if not items or #items == 0 then
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {
					"Empty directory",
				})
				return
			end

			-- Trier les éléments (dossiers en premier, puis fichiers)
			table.sort(items, function(a, b)
				local a_path = path .. "/" .. a
				local b_path = path .. "/" .. b
				local a_is_dir = vim.fn.isdirectory(a_path) == 1
				local b_is_dir = vim.fn.isdirectory(b_path) == 1

				if a_is_dir and not b_is_dir then
					return true
				elseif not a_is_dir and b_is_dir then
					return false
				else
					return a:lower() < b:lower()
				end
			end)

			-- Créer l'affichage de l'arborescence
			local lines = {}
			table.insert(lines, project.name .. "/")

			for i, item in ipairs(items) do
				local item_path = path .. "/" .. item
				local is_dir = vim.fn.isdirectory(item_path) == 1
				local prefix = (i == #items) and "└── " or "├── "
				local suffix = is_dir and "/" or ""
				table.insert(lines, prefix .. item .. suffix)
			end

			vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
		end,
	})

	pickers
		.new({}, {
			prompt_title = "Projects",
			finder = finders.new_table({
				results = all_projects,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.display,
						ordinal = entry.name .. " " .. entry.path,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = tree_previewer,
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection then
						local project = selection.value
						projects_store.open(project.folder, project.shortcut)
					end
				end)
				return true
			end,
		})
		:find()
end, { desc = "Open project selector with Telescope" })
