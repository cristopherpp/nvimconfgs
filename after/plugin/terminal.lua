require("toggleterm").setup({
    size = 15,
    direction = "float",
    start_in_insert = true,
    close_on_exit = true,

    float_opts = {
        border = "rounded",
    },
})

vim.keymap.set({ "n", "t" }, "<leader>tt", "<cmd>ToggleTerm<CR>", {
    desc = "Toggle terminal",
})

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], {
    desc = "Leave terminal mode",
})
