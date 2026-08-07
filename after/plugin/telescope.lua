local telescope_available, telescope = pcall(require, "telescope")
local builtin_available, builtin = pcall(require, "telescope.builtin")

if not telescope_available or not builtin_available then
    return
end

telescope.setup({
    defaults = {
        path_display = {
            "smart",
        },
    },

    pickers = {
        find_files = {
            hidden = true,
        },
    },
})

local map = vim.keymap.set

local function project_root()
    return vim.fs.root(0, {
        ".git",
        "package.json",
        "pyproject.toml",
        "CMakeLists.txt",
        "Makefile",
    }) or vim.uv.cwd()
end

-- Search current file
map("n", "<C-f>", function()
    builtin.current_buffer_fuzzy_find({
        previewer = false,
    })
end, {
    desc = "Search current file",
})

-- Project files
map("n", "<leader>ff", function()
    builtin.find_files({
        cwd = project_root(),
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true,
    })
end, {
    desc = "Find project files",
})

-- Whole-project text search
map("n", "<leader>sg", function()
    builtin.live_grep({
        cwd = project_root(),
    })
end, {
    desc = "Search project text",
})

map("n", "<leader>fg", function()
    builtin.live_grep({
        cwd = project_root(),
    })
end, {
    desc = "Search project text",
})

map("n", "<leader>sw", function()
    builtin.grep_string({
        cwd = project_root(),
    })
end, {
    desc = "Search word under cursor",
})

map("n", "<leader>sb", builtin.buffers, {
    desc = "Search buffers",
})

map("n", "<leader>sr", builtin.resume, {
    desc = "Resume latest search",
})

map("n", "<leader>sh", builtin.help_tags, {
    desc = "Search Neovim help",
})

map("n", "<leader>sd", builtin.diagnostics, {
    desc = "Search diagnostics",
})

map("n", "<leader>sq", builtin.quickfix, {
    desc = "Search quickfix list",
})

map("n", "<leader>sl", builtin.loclist, {
    desc = "Search location list",
})

-- Neovim configuration
local config_directory = vim.fn.stdpath("config")

map("n", "<leader>nf", function()
    builtin.find_files({
        cwd = config_directory,
        hidden = true,
    })
end, {
    desc = "Find Neovim config file",
})

map("n", "<leader>ni", function()
    vim.cmd.edit(
        vim.fn.fnameescape(config_directory .. "/init.lua")
    )
end, {
    desc = "Edit init.lua",
})

map("n", "<leader>np", function()
    vim.cmd.edit(
        vim.fn.fnameescape(
            config_directory .. "/lua/config/plugins.lua"
        )
    )
end, {
    desc = "Edit plugins.lua",
})

map("n", "<leader>nk", function()
    vim.cmd.edit(
        vim.fn.fnameescape(
            config_directory .. "/lua/config/keymaps.lua"
        )
    )
end, {
    desc = "Edit keymaps.lua",
})

map("n", "<leader>nr", "<cmd>restart<CR>", {
    desc = "Restart Neovim",
})
