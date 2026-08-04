local ok, cmp = pcall(require, "cmp")

if not ok then
    return
end

cmp.setup({
    preselect = cmp.PreselectMode.None,

    completion = {
        completeopt = "menu,menuone,noinsert",
    },

    snippet = {
        expand = function(arguments)
            vim.snippet.expand(arguments.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),

        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),

        ["<CR>"] = cmp.mapping.confirm({
            select = false,
        }),

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.snippet.active({
                direction = 1,
            }) then
                vim.snippet.jump(1)
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.snippet.active({
                direction = -1,
            }) then
                vim.snippet.jump(-1)
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
    }),

    sources = cmp.config.sources({
        {
            name = "nvim_lsp",
        },
        {
            name = "path",
        },
    }, {
        {
            name = "buffer",
            keyword_length = 3,
        },
    }),
})
