;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Jacob Herbst"
      user-mail-address "jacob@1362.dk")

(setq
      doom-font (font-spec :family "Iosevka" :size 14)
 ;; doom-font (font-spec :family "Iosevka" :size 14 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Iosevka" :size 13)
      doom-big-font (font-spec :family "Iosevka" :size 24))
(setq doom-theme 'doom-gruvbox)
;; (setq doom-theme 'my-catppuccin)
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
;; (custom-set-faces!
;;   '(font-lock-comment-face :slant italic)
;;   '(font-lock-keyword-face :slant italic))

(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'org-mode-hook #'rainbow-mode)
(add-hook 'org-mode-hook #'visual-line-mode)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(add-load-path! ".")
(after! org
  (require 'org-bullets)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-directory "~/Documents/org"
        org-agenda-files '("~/Documents/org")
        org-hide-emphasis-markers t)
  )

(custom-theme-set-faces
 'user
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-info ((t (:foreground "dark orange"))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-link ((t (:foreground "royal blue" :underline t))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
 '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

;; (let* ((variable-tuple
;;           (cond ((x-list-fonts "Iosevka")         '(:font "Iosevka"))
;;                 ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
;;                 ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
;;                 ((x-list-fonts "Verdana")         '(:font "Verdana"))
;;                 ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
;;                 (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
;;          (base-font-color     (face-foreground 'default nil 'default))
;;          (headline           `(:inherit default :weight bold :foreground "#c6d0f5")))

;;     (custom-theme-set-faces
;;      'user
;;      `(org-level-8 ((t (,@headline ,@variable-tuple))))
;;      `(org-level-7 ((t (,@headline ,@variable-tuple))))
;;      `(org-level-6 ((t (,@headline ,@variable-tuple))))
;;      `(org-level-5 ((t (,@headline ,@variable-tuple))))
;;      `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
;;      `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
;;      `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
;;      `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
;;      `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))

;; (font-lock-add-keywords 'org-mode
;;                           '(("^ *\\([-]\\) "
;;                              (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

(set-buffer-multibyte t)
;; (setq org-latex-with-hyperref nil)
(setq latex-run-command "latexmk -pdflatex='lualatex -shell-escape -interaction nonstopmode' -pdf -f %f")

(defun src-decorate (&optional caption attributes)
  "A wrap function for src blocks."
  (concat
   "ORG\n"
   (when attributes
     (concat (mapconcat 'identity attributes "\n") "\n"))
   (when caption
     (format "#+caption: %s" caption))))

(nyan-mode 1)

(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))
;; (add-hook 'pdf-tools-enabled-hook 'pdf-view-midnight-minor-mode)


(setq org-latex-pdf-process
      '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -f %f"))
(setq org-latex-caption-above nil)
(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
               '("org-plain-latex"
                 "\\documentclass{article}
           [NO-DEFAULT-PACKAGES]
           [PACKAGES]
           [EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("report-noparts"
                 "\\documentclass{article}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-packages-alist '("" "listings"))
  (add-to-list 'org-latex-packages-alist '("" "minted"))
  )
(setq org-latex-src-block-backend 'minted)
(setq org-latex-src-block-backend 'listings)
(setq org-latex-listings-options '(("backgroundcolor=\\color{white}")
                                   ("commentstyle=\\color{codegreen}")
                                   ("keywordstyle=\\color{magenta}")
                                   ("numberstyle=\\tiny\\color{codegray}")
                                   ("stringstyle=\\color{codepurple}")
                                   ("basicstyle=\\ttfamily\\footnotesize")
                                   ("breakatwhitespace=false")
                                   ("breaklines=true")
                                   ("captionpos=b")
                                   ("keepspaces=true")
                                   ("numbers=left")
                                   ("numbersep=5pt")
                                   ("showspaces=false")
                                   ("showstringspaces=false")
                                   ("showtabs=false")
                                   ("tabsize=2")))
(setq org-latex-with-hyperref nil)

;; (setq org-structure-template-alist
;;       '(("ip" . "src jupyter-python :session py :async yes kernel: conda-env")))

;; this seems to add syntax-highlighting to jupyter-python and jupyter-typescript blocks
(after! org-src
  (dolist (lang '(python typescript jupyter))
    (cl-pushnew (cons (format "jupyter-%s" lang) lang)
                org-src-lang-modes :key #'car))
  )

;; (after! pdf-tools
;;   (add-hook! 'pdf-view-mode-hook (pdf-view-midnight-minor-mode 1)))

(setq pdf-view-resize-factor 1.1)

;; set SPC w w to other window :D
(map! :leader
      "w w" #'other-window)

;; Staffeli token thing
(setq require-final-newline nil)

;; accept completion from copilot and fallback to company
;; (use-package! copilot
;;   :hook (prog-mode . copilot-mode)
;;   :bind (:map copilot-completion-map
;;               ("<tab>" . 'copilot-accept-completion)
;;               ("TAB" . 'copilot-accept-completion)
;;               ("C-TAB" . 'copilot-accept-completion-by-word)
;;               ("C-<tab>" . 'copilot-accept-completion-by-word)))
;; (require 'files)

(defvar nix-shebang-interpreter-regexp "#!nix-shell -i \\([^ \t\n]+\\)"
  "Regexp for nix-shell -i header.")

(defun nix-shebang-get-interpreter ()
  "Get interpreter string from nix-shell -i file."
  (save-excursion
    (goto-char (point-min))
    (forward-line 1)
    (when (looking-at nix-shebang-interpreter-regexp)
      (match-string 1))))

(defun nix-shebang-mode ()
  "Detect and run file’s interpreter mode."
  (let ((mode (nix-shebang-get-interpreter)))
    (funcall (assoc-default mode
                            (mapcar (lambda (e)
                                      (cons
                                       (format "\\`%s\\'" (car e))
                                       (cdr e)))
                                    interpreter-mode-alist)
                            #'string-match-p))))

(add-to-list 'interpreter-mode-alist '("nix-shell" . nix-shebang-mode))

(set-frame-parameter nil 'alpha-background 80)
(add-to-list 'default-frame-alist '(alpha-background . 80))
;;;
;;; Tree Sitter

(use-package! tree-sitter
  :hook (prog-mode . turn-on-tree-sitter-mode)
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :config
  (require 'tree-sitter-langs)
  ;; This makes every node a link to a section of code
  (setq tree-sitter-debug-jump-buttons t
        ;; and this highlights the entire sub tree in your code
        tree-sitter-debug-highlight-jump-region t))

;; (use-package! citeproc)

(use-package! protobuf-mode
  :mode "\\.proto\\'")

;; we recommend using use-package to organize your init.el
(use-package codeium
  :init
  ;; use globally
  (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)

  (add-hook 'emacs-startup-hook
            (lambda () (run-with-timer 0.1 nil #'codeium-init)))

  ;; :defer t ;; lazy loading, if you want
  :config
  (setq use-dialog-box nil) ;; do not use popup boxes

  ;; if you don't want to use customize to save the api-key
  ;; (setq codeium/metadata/api_key "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")

  ;; get codeium status in the modeline
  (setq codeium-mode-line-enable
        (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
  ;; (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
  ;; alternatively for a more extensive mode-line
  (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)

  ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
  (setq codeium-api-enabled
        (lambda (api)
          (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))

  ;; You can overwrite all the codeium configs!
  ;; for example, we recommend limiting the string sent to codeium for better performance
  (defun my-codeium/document/text ()
    (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
  ;; if you change the text, you should also change the cursor_offset
  ;; warning: this is measured by UTF-8 encoded bytes
  (defun my-codeium/document/cursor_offset ()
    (codeium-utf8-byte-length
     (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
  (setq codeium/document/text 'my-codeium/document/text)
  (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))

(setq lsp-rust-analyzer-cargo-watch-command "clippy")
(after! lsp-mode
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-show-with-cursor t)
  (setq lsp-ui-doc-header nil)
  (setq lsp-lens-enable t)
  (setq lsp-headerline-breadcrumb-enable t)
  (setq lsp-signature-auto-activate t)
  )

(use-package! gleam-ts-mode
   :mode (rx ".gleam" eos))

;; (require 'app-launcher)

(require 'yuck-mode)
