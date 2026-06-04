(require 'server)
(or (server-running-p)
    (server-start))

(setq inhibit-startup-message t)
(setq ns-pop-up-frames t)
(if window-system
    (tool-bar-mode -1))
;; Uncomment to debug .emacs
(setq debug-on-error t)
(setq native-comp-async-report-warnings-errors 'silent)

;; Adding package archive sources
(require 'package)
;;  elpa
(add-to-list 'package-archives
             '("elpa" . "http://tromey.com/elpa/"))
;; melpa
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
;;  marmalade (defunct — removed)
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

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


;; TypeScript / TSX syntax highlighting
(use-package typescript-mode
  :ensure t
  :mode (("\\.ts\\'" . typescript-mode)
         ("\\.tsx\\'" . typescript-mode)))

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


;; Monet — Claude Code IDE protocol bridge via WebSocket.
;; Run Claude in an external terminal (Ghostty/Kitty/iTerm2),
;; Monet provides diffs, diagnostics, file opening back in Emacs.
(unless (package-installed-p 'monet)
  (message "Monet not installed — run: M-x package-vc-install RET https://github.com/stevemolitor/monet RET"))

(use-package monet
  :config
  (setq monet-prefix-key "C-c m")
  ;; Use ediff for reviewing Claude's proposed changes
  (setq monet-diff-tool #'monet-ediff-tool)
  (setq monet-diff-cleanup-tool #'monet-ediff-cleanup-tool)
  ;; Start monet-mode globally for keybindings
  (monet-mode 1)

  ;; Auto-start Monet server when visiting a project file
  (defun monet-auto-start-server ()
    "Auto-start a Monet server for the current project if not already running."
    (when (and monet-mode buffer-file-name)
      (let* ((context (monet--get-session-context))
             (base-key (car context))
             (directory (cdr context)))
        (unless (gethash base-key monet--sessions)
          (condition-case err
              (progn
                (monet-start-server-in-directory base-key directory)
                (message "Monet: auto-started server for '%s'" base-key))
            (error
             (message "Monet: failed to auto-start for '%s': %s"
                      base-key (error-message-string err))))))))

  (add-hook 'find-file-hook #'monet-auto-start-server))

;; Auto-revert buffers when files change on disk (e.g. Claude Code edits)
(global-auto-revert-mode 1)

;; Highlight changed lines in the margin via git diff
(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode 1)
  (diff-hl-margin-mode 1)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package poetry
 :ensure t)

(use-package ein
  :ensure t
  :init
  ;; Set default notebook directory to current directory
  (setq ein:jupyter-server-use-command "jupyter")
  (setq ein:jupyter-server-use-containers nil)
  (setq ein:jupyter-default-notebook-directory default-directory)
  (defun ein-activate-venv ()
    "Activate the Poetry or virtual environment before running ein:run."
    (let ((poetryenv-path (string-trim (shell-command-to-string "poetryenv")))
          (virtualenv-path (getenv "VIRTUAL_ENV")))
      (cond
       ;; Activate Poetry environment if detected
       ((and poetryenv-path (file-exists-p (concat poetryenv-path "/bin/activate")))
	(pyvenv-activate poetryenv-path)
	(message "Activated Poetry environment: %s" poetryenv-path))
       ;; Activate virtual environment from VIRTUAL_ENV if set
       ((and virtualenv-path (file-exists-p (concat virtualenv-path "/bin/activate")))
	(pyvenv-activate virtualenv-path)
	(message "Activated virtual environment: %s" virtualenv-path))
       ;; No environment detected
       (t (message "No virtual environment detected for EIN")))))
  (add-hook 'ein:notebooklist-login-hook 'ein-activate-venv)
  ;; Automatically activate lsp environment when using python kernel
  (defun ein-notebook-activate-lsp ()
    "Activate LSP mode for Python files in EIN Jupyter notebooks."
    (when (or (derived-mode-p 'python-mode)
              (derived-mode-p 'ein:notebook-multilang-mode))
      (lsp-deferred)))
  (add-hook 'python-mode-hook 'ein-notebook-activate-lsp)
  ;; Enable auto-completion and undo in notebooks
  (setq ein:worksheet-enable-undo t)
  (setq ein:use-auto-complete nil) 
  ;; Keybindings for opening notebooks and connecting to a running Jupyter server
  :bind (("C-c C-j l" . ein:notebooklist-login)
	 ("C-c C-x d" . ein:worksheet-delete-cell)))

;; disable lsp when using tramp
(defun disable-lsp-in-tramp ()
  "Prevent LSP from starting in TRAMP buffers."
  (when (file-remote-p default-directory)
    (message "Disabling LSP for TRAMP buffer: %s" (buffer-name))
    (setq-local lsp-mode nil)
    (setq-local lsp-enabled-clients nil)))

(add-hook 'find-file-hook #'disable-lsp-in-tramp)
(setq lsp-enable-remote-connection nil)

;; Configure company-mode for Python
(use-package company
  :ensure t
  :hook ((python-mode . company-mode)
         (lsp-mode . company-mode))
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection) ;; Use TAB to select completion
              ("RET" . company-complete-selection))  ;; Use Enter to confirm
  :bind (:map company-mode-map
              ("<tab>" . company-indent-or-complete-common))) ;; Use TAB for completion or indentation

(use-package lsp-mode
  :ensure t
  :config
  (setq lsp-log-io nil)
  (setq lsp-pylsp-server-command '("pylsp"))
  (setq lsp-diagnostics-provider :none)
  :hook (python-mode . lsp-deferred))

;; Ensure direnv loads before LSP starts
(add-hook 'lsp-before-initialize-hook #'direnv-update-directory-environment)

;; color theme
(use-package color-theme-sanityinc-tomorrow
  :ensure
  :config (load-theme 'sanityinc-tomorrow-eighties t))


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

;; Set root rights for ddapi ssh config
(setq tramp-default-proxies-alist
      '(("ddapi" "\\`root\\'" "/ssh:ddapi:")))

;; Set org todo tags
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "DELEGATED" "|" "DONE")))
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "red" :weight bold))
        ("IN-PROGRESS" . "darkviolet")
        ("REFACTOR" . "blue")
        ("DELEGATED" . "brown")
        ("DONE" . (:foreground "darkgreen" :strike-through nil))))
(with-eval-after-load 'org
  (set-face-attribute 'org-done nil :strike-through nil)
  (when (facep 'org-headline-done)
    (set-face-attribute 'org-headline-done nil :strike-through nil)))

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
   '("628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d"
     default))
 '(elpy-rpc-python-command "python3")
 '(package-selected-packages nil)
 '(package-vc-selected-packages
   '((monet :vc-backend Git :url "https://github.com/stevemolitor/monet")))
 '(warning-suppress-types
   '(((package reinitialization)) ((package reinitialization)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



(put 'downcase-region 'disabled nil)
