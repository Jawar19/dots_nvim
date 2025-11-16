vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.smartindent = true
vim.opt.smartcase = true

-- tabs options
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.nu = true

vim.opt.termguicolors = true

vim.opt.spelllang = "en_us,da_dk"

vim.env.JAVA_TOOL_OPTIONS = (vim.env.JAVA_TOOL_OPTIONS or "") .. " -Djdk.xml.totalEntitySizeLimit=2000000"
