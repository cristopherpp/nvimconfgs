local function github(repository)
    return "https://github.com/" .. repository
end

local plugins = {
    -- Shared dependencies
    {
        src = github("nvim-tree/nvim-web-devicons"),
        name = "nvim-web-devicons",
    },
    {
        src = github("nvim-lua/plenary.nvim"),
        name = "plenary.nvim",
    },

    -- Navigation
    {
        src = github("nvim-tree/nvim-tree.lua"),
        name = "nvim-tree.lua",
    },
    {
        src = github("nvim-telescope/telescope.nvim"),
        name = "telescope.nvim",
    },
    {
        src = github("ThePrimeagen/harpoon"),
        name = "harpoon",
        version = "harpoon2",
    },

    -- Interface
    {
        src = github("folke/which-key.nvim"),
        name = "which-key.nvim",
    },
    {
        src = github("akinsho/toggleterm.nvim"),
        name = "toggleterm.nvim",
    },
    {
        src = github("folke/tokyonight.nvim"),
        name = "tokyonight.nvim",
    },

    -- Languages
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

    -- Completion
    {
        src = github("hrsh7th/nvim-cmp"),
        name = "nvim-cmp",
    },
    {
        src = github("hrsh7th/cmp-nvim-lsp"),
        name = "cmp-nvim-lsp",
    },
    {
        src = github("hrsh7th/cmp-buffer"),
        name = "cmp-buffer",
    },
    {
        src = github("hrsh7th/cmp-path"),
        name = "cmp-path",
    },

    -- Git
    {
        src = github("lewis6991/gitsigns.nvim"),
        name = "gitsigns.nvim",
    },
    {
        src = github("tpope/vim-fugitive"),
        name = "vim-fugitive",
    },

    -- History
    {
        src = github("mbbill/undotree"),
        name = "undotree",
    },
    {
        src = github("akinsho/bufferline.nvim"),
        name = "bufferline.nvim",
    },
}

local pack_ok, pack_error = pcall(vim.pack.add, plugins, {
    confirm = false,
})

if not pack_ok then
    vim.schedule(function()
        vim.notify(
            "vim.pack could not load plugins:\n" .. tostring(pack_error),
            vim.log.levels.ERROR
        )
    end)
end
