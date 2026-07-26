# Neovim From Scratch

A personal Neovim configuration built for Arch Linux.

This setup does **not** use LazyVim, `lazy.nvim`, or another third-party plugin
manager. Plugins are declared explicitly and installed with Neovim's built-in
`vim.pack` API.

## Features

- File explorer with nvim-tree
- Fuzzy file and project search with Telescope
- Floating terminal with ToggleTerm
- Tree-sitter syntax highlighting
- Built-in plugin management with `vim.pack`
- Reproducible plugin revisions through a lockfile
- Native Neovim LSP support
- ESLint and Ruff linting
- Formatting with Conform
- Tokyo Night colorscheme
- System clipboard support on Wayland
- Latin American keyboard mapping for `ñ`

## Requirements

- Arch Linux or an Arch-based distribution
- Neovim 0.12 or newer
- Git
- A C compiler
- Node.js and npm
- A Nerd Font for file icons

Install the system dependencies:

```bash
sudo pacman -S --needed \
  neovim \
  git \
  base-devel \
  ripgrep \
  fd \
  tree-sitter-cli \
  clang \
  lua-language-server \
  ruff \
  stylua \
  nodejs \
  npm \
  wl-clipboard
```

Install the Node-based language servers and development tools:

```bash
sudo npm install -g \
  typescript \
  typescript-language-server \
  pyright \
  vscode-langservers-extracted \
  eslint \
  eslint_d \
  prettier
```

Check your Neovim version:

```bash
nvim --version | head -n 1
```

## Plugin Management with `vim.pack`

### What `vim.pack` is

`vim.pack` is Neovim's built-in Git-based plugin manager. It installs, loads,
updates and removes plugins without requiring Packer, `lazy.nvim`, or another
third-party manager.

Neovim currently describes `vim.pack` as experimental but stable enough for
daily use. This configuration requires Neovim 0.12 or newer.

