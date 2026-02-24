(use-package markdown-mode)

(use-package yasnippet
  :config
  (yas-global-mode 1))

(define-abbrev-table 'global-abbrev-table
  '(("teh" "the")
    ("adn" "and")
    ("dont" "don't")
    ("cant" "can't")))
(abbrev-mode 1)

(use-package yasnippet-snippets
  :after yasnippet)
(provide 'texttools)
