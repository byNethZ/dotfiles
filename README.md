# Gestion de Dotfiles

Este repositorio centraliza mi configuracion de terminal y editores:

- `setup_zsh.sh`: instala y configura Zsh + Oh My Zsh + plugins.
- `setup_lazyvim.sh`: instala dependencias de LazyVim y enlaza `nvim/`.
- `setup_spacemacs.sh`: instala Emacs + Spacemacs y enlaza `.spacemacs`.
- `setup_doom_emacs.sh`: instala dependencias de Doom, clona Doom y enlaza `doom/`.

La estrategia es simple:

1. Guardar configuraciones en este repo.
2. Crear symlinks en `HOME` hacia los archivos de este repo.
3. Ejecutar scripts para automatizar instalacion y puesta a punto.

## Estructura esperada

El repo asume esta ruta local:

```bash
$HOME/personal-projects/dotfiles
```

Si lo clonas en otra ruta, ajusta `DOTFILES_DIR` en los scripts.

## Instalacion en una maquina nueva

### 1) Clonar el repositorio

```bash
mkdir -p "$HOME/personal-projects"
git clone git@github.com:byNethZ/dotfiles.git "$HOME/personal-projects/dotfiles"
cd "$HOME/personal-projects/dotfiles"
```

### 2) Configurar Zsh

Que hace `setup_zsh.sh`:

- Instala dependencias base (`git`, `bat`, etc.).
- Instala Oh My Zsh.
- Configura symlinks de `~/.zshrc` y `~/.zsh_history`.
- Instala plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `you-should-use`, `zsh-bat`).

Ejecucion:

```bash
chmod +x setup_zsh.sh
./setup_zsh.sh
```

### 3) Configurar LazyVim (Neovim)

Que hace `setup_lazyvim.sh`:

- Instala `ripgrep`, `fd-find`, `bat`, `neovim`.
- Crea symlink `fd` si solo existe `fdfind`.
- Crea symlink `bat` si solo existe `batcat`.
- Respalda `~/.config/nvim` si existe y no es symlink.
- Enlaza `~/.config/nvim -> $DOTFILES_DIR/nvim`.

Ejecucion:

```bash
chmod +x setup_lazyvim.sh
./setup_lazyvim.sh
```

Despues abre `nvim` para que LazyVim termine de instalar plugins.

### 4) Configurar Spacemacs

Que hace `setup_spacemacs.sh`:

- Instala `emacs` (si no existe).
- Clona Spacemacs en `~/.emacs.d` (si no existe).
- Respalda `~/.spacemacs` si existe y no es symlink.
- Enlaza `~/.spacemacs -> $DOTFILES_DIR/.spacemacs`.

Ejecucion:

```bash
chmod +x setup_spacemacs.sh
./setup_spacemacs.sh
```

Despues abre `emacs` para completar la instalacion inicial.

### 5) Configurar Doom Emacs

Que hace `setup_doom_emacs.sh`:

- Instala dependencias para Doom y herramientas de desarrollo.
- Clona Doom Emacs en `~/.config/emacs` (si no existe).
- Ejecuta `doom install` en primera instalacion.
- Enlaza archivos de Doom desde `doom_emacs/` del repo a `~/.config/doom/`.
- Ejecuta `doom sync`.
- Agrega `~/.config/emacs/bin` al `PATH` en `~/.zshrc` si hace falta.

Ejecucion:

```bash
chmod +x setup_doom_emacs.sh
./setup_doom_emacs.sh
```

Verificacion recomendada:

```bash
doom doctor
```

## Nota importante: Spacemacs vs Doom

No es recomendable usar Spacemacs y Doom Emacs a la vez en la misma instancia de Emacs sin separar perfiles, porque ambos pueden entrar en conflicto de configuracion.

Recomendacion:

- Usa **Spacemacs** (`setup_spacemacs.sh`) o
- Usa **Doom Emacs** (`setup_doom_emacs.sh`)

si quieres mantener un setup estable por maquina.

## Flujo de trabajo diario

Cuando cambies configuraciones:

```bash
cd "$HOME/personal-projects/dotfiles"
git add .
git commit -m "actualiza configuracion"
git push
```

En otra maquina:

```bash
cd "$HOME/personal-projects/dotfiles"
git pull
```

Luego reinicia la terminal o editor segun corresponda.
