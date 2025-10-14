return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = { enable = true },         -- enable LSP features if you want Noice's LSP popups
    messages = { enable = true },
    notify = { enable = false },     -- disable Noice notifications, use Snacks instead
    input = { enabled = false },     -- disable Noice input dialog, use Snacks instead
    popupmenu = { enable = true },   -- enable popupmenu if you want Noice's completion UI
    cmdline = {
      enabled = true,
      view = "cmdline_popup",        -- floating cmdline
    },
    presets = {
      command_palette = false,
      long_message_to_split = false,
      inc_rename = false,
      lsp_doc_border = false,
    },
    views = {
      cmdline_popup = {
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          width = "auto",
          height = "auto",
        },
      },
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
  end,
}

