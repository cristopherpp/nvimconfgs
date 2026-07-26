if not vim.pack then
    error("This configuration requires Neovim 0.12 or newer for vim.pack")
end

local github = function(repository)
    return "https://github.com/" .. repository
end

vim.pack.add({
    -- Shared dependencies must be declared before their consumers.
    {
        src = github("nvim-tree/nvim-web-devicons"),
        name = "nvim-web-devicons",
    },
    {
        src = github("nvim-lua/plenary.nvim"),
        name = "plenary.nvim",
    },

    -- Editor features.
    {
        src = github("nvim-tree/nvim-tree.lua"),
        name = "nvim-tree.lua",
    },
    {
        src = github("nvim-telescope/telescope.nvim"),
        name = "telescope.nvim",
    },
    {
        src = github("akinsho/toggleterm.nvim"),
        name = "toggleterm.nvim",
    },
    {
        src = github("nvim-treesitter/nvim-treesitter"),
        name = "nvim-treesitter",
    },
    {
        src = github("neovim/nvim-lspconfig"),
        name = "nvim-lspconfig",
    },
    {
        src = github("mfussenegger/nvim-lint"),
        name = "nvim-lint",
    },
    {
        src = github("stevearc/conform.nvim"),
        name = "conform.nvim",
    },
    {
        src = github("folke/tokyonight.nvim"),
        name = "tokyonight.nvim",
    },
}, {
    -- Install missing plugins automatically on a new machine.
    confirm = false,
})
