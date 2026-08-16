local available, gitsigns = pcall(require, "gitsigns")

if not available then
	vim.notify("gitsigns.nvim could not be loaded", vim.log.levels.ERROR)

	return
end

local function confirm_reset(message, action)
	local choice = vim.fn.confirm(message, "&Reset\n&Cancel", 2)

	if choice == 1 then
		action()
	end
end

gitsigns.setup({
	signs = {
		add = {
			text = "┃",
		},
		change = {
			text = "┃",
		},
		delete = {
			text = "_",
		},
		topdelete = {
			text = "‾",
		},
		changedelete = {
			text = "~",
		},
		untracked = {
			text = "┆",
		},
	},

	signs_staged = {
		add = {
			text = "┃",
		},
		change = {
			text = "┃",
		},
		delete = {
			text = "_",
		},
		topdelete = {
			text = "‾",
		},
		changedelete = {
			text = "~",
		},
		untracked = {
			text = "┆",
		},
	},

	signcolumn = true,
	numhl = false,
	linehl = false,
	word_diff = false,

	signs_staged_enable = true,
	attach_to_untracked = true,

	current_line_blame = false,

	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 700,
		ignore_whitespace = false,
	},

	on_attach = function(buffer_number)
		local function map(mode, lhs, rhs, description)
			vim.keymap.set(mode, lhs, rhs, {
				buffer = buffer_number,
				silent = true,
				desc = description,
			})
		end

		-- Hunk navigation
		map("n", "]h", function()
			gitsigns.nav_hunk("next")
		end, "Next Git hunk")

		map("n", "[h", function()
			gitsigns.nav_hunk("prev")
		end, "Previous Git hunk")

		-- Stage hunks
		map("n", "<leader>gs", gitsigns.stage_hunk, "Stage Git hunk")

		map("x", "<leader>gs", function()
			gitsigns.stage_hunk({
				vim.fn.line("."),
				vim.fn.line("v"),
			})
		end, "Stage selected Git hunk")

		map("n", "<leader>gu", gitsigns.undo_stage_hunk, "Undo staged Git hunk")

		-- Reset hunks with confirmation
		map("n", "<leader>gr", function()
			confirm_reset("Discard changes in the current hunk?", gitsigns.reset_hunk)
		end, "Reset Git hunk")

		map("x", "<leader>gr", function()
			local range = {
				vim.fn.line("."),
				vim.fn.line("v"),
			}

			confirm_reset("Discard changes in the selected hunk?", function()
				gitsigns.reset_hunk(range)
			end)
		end, "Reset selected Git hunk")

		-- Inspect changes
		map("n", "<leader>gp", gitsigns.preview_hunk, "Preview Git hunk")

		map("n", "<leader>gi", gitsigns.preview_hunk_inline, "Preview Git hunk inline")

		map("n", "<leader>gb", function()
			gitsigns.blame_line({
				full = true,
			})
		end, "Show Git blame")

		map("n", "<leader>gd", gitsigns.diffthis, "Diff file against index")

		map("n", "<leader>gD", function()
			gitsigns.diffthis("~")
		end, "Diff file against previous commit")

		-- Send changes to quickfix
		map("n", "<leader>gq", gitsigns.setqflist, "Current file Git hunks")

		map("n", "<leader>gQ", function()
			gitsigns.setqflist("all")
		end, "Project Git hunks")

		-- Optional views
		map("n", "<leader>gl", gitsigns.toggle_current_line_blame, "Toggle Git line blame")

		map("n", "<leader>gw", gitsigns.toggle_word_diff, "Toggle Git word diff")

		-- Git hunk text object: dih, yih, vih, etc.
		map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select Git hunk")
	end,
})
