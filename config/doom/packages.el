;; -*- no-byte-compile: t; -*-

(package! nyan-mode)
(package! gitconfig-mode
	  :recipe (:host github :repo "magit/git-modes"
			 :files ("gitconfig-mode.el")))
(package! gitignore-mode
	  :recipe (:host github :repo "magit/git-modes"
			 :files ("gitignore-mode.el")))
(package! catppuccin-theme)

;; (package! session-async)

(package! futhark-mode)

(package! capnp-mode)

(package! copilot
  :recipe (:host github :repo "zerolfx/copilot.el" :files ("*.el" "dist")))
(package! codeium :recipe (:host github :repo "Exafunction/codeium.el"))

(package! gleam-ts-mode)

(package! tree-sitter)
