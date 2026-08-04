local available, tokyonight = pcall(require, "tokyonight")

if not available then
    vim.cmd.colorscheme("habamax")
    return
end

tokyonight.setup({
    style = "night",
})

vim.cmd.colorscheme("tokyonight")
