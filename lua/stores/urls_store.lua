local M = {}

local function get_project_file()
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local dir = vim.fn.stdpath("data") .. "/project_urls"
	vim.fn.mkdir(dir, "p")
	return dir .. "/" .. project_name .. "_urls.json"
end

function M.open(shortcut)
	local url = M.load()[shortcut]
	if not url then
		vim.notify("No URL found for shortcut '" .. shortcut .. "'", vim.log.levels.ERROR)
		return
	end
	vim.fn.jobstart({ "cmd", "/c", "start", "msedge", url }, { detach = true })
end

function M.load()
	local f = io.open(get_project_file(), "r")
	if not f then
		return {}
	end
	local content = f:read("*a")
	f:close()
	return vim.fn.json_decode(content) or {}
end

local function save(data)
	local f = io.open(get_project_file(), "w")
	if not f then
		return {}
	end
	f:write(vim.fn.json_encode(data))
	f:close()
end

function M.add(shortcut, url)
	local data = M.load()
	if data[shortcut] then
		vim.notify("The shortcut: '" .. shortcut .. "' already exist", vim.log.levels.ERROR)
		return
	end
	data[shortcut] = url
	save(data)
	vim.notify("added " .. shortcut .. " shortcut → " .. url, vim.log.levels.INFO)
end

function M.delete(shortcut)
	local data = M.load()
	if not data[shortcut] then
		vim.notify("No shortcut '" .. shortcut .. "' to delete", vim.log.levels.WARN)
		return
	end
	data[shortcut] = nil
	save(data)
	vim.notify("Deleted '" .. shortcut .. "' shortcut url", vim.log.levels.INFO)
end

return M
