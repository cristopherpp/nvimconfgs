local available, which_key = pcall(require, "which-key")

if not available then
    return
end

which_key.setup({
    preset = "modern",
    delay = 150,
    triggers = {
        { "<leader>", mode = { "n", "v" } },
    },
    win = {
        border = "rounded",
    },
    icons = {
        mappings = true,
    },
})

which_key.add({
    { "<leader>b", group = "buffers" },
    { "<leader>f", group = "files" },
    { "<leader>l", group = "language tools" },
    { "<leader>n", group = "Neovim config" },
    { "<leader>s", group = "search" },
    { "<leader>t", group = "terminal" },
    {
        "<leader>g",
        group = "git",
    },
    {
        "<leader>h",
        group = "harpoon",
    },
    {
        "<leader>u",
        desc = "Undo tree",
    },
})

vim.keymap.set("n", "<leader>?", function()
    which_key.show({ global = false })
end, {
    desc = "Buffer-local keymaps",
})
