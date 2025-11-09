require "nvchad.options"

local o = vim.o

-- Relative line numbers in normal mode, absolute in insert mode
vim.opt.number = true
vim.opt.relativenumber = true

-- Auto switch between relative and absolute line numbers
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.opt.number = true
    vim.opt.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.opt.relativenumber = true
  end,
})

-- Scrolloff
vim.opt.scrolloff = 6
require("scrollEOF").setup {}

-- Set shell to Git Bash on Windows
if vim.fn.has('win32') == 1 then
  o.shell = vim.fn.executable('bash.exe') == 1 and 'bash.exe' or 'pwsh'
  o.shellcmdflag = '-c'
  o.shellquote = ''
  o.shellxquote = '"'
end

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
  end,
})

require("commands.vscode")
require("commands.lazygit")
