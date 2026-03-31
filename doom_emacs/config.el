;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'normal :width 'normal)) ; Ajustado a 12pt para legibilidad en Doom 

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq treesit-language-source-alist
      '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
        (css "https://github.com/tree-sitter/tree-sitter-css" "master" "src")
        (html "https://github.com/tree-sitter/tree-sitter-html" "master" "src")
        (yaml "https://github.com/tree-sitter/tree-sitter-yaml")))

;; --- EDITOR Y COMPORTAMIENTO ---
(setq-default 
 indent-tabs-mode nil ; No usar tabs 
 tab-width 2)        ; Ancho de tab de 2 espacios 

;; Centrado de scroll y márgenes 
(setq scroll-conservatively 0
      scroll-margin 10)

;; Habilitar visual-line-mode globalmente 
(global-visual-line-mode 1)

;; --- IDIOMAS Y HERRAMIENTAS ---

;; Configuración para Prisma 
(add-hook 'prisma-mode-hook #'lsp)

;; GitHub Copilot: Se activa en todos los modos de programación 
;; Nota: Asegúrate de tener instalado el paquete 'copilot' en packages.el
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))


(after! (evil copilot)
  ;; Define the custom function that either accepts the completion or does the default behavior
  (defun my/copilot-tab-or-default ()
    (interactive)
    (if (and (bound-and-true-p copilot-mode)
             ;; Add any other conditions to check for active copilot suggestions if necessary
             )
        (copilot-accept-completion)
      (evil-insert 1))) ; Default action to insert a tab. Adjust as needed.

  ;; Bind the custom function to <tab> in Evil's insert state
  (evil-define-key 'insert 'global (kbd "<tab>") 'my/copilot-tab-or-default))


;; Forma correcta de manejar Flyspell en los hooks
(add-hook 'prog-mode-hook (lambda () (flyspell-mode -1))) ; Desactivar en código
(add-hook 'text-mode-hook (lambda () (flyspell-mode 1)))  ; Activar en texto

;; --- ORGANIZACIÓN (ORG-MODE) ---
;; Tus estados de TODO y colores personalizados 
(after! org
  (setq org-todo-keywords
        '((sequence "TODO(t!)" "NEXT(n!)" "DOINGNOW(d!)" "BLOCKED(b!)" "TODELEGATE(g!)" 
           "DELEGATED(D!)" "FOLLOWUP(f!)" "TICKLE(T!)" "|" "CANCELLED(c!)" "DONE(F!)")))

  (setq org-todo-keyword-faces
        '(("TODO" . org-warning)
          ("DOINGNOW" . "#E35DBF")
          ("CANCELED" . (:foreground "white" :background "#4d4d4d" :weight bold))
          ("DELEGATED" . "pink")
          ("NEXT" . "#008080"))))

(use-package! copilot-chat
  :after (copilot)
  :config
  (setq copilot-chat-frontend 'markdown-mode) ;; Recommended for better formatting
  ;; Add some basic keybindings
  (map! :leader
        :prefix "c"
        :desc "Copilot Chat" "c" #'copilot-chat-display
        :desc "Copilot Chat Help" "h" #'copilot-chat-help
        :desc "Copilot Chat Reset" "r" #'copilot-chat-reset))


(add-hook 'git-commit-setup-hook 'copilot-chat-insert-commit-message)

;; Set default source and target languages (optional)
(setq google-translate-default-source-language "en")
(setq google-translate-default-target-language "es")

(use-package! gptel
  :config
  (setq! gptel-model 'gemini-1.5-flash) ;; O 'gemini-1.5-pro
  (setq! gptel-backend
         (gptel-make-gemini "Gemini"
                            :key "AIzaSyCZBBLNTqrZvY0mBDoK4kfRZ9cbVRZc-_U"
                            :stream t)))
