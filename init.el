(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
	("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)


;; Configure use-package to use straight.el by default
(use-package straight
  :custom
  (straight-use-package-by-default t))

;; Install use-package if not present
;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))
;; (require 'use-package)
;; (setq use-package-always-ensure t)

(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :hook (pdf-view-mode . (lambda () (blink-cursor-mode -1)))
  :config
  (pdf-tools-install :no-query)

  ;; Optional: improve performance
  (setq pdf-view-display-size 'fit-page)

  (setq pdf-view-continuous t)
  ;; Optional: enable midnight mode for dark theme users
  ;; (add-hook 'pdf-view-mode-hook 'pdf-view-midnight-minor-mode)

  ;; Optional: keybindings for easier navigation
  (define-key pdf-view-mode-map (kbd "j") 'pdf-view-next-line-or-next-page)
  (define-key pdf-view-mode-map (kbd "k") 'pdf-view-previous-line-or-previous-page))

(use-package vterm
  :ensure t)

(add-to-list 'load-path "~/.emacs.d/config")
(require 'ui)
(require 'ai)
(require 'texttools)
(require 'ide)
(require 'shell-config)
(require 'languages)
(require 'global)
(require 'completion-config)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
