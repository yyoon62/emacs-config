;;; init.el --- terminal-only Emacs for the Pi -*- lexical-binding: t -*-
;;
;; A small, curated config for running Emacs in a terminal (iTerm2 over ssh).
;; The main job is agent-shell; minibuffer search/completion is the extra.
;; Load it with `emacs --init-directory=DIR' where DIR holds a symlink to this
;; file (see tty/install-pi.sh).  It does not touch the Mac's GUI config.
;;
;; Machine-specific additions (e.g. agent-tree) go in `local.el' next to this
;; file in the init directory; it is loaded last if present.

;;;; Paths

;; systemd user services don't read ~/.bashrc, so set PATH for subprocesses
;; (claude, claude-agent-acp, rg, fd, git) here as well.
(dolist (dir (list (expand-file-name "~/.local/node/bin")
                   (expand-file-name "~/.local/bin")))
  (when (file-directory-p dir)
    (add-to-list 'exec-path dir)
    (unless (member dir (split-string (or (getenv "PATH") "") ":"))
      (setenv "PATH" (concat dir ":" (getenv "PATH"))))))

;;;; Packages: straight.el + use-package

(setq straight-vc-git-default-clone-depth 1   ; shallow clones: less SD wear
      straight-check-for-modifications '(check-on-save find-when-checking))
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq straight-use-package-by-default t)
(require 'use-package)

;;;; Terminal basics (all built in)

(setq inhibit-startup-screen t
      visible-bell t
      ring-bell-function #'ignore
      use-short-answers t
      make-backup-files nil              ; fewer SD writes
      create-lockfiles nil
      custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

(load-theme 'modus-vivendi t)
(xterm-mouse-mode 1)                     ; click, scroll, resize splits
(global-set-key (kbd "<mouse-4>") #'scroll-down-line)
(global-set-key (kbd "<mouse-5>") #'scroll-up-line)

;; Copy (kill) goes to the Mac clipboard via OSC 52.  iTerm2 needs
;; Settings > General > Selection > "Applications in terminal may access
;; clipboard".  Paste from the Mac with Cmd-V as usual.
(setq xterm-extra-capabilities '(setSelection))

(savehist-mode 1)                        ; minibuffer history across restarts
(recentf-mode 1)
(save-place-mode 1)
(global-auto-revert-mode 1)              ; agents edit files under us
(electric-pair-mode 1)
(column-number-mode 1)
(which-key-mode 1)                       ; built in since Emacs 30
(setq-default indent-tabs-mode nil)

(global-set-key (kbd "C-c e b") #'eval-buffer)
(global-set-key (kbd "C-c r b") #'rename-buffer)

;;;; Minibuffer completion and search

(use-package vertico
  :init (vertico-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init (marginalia-mode 1))

(use-package consult
  :bind (("C-x b"   . consult-buffer)
         ("M-y"     . consult-yank-pop)
         ("M-g g"   . consult-goto-line)
         ("M-g i"   . consult-imenu)
         ("C-c s l" . consult-line)
         ("C-c s b" . consult-buffer)
         ("C-c s f" . consult-fd)
         ("C-c s r" . consult-ripgrep)
         ("C-c s o" . consult-outline)))

;; In-buffer completion popup.  corfu draws child frames, which a terminal
;; lacks before Emacs 31, so corfu-terminal draws it with overlays instead.
(use-package corfu
  :custom (corfu-auto t) (corfu-cycle t)
  :init (global-corfu-mode 1))

(use-package corfu-terminal
  :after corfu
  :config
  (unless (display-graphic-p) (corfu-terminal-mode 1)))

;;;; Editing and projects

(use-package evil
  :init (setq evil-want-integration t
              evil-want-keybinding nil
              evil-undo-system 'undo-redo)
  :config (evil-mode 1))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

;; The Mac binds projectile to s-p; Super doesn't reach a terminal, so C-c p.
(use-package projectile
  :init (projectile-mode 1)
  :bind-keymap ("C-c p" . projectile-command-map)
  :custom (projectile-indexing-method 'alien))

(use-package consult-projectile
  :after (consult projectile)
  :bind (("C-c p f" . consult-projectile-find-file)
         ("C-c p p" . consult-projectile-switch-project)
         ("C-c p b" . consult-projectile-switch-to-buffer))
  :custom (projectile-switch-project-action #'consult-projectile-find-file))

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package markdown-mode)

;;;; agent-shell (the main reason this Emacs exists)

(use-package shell-maker
  :straight (:type git :host github :repo "xenodium/shell-maker"))

(use-package acp
  :straight (:type git :host github :repo "xenodium/acp.el"))

(use-package agent-shell
  :straight (:type git :host github :repo "xenodium/agent-shell")
  :bind (("C-c a" . agent-shell))
  :config
  ;; Use the Claude Code login on this machine (subscription), not an API key.
  (setq agent-shell-anthropic-authentication
        (agent-shell-anthropic-make-authentication :login t))
  (setq agent-shell-anthropic-default-session-mode-id "bypassPermissions")
  ;; Go straight to Claude instead of the 24-agent picker.
  (setq agent-shell-preferred-agent-config 'claude-code))

;;;; Machine-local additions

(load (locate-user-emacs-file "local.el") 'noerror 'nomessage)

;;; init.el ends here
