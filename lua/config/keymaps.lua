local map = vim.keymap.set

local opts = {
    noremap = true,
    silent = true,
}

-- File explorer: Space + e
map("n", "<leader>e", vim.cmd.Ex, {
    desc = "Open file explorer",
})

-- Primeagen's original explorer mapping: Space + p + v
map("n", "<leader>pv", vim.cmd.Ex, {
    desc = "Open file explorer",
})

-- Save: Ctrl + s
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", {
    desc = "Save file",
})

-- Quit: Space + q
map("n", "<leader>q", "<cmd>q<CR>", {
    desc = "Quit",
})

-- Force quit: Space + Q
map("n", "<leader>Q", "<cmd>q!<CR>", {
    desc = "Force quit",
})

-- Select everything: Ctrl + a
map("n", "<C-a>", "ggVG", {
    desc = "Select all",
})

-- Copy to system clipboard
map("v", "<C-c>", '"+y', {
    desc = "Copy selection",
})

map({ "n", "v" }, "<leader>y", '"+y', {
    desc = "Copy to system clipboard",
})

map("n", "<leader>Y", '"+Y', {
    desc = "Copy line to system clipboard",
})

-- Paste from system clipboard
map({ "n", "v" }, "<C-v>", '"+p', {
    desc = "Paste from system clipboard",
})

map({ "n", "v" }, "<leader>p", '"+p', {
    desc = "Paste from system clipboard",
})

-- Keep copied text after pasting over a selection
map("x", "p", [["_dP]], {
    desc = "Paste without replacing register",
})

-- Delete without replacing copied text
map({ "n", "v" }, "<leader>d", [["_d]], {
    desc = "Delete without copying",
})

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Join lines without moving the cursor
map("n", "J", "mzJ`z", opts)

-- Window navigation
map("n", "<C-h>", "<C-w>h", {
    desc = "Move to left window",
})

map("n", "<C-j>", "<C-w>j", {
    desc = "Move to lower window",
})

map("n", "<C-k>", "<C-w>k", {
    desc = "Move to upper window",
})

map("n", "<C-l>", "<C-w>l", {
    desc = "Move to right window",
})

-- Buffer navigation
map("n", "<leader>bn", "<cmd>bnext<CR>", {
    desc = "Next buffer",
})

map("n", "<leader>bp", "<cmd>bprevious<CR>", {
    desc = "Previous buffer",
})

map("n", "<leader>bd", "<cmd>bdelete<CR>", {
    desc = "Delete buffer",
})

-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<CR>", {
    desc = "Clear search highlighting",
})

-- Replace the word under the cursor
map(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    {
        desc = "Replace word under cursor",
    }
)

-- Latin American keyboard helpers
-- ñ opens command mode, like :
map("n", "ñ", ":", {
    desc = "Enter command mode",
})

-- Ñ repeats the latest f/F/t/T movement, like ;
map("n", "Ñ", ";", {
    desc = "Repeat character movement",
})

-- Diagnostics
map("n", "]d", function()
    vim.diagnostic.jump({
        count = 1,
        float = true,
    })
end, {
    desc = "Next diagnostic",
})

map("n", "[d", function()
    vim.diagnostic.jump({
        count = -1,
        float = true,
    })
end, {
    desc = "Previous diagnostic",
})

map("n", "<leader>ld", vim.diagnostic.open_float, {
    desc = "Show line diagnostic",
})

map("n", "<leader>lq", vim.diagnostic.setloclist, {
    desc = "Diagnostics to location list",
})

-- Quickfix navigation
map("n", "]q", "<cmd>cnext<CR>zz", {
    desc = "Next quickfix item",
})

map("n", "[q", "<cmd>cprevious<CR>zz", {
    desc = "Previous quickfix item",
})

map("n", "<leader>sq", "<cmd>copen<CR>", {
    desc = "Open quickfix list",
})
