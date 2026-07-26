local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            ".git/",
            "dist/",
            "build/",
        },
    },
})

-- Search inside the current file
vim.keymap.set("n", "<C-f>", builtin.current_buffer_fuzzy_find, {
    desc = "Search current file",
})

-- Search files by name
vim.keymap.set("n", "<leader>ff", builtin.find_files, {
    desc = "Find files",
})

-- Search text throughout the project
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
    desc = "Search project text",
})

-- Recently opened files
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {
    desc = "Recent files",
})

-- Open buffers
vim.keymap.set("n", "<leader>fb", builtin.buffers, {
    desc = "Find buffers",
})
