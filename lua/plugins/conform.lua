return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        lua = { "stylelua" },
        json = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        scss = { { "prettierd", "prettier" } },
        bash = { "beautysh" },
        yaml = { "yamlfix" },
        toml = { "taplo" },
        latex = { "tex-fmt" },
        bib = { "bibtex-tidy" },
        cmake = { "cmake_format" },
        c = { "astyle" },
        cpp = { "astyle" }
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>if", function()
      conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 500,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}

