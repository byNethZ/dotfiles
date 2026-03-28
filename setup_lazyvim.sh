#!/bin/bash

# Script para instalar y configurar LazyVim.

command_exists() {
  command -v "$1" &> /dev/null
}

echo "🛠️  Iniciando instalación y configuración de LazyVim..."

# --- 1. Dependencias base para LazyVim ---
echo "🔍 Verificando dependencias de LazyVim..."
sudo apt update

# Ripgrep
if ! command_exists rg; then
  echo "📦 Instalando ripgrep..."
  sudo apt install -y ripgrep
fi

# FD (fd-find) - en Debian el binario suele ser fdfind
if ! command_exists fdfind; then
  echo "📦 Instalando fd-find..."
  sudo apt install -y fd-find
fi

if ! command_exists fd; then
  echo "🔗 Creando enlace simbólico 'fd' -> 'fdfind'..."
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
fi

# Bat / Batcat
if ! command_exists bat; then
  echo "📦 Instalando bat..."
  sudo apt install -y bat
  if ! command_exists bat && command_exists batcat; then
    echo "🔗 Creando enlace simbólico 'bat' -> 'batcat'..."
    mkdir -p "$HOME/.local/bin"
    ln -sf /usr/bin/batcat "$HOME/.local/bin/bat"
  fi
fi

# Neovim
if ! command_exists nvim; then
  echo "📦 Instalando Neovim..."
  sudo apt install -y neovim
  # NOTA: En Debian estable, apt puede traer una versión vieja.
  # Si necesitas la última versión, descomenta las siguientes líneas y comenta el apt install:
  # curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  # sudo rm -rf /opt/nvim
  # sudo tar -C /opt -xzf nvim-linux64.tar.gz
  # export PATH="$PATH:/opt/nvim-linux64/bin"
  # rm nvim-linux64.tar.gz
fi

# --- 2. Configurar symlink de LazyVim ---
DOTFILES_DIR="$HOME/personal-projects/dotfiles"

mkdir -p "$HOME/.config"

if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
  echo "⚠️  Respaldo de configuración nvim existente creado en .config/nvim.bak"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi

rm -rf "$HOME/.config/nvim"
ln -s "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

echo "✅ LazyVim configurado correctamente."
echo "💡 Abre 'nvim' para que LazyVim termine de instalar sus plugins."
