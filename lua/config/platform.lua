local platform = {}

platform.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
platform.is_linux = vim.fn.has("linux") == 1
platform.is_macos = vim.fn.has("macunix") == 1

platform.home = vim.fn.expand("~")
platform.config = vim.fn.stdpath("config")
platform.data = vim.fn.stdpath("data")
platform.state = vim.fn.stdpath("state")
platform.cache = vim.fn.stdpath("cache")

function platform.joinpath(...)
	return vim.fs.joinpath(...)
end

function platform.executable(name)
	return type(name) == "string" and name ~= "" and vim.fn.executable(name) == 1
end

function platform.first_executable(candidates)
	for _, candidate in ipairs(candidates) do
		if platform.executable(candidate) then
			return candidate
		end
	end

	return nil
end

local function configure_windows_shell()
	local shell = platform.first_executable({
		"pwsh",
		"powershell.exe",
		"powershell",
	})

	if not shell then
		vim.schedule(function()
			vim.notify("PowerShell was not found; Neovim will keep its default shell", vim.log.levels.WARN)
		end)

		return vim.o.shell
	end

	-- These options work with both PowerShell 7 and Windows PowerShell 5.1.
	-- They also preserve command failures when output is redirected by :make.
	vim.o.shell = shell
	vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
	vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
	vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
	vim.o.shellquote = ""
	vim.o.shellxquote = ""

	return shell
end

function platform.setup()
	if platform.is_windows then
		platform.shell = configure_windows_shell()
	else
		-- Respect the user's login shell on Unix-like systems.
		platform.shell = vim.o.shell
	end
end

return platform
