-- Load NvChad mappings if available
require("nvchad.mappings")

local map = vim.keymap.set

-- Unmap unused default mappings

map("n", "<leader>n", "<Nop>")
map("n", "<leader>ch", "<Nop>")
map("n", "<leader>cm", "<Nop>")
map("n", "<leader>fm", "<Nop>")
map("v", "<leader>fm", "<Nop>")
map("n", "<leader>gt", "<Nop>")
map("n", "<leader>rn", "<Nop>")
map("n", "<leader>ma", "<Nop>")
map("n", "<leader>h", "<Nop>")
map("n", "<leader>v", "<Nop>")
map("n", "<leader>D", "<Nop>")
map("n", "<leader>/", "<Nop>")
map("n", "<leader>ds", "<Nop>")
map("n", "<leader>pt", "<Nop>")
map("n", "<leader>ra", "<Nop>")
map("n", "<leader>wa", "<Nop>")
map("n", "<leader>wl", "<Nop>")
map("n", "<leader>wr", "<Nop>")



-- Window navigation with ALT
map("n", "<M-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<M-j>", "<C-w>j", { desc = "Focus bottom window" })
map("n", "<M-k>", "<C-w>k", { desc = "Focus top window" })
map("n", "<M-l>", "<C-w>l", { desc = "Focus right window" })

-- Buffer navigation with ALT I (left) and ALT O (right)
map("n", "<M-i>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<M-o>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Buffer picker with TAB (using bufferline)
map("n", "<Tab>", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer" })

-- Format and save all buffers with LEADER SPACE
map("n", "<leader><space>", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local has_denols = false

  for _, client in ipairs(clients) do
    if client.name == "denols" then
      has_denols = true
      break
    end
  end

  if has_denols then
    -- Use deno fmt on entire directory
    local cwd = vim.fn.getcwd()
    vim.fn.jobstart({ 'deno', 'fmt' }, {
      cwd = cwd,
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          vim.cmd('bufdo checktime')
          vim.cmd('wa')
          print("Formatted all files with deno fmt")
        else
          print("Deno fmt failed")
        end
      end
    })
  else
    local current_buf = vim.api.nvim_get_current_buf()
    vim.cmd "bufdo lua vim.lsp.buf.format({ async = false })"
    vim.cmd "wa"
    vim.api.nvim_set_current_buf(current_buf)
  end
end, { desc = "Format and save all buffers" })

-- Copilot mappings
-- TAB to accept suggestion
map("i", "<C-g>", function()
  return vim.fn["copilot#Accept"]("")
end, { expr = true, silent = true, replace_keycodes = false, desc = "Copilot accept suggestion" })

-- CTRL+N to accept word by word
map("i", "<C-n>", function()
  return vim.fn["copilot#AcceptWord"]("")
end, { expr = true, silent = true, replace_keycodes = false, desc = "Copilot accept word" })

-- Quit nvim with LEADER Q (ask for confirmation if there are unsaved changes)
map("n", "<leader>Q", function()
  if vim.fn.len(vim.fn.getbufinfo { buflisted = 1, changed = 1 }) > 0 then
    vim.cmd 'confirm qa'
  else
    vim.cmd 'qa'
  end
end, { desc = "Quit Neovim" })

-- close buffer with LEADER q
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Close current buffer" })

-- Open a new window terminal with LEADER tt
map("n", "<leader>tt", function()
  local cwd = vim.fn.getcwd()
  local win_cwd = cwd:gsub("\\", "/")
  vim.fn.jobstart({ 'cmd.exe', '/c', 'wt', '-w', '0', '-d', win_cwd }, { detach = true })
end, { desc = "Open new Windows Terminal in current directory" })

-- open a new window terminal with LEADER gl and run lazygit.exe
map("n", "<leader>gl", "<cmd>OpenLazyGit<cr>", { desc = "Open new Windows Terminal with lazygit in current directory" })

-- Open a terminal split with LEADER th and LEADER tv
map("n", "<leader>th", "<cmd>split | terminal<cr>", { desc = "Open terminal in horizontal split" })
map("n", "<leader>tv", "<cmd>vsplit | terminal<cr>", { desc = "Open terminal in vertical split" })

-- Split window with ctrl + hjkl
map("n", "<C-h>", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<C-j>", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<C-k>", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<C-l>", "<cmd>vsplit<cr>", { desc = "Vertical split" })

-- Telescope hidden/visible terminals with LEADER tf
map("n", "<leader>tf", "<cmd>Telescope terminals<cr>", { desc = "Telescope Terminals" })

-- Telescope Git commits with LEADER gc
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Telescope Git commits" })

-- Telescope Git status with LEADER gs
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Telescope Git status" })

-- Telescope marks with LEADER fm
map("n", "<leader>fm", "<cmd>Telescope marks<cr>", { desc = "Telescope Marks" })


-- Increase and decrease window height / width with ALT + ZQSD
map("n", "<M-z>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<M-s>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<M-d>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
map("n", "<M-q>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })

-- Lsp Keymaps with LEADER c prefix
map("n", "<leader>cd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })
map("n", "<leader>cr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "List references" })
map("n", "<leader>ci", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Go to implementation" })
map("n", "<leader>ct", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "Go to type definition" })
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code action" })
map("n", "<leader>ch", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover documentation" })
map("n", "<leader>ce", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename symbol" })
map("n", "<leader>cf", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local has_deno = false
  for _, client in ipairs(clients) do
    if client.name == "deno" then
      has_deno = true
      break
    end
  end
  if has_deno then
    -- Use deno fmt directly
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    vim.fn.jobstart({ 'deno', 'fmt', filename }, {
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          vim.cmd('checktime')
          print("Formatted with deno fmt")
        else
          print("Deno fmt failed")
        end
      end
    })
  else
    vim.lsp.buf.format({ async = true })
  end
end, { desc = "Format buffer" })
map("n", "<leader>cn", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Go to next diagnostic" })
map("n", "<leader>cp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Go to previous diagnostic" })
map("n", "<leader>cs", "<cmd>lua vim.diagnostic.setloclist()<cr>", { desc = "Set location list with diagnostics" })

-- Codes mapping with LEADER c
map("n", "<leader>c/", "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>", { desc = "Toggle comment line" })
map("v", "<leader>c/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
  { desc = "Toggle comment line (visual)" })


-- Config mapping

-- Open NVChad theme telescope with LEADER xt
map("n", "<leader>xt", "<cmd>Telescope themes<cr>", { desc = "NVChad Themes" })
-- Open Mason settings with LEADER xm
map("n", "<leader>xm", "<cmd>Mason<cr>", { desc = "Mason Settings" })
