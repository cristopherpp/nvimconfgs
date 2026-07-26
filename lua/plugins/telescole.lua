local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({})

vim.keymap.set("n", "<leader>ff", builtin.find_files, {
    desc = "Find files",
})

vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
    desc = "Search text",
})

vim.keymap.set("n", "<leader>fb", builtin.buffers, {
    desc = "Find buffers",
})

vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
    desc = "Search help",
})
