local available, toggleterm = pcall(require, "toggleterm")

if not available then
	return
end

local terminal_api = require("toggleterm.terminal")
local map = vim.keymap.set
local platform = require("config.platform")

toggleterm.setup({
	shell = platform.shell,
	direction = "float",
	start_in_insert = true,
	close_on_exit = true,
	shade_terminals = false,

	float_opts = {
		border = "rounded",

		width = function()
			return math.floor(vim.o.columns * 0.85)
		end,

		height = function()
			return math.floor(vim.o.lines * 0.80)
		end,

		title_pos = "center",
	},
})

local function delete_terminal()
	local terminals = terminal_api.get_all()

	if #terminals == 0 then
		vim.notify("There are no terminals to delete", vim.log.levels.INFO)
		return
	end

	vim.ui.select(terminals, {
		prompt = "Delete terminal:",

		format_item = function(terminal)
			local name = terminal.display_name

			if name and name ~= "" then
				return string.format("Terminal %d — %s", terminal.id, name)
			end

			return string.format("Terminal %d", terminal.id)
		end,
	}, function(terminal)
		if not terminal then
			return
		end

		local terminal_id = terminal.id

		terminal:shutdown()

		vim.notify(string.format("Deleted terminal %d", terminal_id))
	end)
end

-- Toggle the last selected terminal.
-- This hides it without terminating its process.
map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", {
	desc = "Toggle current terminal",
})

-- Always create a completely new floating terminal.
map("n", "<leader>tn", "<cmd>TermNew direction=float<CR>", {
	desc = "Create new terminal",
})

-- Select and open an existing terminal.
map("n", "<leader>ts", "<cmd>TermSelect<CR>", {
	desc = "Select terminal",
})

-- Give terminals useful names such as server, tests or database.
map("n", "<leader>tr", "<cmd>ToggleTermSetName<CR>", {
	desc = "Rename terminal",
})

-- Select a terminal and permanently terminate/delete it.
map("n", "<leader>td", delete_terminal, {
	desc = "Delete terminal",
})

-- Terminal-mode mappings.
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*toggleterm#*",

	callback = function(event)
		map("t", "<Esc><Esc>", [[<C-\><C-n>]], {
			buffer = event.buf,
			desc = "Leave terminal mode",
		})

		map("t", "<C-q>", [[<C-\><C-n><cmd>ToggleTerm<CR>]], {
			buffer = event.buf,
			desc = "Hide terminal",
		})
	end,
})
