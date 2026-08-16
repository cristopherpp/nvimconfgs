local tokyonight_available, tokyonight = pcall(require, "tokyonight")

if tokyonight_available then
	tokyonight.setup({
		style = "night",
		transparent = false,
	})
end

require("config.theme").load()
