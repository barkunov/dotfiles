#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$OH_MY_ZSH_DIR/custom}"
P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
ZSH_AUTOSUGGEST_DIR="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
FZF_DIR="$HOME/.fzf"

# 1. Install Homebrew
echo "[1/9] Checking and installing Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew already installed."
fi

# 2. Install Zsh
echo "[2/9] Checking and installing Zsh..."
if ! command -v zsh >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install zsh
  elif command -v apt >/dev/null 2>&1; then
    sudo apt update && sudo apt install -y zsh
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y zsh
  fi
else
  echo "Zsh already installed."
fi

# 3. Install Oh My Zsh
echo "[3/9] Installing Oh My Zsh..."
if [ ! -d "$OH_MY_ZSH_DIR" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed."
fi

# 4. Install Powerlevel10k
echo "[4/9] Installing Powerlevel10k..."
if [ ! -d "$P10K_DIR" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# Ask user if they want to run the wizard
read -p "Do you want to run the Powerlevel10k wizard? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Launch the wizard in a proper interactive login shell
  echo "[INFO] Launching Powerlevel10k wizard in interactive login shell..."
  zsh -l -i -c 'p10k configure'
fi

# 5. Install zsh-autosuggestions
echo "[5/9] Installing zsh-autosuggestions..."
if [ ! -d "$ZSH_AUTOSUGGEST_DIR" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGEST_DIR"
else
  echo "zsh-autosuggestions already installed."
fi

# 6. Install fzf
echo "[6/9] Installing fzf..."
if [ ! -d "$FZF_DIR" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"
  "$FZF_DIR/install" --all
else
  echo "fzf already installed."
fi

# 7. Install Vim
echo "[7/9] Installing Vim..."
if ! command -v vim >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install vim
  elif command -v apt >/dev/null 2>&1; then
    sudo apt install -y vim
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y vim
  fi
fi

# 8. Install tmux
echo "[8/9] Installing tmux..."
if ! command -v tmux >/dev/null 2>&1; then
    if command -v brew >/dev/null 2>&1; then
        brew install tmux
    elif command -v apt >/dev/null 2>&1; then
        sudo apt install -y tmux
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y tmux
    fi
fi

# Install vim-plug
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Link configuration files
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"


# Install Vim plugins
echo "[9/9] Installing Vim plugins..."

vim +PlugInstall +qall || echo "[WARN] Vim plugin installation failed. Run ':PlugInstall' manually in Vim."

echo "Setup complete. Open a new terminal. Your Powerlevel10k prompt should now be configured."
