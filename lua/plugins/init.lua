return {
    -- Colorscheme
    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,

        config = function()
            require("rose-pine").setup({
                styles = {
                    transparency = true,
                },
            })

            vim.cmd.colorscheme("rose-pine")
        end,
    },

    -- Fuzzy finding
    {
        "nvim-telescope/telescope.nvim",
        version = "*",

        dependencies = {
            "nvim-lua/plenary.nvim",

            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },

        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")

            telescope.setup({})

            pcall(telescope.load_extension, "fzf")

            vim.keymap.set("n", "<leader>pf", builtin.find_files, {
                desc = "Find project files",
            })

            vim.keymap.set("n", "<C-p>", builtin.git_files, {
                desc = "Find Git files",
            })

            vim.keymap.set("n", "<leader>ps", builtin.live_grep, {
                desc = "Search project text",
            })

            vim.keymap.set("n", "<leader>pb", builtin.buffers, {
                desc = "Find buffers",
            })

            vim.keymap.set("n", "<leader>vh", builtin.help_tags, {
                desc = "Search help",
            })
        end,
    },

    -- Primeagen's project file navigation
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",

        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        config = function()
            local harpoon = require("harpoon")

            harpoon:setup()

            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end, {
                desc = "Add file to Harpoon",
            })

            vim.keymap.set("n", "<C-e>", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, {
                desc = "Open Harpoon",
            })

            vim.keymap.set("n", "<C-h>", function()
                harpoon:list():select(1)
            end)

            vim.keymap.set("n", "<C-t>", function()
                harpoon:list():select(2)
            end)

            vim.keymap.set("n", "<C-n>", function()
                harpoon:list():select(3)
            end)

            vim.keymap.set("n", "<C-s>", function()
                harpoon:list():select(4)
            end)
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            local treesitter = require("nvim-treesitter")

            treesitter.setup()

            local languages = {
                "lua",
                "vim",
                "vimdoc",
                "bash",
                "c",
                "cpp",
                "python",
                "javascript",
                "typescript",
                "html",
                "css",
                "json",
                "markdown",
            }

            treesitter.install(languages)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = languages,

                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },

    -- Native LSP configurations
    {
        "neovim/nvim-lspconfig",

        config = function()
            vim.lsp.enable("clangd")
            vim.lsp.enable("lua_ls")

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local opts = {
                        buffer = event.buf,
                        silent = true,
                    }

                    vim.keymap.set(
                        "n",
                        "gd",
                        vim.lsp.buf.definition,
                        opts
                    )

                    vim.keymap.set(
                        "n",
                        "K",
                        vim.lsp.buf.hover,
                        opts
                    )

                    vim.keymap.set(
                        "n",
                        "<leader>vrr",
                        vim.lsp.buf.references,
                        opts
                    )

                    vim.keymap.set(
                        "n",
                        "<leader>vrn",
                        vim.lsp.buf.rename,
                        opts
                    )

                    vim.keymap.set(
                        { "n", "v" },
                        "<leader>vca",
                        vim.lsp.buf.code_action,
                        opts
                    )

                    vim.keymap.set(
                        "i",
                        "<C-h>",
                        vim.lsp.buf.signature_help,
                        opts
                    )
                end,
            })
        end,
    },

    -- Git
    {
        "tpope/vim-fugitive",
        cmd = {
            "Git",
            "G",
        },
    },

    -- Persistent undo browser
    {
        "mbbill/undotree",

        keys = {
            {
                "<leader>u",
                "<cmd>UndotreeToggle<CR>",
                desc = "Toggle undo tree",
            },
        },
    },
}
