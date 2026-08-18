local theme = {}
local platform = require("config.platform")

local default_theme = "tokyonight-night"

local state_directory = platform.state
local state_file = platform.joinpath(state_directory, "theme.txt")

local function read_saved_theme()
	if not vim.uv.fs_stat(state_file) then
		return nil
	end

	local lines = vim.fn.readfile(state_file)

	if not lines or not lines[1] or lines[1] == "" then
		return nil
	end

	return vim.trim(lines[1])
end

local function save_theme(name)
	vim.fn.mkdir(state_directory, "p")

	local result = vim.fn.writefile({
		name,
	}, state_file)

	if result ~= 0 then
		vim.notify("Could not save colorscheme: " .. name, vim.log.levels.ERROR)

		return false
	end

	return true
end

function theme.set(name)
	if not name or name == "" then
		return false
	end

	local success, error_message = pcall(vim.cmd.colorscheme, name)

	if not success then
		vim.notify("Could not load colorscheme " .. name .. ": " .. tostring(error_message), vim.log.levels.ERROR)

		return false
	end

	if save_theme(name) then
		vim.notify("Colorscheme saved: " .. name, vim.log.levels.INFO)
	end

	return true
end

function theme.load()
	local saved_theme = read_saved_theme()
	local selected_theme = saved_theme or default_theme

	if pcall(vim.cmd.colorscheme, selected_theme) then
		return
	end

	vim.notify("Could not load colorscheme: " .. selected_theme, vim.log.levels.WARN)

	pcall(vim.cmd.colorscheme, default_theme)
end

function theme.select()
	local available, builtin = pcall(require, "telescope.builtin")

	if not available then
		vim.notify("Telescope is not available", vim.log.levels.ERROR)

		return
	end

	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	builtin.colorscheme({
		enable_preview = true,

		attach_mappings = function(prompt_buffer)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()

				if not selection then
					return
				end

				local selected_theme = selection.value or selection[1] or selection.ordinal

				actions.close(prompt_buffer)

				vim.schedule(function()
					theme.set(selected_theme)
				end)
			end)

			return true
		end,
	})
end

return theme
