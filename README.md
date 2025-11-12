# Dotfiles Setup

This repository contains configuration files and scripts to set up a development environment with Zsh, Oh My Zsh, Powerlevel10k, zsh-autosuggestions, fzf, Homebrew, and Vim with plugins.

## Repository Structure
```
dotfiles/
├── install.sh      # Installation script
├── .zshrc          # Zsh configuration
├── .p10k.zsh       # Powerlevel10k theme configuration
├── .vimrc          # Vim configuration with plugins
└── README.md       # This guide
```

## Installation
1. Clone the repository:
```bash
git clone https://github.com/yourname/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
```

2. Run the installer:
```bash
./install.sh
```

3. Restart your terminal or run:
```bash
exec zsh
```

## What this setup does
- Homebrew: Installs package manager for macOS/Linux.
- Zsh: Modern shell replacement.
- Oh My Zsh: Framework to manage Zsh configuration and plugins.
- Powerlevel10k: Fast, customizable prompt theme.
- zsh-autosuggestions: Command suggestions from history.
- fzf: Interactive fuzzy search (files, history, directories).
- Vim with plugins: Includes sensible defaults, NERDTree, lightline, git gutter, commentary, and fzf integration.

## Vim Plugins
- vim-sensible: Sensible defaults for Vim.
- NERDTree: File explorer.
- lightline.vim: Lightweight statusline.
- fzf & fzf.vim: Fuzzy finder in Vim.
- vim-gitgutter: Shows git changes in the gutter.
- vim-commentary: Easy commenting of code.

## Notes
- After first run, `.p10k.zsh` is generated. Commit it to preserve your theme configuration.
- Vim plugins are automatically installed during the install script.
- This setup is portable; cloning the repository and running `install.sh` replicates your environment on a new machine.
