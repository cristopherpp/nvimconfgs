local available, conform = pcall(require, "conform")

if not available then
	return
end

conform.setup({
	formatters_by_ft = {
		javascript = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},

		javascriptreact = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},

		typescript = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},

		typescriptreact = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},

		vue = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},

		html = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},

		css = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},

		scss = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},

		json = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},

		jsonc = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},

		markdown = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},

		yaml = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},

		lua = {
			"stylua",
		},

		python = {
			"ruff_format",
			"black",
			stop_after_first = true,
		},

		c = {
			"clang_format",
		},

		cpp = {
			"clang_format",
		},
	},

	format_on_save = {
		timeout_ms = 2000,
		lsp_format = "fallback",
	},
})

vim.keymap.set("n", "<leader>lf", function()
	conform.format({
		async = true,
		lsp_format = "fallback",
	})
end, {
	desc = "Format current file",
})
