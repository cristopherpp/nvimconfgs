local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Editor behavior
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.hlsearch = false
opt.incsearch = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.updatetime = 50

-- Appearance
opt.termguicolors = true
opt.colorcolumn = "80"

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Persistent undo
local undo_directory = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undo_directory, "p")

opt.undodir = undo_directory
opt.undofile = true

-- System clipboard
opt.clipboard = "unnamedplus"

-- Better completion menu
opt.completeopt = { "menu", "menuone", "noselect" }

-- Cleaner netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

vim.opt.hidden = true
