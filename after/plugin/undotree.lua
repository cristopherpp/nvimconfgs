if vim.fn.exists(":UndotreeToggle") ~= 2 then
    return
end

vim.g.undotree_SetFocusWhenToggle = 1

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", {
    desc = "Toggle undo tree",
})
