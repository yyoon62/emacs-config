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
  :bind (("C-c a" . agent-shell))
  :config
  ;; Authenticate with Claude Code's login (subscription); use
  ;; :api-key instead if you prefer ANTHROPIC_API_KEY.
  (setq agent-shell-anthropic-authentication
        (agent-shell-anthropic-make-authentication :login t))
  ;; Start every new Claude session in "Bypass Permissions" mode.
  (setq agent-shell-anthropic-default-session-mode-id "bypassPermissions")
  ;; OpenCode (brew install opencode): other providers' models.  Log in to
  ;; providers with `opencode auth login'; the model is picked per session
  ;; (C-c C-v in the shell) or set below as "provider/model".
  (setq agent-shell-opencode-authentication
        (agent-shell-opencode-make-authentication :none t))
  ;; (setq agent-shell-opencode-default-model-id "openai/gpt-5")
  ;; Only offer the agents I use when agent-shell asks which one to start.
  (setq agent-shell-agent-configs
        '(agent-shell-anthropic-make-claude-code-config
          agent-shell-opencode-make-agent-config)))

;; C-c a: agent-shell (pick Claude or OpenCode); C-c A: straight to OpenCode.
(global-set-key (kbd "C-c A") #'agent-shell-opencode-start-agent)

(provide 'ai)
