# Windows setup

## 1. Install WinGet

Install Microsoft's **App Installer** if `winget` is not available. Then open a
new PowerShell window.

## 2. Install the core dependencies

```powershell
winget install --exact --id Neovim.Neovim
winget install --exact --id Git.Git
winget install --exact --id BurntSushi.ripgrep.MSVC
winget install --exact --id sharkdp.fd
winget install --exact --id LLVM.LLVM
winget install --exact --id OpenJS.NodeJS.LTS
```

Close and reopen PowerShell so the new commands are added to `PATH`, then run:

```powershell
npm install --global tree-sitter-cli
```

## 3. Install the configured language tools

For JavaScript, TypeScript, HTML, CSS, JSON, and Python LSP support:

```powershell
npm install --global typescript typescript-language-server pyright vscode-langservers-extracted eslint_d prettier
```

For Python linting and formatting:

```powershell
winget install --exact --id Python.Python.3.12
py -m pip install ruff black
```

For Lua LSP support and formatting:

```powershell
winget install --exact --id LuaLS.lua-language-server
winget install --exact --id JohnnyMorganz.Stylua
```

PowerShell 7 is optional; Neovim falls back to Windows PowerShell automatically:

```powershell
winget install --exact --id Microsoft.PowerShell
```

## 4. Clone the configuration

Neovim's standard Windows configuration directory is
`$env:LOCALAPPDATA\nvim`.

```powershell
git clone https://github.com/cristopherpp/nvimconfgs.git "$env:LOCALAPPDATA\nvim"
```

If this repository is already located there, skip this step.

## 5. Start Neovim

```powershell
nvim
```

On the first launch, wait for the plugins to finish installing. Then run these
commands inside Neovim:

```vim
:TSUpdate
:checkhealth
:checkhealth vim.lsp
```

## 6. Verify the external commands

Run in a new PowerShell window:

```powershell
nvim --version
git --version
rg --version
fd --version
clang --version
tree-sitter --version
node --version
npm --version
```
