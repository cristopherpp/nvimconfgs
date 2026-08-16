local project = {}

local fallback_markers = {
	"pnpm-workspace.yaml",
	"pnpm-lock.yaml",
	"package-lock.json",
	"yarn.lock",
	"bun.lock",
	"bun.lockb",
	"nuxt.config.ts",
	"package.json",
	"pyproject.toml",
	"Cargo.toml",
	"CMakeLists.txt",
	"Makefile",
}

local function start_directory(buffer_number)
	buffer_number = buffer_number or 0

	local file = vim.api.nvim_buf_get_name(buffer_number)

	if file == "" then
		return vim.uv.cwd()
	end

	local information = vim.uv.fs_stat(file)

	if information and information.type == "directory" then
		return file
	end

	return vim.fs.dirname(file)
end

function project.root(buffer_number)
	local start = start_directory(buffer_number)

	-- Prefer the complete Git workspace.
	local git_root = vim.fs.root(start, {
		".git",
	})

	if git_root then
		return git_root
	end

	-- Support projects that are not Git repositories.
	return vim.fs.root(start, fallback_markers) or vim.uv.cwd()
end

return project
