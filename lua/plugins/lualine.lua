return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      vim.o.laststatus = 3
      require("lualine").setup({
        options = {
          theme = "monokai-pro",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_x = {
            {
              'copilot',
              -- Default values
              symbols = {
                status = {
                  icons = {
                    enabled = " ",
                    sleep = " ", -- auto-trigger disabled
                    disabled = " ",
                    warning = " ",
                    unknown = " "
                  },
                  hl = {
                    enabled = "#50FA7B",
                    sleep = "#AEB7D0",
                    disabled = "#6272A4",
                    warning = "#FFB86C",
                    unknown = "#FF5555"
                  }
                },
                spinners = "dots",
                spinner_color = "#6272A4"
              },
              show_colors = false,
              show_loading = true
            },
            'encoding',
            'fileformat',
            'filetype'
          }
        }
      })
    end,
  },
}
