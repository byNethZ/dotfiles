#!/bin/bash

# Script para instalar y configurar Spacemacs.

command_exists() {
  command -v "$1" &> /dev/null
}

echo "🛠️  Iniciando instalación y configuración de Spacemacs..."

# --- 1. Dependencias base ---
echo "🔍 Verificando dependencias para Spacemacs..."
sudo apt update

if ! command_exists emacs; then
  echo "📦 Instalando Emacs..."
  sudo apt install -y emacs
else
  echo "✅ Emacs ya está instalado."
fi

# --- 2. Instalar core de Spacemacs ---
if [ ! -d "$HOME/.emacs.d" ]; then
  echo "📥 Clonando Spacemacs..."
  git clone https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d"
else
  echo "✅ ~/.emacs.d ya existe. No se clona Spacemacs para evitar sobrescribirlo."
fi

# --- 3. Configurar symlink de .spacemacs ---
DOTFILES_DIR="$HOME/personal-projects/dotfiles"

if [ -f "$HOME/.spacemacs" ] && [ ! -L "$HOME/.spacemacs" ]; then
  echo "⚠️  Respaldo de .spacemacs existente creado en ~/.spacemacs.bak"
  mv "$HOME/.spacemacs" "$HOME/.spacemacs.bak"
fi

rm -f "$HOME/.spacemacs"
ln -s "$DOTFILES_DIR/.spacemacs" "$HOME/.spacemacs"

echo "✅ Spacemacs configurado correctamente."
echo "💡 Abre 'emacs' para completar la instalación inicial de paquetes."
