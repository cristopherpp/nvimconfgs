local available, blink = pcall(require, "blink.cmp")

if not available then
	vim.notify("blink.cmp could not be loaded", vim.log.levels.ERROR)

	return
end

blink.setup({
	-- Tab accepts completions and navigates snippet fields.
	keymap = {
		preset = "super-tab",
	},

	appearance = {
		nerd_font_variant = "mono",
	},

	completion = {
		list = {
			selection = {
				-- Preserve your previous behavior: nothing is
				-- automatically selected or inserted.
				preselect = false,
				auto_insert = false,
			},
		},

		menu = {
			draw = {
				columns = {
					{
						"kind_icon",
						"label",
						"label_description",
						gap = 1,
					},
					{
						"kind",
						"source_name",
						gap = 1,
					},
				},
			},
		},

		documentation = {
			auto_show = true,
			auto_show_delay_ms = 300,
		},

		ghost_text = {
			enabled = false,
		},
	},

	signature = {
		enabled = true,
	},

	-- Uses Neovim's native vim.snippet implementation.
	snippets = {
		preset = "default",
	},

	sources = {
		default = {
			"lsp",
			"path",
			"snippets",
			"buffer",
		},
	},

	fuzzy = {
		implementation = "prefer_rust_with_warning",
	},
})

-- Make completion and snippet capabilities available to every LSP.
vim.lsp.config("*", {
	capabilities = blink.get_lsp_capabilities(),
})
