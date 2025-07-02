local handle = io.popen("git pull 2>&1")
if not handle then
	return
end
local result = handle:read("*a")
local success, _, exit_code = handle:close()
if success and exit_code == 0 then
	vim.cmd("edit!")
	vim.notify("git pull succeeded. Neovim reloaded.", vim.log.levels.INFO)
end
