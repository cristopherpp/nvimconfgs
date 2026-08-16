local telescope_available, builtin = pcall(require, "telescope.builtin")

local map = vim.keymap.set

local function telescope_or(telescope_picker, fallback)
	return function()
		if telescope_available and builtin[telescope_picker] then
			builtin[telescope_picker]()
			return
		end

		fallback()
	end
end

local navigation_group = vim.api.nvim_create_augroup("lsp_navigation", {
	clear = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = navigation_group,

	callback = function(event)
		local function options(description)
			return {
				buffer = event.buf,
				silent = true,
				desc = description,
			}
		end

		-- Semantic navigation
		map("n", "gd", telescope_or("lsp_definitions", vim.lsp.buf.definition), options("Go to definition"))

		map("n", "gD", vim.lsp.buf.declaration, options("Go to declaration"))

		map("n", "grr", telescope_or("lsp_references", vim.lsp.buf.references), options("Find references"))

		map(
			"n",
			"gri",
			telescope_or("lsp_implementations", vim.lsp.buf.implementation),
			options("Go to implementation")
		)

		map(
			"n",
			"grt",
			telescope_or("lsp_type_definitions", vim.lsp.buf.type_definition),
			options("Go to type definition")
		)

		-- Documentation and refactoring
		map("n", "K", vim.lsp.buf.hover, options("Show symbol documentation"))

		map("n", "<leader>lr", vim.lsp.buf.rename, options("Rename symbol"))

		map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, options("Code action"))

		-- Symbol search
		map(
			"n",
			"<leader>ss",
			telescope_or("lsp_document_symbols", vim.lsp.buf.document_symbol),
			options("Search document symbols")
		)

		map(
			"n",
			"<leader>sS",
			telescope_or("lsp_dynamic_workspace_symbols", function()
				vim.lsp.buf.workspace_symbol("")
			end),
			options("Search workspace symbols")
		)

		-- Call hierarchy
		map(
			"n",
			"<leader>si",
			telescope_or("lsp_incoming_calls", vim.lsp.buf.incoming_calls),
			options("Search incoming calls")
		)

		map(
			"n",
			"<leader>so",
			telescope_or("lsp_outgoing_calls", vim.lsp.buf.outgoing_calls),
			options("Search outgoing calls")
		)
	end,
})
