local telescope_available, telescope = pcall(require, "telescope")
local builtin_available, builtin = pcall(require, "telescope.builtin")

if not telescope_available or not builtin_available then
	vim.notify("Telescope could not be loaded", vim.log.levels.ERROR)

	return
end

local project = require("config.project")
local platform = require("config.platform")
local map = vim.keymap.set

telescope.setup({
	defaults = {
		path_display = {
			"smart",
		},
	},

	pickers = {
		find_files = {
			-- Show dotfiles while respecting .gitignore.
			hidden = true,
		},
	},
})

-- Search inside the current file.
map("n", "<C-f>", function()
	builtin.current_buffer_fuzzy_find({
		previewer = false,
	})
end, {
	desc = "Search current file",
})

-- Find project files while respecting .gitignore.
map("n", "<leader>ff", function()
	builtin.find_files({
		cwd = project.root(),
	})
end, {
	desc = "Find project files",
})

-- Find hidden and ignored files, excluding generated directories.
map("n", "<leader>fa", function()
	builtin.find_files({
		cwd = project.root(),
		hidden = true,
		no_ignore = true,
		no_ignore_parent = true,

		file_ignore_patterns = {
			"%.git/",
			"node_modules/",
			"%.nuxt/",
			"dist/",
			"coverage/",
			"target/",
			"vendor/",
		},
	})
end, {
	desc = "Find all files including ignored",
})

-- Find recently opened project files.
map("n", "<leader>fo", function()
	builtin.oldfiles({
		cwd_only = true,
	})
end, {
	desc = "Find recent project files",
})

-- Search text throughout the project.
map("n", "<leader>sg", function()
	builtin.live_grep({
		cwd = project.root(),

		additional_args = function()
			return {
				"--hidden",
				"--glob",
				"!**/.git/*",
				"--glob",
				"!**/node_modules/*",
				"--glob",
				"!**/.nuxt/*",
				"--glob",
				"!**/dist/*",
				"--glob",
				"!**/coverage/*",
				"--glob",
				"!**/target/*",
				"--glob",
				"!**/vendor/*",
			}
		end,
	})
end, {
	desc = "Search project text",
})

-- Search for the word under the cursor.
map("n", "<leader>sw", function()
	builtin.grep_string({
		cwd = project.root(),
	})
end, {
	desc = "Search word under cursor",
})

-- General search utilities.
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

map("n", "<leader>sj", builtin.jumplist, {
	desc = "Search jump history",
})

map("n", "<leader>sc", function()
	require("config.theme").select()
end, {
	desc = "Select and save colorscheme",
})

-- Neovim configuration.
local config_directory = platform.config

map("n", "<leader>nf", function()
	builtin.find_files({
		cwd = config_directory,
		hidden = true,
	})
end, {
	desc = "Find Neovim config file",
})

map("n", "<leader>ni", function()
	vim.cmd.edit(vim.fn.fnameescape(platform.joinpath(config_directory, "init.lua")))
end, {
	desc = "Edit init.lua",
})

map("n", "<leader>np", function()
	vim.cmd.edit(vim.fn.fnameescape(platform.joinpath(config_directory, "lua", "config", "plugins.lua")))
end, {
	desc = "Edit plugins.lua",
})

map("n", "<leader>nk", function()
	vim.cmd.edit(vim.fn.fnameescape(platform.joinpath(config_directory, "lua", "config", "keymaps.lua")))
end, {
	desc = "Edit keymaps.lua",
})

map("n", "<leader>nr", "<cmd>restart<CR>", {
	desc = "Restart Neovim",
})
