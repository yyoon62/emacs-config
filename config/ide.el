(use-package hideshow
  :hook (prog-mode . hs-minor-mode))

(use-package lsp-bridge
  :straight '(lsp-bridge :type git :host github :repo "manateelazycat/lsp-bridge"
			 :files (:defaults "*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
			 :build (:not compile))
  :hook ((python-mode . lsp-bridge-mode)
	 (rust-mode . lsp-bridge-mode)
         (emacs-lisp-mode . lsp-bridge-mode)
	 (org-mode . lsp-bridge-mode))
  :config
  (setq lsp-bridge-python-command "~/.emacs.d/lsp-bridge-env/bin/python")
  (setq lsp-bridge-python-lsp-server "pyright")
  (setq acm-enable-yasnippet t)
  (setq lsp-bridge-enable-auto-format-code t)
  ;; Evil mode specific bindings
  (with-eval-after-load 'evil
    ;; Normal mode bindings for lsp-bridge-mode
    (evil-define-key 'normal lsp-bridge-mode-map
      "gd" #'lsp-bridge-find-def
      "gr" #'lsp-bridge-find-references
      "gi" #'lsp-bridge-find-impl
      "K"  #'lsp-bridge-show-documentation
      "gR" #'lsp-bridge-rename
      "ga" #'lsp-bridge-code-action
      "]d" #'lsp-bridge-diagnostic-jump-next
      "[d" #'lsp-bridge-diagnostic-jump-prev))

  ;; Insert mode bindings for lsp-bridge-mode
  (evil-define-key 'insert lsp-bridge-mode-map
    (kbd "C-n") #'acm-select-next
    (kbd "C-p") #'acm-select-prev)

  (with-eval-after-load 'lsp-bridge-ref
    (add-to-list 'evil-emacs-state-modes 'lsp-bridge-ref-mode)
    ))

(use-package format-all
  :ensure t
  :hook (prog-mode . format-all-mode)
  :bind ("C-c f" . format-all-buffer)
  :config
  (setq-default format-all-formatters
	  	'(("Python"     (ruff))
		  ("Emacs Lisp" (emacs-lisp)))))

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind ("s-p" . projectile-command-map)
  :config
  (setq projectile-indexing-method 'alien))

(use-package consult-projectile
  :ensure t
  :after (consult projectile)
  :bind (("s-p f" . consult-projectile-find-file)
         ("s-p F" . consult-projectile-find-dir)
         ("s-p p" . consult-projectile-switch-project)
         ("s-p s" . consult-projectile-switch-to-buffer)
         ("s-p r" . consult-projectile-recentf))
  :config
  ;; Optional: Use consult-projectile for default projectile commands
  (setq projectile-switch-project-action #'consult-projectile-find-file))

(use-package consult
  :ensure t
  :bind (("C-c s l" . consult-line)
         ("C-c s b" . consult-buffer)
         ("C-c s f" . consult-find)
         ("C-c s r" . consult-ripgrep)
         ("C-c s o" . consult-outline)))

(provide 'ide)
