;;; k-mode.el -- Emacs mode for the K Framework

;; Currently just has syntax highlighting for:
;;  - keywords
;;  - declarations (e.g. ops, syntax, etc)
;;  - Quoted identifiers (e.g. for terminals in the syntax)

;; Author: Michael Ilseman

;; Usage: add to your .emacs file:
;;     (setq load-path (cons "path/to/this/file" load-path))
;;     (load-library "k-mode")
;;     (add-to-list 'auto-mode-alist '("\\.k$" . k-mode)) ;; to launch k-mode for .k files
;;     ... other options ...

;;;; Options ;;;;
;; Set to make "--" be used as a beginning of a line comment
;; (emacs's syntax table is unable to differentiate 3 character long comment beginners)
(defvar k-dash-comments nil)

;;;; Syntax Highlighting ;;;;
(setq k-keywords
      '("syntax" "kmod" "endkm" "including" ; "::=" "|"
        "sort" "op" "subsort" "rule" "eq" "ceq" "load")
      k-syntax-terminals-regex
      "`\\w+"
      k-declarations ;; Syntax highlight the name after a declaration
      "\\(syntax\\|sort\\|op\\) \\([a-zA-Z{}\\-]+\\)"
)

;; Set up the regexes
(setq k-keywords-regex
      (regexp-opt k-keywords 'words)
)

;; Put them all together
(setq k-font-lock-keywords
      `((,k-declarations 2 font-lock-builtin-face)
        (,k-keywords-regex . font-lock-keyword-face)
        (,k-syntax-terminals-regex . font-lock-constant-face)
       )
)

;; Handle comments
(defun set-comment-highlighting ()
  "Set up comment highlighting"

  ;; comment style "// ..." and "/* ... */"
  (modify-syntax-entry ?\/ ". 124b" k-mode-syntax-table)
  (modify-syntax-entry ?\n "> b" k-mode-syntax-table)
  (modify-syntax-entry ?* ". 23" k-mode-syntax-table)

  ;; comment style "-- ..."
  (if k-dash-comments (modify-syntax-entry ?- ". 1b2b" k-mode-syntax-table))
)


(define-derived-mode k-mode fundamental-mode
  "k mode"
  "Major Mode for the K framwork"
  (setq font-lock-defaults '((k-font-lock-keywords)))

  ;; Comment entries
  (set-comment-highlighting)

  ;; Clear up memory
  ;;(setq k-keywords nil k-keywords-regex nil)
)

