#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$OH_MY_ZSH_DIR/custom}"
P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
ZSH_AUTOSUGGEST_DIR="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
FZF_DIR="$HOME/.fzf"

echo "[1/8] Checking and installing Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew already installed."
fi

echo "[2/8] Checking and installing Zsh..."
if ! command -v zsh >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install zsh
  elif command -v apt >/dev/null 2>&1; then
    sudo apt update && sudo apt install -y zsh
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y zsh
  else
    echo "Zsh installation method not found."
    exit 1
  fi
else
  echo "Zsh already installed."
fi

echo "[3/8] Installing Oh My Zsh..."
if [ ! -d "$OH_MY_ZSH_DIR" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed."
fi

echo "[4/8] Installing Powerlevel10k..."
if [ ! -d "$P10K_DIR" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
  echo "Powerlevel10k already installed."
fi

# Only run p10k wizard if the command exists
if zsh -c 'typeset -f p10k >/dev/null 2>&1'; then
  echo "[INFO] You can run 'p10k configure' manually to adjust your theme."
else
  echo "[INFO] Skipping automatic p10k wizard. Run 'p10k configure' after opening a new Zsh shell."
fi

echo "[5/8] Installing zsh-autosuggestions..."
if [ ! -d "$ZSH_AUTOSUGGEST_DIR" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGEST_DIR"
else
  echo "zsh-autosuggestions already installed."
fi

echo "[6/8] Installing fzf..."
if [ ! -d "$FZF_DIR" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"
  "$FZF_DIR/install" --all
else
  echo "fzf already installed."
fi

echo "[7/8] Installing Vim..."
if ! command -v vim >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install vim
  elif command -v apt >/dev/null 2>&1; then
    sudo apt install -y vim
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y vim
  fi
fi

# Install vim-plug if missing
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Link dotfiles
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"

# Automatically install Vim plugins
echo "[8/8] Installing Vim plugins..."
vim +PlugInstall +qall || echo "[WARN] Vim plugin installation failed. Run ':PlugInstall' manually in Vim."

echo "Setup complete. Open a new terminal and run 'p10k configure' to set up your prompt if desired."

