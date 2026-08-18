# Linux setup

These instructions target Arch Linux.

## 1. Install the core dependencies

```bash
sudo pacman -S --needed neovim git ripgrep fd clang tree-sitter-cli
```

Install one clipboard provider for your desktop session:

```bash
# Wayland
sudo pacman -S --needed wl-clipboard

# X11 (choose one)
sudo pacman -S --needed xclip
# or
sudo pacman -S --needed xsel
```

## 2. Install the configured language tools

For Lua and Python:

```bash
sudo pacman -S --needed lua-language-server stylua ruff python-black
```

For JavaScript, TypeScript, HTML, CSS, JSON, and Pyright:

```bash
sudo pacman -S --needed nodejs npm
sudo npm install --global typescript typescript-language-server pyright vscode-langservers-extracted eslint_d prettier
```

## 3. Clone the configuration

```bash
git clone https://github.com/cristopherpp/nvimconfgs.git ~/.config/nvim
```

If this repository is already located at `~/.config/nvim`, skip this step.

## 4. Start Neovim

```bash
nvim
```

On the first launch, wait for the plugins to finish installing. Then run:

```vim
:TSUpdate
:checkhealth
:checkhealth vim.lsp
```

## 5. Verify the external commands

```bash
nvim --version
git --version
rg --version
fd --version
clang --version
tree-sitter --version
```
