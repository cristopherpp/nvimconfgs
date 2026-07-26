local servers = {
    "clangd",  -- C and C++
    "pyright", -- Python
    "lua_ls",  -- Lua
    "ts_ls",   -- JavaScript and TypeScript
    "html",
    "cssls",
    "jsonls",
}

vim.lsp.config("clangd", {
    filetypes = {
        "c",
        "cpp",
        "objc",
        "objcpp",
        "cuda",
    },
})

for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local options = {
            buffer = event.buf,
            silent = true,
        }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, options)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, options)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, options)
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, options)
        vim.keymap.set(
            { "n", "v" },
            "<leader>la",
            vim.lsp.buf.code_action,
            options
        )
        vim.keymap.set(
            "n",
            "<leader>ld",
            vim.diagnostic.open_float,
            options
        )
    end,
})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})
