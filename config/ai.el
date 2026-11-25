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
  ;; C-c a picks an agent; C-c A / C-c O start Claude / OpenCode directly.
  :bind (("C-c a" . agent-shell)
         ("C-c A" . agent-shell-anthropic-start-claude-code)
         ("C-c O" . agent-shell-opencode-start-agent))
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
  ;; Only offer the agents I use when agent-shell asks which one to start
  ;; (Codex has no key of its own any more; it's here in the picker).
  (setq agent-shell-agent-configs
        '(agent-shell-anthropic-make-claude-code-config
          agent-shell-opencode-make-agent-config
          agent-shell-openai-make-codex-config)))

(provide 'ai)
