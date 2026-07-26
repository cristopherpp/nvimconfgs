
# Neovim From Scratch

A personal Neovim configuration built manually for Arch Linux.

This setup does **not** use LazyVim, `lazy.nvim`, or another plugin manager.
Plugins are regular Git repositories installed through Neovim's native
`pack/*/start/*` package system.

## Features

- File explorer with nvim-tree
- Fuzzy file and project search with Telescope
- Floating terminal with ToggleTerm
- Tree-sitter syntax highlighting
- Native Neovim LSP support
- ESLint and Ruff linting
- Formatting with Conform
- Tokyo Night colorscheme
- System clipboard support on Wayland
- Latin American keyboard mapping for `Ã±`

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

### 3. Install the plugins

The plugin repositories are intentionally excluded from Git. Install them
locally:

```bash
plugin_dir="$HOME/.config/nvim/pack/plugins/start"
mkdir -p "$plugin_dir"

git clone --depth=1 https://github.com/nvim-tree/nvim-web-devicons \
  "$plugin_dir/nvim-web-devicons"

git clone --depth=1 https://github.com/nvim-tree/nvim-tree.lua \
  "$plugin_dir/nvim-tree.lua"

git clone --depth=1 https://github.com/nvim-lua/plenary.nvim \
  "$plugin_dir/plenary.nvim"

git clone --depth=1 https://github.com/nvim-telescope/telescope.nvim \
  "$plugin_dir/telescope.nvim"

git clone --depth=1 https://github.com/akinsho/toggleterm.nvim \
  "$plugin_dir/toggleterm.nvim"

git clone --depth=1 https://github.com/nvim-treesitter/nvim-treesitter \
  "$plugin_dir/nvim-treesitter"

git clone --depth=1 https://github.com/neovim/nvim-lspconfig \
  "$plugin_dir/nvim-lspconfig"

git clone --depth=1 https://github.com/mfussenegger/nvim-lint \
  "$plugin_dir/nvim-lint"

git clone --depth=1 https://github.com/stevearc/conform.nvim \
  "$plugin_dir/conform.nvim"

git clone --depth=1 https://github.com/folke/tokyonight.nvim \
  "$plugin_dir/tokyonight.nvim"
```

### 4. Start and validate Neovim

Start Neovim:

```bash
nvim
```

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
â”œâ”€â”€ init.lua
â”œâ”€â”€ lua/
â”‚   â””â”€â”€ config/
â”‚       â”œâ”€â”€ keymaps.lua
â”‚       â””â”€â”€ options.lua
â”œâ”€â”€ after/
â”‚   â””â”€â”€ plugin/
â”‚       â”œâ”€â”€ colors.lua
â”‚       â”œâ”€â”€ format.lua
â”‚       â”œâ”€â”€ lint.lua
â”‚       â”œâ”€â”€ lsp.lua
â”‚       â”œâ”€â”€ telescope.lua
â”‚       â”œâ”€â”€ terminal.lua
â”‚       â”œâ”€â”€ tree.lua
â”‚       â””â”€â”€ treesitter.lua
â””â”€â”€ pack/
    â””â”€â”€ plugins/
        â””â”€â”€ start/
            â””â”€â”€ plugin repositories...
```

### Configuration files

| File | Responsibility |
|---|---|
| `init.lua` | Main entry point and leader definitions |
| `lua/config/options.lua` | Core editor behavior |
| `lua/config/keymaps.lua` | General keyboard mappings |
| `after/plugin/tree.lua` | File explorer |
| `after/plugin/telescope.lua` | File and project search |
| `after/plugin/terminal.lua` | Floating terminal |
| `after/plugin/treesitter.lua` | Parsers and syntax highlighting |
| `after/plugin/lsp.lua` | Language servers and LSP mappings |
| `after/plugin/lint.lua` | ESLint and Ruff |
| `after/plugin/format.lua` | Language formatters |
| `after/plugin/colors.lua` | Tokyo Night colorscheme |

Files under `after/plugin/` are loaded after native `start` packages, ensuring
that each plugin is available before its configuration runs.

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
| Command mode on a Latin American keyboard | `Ã±` |
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
| HTML | html language server | â€” | Prettier |
| CSS | cssls | â€” | Prettier |
| JSON | jsonls | â€” | Prettier |
| Markdown | Tree-sitter | â€” | Prettier |

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

## Maintenance

### Update every plugin

```bash
plugin_dir="$HOME/.config/nvim/pack/plugins/start"

for plugin in "$plugin_dir"/*; do
  if [ -d "$plugin/.git" ]; then
    echo "Updating $(basename "$plugin")"
    git -C "$plugin" pull --ff-only
  fi
done
```

After updating nvim-treesitter:

```vim
:TSUpdate
```

### Add a plugin

Clone the plugin:

```bash
git clone --depth=1 <PLUGIN_URL> \
  ~/.config/nvim/pack/plugins/start/<PLUGIN_NAME>
```

Create its configuration:

```text
after/plugin/<plugin-name>.lua
```

Restart Neovim and run `:checkhealth`.

### Remove a plugin

Remove only the specific plugin directory and its configuration file:

```bash
rm -rf ~/.config/nvim/pack/plugins/start/<PLUGIN_NAME>
rm ~/.config/nvim/after/plugin/<plugin-name>.lua
```

Verify both paths carefully before removing anything.

## Publish the Configuration

From `~/.config/nvim`:

```bash
git init
git add init.lua lua after README.md .gitignore
git commit -m "Add personal Neovim configuration"
git branch -M main
git remote add origin <REPOSITORY_URL>
git push -u origin main
```

The `pack/` directory remains local and is not uploaded. Anyone cloning the
configuration recreates it using the installation commands above.

## Design Principles

- Keep every plugin explicit and understandable.
- Use one configuration file per responsibility.
- Prefer native Neovim functionality where practical.
- Install language tools through the operating system.
- Add plugins only when they solve a real limitation.
- Document every new dependency and keymap.
