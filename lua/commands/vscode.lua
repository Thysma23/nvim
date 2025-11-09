-- this create a nvim command to open the current folder in vscode
vim.api.nvim_create_user_command('OpenInVSCode', function()
  local cwd = vim.fn.getcwd()
  vim.fn.jobstart({ 'cmd.exe', '/c', 'code', cwd }, { detach = true })
  print('Opened ' .. cwd .. ' in VSCode')
end, {})
