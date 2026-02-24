;; Modern completion framework
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

;; Enhanced completion styles
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Rich completions
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(provide 'completion-config)
