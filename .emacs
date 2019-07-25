;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq show-paren-style 'expression)
(show-paren-mode 2)

(menu-bar-mode 1)
(tool-bar-mode -1)

;; Emacs autoinstalling tool
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "http://melpa.milkbox.net/packages/")
   t))

;; Get settings from .bash_profile
(unless (package-installed-p 'exec-path-from-shell)
  (package-install 'exec-path-from-shell))

(package-initialize)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Other settings
(setq make-backup-files nil)
(setq auto-save-list-file-name nil)
(setq auto-save-default nil)

(add-to-list 'load-path "~/.emacs.d/plugins")

;; https://orgmode.org/manual/Installation.html
(add-to-list 'load-path "~/.emacs.d/plugins/org-mode/lisp")
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'". org-mode))


;; https://www.emacswiki.org/emacs/download/linum%2b.el
(require 'linum+)
(setq linum-format "%d ")
(global-linum-mode 1)


;; built-in
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

;; Flx (ido-addon)
;; https://github.com/lewang/flx
(add-to-list 'load-path "~/.emacs.d/plugins/flx/")
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
;; (setq ido-enable-flex-matching t)
;; (setq ido-use-faces nil)
;; (setq flx-ido-use-faces nil)


;; built-in
(setq bs-configurations
      '(("files" "^\\*scratch\\*" nil nil bs-visits-non-file bs-sort-buffer-interns-are-last)))


;; https://github.com/nonsequitur/smex
(require 'smex)
(smex-initialize)


;; https://www.emacswiki.org/emacs/PopUp
;; deps for auto-complete
(add-to-list 'load-path "~/.emacs.d/plugins/popup-el/")


;; https://www.emacswiki.org/emacs/AutoComplete
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete")
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete/dict")


;; http://www.emacswiki.org/emacs/SrSpeedbar
(require 'sr-speedbar)


;; https://www.emacswiki.org/emacs/Yasnippet
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)
(yas/load-directory "~/.emacs.d/snippets")


;; http://www.emacswiki.org/emacs/ColorThemes
;; Tools -> Color themes
(add-to-list 'load-path "~/.emacs.d/plugins/color-theme/")
(require 'color-theme)
(color-theme-initialize)
(setq color-theme-is-global t)

(color-theme-charcoal-black)
;;(color-theme-classic)
(color-theme-select)

;; Options -> Set default font
(add-to-list 'default-frame-alist '(font . "Monaco-14"))
(set-default-font "Monaco-14")


;; ErgoEmacs
;; http://ergoemacs.github.io/
(add-to-list 'load-path "~/.emacs.d/plugins/ergoemacs-mode")
(require 'ergoemacs-mode)

(setq ergoemacs-theme nil) ;; Uses Standard Ergoemacs keyboard theme
(setq ergoemacs-keyboard-layout "us") ;; Assumes QWERTY keyboard layout
(ergoemacs-mode 1)

;; https://docs.projectile.mx/en/latest/installation/
;; https://docs.projectile.mx/en/latest/usage/
(require 'projectile)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)

;; Project Dirs
(setq projectile-project-search-path '("~/projects/" "~/work/"))


;; Erlang Mode settings
(add-to-list 'auto-mode-alist '("\\.erl?$" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.hrl?$" . erlang-mode))

(setq erlang-root-dir "/usr/local/Cellar/erlang/22.0.4/lib/erlangs")
;; (setq erlang-man-root-dir "D:/Dev/erl5.8.2/erts-5.8.2/man")
(setq load-path (cons "/usr/local/Cellar/erlang/22.0.4/lib/erlang/lib/tools-3.2/emacs" load-path))
(setq exec-path (cons "/usr/local/Cellar/erlang/22.0.4/bin" exec-path))
(setq erlang-electric-commands '())
(require 'erlang-start)

(defun my-erlang-mode-hook ()
        ;; when starting an Erlang shell in Emacs, default in the node name
        (setq inferior-erlang-machine-options '("-sname" "emacs"))
        ;; add Erlang functions to an imenu menu
        (imenu-add-to-menubar "imenu")
        ;; customize keys
        (local-set-key [return] 'newline-and-indent)
        )
;; Some Erlang customizations
(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)


;; Elixir mod
(unless (package-installed-p 'elixir-mode)
  (package-install 'elixir-mode))

;; Highlights *.elixir2 as well
(add-to-list 'auto-mode-alist '("\\.elixir2\\'" . elixir-mode))

;; Create a buffer-local hook to run elixir-format on save, only when we enable elixir-mode.
(add-hook 'elixir-mode-hook
          (lambda () (add-hook 'before-save-hook 'elixir-format nil t)))

(add-hook 'elixir-format-hook (lambda ()
                                 (if (projectile-project-p)
                                      (setq elixir-format-arguments
                                            (list "--dot-formatter"
                                                  (concat (locate-dominating-file buffer-file-name ".formatter.exs") ".formatter.exs")))
                                   (setq elixir-format-arguments nil))))

;; Elixir Alchemist tool
(unless (package-installed-p 'alchemist)
  (package-install 'alchemist))

(defun my-elixir-iex ()
  (interactive)
  (term "iex"))

;; Elixir Alchemist settings
;; Use a different shell command for mix.
(setq alchemist-mix-command "/usr/local/bin/mix")
;; Use a different task for running tests.
(setq alchemist-mix-test-task "espec")
;; Use custom mix test task options.
(setq alchemist-mix-test-default-options '()) ;; default
;;Use a different environment variable in which mix tasks will run.
(setq alchemist-mix-env "prod")
;; Use a different shell command for iex.
(setq alchemist-iex-program-name "/usr/local/bin/iex") ;; default: iex
;; Use a different shell command for elixir.
(setq alchemist-execute-command "/usr/local/bin/elixir") ;; default: elixir
;; Use a different shell command for elixirc.
(setq alchemist-compile-command "/usr/local/bin/elixirc") ;; default: elixirc
;; Disable the change of the modeline color with the last test run status.
(setq alchemist-test-status-modeline nil)
;; Use a different keybinding prefix than C-c a
;;(setq alchemist-key-command-prefix (kbd "C-c ,")) ;; default: (kbd "C-c a")
;; Disable the use of a more significant syntax highlighting on functions like test, assert_* and refute_*
(setq alchemist-test-mode-highlight-tests nil) ;; default t
;; Don't ask to save changed file buffers before running tests.
(setq alchemist-test-ask-about-save nil)
;; Don't change the color of the mode-name when test run failed or passed.
(setq alchemist-test-status-modeline nil)
;; Show compilation output in test report.
(setq alchemist-test-display-compilation-output t)
;; (setq alchemist-test-display-compilation-output t)
(setq alchemist-test-truncate-lines nil) ;; default t
;; Run the whole test suite with alchemist-mix-test after saving a buffer.
(setq alchemist-hooks-test-on-save t)
;; Compile your project with alchemist-mix-compile after saving a buffer.
(setq alchemist-hooks-compile-on-save t)


;; Key Bindings
;; (global-unset-key (kbd "M-x"))
(defun my-keybindings (my-key-map)
  (define-key my-key-map (kbd "C-9") 'bs-show)
  (define-key my-key-map (kbd "C-0") 'sr-speedbar-toggle)
  (define-key my-key-map (kbd "M-<right>") 'increase-left-margin)
  (define-key my-key-map (kbd "M-<left>") 'decrease-left-margin)
  (define-key my-key-map (kbd "M-<S-right>") 'enlarge-window-horizontally)
  (define-key my-key-map (kbd "M-<S-left>") 'shrink-window-horizontally)
  (define-key my-key-map (kbd "M-<S-down>") 'enlarge-window)
  (define-key my-key-map (kbd "M-<S-up>") 'shrink-window)
  )

  (my-keybindings (current-global-map))


;; Flymake

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (alchemist ## projectile expand-region avy multiple-cursors))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
