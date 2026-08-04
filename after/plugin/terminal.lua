local available, toggleterm = pcall(require, "toggleterm")

if not available then
    return
end

toggleterm.setup({
    size = 15,
    direction = "float",
    start_in_insert = true,
    close_on_exit = true,
    persist_size = true,
    float_opts = {
        border = "rounded",
    },
})

local map = vim.keymap.set

map({ "n", "t" }, "<leader>tt", "<cmd>ToggleTerm<CR>", {
    desc = "Toggle last terminal",
})

map("n", "<leader>tn", "<cmd>TermNew direction=float<CR>", {
    desc = "New floating terminal",
})

map("n", "<leader>th", "<cmd>TermNew direction=horizontal<CR>", {
    desc = "New horizontal terminal",
})

map("n", "<leader>tv", "<cmd>TermNew direction=vertical<CR>", {
    desc = "New vertical terminal",
})

map("n", "<leader>ts", "<cmd>TermSelect<CR>", {
    desc = "Select terminal",
})

map("t", "<Esc><Esc>", [[<C-\><C-n>]], {
    desc = "Leave terminal mode",
})

map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], {
    desc = "Move to left window",
})

map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], {
    desc = "Move to lower window",
})

map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], {
    desc = "Move to upper window",
})

map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], {
    desc = "Move to right window",
})
