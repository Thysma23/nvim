return {
  -- GitHub Copilot
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      -- Disable default mappings (we handle them in mappings.lua)
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_filetypes = { ["*"] = true }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  -- BufferLine for buffer management with letter picking
  {
    "akinsho/bufferline.nvim",
    event = "BufReadPre",
    opts = {
      options = {
        themable = true,
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- Command-line autocompletion
  {
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local cmp = require("cmp")
      -- Setup for ':' commands
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
      -- Setup for '/' and '?' search
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
    end,
  },

  -- WhichKey configuration
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      -- Hide unmapped keys
      opts.spec = opts.spec or {}
      table.insert(opts.spec, {
        { "<leader>n",  hidden = true },
        { "<leader>ch", hidden = true },
        { "<leader>cm", hidden = true },
        { "<leader>gt", hidden = true },
        { "<leader>rn", hidden = true },
        { "<leader>ma", hidden = true },
        { "<leader>h",  hidden = true },
        { "<leader>v",  hidden = true },
        { "<leader>D",  hidden = true },
        { "<leader>/",  hidden = true },
        { '<leader>ds', hidden = true },
        { "<leader>pt", hidden = true },
        { "<leader>ra", hidden = true },
        { "<leader>wa", hidden = true },
        { "<leader>wl", hidden = true },
        { "<leader>wr", hidden = true },
      })
      -- Add group names for categories
      table.insert(opts.spec, {
        { "<leader>t", group = "Terminal" },
        { "<leader>g", group = "Git" },
        { "<leader>f", group = "Find/Files" },
        { "<leader>c", group = "Code" },
        { "<leader>x", group = "Config" },
      })
      return opts
    end,
  },
}
