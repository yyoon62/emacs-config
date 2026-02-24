(use-package pyvenv)
;; Python - 4 spaces (PEP 8)
(use-package python
  :hook (python-mode . (lambda ()
                         (setq indent-tabs-mode nil
                               tab-width 4
                               python-indent-offset 4)))
  :config
  (modify-syntax-entry ?_ "w" python-mode-syntax-table))

(use-package js
  :hook ((js-mode js2-mode) . (lambda ()
                                (setq indent-tabs-mode nil
                                      tab-width 2
                                      js-indent-level 2))))

;; Web development - 2 spaces
(use-package web-mode
  :ensure t
  :mode ("\\.html?\\'" "\\.css\\'" "\\.jsx?\\'")
  :hook (web-mode . (lambda ()
                      (setq indent-tabs-mode nil
                            tab-width 2
                            web-mode-markup-indent-offset 2
                            web-mode-css-indent-offset 2
                            web-mode-code-indent-offset 2))))

(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :config
  (setq rust-format-on-save t))

(provide 'languages)
