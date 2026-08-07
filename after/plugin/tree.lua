local available, tree = pcall(require, "nvim-tree")

if not available then
    return
end

local api = require("nvim-tree.api")

tree.setup({
    view = {
        width = 35,
    },

    renderer = {
        group_empty = true,

        icons = {
            show = {
                file = true,
                folder = true,
                git = true,
            },
        },
    },

    filters = {
        dotfiles = false,
        git_ignored = false,
        custom = {
            "^%.git$",
        }
    },

    git = {
        enable = true,
    },
})

vim.keymap.set("n", "<leader>e", function()
    api.tree.toggle({
        find_file = true,
        focus = true,
    })
end, {
    desc = "Toggle file explorer",
})
