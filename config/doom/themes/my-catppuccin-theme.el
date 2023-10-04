;;; themes/my-catppuccin-theme.el -*- lexical-binding: t; -*-
(require 'doom-themes)

(defgroup doom-catppuccin-theme nil
  "Options for the `doom-catppuccin' theme."
  :group 'doom-themes)

(defcustom doom-catppuccin-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-catppuccin-theme
  :type 'boolean)

(defcustom doom-catppuccin-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-catppuccin-theme
  :type 'boolean)

(defcustom doom-catppuccin-comment-bg doom-catppuccin-brighter-comments
  "If non-nil, comments will have a subtle, darker background. Enhancing their
legibility."
  :group 'doom-catppuccin-theme
  :type 'boolean)

(defcustom doom-catppuccin-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to
determine the exact padding."
  :group 'doom-catppuccin-theme
  :type '(choice integer boolean))

;;
(def-doom-theme my-catppuccin
  "A dark theme inspired by Atom Spacegrey Dark"

  ;; name        default   256       16
  ((bg         '("#303446" nil       nil            ))
   (bg-alt     '("#292c3c" nil       nil            ))
   (base0      '("#232634" "#232634"   "black"        ))
   (base1      '("#414559" "#414559" "brightblack"  ))
   (base2      '("#51576d" "#51576d" "brightblack"  ))
   (base3      '("#626880" "#626880" "brightblack"  ))
   (base4      '("#737994" "#737994" "brightblack"  ))
   (base5      '("#838ba7" "#838ba7" "brightblack"  ))
   (base6      '("#949cbb" "#949cbb" "brightblack"  ))
   (base7      '("#a5adce" "#a5adce" "brightblack"  ))
   (base8      '("#b5bfe2" "#b5bfe2" "white"        ))
   (fg         '("#c6d0f5" "#c6d0f5" "brightwhite"  ))
   (fg-alt     '("#b5bfe2" "#b5bfe2" "white"        ))

   (grey       base4)
   (red        '("#e78284" "#e78284" "red"          ))
   (orange     '("#f2d5cf" "#f2d5cf" "brightred"    ))
   (green      '("#a6d189" "#a6d189" "green"        ))
   (blue       '("#85c1dc" "#85c1dc" "brightblue"   ))
   (violet     '("#babbf1" "#babbf1" "brightmagenta"))
   (teal       '("#81c8be" "#81c8be" "brightgreen"  ))
   (yellow     '("#e5c890" "#e5c890" "yellow"       ))
   (dark-blue  '("#8caaee" "#8caaee" "blue"         ))
   (magenta    '("#ca9ee6" "#ca9ee6" "magenta"      ))
   (cyan       '("#99d1db" "#99d1db" "brightcyan"   ))
   (dark-cyan  '("#5699AF" "#5699AF" "cyan"         ))

   ;; face categories -- required for all themes
   (highlight      orange)
   (vertical-bar   (doom-darken bg 0.25))
   (selection      base4)
   (builtin        orange)
   (comments       (if doom-catppuccin-brighter-comments dark-cyan base5))
   (doc-comments   (doom-lighten (if doom-catppuccin-brighter-comments dark-cyan base5) 0.25))
   (constants      orange)
   (functions      blue)
   (keywords       violet)
   (methods        blue)
   (operators      fg)
   (type           yellow)
   (strings        cyan)
   (variables      red)
   (numbers        orange)
   (region         selection)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (hidden     `(,(car bg-alt) "black" "black"))
   (-modeline-bright doom-catppuccin-brighter-modeline)
   (-modeline-pad
    (when doom-catppuccin-padded-modeline
      (if (integerp doom-catppuccin-padded-modeline) doom-catppuccin-padded-modeline 4)))

   (modeline-fg     nil)
   (modeline-fg-alt (doom-blend violet base4 (if -modeline-bright 0.5 0.2)))
   (modeline-bg
    (if -modeline-bright
        (doom-darken base3 0.1)
      base1))
   (modeline-bg-l
    (if -modeline-bright
        (doom-darken base3 0.05)
      base1))
   (modeline-bg-inactive   `(,(doom-darken (car bg-alt) 0.05) ,@(cdr base1)))
   (modeline-bg-inactive-l (doom-darken bg 0.1)))


  ;;;; Base theme face overrides
  (((font-lock-comment-face &override)
    :background (if doom-catppuccin-comment-bg (doom-lighten bg 0.05)))
   ((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground fg)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground (if -modeline-bright base8 highlight))

   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground fg)
   (css-selector             :foreground red)
   ;;;; doom-modeline
   (doom-modeline-bar :background (if -modeline-bright modeline-bg highlight))
   ;;;; elscreen
   (elscreen-tab-other-screen-face :background "#353a42" :foreground "#1e2022")
   ;;;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground red)
   ((markdown-code-face &override) :background (doom-darken bg 0.1))
   ;;;; outline <built-in>
   ((outline-1 &override) :foreground fg :weight 'ultra-bold)
   ((outline-2 &override) :foreground (doom-blend fg blue 0.35))
   ((outline-3 &override) :foreground (doom-blend fg blue 0.7))
   ((outline-4 &override) :foreground blue)
   ((outline-5 &override) :foreground (doom-blend magenta blue 0.2))
   ((outline-6 &override) :foreground (doom-blend magenta blue 0.4))
   ((outline-7 &override) :foreground (doom-blend magenta blue 0.6))
   ((outline-8 &override) :foreground fg)
   ;;;; org <built-in>
   (org-block            :background (doom-darken bg-alt 0.04))
   (org-block-begin-line :foreground base4 :slant 'italic :background (doom-darken bg 0.04))
   (org-ellipsis         :underline nil :background bg    :foreground red)
   ((org-quote &override) :background base1)
   (org-hide :foreground bg)
   ;;;; solaire-mode
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l))))

  ;;;; Base theme variable overrides-
  ;; ()
  )

;;; doom-catppuccin.el ends here
