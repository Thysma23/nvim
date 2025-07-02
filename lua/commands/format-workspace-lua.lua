vim.api.nvim_create_user_command("FormatWorkspaceLua", function()
	if vim.fn.executable("stylua") == 1 then
		local output = vim.fn.system({ "stylua", "." })
		if vim.v.shell_error == 0 then
			vim.notify("Directory formated", vim.log.levels.INFO)
		else
			vim.notify("Error while formating the directory...\n" .. output, vim.log.levels.ERROR)
		end
	else
		vim.notify("Installing stylua from Mason", vim.log.levels.WARN)
		vim.cmd("MasonInstall stylua")
	end
end, {
	desc = "Format all Lua files in the workspace using stylua",
})
