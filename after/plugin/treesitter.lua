local treesitter = require("nvim-treesitter")

treesitter.setup()

local parsers = {
    "lua",
    "vim",
    "vimdoc",
    "bash",
    "c",
    "cpp",
    "python",
    "javascript",
    "typescript",
    "tsx",
    "html",
    "css",
    "json",
    "yaml",
    "markdown",
    "markdown_inline",
}

treesitter.install(parsers)

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "lua",
        "vim",
        "help",
        "bash",
        "sh",
        "c",
        "cpp",
        "python",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "html",
        "css",
        "json",
        "yaml",
        "markdown",
    },

    callback = function()
        pcall(vim.treesitter.start)
    end,
})
