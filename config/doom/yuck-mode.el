;;; ../../dotfiles/config/doom/eww-mode.el -*- lexical-binding: t; -*-

(defvar yuck-keywords nil "yuck keywords")
(setq yuck-keywords '(
    "defwindow"
    "defwidget"
    "defpoll"
    "deflisten"
    "defvar"
    "for"
    "include"
    "true"
    "false"
    ))
(defvar yuck-widgets nil "yuck widgets")
(setq yuck-widgets '("combo-box-text"
        "expander" "revealer" "checkbox" "color-button" "color-chooser" "scale" "progress"
        "input" "button" "image" "box" "overlay" "centerbox" "scroll" "eventbox"
        "label" "literal" "calendar" "transform" "circular-progress" "graph" "geometry"))

(defvar yuck-constants nil "yuck constants")
(setq yuck-constants '("true" "false"))

(defvar yuck-symbol nil "yuck symbols")
(setq yuck-symbol "[a-zA-Z\\._][^][({\s)}]*")

(defvar yuck-operators nil "yuck operators")
(setq yuck-operators "[=:\\+\\*\\?></!]+")

(defvar yuck-function-call nil "yuck-func-call")
(setq yuck-function-call (concat "\\(\s*" yuck-symbol))

(defvar yuck-fontlock nil "list for font-lock-defaults")
(setq yuck-fontlock
      (let (yuck-constants-regex yuck-keywords-regex yuck-widgets-regex)
        (setq yuck-constants-regex (regexp-opt yuck-constants 'words))
        (setq yuck-keywords-regex (regexp-opt yuck-keywords 'words))
        (setq yuck-widgets-regex (regexp-opt yuck-widgets 'words))
        (list (cons ":[^]\s)}]+" 'font-lock-builtin-face)
              (cons yuck-keywords-regex 'font-lock-keyword-face)
              (cons yuck-constants-regex 'font-lock-constant-face)
              (cons yuck-widgets-regex 'font-lock-type-face)
              ;; (cons yuck-function-call 'font-lock-function-call-face)
              ;; (cons yuck-symbol 'font-lock-variable-name-face)
              (cons yuck-operators 'font-lock-keyword-face)
              ;; (cons yuck-symbol 'font-lock-function-name-face)
        )))

(defun yuck-completion ()
  "This is the function to be used for the hook `completion-at-point-functions'."
  (interactive)
  (let ((bds (bounds-of-thing-at-point 'symbol))
        start
        end)
    (setq start (car bds))
    (setq end (cdr bds))

    (list start end yuck-keywords . nil)))

(defvar yuck-mode-hook nil "Hook for function `my-mode-hook'.")

(define-derived-mode yuck-mode prog-mode "yuck-mode"
  "Major mode for yuck the description language for Elkowars Wacky Widgets (EWW)"
  :syntax-table emacs-lisp-mode-syntax-table
  (setq font-lock-defaults '((yuck-fontlock)))
  (setq-local comment-start ";")
  (setq-local comment-end "")
  (setq-local comment-padding "")
  (font-lock-ensure)
  (add-hook 'completion-at-point-functions 'yuck-completion nil 'local)
  (run-hooks 'yuck-mode-hook)
  )

(when (boundp 'rainbow-delimiters-mode)
  (add-hook 'yuck-mode-hook #'rainbow-delimiters-mode))

(add-to-list 'auto-mode-alist '("\\.yuck\\'" . yuck-mode))

(provide 'yuck-mode)
