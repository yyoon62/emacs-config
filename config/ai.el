(use-package gptel
  :ensure t
  :config
  (setq gptel-api-key (getenv "ANTHROPIC_API_KEY")
        gptel-model 'claude-sonnet-4-5-20250929
        gptel-backend (gptel-make-anthropic "Claude"
                        :stream t
                        :key gptel-api-key)
        gptel-default-mode 'text-mode
        gptel-org-branching-context t)
  (setq gptel-directives
	'((default . "You are a large language model living in Emacs and a helpful assistant. Respond concisely without org-mode headers.")))

  :bind
  ("C-c g" . gptel)
  :hook ((text-mode markdown-mode org-mode) . gptel-mode))


(use-package claude-code
  :straight (:type git :host github :repo "stevemolitor/claude-code.el" :branch "main"
                   :files ("*.el" (:exclude "demo.gif")))
  :bind-keymap
  ("C-c c" . claude-code-command-map)
  :config
  (claude-code-mode))

(provide 'ai)
