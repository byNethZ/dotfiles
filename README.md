# Gestión de Dotfiles (Zsh y Spacemacs)

Este repositorio gestiona mis configuraciones personales (dotfiles) para Zsh y Spacemacs, permitiéndome sincronizarlas entre múltiples equipos.

La estrategia principal se basa en:

1.  **Un repositorio Git central** (este) que almacena los archivos de configuración (ej. `.zshrc`, `.spacemacs`).
2.  **Enlaces Simbólicos (symlinks)** en cada máquina, que apuntan desde la ubicación esperada (ej. `~/.spacemacs`) al archivo correspondiente dentro de este repositorio.
3.  **Un script de instalación** (`setup_zsh.sh`) para automatizar la instalación de dependencias como Oh My Zsh, plugins y otras herramientas (`bat`).

-----

### 1\. Configuración Inicial (Computadora Principal)

Estos pasos se realizan **una sola vez** para crear el repositorio.

1.  **Crea un nuevo repositorio para tus "dotfiles"**:

      * Puedes crearlo en GitHub o GitLab. Llamémoslo `dotfiles`.
      * En tu computadora, crea una carpeta para el repositorio:
        ```bash
        mkdir ~/dotfiles
        cd ~/dotfiles
        git init
        # Conecta con tu repositorio remoto (ej. GitHub)
        # git remote add origin [URL-DE-TU-REPOSITORIO]
        git remote add origin [git@github.com:byNethZ/dotfiles.git]
        ```

2.  **Mueve tus archivos de configuración al repositorio**:

      * Mueve tu `.zshrc` y tu `.spacemacs` de tu `home` a la nueva carpeta.
        ```bash
        mv ~/.zshrc ~/dotfiles/
        mv ~/.spacemacs ~/dotfiles/ 
        ```

3.  **Crea los enlaces simbólicos (symlinks)**:

      * Vuelve a crear los "accesos directos" en tu `home` para que apunten a los archivos dentro del repositorio.
        ```bash
        ln -s ~/dotfiles/.zshrc ~/.zshrc
        ln -s ~/dotfiles/.zsh_history ~/.zsh_history 
        ln -s ~/dotfiles/.spacemacs ~/.spacemacs 
        ```

4.  **(Recomendado) Abstrae la configuración local de Zsh**:

      * Para evitar conflictos con rutas específicas de cada máquina (como WebStorm), modifica tu `~/dotfiles/.zshrc` y añade al final:
        ```bash
        # Cargar configuración local específica de la máquina (si existe)
        if [[ -f ~/.zshrc.local ]]; then
          source ~/.zshrc.local
        fi
        ```
      * Crea un archivo `~/.zshrc.local` (en tu `home`, *no* en el repo) con las rutas de esa máquina:
        ```bash
        # Ejemplo de ~/.zshrc.local
        export PATH="/home/usuario-pc/WebStorm-XXXX/bin:$PATH"
        ```

5.  **Añade el script de instalación y `.gitignore`**:

      * Guarda el script `setup_zsh.sh` (del paso anterior) dentro de tu carpeta `~/dotfiles/`.
      * Crea un archivo `.gitignore` en `~/dotfiles/` para ignorar los archivos locales:
        ```
        # .gitignore
        .zshrc.local
        ```

6.  **Sube tu configuración al repositorio**:

      * Desde la carpeta `~/dotfiles/`, añade, confirma y sube tus archivos.
        ```bash
        git add .zshrc .spacemacs setup_zsh.sh .gitignore
        git commit -m "Configuración inicial de Zsh y Spacemacs"
        git push origin main
        ```

-----

### 2\. Instalación en un Equipo Nuevo (Laptop)

Cuando llegues a una máquina nueva, sigue estos pasos para replicar tu entorno.

#### 2.1. Configuración de Zsh (Oh My Zsh y Plugins)

1.  **Instala dependencias básicas**:

    ```bash
    # Necesitarás git y curl (y build-essential para algunas cosas)
    sudo apt update
    sudo apt install -y git curl 
    ```

2.  **Clona tu repositorio de configuración**:

      * Clona el repositorio que creaste en el paso anterior.
        ```bash
        git clone [git@github.com:byNethZ/dotfiles.git] ~/dotfiles
        ```

3.  **Ejecuta el Script de Instalación**:

      * Navega a la carpeta, da permisos de ejecución al script y córrelo. Este script se encargará de:
          * Instalar `bat` (si es necesario).
          * Instalar Oh My Zsh.
          * Clonar todos los plugins de Zsh (`zsh-autosuggestions`, `zsh-syntax-highlighting`, etc.).
          * Crear el enlace simbólico para `.zshrc`.
          ```
        ln -s ~/dotfiles/.zshrc ~/.zshrc
        ln -s ~/dotfiles/.zsh_history ~/.zsh_history 
          ```
    <!-- end list -->

    ```bash
    cd ~/dotfiles
    chmod +x setup_zsh.sh
    ./setup_zsh.sh
    ```

4.  **(Opcional) Configuración Local**:

      * Si esta máquina tiene rutas específicas (como otra versión de WebStorm), crea el archivo `~/.zshrc.local` correspondiente.

5.  **Reinicia la terminal** (o ejecuta `zsh`) para cargar el nuevo entorno.

#### 2.2. Configuración de Spacemacs

1.  **Instala Spacemacs (el "motor")**:

      * Esto implica clonar el repositorio oficial en `~/.emacs.d`.
        ```bash
        git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
        ```

2.  **Crea el enlace simbólico**:

      * (Asegúrate de borrar cualquier `~/.spacemacs` que Emacs haya creado automáticamente).
      * Crea el symlink apuntando al archivo que ya clonaste con tu repo de `dotfiles`.
        ```bash
        # Si existe, bórralo: rm ~/.spacemacs
        ln -s ~/dotfiles/.spacemacs ~/.spacemacs
        ```

3.  **Abre Emacs y sé paciente**:

      * Al abrir Emacs, leerá tu archivo `.spacemacs` personalizado, verá todas las capas y comenzará a descargar e instalar todos los paquetes necesarios. **Este proceso puede tardar varios minutos**.

-----

### 3\. Flujo de Trabajo para Mantener Todo Sincronizado

Ahora, tu flujo de trabajo para actualizar cualquier configuración es muy sencillo:

  * **¿Hiciste un cambio en tu `.zshrc` o `.spacemacs` en la laptop?**
    1.  Ve a `~/dotfiles/`.
    2.  Haz `git add .`, `git commit -m "Añadido alias X a zsh"`, y `git push`.
  * **¿Quieres aplicar esos cambios en tu computadora principal?**
    1.  Ve a `~/dotfiles/`.
    2.  Haz `git pull`.
    3.  Reinicia Emacs (si cambiaste `.spacemacs`) o abre una nueva terminal (si cambiaste `.zshrc`).
