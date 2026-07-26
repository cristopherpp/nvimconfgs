local lint = require("lint")

lint.linters_by_ft = {
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    python = { "ruff" },
}

vim.api.nvim_create_autocmd({
    "BufEnter",
    "BufWritePost",
    "InsertLeave",
}, {
    callback = function()
        lint.try_lint()
    end,
})

vim.keymap.set("n", "<leader>ll", function()
    lint.try_lint()
end, {
    desc = "Lint current file",
})
