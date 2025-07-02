local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
map("n", "<A-;>", "<Cmd>BufferNext<CR>", opts)

-- Re-order to previous/next
map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)

-- Goto buffer in position...
map("n", "<A-&>", "<Cmd>BufferGoto 1<CR>", opts)
map("n", "<A-é>", "<Cmd>BufferGoto 2<CR>", opts)
map("n", '<A-">', "<Cmd>BufferGoto 3<CR>", opts)
map("n", "<A-'>", "<Cmd>BufferGoto 4<CR>", opts)
map("n", "<A-(>", "<Cmd>BufferGoto 5<CR>", opts)
map("n", "<A-->", "<Cmd>BufferGoto 6<CR>", opts)
map("n", "<A-è>", "<Cmd>BufferGoto 7<CR>", opts)
map("n", "<A-_>", "<Cmd>BufferGoto 8<CR>", opts)
map("n", "<A-ç>", "<Cmd>BufferGoto 9<CR>", opts)
map("n", "<A-à>", "<Cmd>BufferLast<CR>", opts)

-- Pin/unpin buffer
map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)

-- Goto pinned/unpinned buffer
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned

map("n", "<C-w>", "<Cmd>BufferClose<CR>", opts)
map("i", "<C-w>", "<Nop>", opts)

-- Wipeout buffer
--                 :BufferWipeout

-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight

-- Magic buffer-picking mode
map("n", "<C-p>", "<Cmd>BufferPick<CR>", opts)
map("n", "<C-s-p>", "<Cmd>BufferPickDelete<CR>", opts)

-- Sort automatically by...
map("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", opts)
map("n", "<Space>bn", "<Cmd>BufferOrderByName<CR>", opts)
map("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", opts)
map("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", opts)
map("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", opts)

-- Git shortcuts for tabs
map("n", "<Space>gb", "<Cmd>Telescope git_branches<CR>", opts)
map("n", "<Space>gf", "<Cmd>Telescope git_files<CR>", opts)
map("n", "<Space>gs", "<Cmd>Telescope git_status<CR>", opts)
map("n", "<Space>gc", "<Cmd>Telescope git_commits<CR>", opts)
