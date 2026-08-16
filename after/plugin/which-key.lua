local available, which_key = pcall(require, "which-key")

if not available then
	return
end

which_key.setup({
	preset = "modern",

	delay = function(context)
		-- Plugin-generated menus can appear immediately.
		return context.plugin and 0 or 150
	end,

	win = {
		border = "rounded",
		padding = {
			1,
			2,
		},
	},

	layout = {
		width = {
			min = 20,
			max = 50,
		},
		spacing = 3,
	},

	icons = {
		mappings = true,
	},

	-- These document Neovim's built-in command families.
	plugins = {
		marks = true,
		registers = true,

		spelling = {
			enabled = true,
			suggestions = 20,
		},

		presets = {
			operators = true,
			motions = true,
			text_objects = true,
			windows = true,
			nav = true,
			z = true,
			g = true,
		},
	},

	-- Prefer buffer-local commands, then groups and mappings.
	sort = {
		"local",
		"order",
		"group",
		"alphanum",
		"mod",
	},

	-- Let WhichKey automatically discover relevant prefixes.
	-- Do not restrict it to <leader>.
	triggers = {
		{
			"<auto>",
			mode = {
				"n",
				"x",
				"s",
				"o",
			},
		},
	},

	show_help = true,
	show_keys = true,
})

which_key.add({
	{
		"<leader>b",
		group = "buffers",
		icon = "󰓩",
	},
	{
		"<leader>f",
		group = "files",
		icon = "󰈞",
	},
	{
		"<leader>g",
		group = "git",
		icon = "󰊢",
	},
	{
		"<leader>h",
		group = "harpoon",
		icon = "󰀱",
	},
	{
		"<leader>l",
		group = "language",
		icon = "󰘦",
	},
	{
		"<leader>n",
		group = "Neovim config",
		icon = "",
	},
	{
		"<leader>s",
		group = "search",
		icon = "󰍉",
	},
	{
		"<leader>t",
		group = "terminal",
		icon = "",
	},

	-- Optional: access native window commands through Space+w.
	{
		"<leader>w",
		group = "windows",
		proxy = "<C-w>",
		icon = "󰖲",
	},
	{
		"<leader>r",
		group = "replace",
		icon = "󰛔",
	},
	{
		"<leader>c",
		group = "commands",
		icon = "",
	},
})

vim.keymap.set("n", "<leader>?", function()
	which_key.show({
		global = false,
	})
end, {
	desc = "Show buffer-local keymaps",
})
