(server-start)
(setq inhibit-startup-message t)
(setq ns-pop-up-frames t)
(if window-system
    (tool-bar-mode -1))
;; Uncomment to debug .emacs
(setq debug-on-error t)

;; Adding package archive sources
(require 'package)
;;  elpa
(add-to-list 'package-archives
             '("elpa" . "http://tromey.com/elpa/"))
;; melpa
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
;;  marmalade
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

;; setting use-package
(condition-case nil
    (require 'use-package)
  (file-error
   (package-refresh-contents)
   (package-install 'use-package)
   (setq use-package-always-ensure t)
   (require 'use-package)))

;; enable some native modes (simple.el) for cursor management and indentation
(setq column-number-mode t)
(setq line-number-mode t)
(setq indent-tabs-mode nil)

;; Makes the cursor red
(add-to-list 'default-frame-alist '(cursor-color . "red"))
(set-face-attribute 'region nil :background "#ead9ff")

;; vertical line
(use-package fill-column-indicator
	     :ensure t
	     :config
	     (setq fci-rule-column 80))

;; Enable org-mode on files ending with *.org
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; Enable python-mode on files ending with *.py
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))

;; color theme
(use-package color-theme-sanityinc-tomorrow
  :ensure
  :config (load-theme 'sanityinc-tomorrow-eighties t))



;; yaml mode
;;(require 'yaml-mode)
;; (add-hook 'yaml-mode-hook
;;           (lambda ()
;;             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
;; (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
;; (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

;; text marking
(global-set-key (kbd "C-c m") 'er/expand-region)

(setq imagemagick '(imagemagick :programs ("latex" "convert")
                                :description "pdf > png"
                                :message "you need to install the programs: latex and imagemagick."
                                :use-xcolor t
                                :image-input-type "pdf"
                                :image-output-type ...))

;; configs for publishing HTML
(global-set-key (kbd "C-M-f") 'org-publish-current-file)
(global-set-key (kbd "C-M-a") 'org-publish-project)
;; automatic inclusion of drawing pagckages for org-export-latex
(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
             '("beamer"
               "\\documentclass[presentation]{beamer}
               \\usepackage{tikz}
               \\usepackage{pgfplots}
               \\usetikzlibrary{arrows}
               \\usefonttheme{serif}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

(with-eval-after-load 'ox-latex
   (add-to-list 'org-latex-classes
                '("article"
                  "\\documentclass[a4paper,12pt]{article}
                  \\usepackage{tikz}
                  \\usepackage{pgfplots}
                  \\usetikzlibrary{arrows}"
                  ("\\section{%s}" . "\\section{%s}")
                  ("\\subsection{%s}" . "\\subsection{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection{%s}")
                  ("\\paragraph{%s}" . "\\paragraph{%s}")
                  ("\\subparagraph{%s}" . "\\subparagraph{%s}"))))

(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
             '("landscape_poster_a1"
               "\\documentclass[t]{beamer}
                \\usepackage[orientation=landscape,size=a1,scale=1.25]{beamerposter}
                \\usepackage[absolute,overlay]{textpos}
                \\usepackage{tikz}
                \\usepackage{pgfplots}
                \\usetikzlibrary{arrows}
                [NO-DEFAULT-PACKAGES]
                [PACKAGES]
                [EXTRA]"
              ("\\section{%s}" . "\\section*{%s}")
              ("\\subsection{%s}" . "\\subsection*{%s}")
              ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

(with-eval-after-load 'ox-latex
   (add-to-list 'org-latex-classes
             '("portrait_poster_a0"
               "\\documentclass[t]{beamer}
                \\usepackage[orientation=portrait,size=a0,scale=1.2,debug]{beamerposter}
                \\usepackage[absolute,overlay]{textpos}
                \\usepackage{tikz}
                \\usepackage{pgfplots}
                \\usetikzlibrary{arrows}
                [NO-DEFAULT-PACKAGES]
                [PACKAGES]
                [EXTRA]"
             ("\\section{%s}" . "\\section*{%s}")
             ("\\subsection{%s}" . "\\subsection*{%s}")
             ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

(setq org-latex-create-formula-image-program 'imagemagick)
(setq org-preview-latex-default-process 'imagemagick)
(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

;; Set your lisp system and, optionally, some contribs
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq slime-contribs '(slime-fancy))

;; (load-library "python")
;; (autoload 'python-mode "python-mode" "Python Mode." t)
;; (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;; (add-to-list 'interpreter-mode-alist '("python" . python-mode))
;; 
;; ;; python ident by spaces rather than TAB
;; (setq interpreter-mode-alist
;;       (cons '("python" . python-mode)
;;             interpreter-mode-alist)
;;       python-mode-hook
;;       '(lambda () (progn
;; 		    (set-variable 'indent-tabs-mode nil)
;;                     (set-variable 'py-indent-offset 4))))
;; 
;; Hook for C programming identation
(add-hook 'c-mode-common-hook '(lambda ()
                                 (local-set-key (kbd "RET") 'newline-and-indent)))
;; load rustic for better rust mode and better integration with cargo
;; lsp-mode for rust-analyzer integration
(use-package lsp-mode
  :ensure t
  :commands lsp)

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
	      ("M-?" . lsp-find-references)
	      ("C-c C-c C-r" . rustic-cargo-comint-run)
	      ("C-c C-c l" . flycheck-list-errors)
	      ("C-c C-c a" . lsp-execute-code-action)
	      ("C-c C-c r" . lsp-rename)
	      ("C-c C-c q" . lsp-workspace-restart)
	      ("C-c C-c Q" . lsp-workspace-shutdown)
	      ("C-c C-c s" . lsp-rust-analyzer-status)))
;; Load lsp-java
(use-package lsp-java
             :ensure)
(add-hook 'java-mode-hook #'lsp)

;; (use-package projectile)
;; (use-package flycheck)
;; (use-package yasnippet :config (yas-global-mode))
;; (use-package lsp-mode :hook ((lsp-mode . lsp-enable-which-key-integration))
;;   :config (setq lsp-completion-enable-additional-text-edit nil))
;; (use-package lsp-ui)
;; (use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))
;; (use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))
;; (use-package dap-java :ensure nil)
;; (use-package lsp-treemacs)
;; (use-package helm-core)
;; (use-package helm-lsp :after helm-core)
;; (use-package helm
;;   :config (helm-mode))
;; (define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol)


;; Set org todo tags
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "DELEGATED" "|" "DONE")))
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "red" :weight bold))
        ("IN-PROGRESS" . "darkviolet")
        ("REFACTOR" . "blue")
        ("DELEGATED" . "brown")
        ("DONE" .  "darkgreen")))

;; Efective Keyboard Cmds
(setq ns-function-modifier 'super)
(setq mac-option-modifier 'meta)
;; moving
(setq next-line-add-newlines t)
(global-set-key (kbd "C-/") 'forward-char)
(global-set-key (kbd "M-/") 'forward-word)
(with-eval-after-load 'org
(org-defkey org-mode-map (kbd "C-,") 'backward-char))
(global-set-key (kbd "C-,") 'backward-char)
(global-set-key (kbd "M-,") 'backward-word)
(global-set-key (kbd "C-l") 'previous-line)
(global-set-key (kbd "C-.") 'next-line)
(eval-after-load "dired"
  '(progn(define-key dired-mode-map (kbd "C-.") 'next-line)
         (define-key dired-mode-map (kbd "C-l") 'previous-line)))

;; iy note ';' go to next char and ',' go to previous
(global-set-key (kbd "C-c f") 'iy-go-to-char)
(global-set-key (kbd "C-c b") 'iy-go-to-char-backward)
(global-set-key (kbd "C-c n") 'iy-go-to-or-up-to-continue)
(global-set-key (kbd "C-c p") 'iy-go-to-or-up-to-continue-backward)
(global-set-key (kbd "C-c C-g") 'iy-go-to-char-done)

;; additional rebindings
(global-set-key (kbd "C-c s") 'other-frame)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-c C-f") 'load-file)
(global-set-key (kbd "C-c e") 'eval-expression)
(global-set-key (kbd "C-c r") 'eval-region)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-M-m") 'mc/mark-more-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-x g") 'magit-status)

(setq org-src-tab-acts-natively t)

;; Export-tools
(global-set-key (kbd "C-c M-e b") 'org-beamer-export-to-pdf)




;; (use-package ob-shell
;;   :ensure t)
;; (org-babel-do-load-languages
;;  'org-babel-load-languages '((shell . t)
;;                              (C . t)
;;                              (lisp . t)
;;                              (latex . t)
;; 			     (java . t)))
;; 

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(put 'upcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(sanityinc-tomorrow-eighties))
 '(custom-safe-themes
   '("628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" default))
 '(package-selected-packages
   '(rjsx-mode load-relative color-theme-sanityinc-tomorrow-eighties lsp-mode rustic rust-mode helm-core docker-tramp helm-lsp which-key yasnippet flycheck projectile use-package company lsp-ui lsp-java markdown-mode swift-mode json-mode yaml-mode omnisharp csharp-mode s-buffer multiple-cursors magit iy-go-to-char htmlize fill-column-indicator expand-region ess ein color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized cider-eval-sexp-fu cider))
 '(warning-suppress-types
   '(((package reinitialization))
     ((package reinitialization)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



