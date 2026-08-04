local available, conform = pcall(require, "conform")

if not available then
    return
end

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },

        c = { "clang_format" },
        cpp = { "clang_format" },

        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
    },
})

vim.keymap.set({ "n", "v" }, "<leader>lf", function()
    conform.format({
        async = true,
        lsp_format = "fallback",
    })
end, {
    desc = "Format file or selection",
})
