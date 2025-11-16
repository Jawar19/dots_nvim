-- stylua: ignore start
-- =========================================
-- 🗺️ LazyVim Custom Keymaps
-- =========================================

local map = vim.keymap.set

-- Safely get Snacks module
local ok, snacks = pcall(require, "snacks")
if not ok then
  vim.notify("Snacks plugin not found", vim.log.levels.WARN)
  return
end

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- =========================================
-- 🧭 Top Pickers & Explorer
-- =========================================
map("n", "<leader><space>", function() snacks.picker.smart() end, { desc = "Smart Find Files" })
map("n", "<leader>,", function() snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>/", function() snacks.picker.grep() end, { desc = "Grep" })
map("n", "<leader>:", function() snacks.picker.command_history() end, { desc = "Command History" })
map("n", "<leader>n", function() snacks.picker.notifications() end, { desc = "Notification History" })
map("n", "<leader>e", function() snacks.explorer() end, { desc = "File Explorer" })
map("n", "<leader>E", function()
  local path = vim.fn.expand("%:p:h")
  snacks.explorer({ cwd = path ~= "" and path or vim.loop.cwd() })
end, { desc = "File Explorer (current file dir)" })

-- =========================================
-- 🔍 Find
-- =========================================
local find = {
  b = { snacks.picker.buffers, "Buffers" },
  c = { function() snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, "Config Files" }, -- ✅ Wrap in table
  f = { snacks.picker.files, "Find Files" },
  g = { snacks.picker.git_files, "Find Git Files" },
  p = { snacks.picker.projects, "Projects" },
  r = { snacks.picker.recent, "Recent Files" },
}
for k, v in pairs(find) do
  local fn, desc = v[1] or v, v[2] or "Find " .. k
  map("n", "<leader>f" .. k, fn, { desc = desc })
end

-- =========================================
-- 🧬 Git
-- =========================================
local git = {
  b = { snacks.picker.git_branches, "Git Branches" },
  l = { snacks.picker.git_log, "Git Log" },
  L = { snacks.picker.git_log_line, "Git Log Line" },
  s = { snacks.picker.git_status, "Git Status" },
  S = { snacks.picker.git_stash, "Git Stash" },
  d = { snacks.picker.git_diff, "Git Diff (Hunks)" },
  f = { snacks.picker.git_log_file, "Git Log File" },
  g = { snacks.lazygit.open, "LazyGit" },
}
for k, v in pairs(git) do
  map("n", "<leader>g" .. k, v[1], { desc = v[2] })
end
map({ "n", "v" }, "<leader>gB", function() snacks.gitbrowse() end, { desc = "Git Browse" })

-- =========================================
-- 🔎 Search & Grep
-- =========================================
map("n", "<leader>sb", function() snacks.picker.lines() end, { desc = "Buffer Lines" })
map("n", "<leader>sB", function() snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
map("n", "<leader>sg", function() snacks.picker.grep() end, { desc = "Grep" })
map({ "n", "x" }, "<leader>sw", function() snacks.picker.grep_word() end, { desc = "Visual selection or word" })

-- Extended Search Tools
local search_tools = {
  ['"'] = { snacks.picker.registers, "Registers" },
  ["/"] = { snacks.picker.search_history, "Search History" },
  a = { snacks.picker.autocmds, "Autocmds" },
  c = { snacks.picker.command_history, "Command History" },
  C = { snacks.picker.commands, "Commands" },
  d = { snacks.picker.diagnostics, "Diagnostics" },
  D = { snacks.picker.diagnostics_buffer, "Buffer Diagnostics" },
  h = { snacks.picker.help, "Help Pages" },
  H = { snacks.picker.highlights, "Highlights" },
  i = { snacks.picker.icons, "Icons" },
  j = { snacks.picker.jumps, "Jumps" },
  k = { snacks.picker.keymaps, "Keymaps" },
  l = { snacks.picker.loclist, "Location List" },
  m = { snacks.picker.marks, "Marks" },
  M = { snacks.picker.man, "Man Pages" },
  p = { snacks.picker.lazy, "Search for Plugin Spec" },
  q = { snacks.picker.qflist, "Quickfix List" },
  R = { snacks.picker.resume, "Resume" },
  u = { snacks.picker.undo, "Undo History" },
}
for k, v in pairs(search_tools) do
  map("n", "<leader>s" .. k, v[1], { desc = v[2] })
end
map("n", "<leader>uC", function() snacks.picker.colorschemes() end, { desc = "Colorschemes" })

-- =========================================
-- 💡 LSP / Code Actions
-- =========================================
-- LSP mappings moved to LspAttach handler in lua/plugins/lsp.lua so they are buffer-local
-- (prevents conflicts with filetype-specific mappings, e.g., LaTeX)
-- LSP Diagnostics & Actions (reformatted for keymaps.lua style)
local picker = require("snacks").picker
map("n", "<leader>ld", picker.diagnostics, { desc = "Project Diagnostics" })
map("n", "<leader>lD", picker.diagnostics_buffer, { desc = "Buffer Diagnostics" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })
map("i", "<C-c>a", function()
  vim.cmd("stopinsert")
  vim.lsp.buf.code_action()
end, { desc = "Code Action (Insert Mode)" })

-- Rename / hover / format
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
map("n", "<leader>lR", function() require("snacks").rename.rename_file() end, { desc = "Rename File" })
map("n", "<leader>li", vim.lsp.buf.hover, { desc = "Show Hover Info" })
map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format Buffer" })

-- =========================================
-- 🧰 UI / Misc
-- =========================================
map("n", "<leader>z", function() snacks.zen() end, { desc = "Toggle Zen Mode" })
map("n", "<leader>Z", function() snacks.zen.zoom() end, { desc = "Toggle Zoom" })
map("n", "<leader>.", function() snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
map("n", "<leader>S", function() snacks.scratch.select() end, { desc = "Select Scratch Buffer" })
map("n", "<leader>bd", function() snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>cR", function() snacks.rename.rename_file() end, { desc = "Rename File" })
map("n", "<leader>un", function() snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })
map("n", "<C-/>", function() snacks.terminal() end, { desc = "Toggle Terminal" })
map("n", "<C-_>", function() snacks.terminal() end, { desc = "which_key_ignore" })
map({ "n", "t" }, "]]", function() snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
map({ "n", "t" }, "[[", function() snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })

-- =========================================
-- 💾 File & Buffer Management
-- =========================================
map("n", "<leader>qc", function() snacks.bufdelete.delete() end, { desc = "Close buffer (snacks)" })
map("n", "<leader>qC", function() snacks.bufdelete.delete({ force = true }) end, { desc = "Force close buffer (snacks)" })

map({ "n", "i", "v" }, "<C-S-s>", "<cmd>write<CR>", { desc = "Save file" })
map({ "n", "i", "v" }, "<C-s>", function()
  vim.cmd("write")
  local mode = vim.api.nvim_get_mode().mode
  if mode == "i" or mode == "v" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end
end, { desc = "Save file and leave to normal mode" })
-- =========================================
-- 💬 Comments
-- =========================================
-- Only set if Commentary is available
if vim.fn.exists(":Commentary") == 2 then
  map("i", "<C-/>", "<Esc>:Commentary<CR>")
end

-- stylua: ignore end
