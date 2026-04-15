#!/bin/bash
# setup_doom_environment.sh

command_exists() { command -v "$1" &>/dev/null; }

echo "🚀 Iniciando migración a Doom Emacs..."

# 1. Dependencias adicionales para Doom y tus lenguajes
sudo apt update
sudo apt install -y git curl ripgrep fd-find libtool-bin cmake \
  libvterm-dev nodejs npm python3-pip golang-go # Necesarios para tus LSPs

# 2. Clonar Doom Emacs si no existe
if [ ! -d "$HOME/.config/emacs" ]; then
  echo "📥 Instalando el core de Doom Emacs..."
  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
  # El instalador te preguntará si quieres correr 'doom install'
  ~/.config/emacs/bin/doom install
else
  echo "✅ Doom Emacs ya está instalado."
fi

# 3. Vincular tus Dotfiles (ajustado a la estructura de Doom)
DOTFILES_DIR="$HOME/personal-projects/dotfiles"
mkdir -p "$HOME/.config/doom"

# Enlazar archivos individuales de la carpeta doom en tus dotfiles
for file in init.el config.el packages.el; do
  if [ -f "$DOTFILES_DIR/doom_emacs/$file" ]; then
    ln -sf "$DOTFILES_DIR/doom_emacs/$file" "$HOME/.config/doom/$file"
  fi
done

# 4. Sincronizar configuración
echo "🔄 Sincronizando paquetes de Doom..."
~/.config/emacs/bin/doom sync

# 5. Agregar Doom al PATH si no está
if [[ ":$PATH:" != *":$HOME/.config/emacs/bin:"* ]]; then
  echo 'export PATH="$HOME/.config/emacs/bin:$PATH"' >>~/.zshrc
  echo "⚡ PATH actualizado. Reinicia tu shell."
fi

echo "🎉 Migración completada. Usa 'doom doctor' para verificar errores."
