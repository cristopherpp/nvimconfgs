local map = vim.keymap.set

-- Fugitive
if vim.fn.exists(":Git") == 2 then
	map("n", "<leader>gg", "<cmd>Git<CR>", {
		desc = "Git status",
	})

	map("n", "<leader>gb", "<cmd>Git blame<CR>", {
		desc = "Git blame file",
	})

	map("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", {
		desc = "Git diff split",
	})
end
