ocal telescope_available, telescope = pcall(require, "telescope")
local builtin_available, builtin = pcall(require, "telescope.builtin")

if not telescope_available or not builtin_available then
    return
end

telescope.setup({
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            ".git/",
            "dist/",
            "build/",
        },
    },
})

local map = vim.keymap.set

local function project_root()
    local lsp_clients = vim.lsp.get_clients({ bufnr = 0 })

    for _, client in ipairs(lsp_clients) do
        if client.root_dir then
            return client.root_dir
        end
    end

    return vim.fs.root(0, {
        ".git",
        "package.json",
        "pyproject.toml",
        "CMakeLists.txt",
        "Makefile",
    }) or vim.uv.cwd()
end

local function find_project_files()
    builtin.find_files({
        cwd = project_root(),
        hidden = true,
    })
end

local function grep_project()
    builtin.live_grep({
        cwd = project_root(),
    })
end

local function grep_current_word()
    builtin.grep_string({
        cwd = project_root(),
    })
end

local function find_config_files()
    builtin.find_files({
        cwd = vim.fn.stdpath("config"),
        hidden = true,
    })
end

map("n", "<C-f>", builtin.current_buffer_fuzzy_find, {
    desc = "Search current file",
})

map("n", "<leader>ff", find_project_files, {
    desc = "Find project files",
})

map("n", "<leader>fr", builtin.oldfiles, {
    desc = "Recent files",
})

map("n", "<leader>fb", builtin.buffers, {
    desc = "Open buffers",
})

map("n", "<leader>sg", grep_project, {
    desc = "Grep whole project",
})

-- Keep the previous project-grep mapping as a compatibility alias.
map("n", "<leader>fg", grep_project, {
    desc = "Grep whole project",
})

map("n", "<leader>sw", grep_current_word, {
    desc = "Search word under cursor",
})

map("n", "<leader>sb", builtin.current_buffer_fuzzy_find, {
    desc = "Search current buffer",
})

map("n", "<leader>sr", builtin.resume, {
    desc = "Resume last search",
})

map("n", "<leader>sh", builtin.help_tags, {
    desc = "Search Neovim help",
})

map("n", "<leader>nf", find_config_files, {
    desc = "Find config file",
})

map("n", "<leader>ni", function()
    vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
end, {
    desc = "Edit init.lua",
})

map("n", "<leader>np", function()
    vim.cmd.edit(vim.fn.stdpath("config") .. "/lua/config/plugins.lua")
end, {
    desc = "Edit plugins.lua",
})

map("n", "<leader>nk", function()
    vim.cmd.edit(vim.fn.stdpath("config") .. "/lua/config/keymaps.lua")
end, {
    desc = "Edit keymaps.lua",
})

map("n", "<leader>nr", "<cmd>restart<CR>", {
    desc = "Restart Neovim",
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
