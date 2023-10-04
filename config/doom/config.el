;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq user-full-name "Jacob Herbst"
      user-mail-address "jacob@1362.dk")

(setq doom-font (font-spec :family "Iosevka" :size 14 :weight 'semi-light)
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
(add-to-list 'org-latex-packages-alist '("" "listings")))
(setq org-latex-listings 'listings)
(setq org-latex-listings-options '(("backgroundcolor=\\color{backcolour}")
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
(setq lsp-lens-enable nil)

;; (after! pdf-tools
;;   (add-hook! 'pdf-view-mode-hook (pdf-view-midnight-minor-mode 1)))

(setq pdf-view-resize-factor 1.1)

;; set SPC w w to other window :D
(map! :leader
      "w w" #'other-window)

;; Staffeli token thing
(setq require-final-newline nil)

(setq lsp-rust-analyzer-cargo-watch-command "clippy")
;; accept completion from copilot and fallback to company
;; (use-package! copilot
;;   :hook (prog-mode . copilot-mode)
;;   :bind (:map copilot-completion-map
;;               ("<tab>" . 'copilot-accept-completion)
;;               ("TAB" . 'copilot-accept-completion)
;;               ("C-TAB" . 'copilot-accept-completion-by-word)
;;               ("C-<tab>" . 'copilot-accept-completion-by-word)))
(require 'files)

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