Official documentation:
[Neovim `vim.pack`](https://neovim.io/doc/user/pack/#vim.pack)

### Source of truth

Plugin installation and plugin configuration have separate responsibilities:

| Location | Responsibility |
|---|---|
| `lua/config/plugins.lua` | Declares which plugins must exist |
| `after/plugin/*.lua` | Configures each installed plugin |
| `nvim-pack-lock.json` | Records the exact installed revisions |

`lua/config/plugins.lua` is the canonical plugin list:

```lua
if not vim.pack then
    error("This configuration requires Neovim 0.12 or newer for vim.pack")
end

local github = function(repository)
    return "https://github.com/" .. repository
end

vim.pack.add({
    {
        src = github("nvim-lua/plenary.nvim"),
        name = "plenary.nvim",
    },
    {
        src = github("nvim-telescope/telescope.nvim"),
        name = "telescope.nvim",
    },
}, {
    confirm = false,
})
```

Dependencies should be declared before the plugins that use them. For example,
Plenary is declared before Telescope, while nvim-web-devicons is declared
before nvim-tree.

The `confirm = false` option allows a newly cloned configuration to install its
missing plugins automatically. It does not automatically update plugins that
are already installed.

### Startup lifecycle

When Neovim starts:

1. `init.lua` loads `lua/config/plugins.lua`.
2. `vim.pack.add()` reads the plugin specifications.
3. Missing plugins are cloned in parallel.
4. Installed plugins are added to Neovim's runtime.
5. Their revisions are recorded in `nvim-pack-lock.json`.
6. Files under `after/plugin/` apply the plugin-specific configuration.

`vim.pack` stores managed plugin repositories outside this Git repository:

```text
~/.local/share/nvim/site/pack/core/opt/
```

The configuration repository therefore contains declarations and a lockfile,
not copies of third-party plugin repositories.

### Lockfile

The lockfile is located at:

```text
~/.config/nvim/nvim-pack-lock.json
```

It stores the resolved source, version information and exact Git revision for
every managed plugin.

The lockfile must:

- Be committed to Git.
- Be updated after accepted plugin updates.
- Never be edited manually.
- Not be added to `.gitignore`.

On another computer, the first `vim.pack` call reads this lockfile and installs
the recorded plugin revisions. This makes the configuration reproducible
instead of always installing an arbitrary latest commit.

### Inspect installed plugins

Show all plugins managed by `vim.pack`:

```vim
:lua vim.print(vim.pack.get())
```

Open the plugin review buffer without downloading new information:

```vim
:packupdate ++offline
```

### Update plugins

Check every managed plugin for updates:

```vim
:packupdate
```

Neovim opens a confirmation buffer containing the proposed revisions and
changes:

- Use `]]` and `[[` to move between plugin sections.
- Use `:write` to accept and apply the selected updates.
- Use `:quit` to reject the update operation.
- Run `:restart` after applying updates.

Update one plugin:

```vim
:packupdate telescope.nvim
```

After updating nvim-treesitter, also update its parsers:

```vim
:TSUpdate
```

Commit the changed lockfile after validating the updates:

```bash
git add nvim-pack-lock.json
git commit -m "Update Neovim plugins"
```

### Add a plugin

Add a specification to `lua/config/plugins.lua`:

```lua
{
    src = github("OWNER/REPOSITORY"),
    name = "PLUGIN_NAME",
},
```

Create its configuration separately:

```text
after/plugin/plugin-name.lua
```

Restart Neovim. The missing plugin is installed automatically and added to the
lockfile.

### Pin a plugin

A plugin can follow a branch, tag or exact commit through `version`:

```lua
{
    src = github("OWNER/REPOSITORY"),
    name = "PLUGIN_NAME",
    version = "v1.2.3",
},
```

The lockfile already records exact resolved revisions, so explicit version
constraints should be used only when the configuration needs to remain on a
specific branch, release or commit.

### Remove a plugin

1. Remove its specification from `lua/config/plugins.lua`.
2. Restart Neovim so it is no longer active.
3. Remove its managed repository:

```vim
:packdel PLUGIN_NAME
```

4. Remove its matching `after/plugin/plugin-name.lua` file.
5. Commit the configuration and lockfile changes.

Removing only the files from disk is insufficient: if the specification remains
in `plugins.lua`, `vim.pack` installs the plugin again during the next startup.

### Recover a previous plugin state

Because `nvim-pack-lock.json` is tracked by Git, restore its previous version:

```bash
git restore nvim-pack-lock.json
```

Then restart Neovim and synchronize the installed revisions with the restored
lockfile:

```vim
:packupdate ++offline ++lockfile
```

## Installation

### 1. Back up the current configuration

Close all Neovim instances before continuing:

```bash
backup="$HOME/.local/backups/nvim-$(date +%Y%m%d-%H%M%S)"

mkdir -p \
  "$backup/config" \
  "$backup/data" \
  "$backup/state" \
  "$backup/cache"

[ -e "$HOME/.config/nvim" ] &&
  mv "$HOME/.config/nvim" "$backup/config/"

[ -e "$HOME/.local/share/nvim" ] &&
  mv "$HOME/.local/share/nvim" "$backup/data/"

[ -e "$HOME/.local/state/nvim" ] &&
  mv "$HOME/.local/state/nvim" "$backup/state/"

[ -e "$HOME/.cache/nvim" ] &&
  mv "$HOME/.cache/nvim" "$backup/cache/"

echo "Backup created at: $backup"
```

### 2. Clone this repository

Replace `<REPOSITORY_URL>` with the URL of your repository:

```bash
git clone <REPOSITORY_URL> ~/.config/nvim
```

### 3. Migrate an older manual-package installation

Skip this step on a clean installation. If this configuration previously kept
cloned plugins under `~/.config/nvim/pack`, move that directory aside so the
same plugins are not loaded twice:

```bash
legacy_pack="$HOME/.config/nvim/pack"
legacy_backup="$HOME/.local/backups/nvim-pack-$(date +%Y%m%d-%H%M%S)"

if [ -d "$legacy_pack" ]; then
  mkdir -p "$legacy_backup"
  mv "$legacy_pack" "$legacy_backup/"
  echo "Legacy packages moved to: $legacy_backup"
fi
```

Make sure `init.lua` loads the plugin declarations:

```lua
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.options")
require("config.keymaps")
require("config.plugins")
```

### 4. Start and validate Neovim

Start Neovim:

```bash
nvim
```

`vim.pack` reads `lua/config/plugins.lua`, installs every missing plugin and
records its exact revision in `nvim-pack-lock.json`. Do not edit the lockfile
manually.

Install or update the Tree-sitter parsers:

```vim
:TSUpdate
```

Run the health checks:

```vim
:checkhealth
:checkhealth vim.lsp
```

## Project Structure

```text
~/.config/nvim/
├── init.lua
├── lua/
│   └── config/
│       ├── keymaps.lua
│       ├── options.lua
│       └── plugins.lua
├── after/
│   └── plugin/
│       ├── colors.lua
│       ├── format.lua
│       ├── lint.lua
│       ├── lsp.lua
│       ├── telescope.lua
│       ├── terminal.lua
│       ├── tree.lua
│       └── treesitter.lua
└── nvim-pack-lock.json
```

### Configuration files

| File | Responsibility |
|---|---|
| `init.lua` | Main entry point and leader definitions |
| `lua/config/options.lua` | Core editor behavior |
| `lua/config/keymaps.lua` | General keyboard mappings |
| `lua/config/plugins.lua` | Canonical `vim.pack` plugin declarations |
| `nvim-pack-lock.json` | Reproducible plugin revisions |
| `after/plugin/tree.lua` | File explorer |
| `after/plugin/telescope.lua` | File and project search |
| `after/plugin/terminal.lua` | Floating terminal |
| `after/plugin/treesitter.lua` | Parsers and syntax highlighting |
| `after/plugin/lsp.lua` | Language servers and LSP mappings |
| `after/plugin/lint.lua` | ESLint and Ruff |
| `after/plugin/format.lua` | Language formatters |
| `after/plugin/colors.lua` | Tokyo Night colorscheme |

`vim.pack` makes each plugin available during startup. Files under
`after/plugin/` keep installation separate from plugin behavior and mappings.

## Keymaps

The leader key is `Space`.

### General

| Action | Key |
|---|---|
| Save | `Ctrl-s` |
| Quit | `Space q` |
| Force quit | `Space Shift-q` |
| Select all | `Ctrl-a` |
| Copy selection | `Ctrl-c` |
| Paste | `Ctrl-v` |
| Command mode on a Latin American keyboard | `ñ` |
| Next buffer | `Space b n` |
| Previous buffer | `Space b p` |
| Delete buffer | `Space b d` |

### Navigation and search

| Action | Key |
|---|---|
| Toggle file explorer | `Space e` |
| Search current file | `Ctrl-f` |
| Find files | `Space f f` |
| Search project text | `Space f g` |
| Recent files | `Space f r` |
| Find open buffers | `Space f b` |
| Toggle terminal | `Space t t` |
| Leave terminal mode | `Esc Esc` |

### LSP, linting, and formatting

| Action | Key |
|---|---|
| Go to definition | `g d` |
| Find references | `g r` |
| Hover documentation | `K` |
| Rename symbol | `Space l r` |
| Code action | `Space l a` |
| Show diagnostic | `Space l d` |
| Run linter | `Space l l` |
| Format file or selection | `Space l f` |

## Language Support

| Language | Intelligence | Linter | Formatter |
|---|---|---|---|
| C/C++ | clangd | clangd diagnostics | clang-format |
| Python | Pyright | Ruff | Ruff |
| Lua | lua-language-server | LSP diagnostics | StyLua |
| JavaScript/TypeScript | ts_ls | ESLint | Prettier |
| HTML | html language server | — | Prettier |
| CSS | cssls | — | Prettier |
| JSON | jsonls | — | Prettier |
| Markdown | Tree-sitter | — | Prettier |

ESLint is specific to the JavaScript and TypeScript ecosystem. Initialize it
inside each web project:

```bash
npm install --save-dev eslint
npx eslint --init
```

## LSP Project Detection

Language servers normally detect a project through files such as `.git`,
`package.json`, `pyproject.toml`, or `compile_commands.json`.

If no LSP client attaches, first open a real source file inside a project and
then run:

```vim
:set filetype?
:checkhealth vim.lsp
:lua vim.print(vim.lsp.get_clients({ bufnr = 0 }))
```

Check whether a server executable is available:

```vim
:echo executable("lua-language-server")
```

The expected result is `1`.

You can also check all configured executables from the shell:

```bash
for server in \
  clangd \
  lua-language-server \
  pyright-langserver \
  typescript-language-server \
  vscode-html-language-server \
  vscode-css-language-server \
  vscode-json-language-server
do
  command -v "$server" || echo "MISSING: $server"
done
```

## Maintenance Quick Reference

The complete lifecycle is documented in
[Plugin Management with `vim.pack`](#plugin-management-with-vimpack).

| Task | Command |
|---|---|
| Inspect managed plugins | `:lua vim.print(vim.pack.get())` |
| Review installed state | `:packupdate ++offline` |
| Update every plugin | `:packupdate` |
| Update one plugin | `:packupdate PLUGIN_NAME` |
| Remove an inactive plugin | `:packdel PLUGIN_NAME` |
| Restart Neovim | `:restart` |
| Update Tree-sitter parsers | `:TSUpdate` |

## Publish the Configuration

From `~/.config/nvim`:

```bash
git init
git add init.lua lua after nvim-pack-lock.json README.md .gitignore
git commit -m "Add personal Neovim configuration"
git branch -M main
git remote add origin <REPOSITORY_URL>
git push -u origin main
```

The lockfile is part of the configuration and must be committed. It allows
another machine to install the same plugin revisions on first startup.

## Design Principles

- Keep every plugin explicit and understandable.
- Use one configuration file per responsibility.
- Prefer native Neovim functionality where practical.
- Install language tools through the operating system.
- Add plugins only when they solve a real limitation.
- Document every new dependency and keymap.

## Planned Improvements

- Autocompletion
- Snippets
- Git integration
- Harpoon
- Status line
- Keymap discovery
- DAP debugging
- Test runner integration
