local M = {}

local function exists(filename)
	return vim.fn.filereadable(vim.loop.cwd() .. "/" .. filename) == 1
end

local function has_any_extension(exts)
	local cwd = vim.loop.cwd()
	for _, ext in ipairs(exts) do
		local files = vim.fn.globpath(cwd, "*." .. ext, false, true)
		if #files > 0 then
			return true
		end
	end
	return false
end

function M.detect_profile()
	if has_any_extension({ "lua" }) or exists("init.lua") then
		return "lua"
	end

	if has_any_extension({ "py" }) or exists("pyproject.toml") then
		return "python"
	end

	return "default"
end

function M.setup()
	local profile = M.detect_profile()

	if profile == "lua" then
		require("profile_loader.lua").setup()
	end

	if profile == "python" then
		require("profile_loader.python").setup()
	end
end

return M
