# Neovim configuration

One shared Neovim configuration for Arch Linux and native Windows 10 or newer.
It uses Neovim 0.12's built-in `vim.pack` plugin manager.

## Setup

- [Linux / Arch Linux](LINUX.md)
- [Windows 10+](WINDOWS.md)

## Structure

```text
.
├── init.lua                  Entry point
├── lua/config/
│   ├── platform.lua         Small Linux/Windows adapter
│   ├── options.lua          Editor options
│   ├── keymaps.lua          Shared keymaps
│   ├── plugins.lua          vim.pack plugin list
│   ├── project.lua          Project-root detection
│   └── theme.lua            Persistent colorscheme
├── after/plugin/            Plugin configuration
├── nvim-pack-lock.json      Locked plugin revisions
├── LINUX.md                 Linux setup
└── WINDOWS.md               Windows setup
```

Everything is shared except the small platform adapter:

- Linux keeps the user's current shell.
- Windows prefers `pwsh` and falls back to `powershell.exe`.
- Paths use Neovim's standard directories and path APIs.
- External tools and language servers are resolved through `PATH`.
- Installed plugins, parsers, caches, and logs stay outside this repository.

## Main keymaps

The leader key is `Space`.

| Action               | Key                   |
| -------------------- | --------------------- |
| File explorer        | `Space e`             |
| Find files           | `Space f f`           |
| Search project text  | `Space s g`           |
| Toggle terminal      | `Space t t`           |
| Command palette      | `Space c p`           |
| Harpoon menu         | `Space h h`           |
| Format file          | `Space l f`           |
| Lint file            | `Space l l`           |
| Git status           | `Space g g`           |
| Previous/next buffer | `Shift-h` / `Shift-l` |

## Plugins

Plugins are declared in `lua/config/plugins.lua`, configured in
`after/plugin/`, and pinned by `nvim-pack-lock.json`.

Update them with:

```vim
:packupdate
:TSUpdate
```
