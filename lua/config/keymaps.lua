local map = vim.keymap.set

local function options(description)
	return {
		noremap = true,
		silent = true,
		desc = description,
	}
end

local function open_command_palette()
	require("config.command_palette").open()
end

map("n", "<C-S-p>", open_command_palette, options("Open command palette"))

map("n", "<leader>cp", open_command_palette, options("Open command palette"))

-- File explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", options("Toggle file explorer"))

-- Save
map({ "n", "i", "x" }, "<C-s>", "<cmd>write<CR>", options("Save file"))

-- Quit
map("n", "<leader>q", "<cmd>quit<CR>", options("Quit window"))

map("n", "<leader>Q", "<cmd>quit!<CR>", options("Force quit window"))

-- Select everything
map("n", "<C-a>", "ggVG", options("Select entire file"))

-- System clipboard
map("x", "<C-c>", '"+y', options("Copy selection to clipboard"))

map({ "n", "x" }, "<leader>y", '"+y', options("Copy to system clipboard"))

map("n", "<leader>Y", '"+Y', options("Copy line to system clipboard"))

map({ "n", "x" }, "<leader>p", '"+p', options("Paste from system clipboard"))

-- Keep the copied text after replacing a selection.
map("x", "p", [["_dP]], options("Paste without replacing register"))

-- Delete without replacing copied text.
map({ "n", "x" }, "<leader>d", [["_d]], options("Delete without copying"))

-- Move selected lines
map("x", "J", ":move '>+1<CR>gv=gv", options("Move selection down"))

map("x", "K", ":move '<-2<CR>gv=gv", options("Move selection up"))

-- Center the cursor after navigation
map("n", "<C-d>", "<C-d>zz", options("Scroll down and center"))

map("n", "<C-u>", "<C-u>zz", options("Scroll up and center"))

map("n", "n", "nzzzv", options("Next search result and center"))

map("n", "N", "Nzzzv", options("Previous search result and center"))

-- Join lines without moving the cursor
map("n", "J", "mzJ`z", options("Join lines without moving cursor"))

-- Window navigation
map("n", "<C-h>", "<C-w>h", options("Move to left window"))

map("n", "<C-j>", "<C-w>j", options("Move to lower window"))

map("n", "<C-k>", "<C-w>k", options("Move to upper window"))

map("n", "<C-l>", "<C-w>l", options("Move to right window"))

-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<CR>", options("Clear search highlighting"))

-- Start a project-wide replacement for the word under the cursor.
map("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], options("Replace word in current file"))

-- Latin American keyboard helpers
map({ "n", "x" }, "ñ", ":", options("Enter command mode"))

map("n", "Ñ", ";", options("Repeat character movement"))

-- Diagnostics
map("n", "]d", function()
	vim.diagnostic.jump({
		count = 1,
		float = true,
	})
end, options("Next diagnostic"))

map("n", "[d", function()
	vim.diagnostic.jump({
		count = -1,
		float = true,
	})
end, options("Previous diagnostic"))

map("n", "<leader>ld", vim.diagnostic.open_float, options("Show line diagnostic"))

map("n", "<leader>lq", vim.diagnostic.setloclist, options("Send diagnostics to location list"))

-- Quickfix navigation
map("n", "]q", "<cmd>cnext<CR>zz", options("Next quickfix item"))

map("n", "[q", "<cmd>cprevious<CR>zz", options("Previous quickfix item"))
