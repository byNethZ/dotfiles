#!/bin/bash

# Script para configurar Zsh, LazyVim y Dotfiles.

# --- Función para verificar comandos ---
command_exists() {
  command -v "$1" &> /dev/null
}

echo "🛠️  Iniciando configuración del entorno (Zsh + LazyVim)..."

# --- 1. Verificación e Instalación de Dependencias Básicas ---

echo "🔍 Verificando dependencias del sistema..."

# Actualizar repositorios
sudo apt update

# Instalación de Git, Curl, Build Essential (GCC), Unzip (necesario para Mason)
sudo apt install -y git curl build-essential unzip

# --- 2. Instalación de Herramientas para LazyVim (Ripgrep, FD, Neovim) ---

# Ripgrep
if ! command_exists rg; then
  echo "📦 Instalando ripgrep..."
  sudo apt install -y ripgrep
fi

# FD (fd-find) - En Debian se llama fdfind, LazyVim a veces busca 'fd'
if ! command_exists fdfind; then
  echo "📦 Instalando fd-find..."
  sudo apt install -y fd-find
fi
# Crear enlace simbólico de fdfind a fd para compatibilidad
if ! command_exists fd; then
    echo "🔗 Creando enlace simbólico 'fd' -> 'fdfind'..."
    mkdir -p ~/.local/bin
    ln -s $(which fdfind) ~/.local/bin/fd
fi

# Bat (o batcat)
if ! command_exists bat; then
  echo "📦 Instalando bat..."
  sudo apt install -y bat
  if ! command_exists bat && command_exists batcat; then
    echo "🔗 Creando enlace simbólico 'bat' -> 'batcat'..."
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat
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

# --- 3. Instalar Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🚀 Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh ya está instalado."
fi

# --- 4. Clonar/Actualizar Dotfiles ---
DOTFILES_REPO="URL-DE-TU-REPOSITORIO" # <--- ¡PON TU URL AQUÍ!
DOTFILES_DIR="$HOME/dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "📥 Clonando dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  echo "🔄 Actualizando dotfiles..."
  (cd "$DOTFILES_DIR" && git pull)
fi

# --- 5. Configurar Enlaces Simbólicos (Zsh y LazyVim) ---

echo "🔗 Configurando Symlinks..."

# --- ZSH ---
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi
rm -f "$HOME/.zshrc" # Borra symlink roto si existe
ln -s "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# --- LAZYVIM (NEOVIM) ---
mkdir -p "$HOME/.config" # Asegura que .config exista

# Si existe una carpeta nvim que NO es un symlink, haz backup
if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
  echo "⚠️  Respaldo de configuración nvim existente creado en .config/nvim.bak"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi

rm -rf "$HOME/.config/nvim" # Borra symlink anterior o carpeta vacía si existiera
ln -s "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
echo "✅ Enlace a LazyVim creado."

# --- SPACEMACS ---
if [ -f "$HOME/.spacemacs" ] && [ ! -L "$HOME/.spacemacs" ]; then
    mv "$HOME/.spacemacs" "$HOME/.spacemacs.bak"
fi
rm -f "$HOME/.spacemacs"
ln -s "$DOTFILES_DIR/.spacemacs" "$HOME/.spacemacs"


# --- 6. Instalar Plugins de Zsh ---
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
PLUGINS_DIR="$ZSH_CUSTOM/plugins"
THEMES_DIR="$ZSH_CUSTOM/themes"

echo "🔌 Instalando plugins de Zsh..."

[ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
[ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
[ ! -d "$PLUGINS_DIR/you-should-use" ] && git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "$PLUGINS_DIR/you-should-use"
[ ! -d "$PLUGINS_DIR/zsh-bat" ] && git clone https://github.com/fdellwing/zsh-bat.git "$PLUGINS_DIR/zsh-bat"

# --- 7. Instalar Powerlevel10k ---
if [ ! -d "$THEMES_DIR/powerlevel10k" ]; then
  echo "🎨 Instalando tema Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEMES_DIR/powerlevel10k"
else
  echo "✅ Powerlevel10k ya está instalado."
fi

# --- 8. Instalar fuentes MesloLGS NF ---
FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

for font in \
  MesloLGS\ NF\ Regular.ttf \
  MesloLGS\ NF\ Bold.ttf \
  MesloLGS\ NF\ Italic.ttf \
  MesloLGS\ NF\ Bold\ Italic.ttf
do
  if [ ! -f "$FONTS_DIR/$font" ]; then
    echo "📥 Descargando fuente '$font'..."
    curl -fLo "$FONTS_DIR/$font" "https://github.com/romkatv/powerlevel10k-media/raw/master/$font"
  else
    echo "✅ Fuente '$font' ya existe."
  fi
done

if command_exists fc-cache; then
  fc-cache -f "$FONTS_DIR"
fi

# --- 9. Configurar symlink de .p10k.zsh ---
if [ -f "$DOTFILES_DIR/.p10k.zsh" ]; then
  if [ -f "$HOME/.p10k.zsh" ] && [ ! -L "$HOME/.p10k.zsh" ]; then
    mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak"
  fi

  rm -f "$HOME/.p10k.zsh"
  ln -s "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
else
  echo "⚠️  No existe '$DOTFILES_DIR/.p10k.zsh'."
  echo "💡 Ejecuta 'p10k configure' en una nueva terminal y guarda el resultado en el repo para reutilizarlo."
fi

echo "🎉 ¡Todo listo! Reinicia tu terminal."
echo "💡 Selecciona la fuente 'MesloLGS NF' en tu terminal para ver correctamente los iconos."
echo "💡 Abre 'nvim' para que LazyVim termine de instalar sus plugins."
