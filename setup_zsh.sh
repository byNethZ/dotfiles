#!/bin/bash

# Script para configurar Zsh y Oh My Zsh con plugins personalizados.

# --- Función para verificar comandos ---
command_exists() {
  command -v "$1" &> /dev/null
}

echo "Iniciando configuración de Zsh..."

# --- 1. Verificación de Dependencias (Git y Bat) ---

# Git es crítico
if ! command_exists git; then
  echo "❌ Error: Git no está instalado. Por favor, instálalo primero."
  echo "Puedes usar: sudo apt install git"
  exit 1
fi
echo "✅ Git está instalado."

# Bat (de tu README)
if ! command_exists bat; then
  echo "⚠️ 'bat' (o 'batcat') no encontrado. Instalando vía apt..."
  # En Debian 13, el binario puede llamarse 'batcat' pero se instala con 'bat'
  sudo apt update
  sudo apt install -y bat
  
  # Algunas distros (como Ubuntu) crean 'batcat'. Creamos un enlace si 'bat' no existe.
  if ! command_exists bat && command_exists batcat; then
    echo "Creando enlace simbólico para 'bat' desde 'batcat'..."
    sudo ln -s /usr/bin/batcat /usr/local/bin/bat
  fi
else
  echo "✅ bat está instalado."
fi

# --- 2. Instalar Oh My Zsh (Prerrequisito) ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Instalando Oh My Zsh..."
  # Usamos la instalación desatendida
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh ya está instalado."
fi

# --- 3. Clonar tu Repositorio de Dotfiles ---
# NOTA: Cambia la URL por la de tu repositorio
DOTFILES_REPO="git@github.com:byNethZ/dotfiles.git"
DOTFILES_DIR="$HOME/personal-projects/dotfiles" # O la carpeta que prefieras

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Clonando tu repositorio de dotfiles desde $DOTFILES_REPO..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  echo "Actualizando tu repositorio de dotfiles..."
  (cd "$DOTFILES_DIR" && git pull)
fi

# --- 4. Crear Enlace Simbólico (Symlink) para .zshrc ---
# (Sigue la misma lógica de tu guía de Spacemacs)

# Mueve cualquier .zshrc existente (creado por OMZ) a una copia de seguridad
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  echo "Creando copia de seguridad del .zshrc existente en .zshrc.bak"
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

# Borra un symlink roto si existe
if [ -L "$HOME/.zshrc" ]; then
    rm "$HOME/.zshrc"
fi

echo "Creando enlace simbólico para .zshrc..."
# Asume que tu archivo se llama '.zshrc' dentro de tu repo
ln -s "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -s "$DOTFILES_DIR/.zsh_history" "$HOME/.zsh_history"

# --- 5. Instalar Plugins (Basado en tu README.md y .zshrc) ---
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
PLUGINS_DIR="$ZSH_CUSTOM/plugins"
THEMES_DIR="$ZSH_CUSTOM/themes"

echo "Instalando plugins de Zsh en $PLUGINS_DIR..."

# zsh-autosuggestions
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
else
    echo "Plugin 'zsh-autosuggestions' ya existe. Omitiendo."
fi

# zsh-syntax-highlighting
if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
else
  echo "Plugin 'zsh-syntax-highlighting' ya existe. Omitiendo."
fi

# you-should-use
if [ ! -d "$PLUGINS_DIR/you-should-use" ]; then
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$PLUGINS_DIR/you-should-use"
else
  echo "Plugin 'you-should-use' ya existe. Omitiendo."
fi

# zsh-bat
if [ ! -d "$PLUGINS_DIR/zsh-bat" ]; then
  git clone https://github.com/fdellwing/zsh-bat.git "$PLUGINS_DIR/zsh-bat"
else
  echo "Plugin 'zsh-bat' ya existe. Omitiendo."
fi

# --- 6. Instalar Powerlevel10k ---
if [ ! -d "$THEMES_DIR/powerlevel10k" ]; then
  echo "Instalando tema 'powerlevel10k'..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEMES_DIR/powerlevel10k"
else
  echo "Tema 'powerlevel10k' ya existe. Omitiendo."
fi

# --- 7. Instalar fuentes MesloLGS NF ---
FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

for font in \
  MesloLGS\ NF\ Regular.ttf \
  MesloLGS\ NF\ Bold.ttf \
  MesloLGS\ NF\ Italic.ttf \
  MesloLGS\ NF\ Bold\ Italic.ttf
do
  if [ ! -f "$FONTS_DIR/$font" ]; then
    echo "Descargando fuente '$font'..."
    curl -fLo "$FONTS_DIR/$font" "https://github.com/romkatv/powerlevel10k-media/raw/master/$font"
  else
    echo "Fuente '$font' ya existe. Omitiendo."
  fi
done

if command_exists fc-cache; then
  fc-cache -f "$FONTS_DIR"
fi

# --- 8. Crear Enlace Simbólico (Symlink) para .p10k.zsh ---
if [ -f "$DOTFILES_DIR/.p10k.zsh" ]; then
  if [ -f "$HOME/.p10k.zsh" ] && [ ! -L "$HOME/.p10k.zsh" ]; then
    echo "Creando copia de seguridad del .p10k.zsh existente en .p10k.zsh.bak"
    mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak"
  fi

  if [ -L "$HOME/.p10k.zsh" ]; then
    rm "$HOME/.p10k.zsh"
  fi

  echo "Creando enlace simbólico para .p10k.zsh..."
  ln -s "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
else
  echo "No se encontró '$DOTFILES_DIR/.p10k.zsh'."
  echo "Después de abrir una nueva terminal, ejecuta 'p10k configure' y guarda el archivo generado en tu repositorio de dotfiles."
fi

# --- 9. Finalización ---
echo "🎉 ¡Configuración completada!"
echo "Recuerda crear tu archivo ~/.zshrc.local si necesitas configuraciones específicas para esta máquina (ej. WebStorm)."
echo "Selecciona la fuente 'MesloLGS NF' en tu terminal para ver correctamente los iconos de Powerlevel10k."
echo "Por favor, reinicia tu terminal o ejecuta 'source ~/.zshrc' para aplicar los cambios."
