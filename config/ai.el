(add-to-list 'load-path "~/.emacs.d/config/llm-tool-collection")
(require 'llm-tool-collection)

(use-package gptel
  :ensure t
  :demand t
  :config
  (setq gptel-api-key (getenv "ANTHROPIC_API_KEY")
        gptel-model 'claude-sonnet-4-6
        gptel-backend (gptel-make-anthropic "Claude"
                        :stream t
                        :key gptel-api-key)
        gptel-default-mode 'text-mode
        gptel-org-branching-context t)
  (setq gptel-directives
	'((default . "You are a large language model living in Emacs and a helpful assistant. Respond concisely without org-mode headers.")))
  (setq gptel-tools
        (mapcar (apply-partially #'apply #'gptel-make-tool)
                (llm-tool-collection-get-all)))

  :bind
  (("C-c g g" . gptel)
   ("C-c g m" . gptel-menu))
  :hook ((text-mode markdown-mode org-mode) . gptel-mode))


(use-package claude-code
  :straight (:type git :host github :repo "stevemolitor/claude-code.el" :branch "main"
                   :files ("*.el" (:exclude "demo.gif")))
  :bind-keymap
  ("C-c c" . claude-code-command-map)
  :config
  (claude-code-mode))

(straight-use-package '(shell-maker :type git :host github :repo "xenodium/shell-maker"))
(straight-use-package '(acp :type git :host github :repo "xenodium/acp.el"))

(use-package agent-shell
  :ensure t
  :straight (:type git :host github :repo "xenodium/agent-shell")
  ;; C-c A / C-c O start a Claude / Codex (OpenAI) shell directly, skipping the picker.
  :bind (("C-c a" . agent-shell)
         ("C-c A" . agent-shell-anthropic-start-claude-code)
         ("C-c O" . agent-shell-openai-start-codex))
  :config
  ;; Authenticate with Claude Code's login (subscription); use
  ;; :api-key instead if you prefer ANTHROPIC_API_KEY.
  (setq agent-shell-anthropic-authentication
        (agent-shell-anthropic-make-authentication :login t))
  ;; Start every new Claude session in "Bypass Permissions" mode.
  (setq agent-shell-anthropic-default-session-mode-id "bypassPermissions"))

(provide 'ai)
