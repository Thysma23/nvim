-- Description: Open the current working directory in Windows Terminal with lazygit

vim.api.nvim_create_user_command('OpenLazyGit', function()
  local cwd = vim.fn.getcwd()
  local win_cwd = cwd:gsub("\\", "/")
  vim.fn.jobstart({ 'cmd.exe', '/c', 'wt', '-w', '0', '-d', win_cwd, 'lazygit.exe' }, { detach = true })
end, {})
