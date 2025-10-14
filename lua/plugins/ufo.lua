return {
  "kevinhwang91/nvim-ufo",
  event = "VeryLazy",
  dependencies = "kevinhwang91/promise-async",
  config = function()
    vim.o.foldcolumn = "1" -- '0' is not bad
    vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
    vim.keymap.set("n", "zK", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = "Peek Fold" })

    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        -- Don't enable ufo in quickfix, help, or diagnostic buffers
        local exclude = { 'qf', 'help', 'Trouble', 'lspinfo', 'diagnostic', 'notify' }
        if vim.tbl_contains(exclude, filetype) or buftype ~= '' then
          return ''
        end
        return { 'treesitter', 'indent' }
      end
    })
  end,
}

