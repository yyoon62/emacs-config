(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "ANTHROPIC_API_KEY")))

(use-package magit
  :ensure t)


(provide 'shell-config)
