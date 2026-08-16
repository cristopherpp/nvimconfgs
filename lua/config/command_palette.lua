local palette = {}

local modes = {
	n = "Normal",
}

local function notify_error(message)
	vim.notify(message, vim.log.levels.ERROR, {
		title = "Command Palette",
	})
end

local function normalize_key(key)
	return vim.fn.keytrans(key)
end

local function collect_keymaps()
	local entries = {}
	local seen = {}

	local function add_mapping(mapping, mode, buffer_local)
		if not mapping.desc or mapping.desc == "" then
			return
		end

		local identifier = table.concat({
			mode,
			mapping.lhs,
			mapping.desc,
		}, ":")

		if seen[identifier] then
			return
		end

		seen[identifier] = true

		table.insert(entries, {
			kind = "keymap",
			label = mapping.desc,
			command = normalize_key(mapping.lhs),
			mode = mode,
			scope = buffer_local and "Buffer" or "Global",
			lhs = mapping.lhs,
		})
	end

	for mode in pairs(modes) do
		for _, mapping in ipairs(vim.api.nvim_get_keymap(mode)) do
			add_mapping(mapping, mode, false)
		end

		for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(0, mode)) do
			add_mapping(mapping, mode, true)
		end
	end

	return entries
end

local function get_commands()
	local success, commands = pcall(vim.api.nvim_get_commands, {
		builtin = true,
	})

	if success then
		return commands
	end

	return vim.api.nvim_get_commands({
		builtin = false,
	})
end

local function collect_commands()
	local entries = {}

	for name, command in pairs(get_commands()) do
		local label = name

		if command.definition and command.definition ~= "" and not command.definition:match("^<Lua") then
			label = name .. " — " .. command.definition
		end

		table.insert(entries, {
			kind = "command",
			label = label,
			command = ":" .. name,
			name = name,
			nargs = command.nargs,
		})
	end

	return entries
end

local function collect_entries()
	local entries = collect_keymaps()

	vim.list_extend(entries, collect_commands())

	table.sort(entries, function(left, right)
		if left.kind ~= right.kind then
			return left.kind < right.kind
		end

		return left.label:lower() < right.label:lower()
	end)

	return entries
end

local function execute_keymap(entry)
	local current_mode = vim.api.nvim_get_mode().mode

	if not current_mode:match("^" .. entry.mode) then
		vim.notify(
			string.format("%s is a %s-mode mapping", entry.command, modes[entry.mode] or entry.mode),
			vim.log.levels.WARN,
			{
				title = "Command Palette",
			}
		)

		return
	end

	local keys = vim.api.nvim_replace_termcodes(entry.lhs, true, false, true)

	vim.api.nvim_feedkeys(keys, "m", false)
end

local function execute_command(entry)
	if entry.nargs == "0" then
		local success, error_message = pcall(vim.cmd, entry.name)

		if not success then
			notify_error(error_message)
		end

		return
	end

	-- Commands accepting arguments open the command line so the
	-- necessary arguments can be completed manually.
	local keys = vim.api.nvim_replace_termcodes(":" .. entry.name .. " ", true, false, true)

	vim.api.nvim_feedkeys(keys, "n", false)
end

local function execute(entry)
	if entry.kind == "keymap" then
		execute_keymap(entry)
		return
	end

	execute_command(entry)
end

function palette.open()
	local telescope_available, pickers = pcall(require, "telescope.pickers")

	if not telescope_available then
		notify_error("Telescope is not available")
		return
	end

	local finders = require("telescope.finders")
	local config = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local entry_display = require("telescope.pickers.entry_display")

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{
				width = 10,
			},
			{
				remaining = true,
			},
			{
				width = 28,
			},
		},
	})

	local function make_display(entry)
		local category
		local category_highlight

		if entry.value.kind == "keymap" then
			category = entry.value.scope
			category_highlight = "TelescopeResultsIdentifier"
		else
			category = "Command"
			category_highlight = "TelescopeResultsNumber"
		end

		return displayer({
			{
				category,
				category_highlight,
			},
			entry.value.label,
			{
				entry.value.command,
				"TelescopeResultsComment",
			},
		})
	end

	pickers
		.new({}, {
			prompt_title = "Neovim Command Palette",
			results_title = "Actions and commands",
			preview_title = "Documentation",

			finder = finders.new_table({
				results = collect_entries(),

				entry_maker = function(item)
					return {
						value = item,
						display = make_display,
						ordinal = table.concat({
							item.kind,
							item.label,
							item.command,
							item.scope or "",
						}, " "),
					}
				end,
			}),

			sorter = config.generic_sorter({}),

			attach_mappings = function(prompt_buffer)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()

					actions.close(prompt_buffer)

					if selection then
						vim.schedule(function()
							execute(selection.value)
						end)
					end
				end)

				return true
			end,
		})
		:find()
end

return palette
