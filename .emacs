(require 'server)
(or (server-running-p)
    (server-start))

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


(use-package gptel
  :ensure t
  :config
  (setq gptel-model "gpt-3.5-turbo"))

;; install python's python-language-server 
;; for additional support: pyls-black pyls-mypy pyls-isort future
;; https://www.kotaweaver.com/blog/emacs-python-lsp/
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package direnv
  :ensure t
  :config
  (direnv-mode))

; setup Emacs path from our ~/.zshenv
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package flycheck
  :ensure t)

(use-package company
  :ensure t
  :hook (python-mode . company-mode)
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1))

(use-package poetry
 :ensure t)

;; Use EIN for Jupyter notebook integration
(use-package ein
  :ensure t
  :init
  ;; Set default notebook directory to current directory
  (setq ein:jupyter-server-use-command "jupyter")
  (setq ein:jupyter-server-use-containers nil)
  (setq ein:jupyter-default-notebook-directory default-directory)
  :config
  ;; Automatically activate the Poetry virtual environment when starting ein:run
  (defun ein-activate-poetry-venv ()
    "Activate the Poetry virtual environment before running ein:run."
    (let ((venv-path (string-trim (shell-command-to-string "poetryenv"))))
      (when (and venv-path (file-exists-p (concat venv-path "/bin/activate")))
        (pyvenv-activate (concat venv-path "/bin/activate")))))
  (add-hook 'ein:notebooklist-login-hook 'ein-activate-poetry-venv)
  ;; Automatically activate lsp environment when using python kernel
  (defun my-ein-notebook-activate-lsp ()
    "Activate LSP mode for Python files in EIN Jupyter notebooks."
    (when (and (eq major-mode 'ein:notebook-multilang-mode)
               (string= ein:notebook--kernel-name "python"))
      (lsp)))
  (add-hook 'ein:notebook-multilang-mode-hook 'my-ein-notebook-activate-lsp)
  ;; Enable auto-completion and undo in notebooks
  (setq ein:use-auto-complete t)
  (setq ein:worksheet-enable-undo t)
  ;; Keybindings for opening notebooks and connecting to a running Jupyter server
  :bind (("C-c C-j l" . ein:notebooklist-login)))

(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-completion-provider :capf) ;; Use lsp-mode's built-in completion-at-point function
  :config
  ;; Register custom settings for pylsp
  (lsp-register-custom-settings
   '(("pyls.plugins.pyls_black.enabled" t t)
     ("pyls.plugins.pyls_isort.enabled" t t)
     ("pyls.plugins.pyls_mypy.enabled" t t)
     ("pyls.plugins.pyls_mypy.live_mode" nil t)
     ("pyls.plugins.pyls_autopep8.enabled" nil t))) ;; Disable autopep8 if black is enabled
  :hook
  ((python-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))
  :bind (:map lsp-mode-map
              ("C-<tab>" . completion-at-point)
              ("C-d p" . lsp-describe-thing-at-point)))


;; color theme
(use-package color-theme-sanityinc-tomorrow
  :ensure
  :config (load-theme 'sanityinc-tomorrow-eighties t))

;; text marking
(global-set-key (kbd "C-c m") 'er/expand-region)

(setq imagemagick '(imagemagick :programs ("latex" "convert")
                                :description "pdf > png"
                                :message "you need to install the programs: latex and imagemagick."
                                :use-xcolor t
                                :image-input-type "pdf"
                                :image-output-type ...))

;; handy commands for org-mode
(global-set-key (kbd "C-c C-,") 'org-insert-structure-template)

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
                  \\usetikzlibrary{arrows}
                  \\pgfplotsset{compat=1.11}"
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
(global-set-key (kbd "C-c f") 'jump-char-forward)
(global-set-key (kbd "C-c b") 'jump-char-backward)

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
 '(elpy-rpc-python-command "python3")
 '(package-selected-packages
   '(poetry gptel company-lsp pyvenv js2-mode jump-char elpy jedi-direx jedi rjsx-mode load-relative color-theme-sanityinc-tomorrow-eighties lsp-mode helm-core docker-tramp helm-lsp which-key yasnippet flycheck projectile use-package company lsp-java markdown-mode swift-mode json-mode yaml-mode omnisharp csharp-mode s-buffer multiple-cursors magit iy-go-to-char htmlize fill-column-indicator expand-region ess ein color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized cider-eval-sexp-fu cider))
 '(warning-suppress-types
   '(((package reinitialization))
     ((package reinitialization)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



(put 'downcase-region 'disabled nil)
