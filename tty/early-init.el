;;; early-init.el --- terminal-only Emacs (Pi) -*- lexical-binding: t -*-

;; straight.el manages packages; don't let package.el load anything.
(setq package-enable-at-startup nil)

;; Faster startup: collect garbage rarely while loading, then restore.
(setq gc-cons-threshold (* 64 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 16 1024 1024))))

(menu-bar-mode -1)
