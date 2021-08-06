;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!

;; You will most likely need to adjust this font size for your system!
(defvar efs/default-font-size 100)
(defvar efs/default-variable-font-size 110)

;; Make frame transparency overridable
(defvar efs/frame-transparency '(90 . 80))

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))

;; NOTE: If you want to move everything out of the ~/.emacs.d folder
;; reliably, set `user-emacs-directory` before loading no-littering!
;(setq user-emacs-directory "~/.cache/emacs")

(use-package no-littering)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Set frame transparency
(set-frame-parameter (selected-frame) 'alpha efs/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,efs/frame-transparency))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Disable line numbers for some modes
(dolist (mode '(term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default nil :font "Fira Code Retina" :height efs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height efs/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height efs/default-variable-font-size :weight 'regular)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :after evil
  :config
  (general-create-definer efs/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (efs/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "fde" '(lambda () (interactive) (find-file (expand-file-name "~/.emacs.d/Emacs.org")))))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))
(use-package evil-tutor)

(use-package command-log-mode
  :commands command-log-mode)

(use-package doom-themes
  :init (load-theme 'doom-challenger-deep t))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 10)))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

;;Make that dumbass ^ go away
(setq ivy-initial-inputs-alist nil)

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  ;; Uncomment the following line to have sorting remembered across sessions!
  ;(prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra
  :defer t)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(efs/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(use-package dashboard
  :init      ;; tweak dashboard config before loading it
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "Nothing Good Happens After Midnight")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner "~/.emacs.d/emacs-dash.png")  ;; use custom image as banner
  (setq dashboard-center-content t) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (bookmarks . 3)
                          (projects . 3)
                          (registers . 3)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book"))))

(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Overpass Nerd Font" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :pin org
  :commands (org-capture org-agenda)
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
        '("~/dev/ORG/OrgOrganizer/Tasks.org"
          "~/dev/ORG/OrgOrganizer/Habits.org"
          "~/dev/ORG/OrgOrganizer/Birthdays.org"))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets
    '(("Archive.org" :maxlevel . 1)
      ("Tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 31)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-email")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))

  (setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/dev/ORG/OrgOrganizer/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/dev/ORG/OrgOrganizer/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/dev/ORG/OrgOrganizer/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/dev/ORG/OrgOrganizer/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/dev/ORG/OrgOrganizer/Metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))

  (efs/org-font-setup))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(with-eval-after-load 'org
  (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
      (python . t)
      (shell . t)))


  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(with-eval-after-load 'org
  ;; This is needed as of Org 9.2
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python")))

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(defun efs/lsp-mode-setup ()
(setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
(lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
:commands (lsp lsp-deferred)
:hook (lsp-mode . efs/lsp-mode-setup)
:init
(setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
:config
(lsp-enable-which-key-integration t))

(use-package lsp-ui
:hook (lsp-mode . lsp-ui-mode)
:custom
(lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
:after lsp)

(use-package lsp-ivy
:after lsp)

(use-package dap-mode
;; Uncomment the config below if you want all UI panes to be hidden by default!
;; :custom
;; (lsp-enable-dap-auto-configure nil)
;; :config
;; (dap-ui-mode 1)
:commands dap-debug
:config
;; Set up Node debugging
(require 'dap-node)
(dap-node-setup) ;; Automatically installs Node debug adapter if needed

;; Bind `C-c l d` to `dap-hydra` for easy access
(general-define-key
    :keymaps 'lsp-mode-map
    :prefix lsp-keymap-prefix
    "d" '(dap-hydra t :wk "debugger")))

(use-package typescript-mode
:mode "\\.ts\\'"
:hook (typescript-mode . lsp-deferred)
:config
(setq typescript-indent-level 2))

(use-package python-mode
:ensure t
:hook (python-mode . lsp-deferred)
:custom
;; NOTE: Set these if Python 3 is called "python3" on your system!
;; (python-shell-interpreter "python3")
;; (dap-python-executable "python3")
(dap-python-debugger 'debugpy)
:config
(require 'dap-python))

(use-package pyvenv
:after python-mode
:config
(pyvenv-mode 1))

(use-package haskell-mode)

(use-package company
:after lsp-mode
:hook (lsp-mode . company-mode)
:bind (:map company-active-map
        ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
:custom
(company-minimum-prefix-length 1)
(company-idle-delay 0.0))

(use-package company-box
:hook (company-mode . company-box-mode))

(use-package projectile
:diminish projectile-mode
:config (projectile-mode)
:custom ((projectile-completion-system 'ivy))
:bind-keymap
("C-c p" . projectile-command-map)
:init
;; NOTE: Set this to the folder where you keep your Git repos!
(when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
(setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
:after projectile
:config (counsel-projectile-mode))

(use-package magit
:commands magit-status
:custom
(magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
(use-package forge
:after magit)

(use-package evil-nerd-commenter
:bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package rainbow-delimiters
:hook (prog-mode . rainbow-delimiters-mode))

(use-package term
  :commands term
  :config
  (setq explicit-shell-file-name "bash") ;; Change this to zsh, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  ;;(setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "powershell.exe")
  (setq explicit-powershell.exe-args '()))

(defun efs/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
  :after eshell)

(use-package eshell
  :hook (eshell-first-time-mode . efs/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim")))

  (eshell-git-prompt-use-theme 'powerline))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single
  :commands (dired dired-jump))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :commands (dired dired-jump)
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(defun efs/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(defun efs/set-wallpaper ()
  (interactive)
  ;; NOTE: You will need to update this to a valid background path!
  (start-process-shell-command
      "feh" nil  "feh --recursive --bg-fill --randomize ~/wallpapers/*"))

(defun efs/exwm-init-hook ()
  ;; Make workspace 1 be the one where we land at startup
  (exwm-workspace-switch-create 1)

  ;; Open eshell by default
  ;;(eshell)

  ;; Show battery status in the mode line
  (display-battery-mode 1)

  ;; Show the time and date in modeline
  (setq display-time-day-and-date t)
  (display-time-mode 1)
  ;; Also take a look at display-time-format and format-time-string

  ;; Launch apps that will run in the background
  (efs/run-in-background "nm-applet")
  (efs/run-in-background "pasystray")
  (efs/run-in-background "blueman-applet"))

(defun efs/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(defun efs/exwm-update-title ()
  (pcase exwm-class-name
    ("Firefox"      (exwm-workspace-rename-buffer (format exwm-title)))
    ("Firefox Beta" (exwm-workspace-rename-buffer (format exwm-title)))
    ("okular" (exwm-workspace-rename-buffer (format exwm-title)))
    ("Brave-browser"(exwm-workspace-rename-buffer (format exwm-title)))))

(defun restrict-fullscreen ()
  (interactive)
  (toggle-frame-fullscreen)
  (exwm-reset))

;; This function isn't currently used, only serves as an example how to
;; position a window
(defun efs/position-window ()
  (let* ((pos (frame-position))
         (pos-x (car pos))
         (pos-y (cdr pos)))

    (exwm-floating-move (- pos-x) (- pos-y))))

(defun efs/configure-window-by-class ()
  (interactive)
  (pcase exwm-class-name
    ("Sol" (exwm-workspace-move-window 3))
    ("mpv" ;;(exwm-floating-toggle-floating)
           (exwm-layout-toggle-mode-line))))


(defun open-terminal ()
  (interactive)
  (start-process-shell-command "terminator" nil "terminator"))
(use-package exwm
  :config
  ;; Set the default number of workspaces
  (setq exwm-workspace-number 10)

  ;; When window "class" updates, use it to set the buffer name
  (add-hook 'exwm-update-class-hook #'efs/exwm-update-class)

  ;; When window title updates, use it to set the buffer name
  (add-hook 'exwm-update-title-hook #'efs/exwm-update-title)

  ;; Configure windows as they're created
  (add-hook 'exwm-manage-finish-hook #'efs/configure-window-by-class)

  ;;Make char mode active
  (add-hook 'exwm-manage-finish-hook #'exwm-input-release-keyboard)

  ;; When EXWM starts up, do some extra confifuration
  (add-hook 'exwm-init-hook #'efs/exwm-init-hook)

  (add-hook 'exwm-manage-finish-hook
            (lambda ()
              (when (and exwm-class-name
                         (string= exwm-class-name "Terminator"))
                (exwm-input-set-local-simulation-keys '(([?\C-c ?\C-c] . ?\C-c))))))

  ;;keyboard layout is us or dvp
  (start-process-shell-command "setxkbmap" nil "setxkbmap -model 'pc104' -layout 'us(cmk_ed_us), us' -option 'misc:extend,lv5:caps_switch_lock,grp:shifts_toggle,compose:menu'")
  ;;(start-process-shell-command "setxkbmap" nil "setxkbmap -model pc104 -layout us -variant colemak")



  ;; Rebind Alt Car and Prt Scr to Ctrl
  (start-process-shell-command "xmodmap" nil "xmodmap ~/.emacs.d/exwm/Xmodmap")


  ;;Would  seet keyboard layout to dvorak
  ;;(start-process-shell-command "setxkbmap" nil "setxkbmap -model pc104 -layout us -variant dvorak")
  ;; NOTE: Uncomment the following two options if you want window buffers
  ;;       to be available on all workspaces!

  ;; Automatically move EXWM buffer to current workspace when selected
  (setq exwm-layout-show-all-buffers t)

  ;; Display all EXWM buffers in every workspace buffer list
  (setq exwm-workspace-show-all-buffers t)

  ;; NOTE: Uncomment this option if you want :w
  ;;to detach the minibuffer!
  ;; Detach the minibuffer (show it with exwm-workspace-toggle-minibuffer)
  ;;(setq exwm-workspace-minibuffer-position 'top)

  ;; Set the screen resolution (update this to be the correct resolution for your screen!)
  (require 'exwm-randr)
  (exwm-randr-enable)
  (start-process-shell-command "xrandr" nil "xrandr --output Virtual-1 --primary --mode 1920x1080x32 --pos 0x0 --rotate normal")

  ;; Set the wallpaper after changing the resolution
  (efs/set-wallpaper)

  ;; Load the system tray before exwm-init
  (require 'exwm-systemtray)
  (setq exwm-systemtray-height 32)
  ;;(exwm-systemtray-enable)

  ;;Launch picom on startup
  (start-process-shell-command "picom" nil "picom")
  ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
    '(?\C-x
      ?\C-u
      ?\C-h
      ?\M-x
      ?\M-`
      ?\M-&
      ?\M-:
      ?\C-\M-j  ;; Buffer list
      ?\C-\ ))  ;; Ctrl+Space

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings.  These always work, no matter the input state!
  ;; Keep in mind that changing this list after EXWM initializes has no effect.
  (setq exwm-input-global-keys
        `(
          ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)


          ([?\s-r] . exwm-reset)

          ;;Swaps Windows
          ([s-M-left] . windmove-swap-states-left)
          ([s-M-right] . windmove-swap-states-right)
          ([s-M-up] . windmove-swap-states-up)
          ([s-M-down] . windmove-swap-states-down)

          ;; Move between windows
          ([s-left] . windmove-left)
          ([s-right] . windmove-right)
          ([s-up] . windmove-up)
          ([s-down] . windmove-down)

          ;;VIM window control
          ;;Swaps Windows
          ([s-M-h] . windmove-swap-states-left)
          ([s-M-l] . windmove-swap-states-right)
          ([s-M-k] . windmove-swap-states-up)
          ([s-M-j] . windmove-swap-states-down)

          ;;Moves between windows
          ([?\s-h] . windmove-left)
          ([?\s-l] . windmove-right)
          ([?\s-k] . windmove-up)
          ([?\s-j] . windmove-down)



          ;;Log Out
          ([?\C-x ?\C-c] . save-buffer-kill-emacs)

          ;;Kills current buffer
          ([?\s-c] . kill-buffer)
          ;;Removes a Window
          ([?\s-q] . delete-window)
          ;;Kills current buffer and removes window
          ;;([?\s-Q] . kill-buffer-and-window)


          ;;Window Splitting

          ([?\s-y] . split-window-right)
          ([?\s-x] . split-window-below)

          ;; Launch applications via shell command
          ([?\s-.] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))

          ;; Switch workspace
          ([?\s-w] . exwm-workspace-switch)
          ([?\s-`] . (lambda () (interactive) (exwm-workspace-switch-create 0)))

          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  (exwm-input-set-key (kbd "s-SPC") 'counsel-linux-app)
  ;; Epic Volume aadjustment
  (exwm-input-set-key (kbd "s-[") 'desktop-environment-volume-decrement-slowly)
  (exwm-input-set-key (kbd "s-]") 'desktop-environment-volume-increment-slowly)
  (exwm-input-set-key (kbd "s-<return>") 'open-terminal)


  ;;Resize Windows  
  (exwm-input-set-key (kbd "s-C-h") 'exwm-layout-shrink-window-horizontally)
  (exwm-input-set-key (kbd "s-C-j") 'exwm-layout-shrink-window)
  (exwm-input-set-key (kbd "s-C-k") 'exwm-layout-enlarge-window)
  (exwm-input-set-key (kbd "s-C-l") 'exwm-layout-enlarge-window-horizontally)
  ;;Resize Windows  
  (exwm-input-set-key (kbd "s-M-h") 'windmove-swap-states-left)
  (exwm-input-set-key (kbd "s-M-j") 'windmove-swap-states-down)
  (exwm-input-set-key (kbd "s-M-k") 'windmove-swap-states-up)
  (exwm-input-set-key (kbd "s-M-l") 'windmove-swap-states-right)
  (exwm-enable))

(use-package desktop-environment
  :after exwm
  :custom
  (desktop-environment-brightness-small-increment "2%+")
  (desktop-environment-brightness-small-decrement "2%-")
  (desktop-environment-brightness-normal-increment "5%+")
  (desktop-environment-brightness-normal-decrement "5%-"))

;;; exwm.el --- Emacs X Window Manager  -*- lexical-binding: t -*-

;; Copyright (C) 2015-2020 Free Software Foundation, Inc.

;; Author: Chris Feng <chris.w.feng@gmail.com>
;; Maintainer: Chris Feng <chris.w.feng@gmail.com>
;; Version: 0.24
;; Package-Requires: ((xelb "0.18"))
;; Keywords: unix
;; URL: https://github.com/ch11ng/exwm

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Overview
;; --------
;; EXWM (Emacs X Window Manager) is a full-featured tiling X window manager
;; for Emacs built on top of [XELB](https://github.com/ch11ng/xelb).
;; It features:
;; + Fully keyboard-driven operations
;; + Hybrid layout modes (tiling & stacking)
;; + Dynamic workspace support
;; + ICCCM/EWMH compliance
;; + (Optional) RandR (multi-monitor) support
;; + (Optional) Built-in system tray

;; Installation & configuration
;; ----------------------------
;; Here are the minimal steps to get EXWM working:
;; 1. Install XELB and EXWM, and make sure they are in `load-path'.
;; 2. In '~/.emacs', add following lines (please modify accordingly):
;;
;;    (require 'exwm)
;;    (require 'exwm-config)
;;    (exwm-config-example)
;;
;; 3. Link or copy the file 'xinitrc' to '~/.xinitrc'.
;; 4. Launch EXWM in a console (e.g. tty1) with
;;
;;    xinit -- vt01
;;
;; You should additionally hide the menu-bar, tool-bar, etc to increase the
;; usable space.  Please check the wiki (https://github.com/ch11ng/exwm/wiki)
;; for more detailed instructions on installation, configuration, usage, etc.

;; References:
;; + dwm (http://dwm.suckless.org/)
;; + i3 wm (https://i3wm.org/)
;; + Also see references within each required library.

;;; Code:

(require 'server)
(require 'exwm-core)
(require 'exwm-workspace)
(require 'exwm-layout)
(require 'exwm-floating)
(require 'exwm-manage)
(require 'exwm-input)

(defgroup exwm nil
  "Emacs X Window Manager."
  :tag "EXWM"
  :version "25.3"
  :group 'applications
  :prefix "exwm-")

(defcustom exwm-init-hook nil
  "Normal hook run when EXWM has just finished initialization."
  :type 'hook)

(defcustom exwm-exit-hook nil
  "Normal hook run just before EXWM exits."
  :type 'hook)

(defcustom exwm-update-class-hook nil
  "Normal hook run when window class is updated."
  :type 'hook)

(defcustom exwm-update-title-hook nil
  "Normal hook run when window title is updated."
  :type 'hook)

(defcustom exwm-blocking-subrs '(x-file-dialog x-popup-dialog x-select-font)
  "Subrs (primitives) that would normally block EXWM."
  :type '(repeat function))

(defcustom exwm-replace 'ask
  "Whether to replace existing window manager."
  :type '(radio (const :tag "Ask" ask)
                (const :tag "Replace by default" t)
                (const :tag "Do not replace" nil)))

(defconst exwm--server-name "server-exwm"
  "Name of the subordinate Emacs server.")

(defvar exwm--server-process nil "Process of the subordinate Emacs server.")

(defun exwm-reset ()
  "Reset the state of the selected window (non-fullscreen, line-mode, etc)."
  (interactive)
  (exwm--log)
  (with-current-buffer (window-buffer)
    (when (derived-mode-p 'exwm-mode)
      (when (exwm-layout--fullscreen-p)
        (exwm-layout-unset-fullscreen))
      ;; Force refresh
      (exwm-layout--refresh)
      (call-interactively #'exwm-input-grab-keyboard))))

;;;###autoload
(defun exwm-restart ()
  "Restart EXWM."
  (interactive)
  (exwm--log)
  (when (exwm--confirm-kill-emacs "[EXWM] Restart? " 'no-check)
    (let* ((attr (process-attributes (emacs-pid)))
           (args (cdr (assq 'args attr)))
           (ppid (cdr (assq 'ppid attr)))
           (pargs (cdr (assq 'args (process-attributes ppid)))))
      (cond
       ((= ppid 1)
        ;; The parent is the init process.  This probably means this
        ;; instance is an emacsclient.  Anyway, start a control instance
        ;; to manage the subsequent ones.
        (call-process (car command-line-args))
        (kill-emacs))
       ((string= args pargs)
        ;; This is a subordinate instance.  Return a magic number to
        ;; inform the parent (control instance) to start another one.
        (kill-emacs ?R))
       (t
        ;; This is the control instance.  Keep starting subordinate
        ;; instances until told to exit.
        ;; Run `server-force-stop' if it exists.
        (run-hooks 'kill-emacs-hook)
        (with-temp-buffer
          (while (= ?R (shell-command-on-region (point) (point) args))))
        (kill-emacs))))))

(defun exwm--update-desktop (xwin)
  "Update _NET_WM_DESKTOP."
  (exwm--log "#x%x" xwin)
  (with-current-buffer (exwm--id->buffer xwin)
    (let ((reply (xcb:+request-unchecked+reply exwm--connection
                     (make-instance 'xcb:ewmh:get-_NET_WM_DESKTOP
                                    :window xwin)))
          desktop)
      (when reply
        (setq desktop (slot-value reply 'value))
        (cond
         ((eq desktop 4294967295.)
          (unless (or (not exwm--floating-frame)
                      (eq exwm--frame exwm-workspace--current)
                      (and exwm--desktop
                           (= desktop exwm--desktop)))
            (exwm-layout--show xwin (frame-root-window exwm--floating-frame)))
          (setq exwm--desktop desktop))
         ((and desktop
               (< desktop (exwm-workspace--count))
               (if exwm--desktop
                   (/= desktop exwm--desktop)
                 (/= desktop (exwm-workspace--position exwm--frame))))
          (exwm-workspace-move-window desktop xwin))
         (t
          (exwm-workspace--set-desktop xwin)))))))

(defun exwm--update-window-type (id &optional force)
  "Update _NET_WM_WINDOW_TYPE."
  (exwm--log "#x%x" id)
  (with-current-buffer (exwm--id->buffer id)
    (unless (and exwm-window-type (not force))
      (let ((reply (xcb:+request-unchecked+reply exwm--connection
                       (make-instance 'xcb:ewmh:get-_NET_WM_WINDOW_TYPE
                                      :window id))))
        (when reply                     ;nil when destroyed
          (setq exwm-window-type (append (slot-value reply 'value) nil)))))))

(defun exwm--update-class (id &optional force)
  "Update WM_CLASS."
  (exwm--log "#x%x" id)
  (with-current-buffer (exwm--id->buffer id)
    (unless (and exwm-instance-name exwm-class-name (not force))
      (let ((reply (xcb:+request-unchecked+reply exwm--connection
                       (make-instance 'xcb:icccm:get-WM_CLASS :window id))))
        (when reply                     ;nil when destroyed
          (setq exwm-instance-name (slot-value reply 'instance-name)
                exwm-class-name (slot-value reply 'class-name))
          (when (and exwm-instance-name exwm-class-name)
            (run-hooks 'exwm-update-class-hook)))))))

(defun exwm--update-utf8-title (id &optional force)
  "Update _NET_WM_NAME."
  (exwm--log "#x%x" id)
  (with-current-buffer (exwm--id->buffer id)
    (when (or force (not exwm-title))
      (let ((reply (xcb:+request-unchecked+reply exwm--connection
                       (make-instance 'xcb:ewmh:get-_NET_WM_NAME :window id))))
        (when reply                     ;nil when destroyed
          (setq exwm-title (slot-value reply 'value))
          (when exwm-title
            (setq exwm--title-is-utf8 t)
            (run-hooks 'exwm-update-title-hook)))))))

(defun exwm--update-ctext-title (id &optional force)
  "Update WM_NAME."
  (exwm--log "#x%x" id)
  (with-current-buffer (exwm--id->buffer id)
    (unless (or exwm--title-is-utf8
                (and exwm-title (not force)))
      (let ((reply (xcb:+request-unchecked+reply exwm--connection
                       (make-instance 'xcb:icccm:get-WM_NAME :window id))))
        (when reply                     ;nil when destroyed
          (setq exwm-title (slot-value reply 'value))
          (when exwm-title
            (run-hooks 'exwm-update-title-hook)))))))

(defun exwm--update-title (id)
  "Update _NET_WM_NAME or WM_NAME."
  (exwm--log "#x%x" id)
  (exwm--update-utf8-title id)
  (exwm--update-ctext-title id))

(defun exwm--update-transient-for (id &optional force)
  "Update WM_TRANSIENT_FOR."
  (exwm--log "#x%x" id)
  (with-current-buffer (exwm--id->buffer id)
    (unless (and exwm-transient-for (not force))
      (let ((reply (xcb:+request-unchecked+reply exwm--connection
                       (make-instance 'xcb:icccm:get-WM_TRANSIENT_FOR
                                      :window id))))
        (when reply                     ;nil when destroyed
          (setq exwm-transient-for (slot-value reply 'value)))))))

(defun exwm--update-normal-hints (id &optional force)
  "Update WM_NORMAL_HINTS."
  (exwm--log "#x%x" id)
  (with-current-buffer (exwm--id->buffer id)
    (unless (and (not force)
                 (or exwm--normal-hints-x exwm--normal-hints-y
                     exwm--normal-hints-width exwm--normal-hints-height
                     exwm--normal-hints-min-width exwm--normal-hints-min-height
                     exwm--normal-hints-max-width exwm--normal-hints-max-height
                     ;; FIXME: other fields
                     ))
      (let ((reply (xcb:+request-unchecked+reply exwm--connection
                       (make-instance 'xcb:icccm:get-WM_NORMAL_HINTS
                                      :window id))))
        (when (and reply (slot-value reply 'flags)) ;nil when destroyed
          (with-slots (flags x y width height min-width min-height max-width
                             max-height base-width base-height ;; win-gravity
                             )
              reply
            (unless (= 0 (logand flags xcb:icccm:WM_SIZE_HINTS:USPosition))
              (setq exwm--normal-hints-x x exwm--normal-hints-y y))
            (unless (= 0 (logand flags xcb:icccm:WM_SIZE_HINTS:USSize))
              (setq exwm--normal-hints-width width
                    exwm--normal-hints-height height))
            (unless (= 0 (logand flags xcb:icccm:WM_SIZE_HINTS:PMinSize))
              (setq exwm--normal-hints-min-width min-width
                    exwm--normal-hints-min-height min-height))
            (unless (= 0 (logand flags xcb:icccm:WM_SIZE_HINTS:PMaxSize))
              (setq exwm--normal-hints-max-width max-width
                    exwm--normal-hints-max-height max-height))
            (unless (or exwm--normal-hints-min-width
                        (= 0 (logand flags xcb:icccm:WM_SIZE_HINTS:PBaseSize)))
              (setq exwm--normal-hints-min-width base-width
                    exwm--normal-hints-min-height base-height))
            ;; (unless (= 0 (logand flags xcb:icccm:WM_SIZE_HINTS:PWinGravity))
            ;;   (setq exwm--normal-hints-win-gravity win-gravity))
            (setq exwm--fixed-size
                  (and exwm--normal-hints-min-width
                       exwm--normal-hints-min-height
                       exwm--normal-hints-max-width
                       exwm--normal-hints-max-height
                       (/= 0 exwm--normal-hints-min-width)
                       (/= 0 exwm--normal-hints-min-height)
                       (= exwm--normal-hints-min-width
                          exwm--normal-hints-max-width)
                       (= exwm--normal-hints-min-height
                          exwm--normal-hints-max-height)))))))))

(defun exwm--update-hints (id &optional force)
  "Update WM_HINTS."
  (exwm--log "#x%x" id)
  (with-current-buffer (exwm--id->buffer id)
    (unless (and (not force) exwm--hints-input exwm--hints-urgency)
      (let ((reply (xcb:+request-unchecked+reply exwm--connection
                       (make-instance 'xcb:icccm:get-WM_HINTS :window id))))
        (when (and reply (slot-value reply 'flags)) ;nil when destroyed
          (with-slots (flags input initial-state) reply
            (when flags
              (unless (= 0 (logand flags xcb:icccm:WM_HINTS:InputHint))
                (setq exwm--hints-input (when input (= 1 input))))
              (unless (= 0 (logand flags xcb:icccm:WM_HINTS:StateHint))
                (setq exwm-state initial-state))
              (unless (= 0 (logand flags xcb:icccm:WM_HINTS:UrgencyHint))
                (setq exwm--hints-urgency t))))
          (when (and exwm--hints-urgency
                     (not (eq exwm--frame exwm-workspace--current)))
            (unless (frame-parameter exwm--frame 'exwm-urgency)
              (set-frame-parameter exwm--frame 'exwm-urgency t)
              (setq exwm-workspace--switch-history-outdated t))))))))

(defun exwm--update-protocols (id &optional force)
  "Update WM_PROTOCOLS."
  (exwm--log "#x%x" id)
  (with-current-buffer (exwm--id->buffer id)
    (unless (and exwm--protocols (not force))
      (let ((reply (xcb:+request-unchecked+reply exwm--connection
                       (make-instance 'xcb:icccm:get-WM_PROTOCOLS
                                      :window id))))
        (when reply                     ;nil when destroyed
          (setq exwm--protocols (append (slot-value reply 'value) nil)))))))

(defun exwm--update-struts-legacy (id)
  "Update _NET_WM_STRUT."
  (exwm--log "#x%x" id)
  (let ((pair (assq id exwm-workspace--id-struts-alist))
        reply struts)
    (unless (and pair (< 4 (length (cdr pair))))
      (setq reply (xcb:+request-unchecked+reply exwm--connection
                      (make-instance 'xcb:ewmh:get-_NET_WM_STRUT
                                     :window id)))
      (when reply
        (setq struts (slot-value reply 'value))
        (if pair
            (setcdr pair struts)
          (push (cons id struts) exwm-workspace--id-struts-alist))
        (exwm-workspace--update-struts))
      ;; Update workareas.
      (exwm-workspace--update-workareas)
      ;; Update workspaces.
      (dolist (f exwm-workspace--list)
        (exwm-workspace--set-fullscreen f)))))

(defun exwm--update-struts-partial (id)
  "Update _NET_WM_STRUT_PARTIAL."
  (exwm--log "#x%x" id)
  (let ((reply (xcb:+request-unchecked+reply exwm--connection
                   (make-instance 'xcb:ewmh:get-_NET_WM_STRUT_PARTIAL
                                  :window id)))
        struts pair)
    (when reply
      (setq struts (slot-value reply 'value)
            pair (assq id exwm-workspace--id-struts-alist))
      (if pair
          (setcdr pair struts)
        (push (cons id struts) exwm-workspace--id-struts-alist))
      (exwm-workspace--update-struts))
    ;; Update workareas.
    (exwm-workspace--update-workareas)
    ;; Update workspaces.
    (dolist (f exwm-workspace--list)
      (exwm-workspace--set-fullscreen f))))

(defun exwm--update-struts (id)
  "Update _NET_WM_STRUT_PARTIAL or _NET_WM_STRUT."
  (exwm--log "#x%x" id)
  (exwm--update-struts-partial id)
  (exwm--update-struts-legacy id))

(defun exwm--on-PropertyNotify (data _synthetic)
  "Handle PropertyNotify event."
  (let ((obj (make-instance 'xcb:PropertyNotify))
        atom id buffer)
    (xcb:unmarshal obj data)
    (setq id (slot-value obj 'window)
          atom (slot-value obj 'atom))
    (exwm--log "atom=%s(%s)" (x-get-atom-name atom exwm-workspace--current) atom)
    (setq buffer (exwm--id->buffer id))
    (if (not (buffer-live-p buffer))
        ;; Properties of unmanaged X windows.
        (cond ((= atom xcb:Atom:_NET_WM_STRUT)
               (exwm--update-struts-legacy id))
              ((= atom xcb:Atom:_NET_WM_STRUT_PARTIAL)
               (exwm--update-struts-partial id)))
      (with-current-buffer buffer
        (cond ((= atom xcb:Atom:_NET_WM_WINDOW_TYPE)
               (exwm--update-window-type id t))
              ((= atom xcb:Atom:WM_CLASS)
               (exwm--update-class id t))
              ((= atom xcb:Atom:_NET_WM_NAME)
               (exwm--update-utf8-title id t))
              ((= atom xcb:Atom:WM_NAME)
               (exwm--update-ctext-title id t))
              ((= atom xcb:Atom:WM_TRANSIENT_FOR)
               (exwm--update-transient-for id t))
              ((= atom xcb:Atom:WM_NORMAL_HINTS)
               (exwm--update-normal-hints id t))
              ((= atom xcb:Atom:WM_HINTS)
               (exwm--update-hints id t))
              ((= atom xcb:Atom:WM_PROTOCOLS)
               (exwm--update-protocols id t))
              ((= atom xcb:Atom:_NET_WM_USER_TIME)) ;ignored
              (t
               (exwm--log "Unhandled: %s(%d)"
                          (x-get-atom-name atom exwm-workspace--current)
                          atom)))))))

(defun exwm--on-ClientMessage (raw-data _synthetic)
  "Handle ClientMessage event."
  (let ((obj (make-instance 'xcb:ClientMessage))
        type id data)
    (xcb:unmarshal obj raw-data)
    (setq type (slot-value obj 'type)
          id (slot-value obj 'window)
          data (slot-value (slot-value obj 'data) 'data32))
    (exwm--log "atom=%s(%s)" (x-get-atom-name type exwm-workspace--current)
               type)
    (cond
     ;; _NET_NUMBER_OF_DESKTOPS.
     ((= type xcb:Atom:_NET_NUMBER_OF_DESKTOPS)
      (let ((current (exwm-workspace--count))
            (requested (elt data 0)))
        ;; Only allow increasing/decreasing the workspace number by 1.
        (cond
         ((< current requested)
          (make-frame))
         ((and (> current requested)
               (> current 1))
          (let ((frame (car (last exwm-workspace--list))))
            (exwm-workspace--get-remove-frame-next-workspace frame)
            (delete-frame frame))))))
     ;; _NET_CURRENT_DESKTOP.
     ((= type xcb:Atom:_NET_CURRENT_DESKTOP)
      (exwm-workspace-switch (elt data 0)))
     ;; _NET_ACTIVE_WINDOW.
     ((= type xcb:Atom:_NET_ACTIVE_WINDOW)
      (let ((buffer (exwm--id->buffer id))
            iconic window)
        (when (buffer-live-p buffer)
          (with-current-buffer buffer
            (when (eq exwm--frame exwm-workspace--current)
              (if exwm--floating-frame
                  (select-frame exwm--floating-frame)
                (setq iconic (exwm-layout--iconic-state-p))
                (when iconic
                  ;; State change: iconic => normal.
                  (set-window-buffer (frame-selected-window exwm--frame)
                                     (current-buffer)))
                ;; Focus transfer.
                (setq window (get-buffer-window nil t))
                (when (or iconic
                          (not (eq window (selected-window))))
                  (select-window window))))))))
     ;; _NET_CLOSE_WINDOW.
     ((= type xcb:Atom:_NET_CLOSE_WINDOW)
      (let ((buffer (exwm--id->buffer id)))
        (when (buffer-live-p buffer)
          (exwm--defer 0 #'kill-buffer buffer))))
     ;; _NET_WM_MOVERESIZE
     ((= type xcb:Atom:_NET_WM_MOVERESIZE)
      (let ((direction (elt data 2))
            (buffer (exwm--id->buffer id)))
        (unless (and buffer
                     (not (buffer-local-value 'exwm--floating-frame buffer)))
          (cond ((= direction
                    xcb:ewmh:_NET_WM_MOVERESIZE_SIZE_KEYBOARD)
                 ;; FIXME
                 )
                ((= direction
                    xcb:ewmh:_NET_WM_MOVERESIZE_MOVE_KEYBOARD)
                 ;; FIXME
                 )
                ((= direction xcb:ewmh:_NET_WM_MOVERESIZE_CANCEL)
                 (exwm-floating--stop-moveresize))
                ;; In case it's a workspace frame.
                ((and (not buffer)
                      (catch 'break
                        (dolist (f exwm-workspace--list)
                          (when (or (eq id (frame-parameter f 'exwm-outer-id))
                                    (eq id (frame-parameter f 'exwm-id)))
                            (throw 'break t)))
                        nil)))
                (t
                 ;; In case it's a floating frame,
                 ;; move the corresponding X window instead.
                 (unless buffer
                   (catch 'break
                     (dolist (pair exwm--id-buffer-alist)
                       (with-current-buffer (cdr pair)
                         (when
                             (and exwm--floating-frame
                                  (or (eq id
                                          (frame-parameter exwm--floating-frame
                                                           'exwm-outer-id))
                                      (eq id
                                          (frame-parameter exwm--floating-frame
                                                           'exwm-id))))
                           (setq id exwm--id)
                           (throw 'break nil))))))
                 ;; Start to move it.
                 (exwm-floating--start-moveresize id direction))))))
     ;; _NET_REQUEST_FRAME_EXTENTS
     ((= type xcb:Atom:_NET_REQUEST_FRAME_EXTENTS)
      (let ((buffer (exwm--id->buffer id))
            top btm)
        (if (or (not buffer)
                (not (buffer-local-value 'exwm--floating-frame buffer)))
            (setq top 0
                  btm 0)
          (setq top (window-header-line-height)
                btm (window-mode-line-height)))
        (xcb:+request exwm--connection
            (make-instance 'xcb:ewmh:set-_NET_FRAME_EXTENTS
                           :window id
                           :left 0
                           :right 0
                           :top top
                           :bottom btm)))
      (xcb:flush exwm--connection))
     ;; _NET_WM_DESKTOP.
     ((= type xcb:Atom:_NET_WM_DESKTOP)
      (let ((buffer (exwm--id->buffer id)))
        (when (buffer-live-p buffer)
          (exwm-workspace-move-window (elt data 0) id))))
     ;; _NET_WM_STATE
     ((= type xcb:Atom:_NET_WM_STATE)
      (let ((action (elt data 0))
            (props (list (elt data 1) (elt data 2)))
            (buffer (exwm--id->buffer id))
            props-new)
        ;; only support _NET_WM_STATE_FULLSCREEN / _NET_WM_STATE_ADD for frames
        ;;(when (and (not buffer)
                   ;;(memq xcb:Atom:_NET_WM_STATE_FULLSCREEN props)
                   ;;(= action xcb:ewmh:_NET_WM_STATE_ADD)))
          ;;(xcb:+request
              ;;exwm--connection
              ;;(make-instance 'xcb:ewmh:set-_NET_WM_STATE
                             ;;:window id
                             ;;:data (vector xcb:Atom:_NET_WM_STATE_FULLSCREEN)))
          ;;(xcb:flush exwm--connection))
        (when buffer                    ;ensure it's managed
          (with-current-buffer buffer
            ;; _NET_WM_STATE_FULLSCREEN
            (when (or (memq xcb:Atom:_NET_WM_STATE_FULLSCREEN props)
                      (memq xcb:Atom:_NET_WM_STATE_ABOVE props))
              (cond ((= action xcb:ewmh:_NET_WM_STATE_ADD)
                     (unless (exwm-layout--fullscreen-p)
                       (exwm-layout-unset-fullscreen id))
                     (push xcb:Atom:_NET_WM_STATE_FULLSCREEN props-new))
                    ((= action xcb:ewmh:_NET_WM_STATE_REMOVE)
                     (when (exwm-layout--fullscreen-p)
                       (exwm-layout-unset-fullscreen id)))
                    ((= action xcb:ewmh:_NET_WM_STATE_TOGGLE)
                     (if (exwm-layout--fullscreen-p)
                         (exwm-layout-unset-fullscreen id)
                       (push xcb:Atom:_NET_WM_STATE_FULLSCREEN props-new))
                     (split-window-right)
                     (windmove-right)
                     (delete-window)

                     (exwm-layout-enlarge-window)
                     (exwm-layout-shrink-window)
                     (exwm-reset))))

            ;; _NET_WM_STATE_DEMANDS_ATTENTION
            ;; FIXME: check (may require other properties set)
            (when (memq xcb:Atom:_NET_WM_STATE_DEMANDS_ATTENTION props)
              (when (= action xcb:ewmh:_NET_WM_STATE_ADD)
                (unless (eq exwm--frame exwm-workspace--current)
                  (set-frame-parameter exwm--frame 'exwm-urgency t)
                  (setq exwm-workspace--switch-history-outdated t)))
              ;; xcb:ewmh:_NET_WM_STATE_REMOVE?
              ;; xcb:ewmh:_NET_WM_STATE_TOGGLE?
              )
            (xcb:+request exwm--connection
                (make-instance 'xcb:ewmh:set-_NET_WM_STATE
                               :window id :data (vconcat props-new)))
            (xcb:flush exwm--connection)))))
     ((= type xcb:Atom:WM_PROTOCOLS)
      (let ((type (elt data 0)))
        (cond ((= type xcb:Atom:_NET_WM_PING)
               (setq exwm-manage--ping-lock nil))
              (t (exwm--log "Unhandled WM_PROTOCOLS of type: %d" type)))))
     ((= type xcb:Atom:WM_CHANGE_STATE)
      (let ((buffer (exwm--id->buffer id)))
        (when (and (buffer-live-p buffer)
                   (= (elt data 0) xcb:icccm:WM_STATE:IconicState))
          (with-current-buffer buffer
            (if exwm--floating-frame
                (call-interactively #'exwm-floating-hide)
              (bury-buffer))))))
     (t
      (exwm--log "Unhandled: %s(%d)"
                 (x-get-atom-name type exwm-workspace--current) type)))))

(defun exwm--on-SelectionClear (data _synthetic)
  "Handle SelectionClear events."
  (exwm--log)
  (let ((obj (make-instance 'xcb:SelectionClear))
        owner selection)
    (xcb:unmarshal obj data)
    (setq owner (slot-value obj 'owner)
          selection (slot-value obj 'selection))
    (when (and (eq owner exwm--wmsn-window)
               (eq selection xcb:Atom:WM_S0))
      (exwm-exit))))

(defun exwm--init-icccm-ewmh ()
  "Initialize ICCCM/EWMH support."
  (exwm--log)
  ;; Handle PropertyNotify event
  (xcb:+event exwm--connection 'xcb:PropertyNotify #'exwm--on-PropertyNotify)
  ;; Handle relevant client messages
  (xcb:+event exwm--connection 'xcb:ClientMessage #'exwm--on-ClientMessage)
  ;; Handle SelectionClear
  (xcb:+event exwm--connection 'xcb:SelectionClear #'exwm--on-SelectionClear)
  ;; Set _NET_SUPPORTED
  (xcb:+request exwm--connection
      (make-instance 'xcb:ewmh:set-_NET_SUPPORTED
                     :window exwm--root
                     :data (vector
                            ;; Root windows properties.
                            xcb:Atom:_NET_SUPPORTED
                            xcb:Atom:_NET_CLIENT_LIST
                            xcb:Atom:_NET_CLIENT_LIST_STACKING
                            xcb:Atom:_NET_NUMBER_OF_DESKTOPS
                            xcb:Atom:_NET_DESKTOP_GEOMETRY
                            xcb:Atom:_NET_DESKTOP_VIEWPORT
                            xcb:Atom:_NET_CURRENT_DESKTOP
                            ;; xcb:Atom:_NET_DESKTOP_NAMES
                            xcb:Atom:_NET_ACTIVE_WINDOW
                            ;; xcb:Atom:_NET_WORKAREA
                            xcb:Atom:_NET_SUPPORTING_WM_CHECK
                            ;; xcb:Atom:_NET_VIRTUAL_ROOTS
                            ;; xcb:Atom:_NET_DESKTOP_LAYOUT
                            ;; xcb:Atom:_NET_SHOWING_DESKTOP

                            ;; Other root window messages.
                            xcb:Atom:_NET_CLOSE_WINDOW
                            ;; xcb:Atom:_NET_MOVERESIZE_WINDOW
                            xcb:Atom:_NET_WM_MOVERESIZE
                            ;; xcb:Atom:_NET_RESTACK_WINDOW
                            xcb:Atom:_NET_REQUEST_FRAME_EXTENTS

                            ;; Application window properties.
                            xcb:Atom:_NET_WM_NAME
                            ;; xcb:Atom:_NET_WM_VISIBLE_NAME
                            ;; xcb:Atom:_NET_WM_ICON_NAME
                            ;; xcb:Atom:_NET_WM_VISIBLE_ICON_NAME
                            xcb:Atom:_NET_WM_DESKTOP
                            ;;
                            xcb:Atom:_NET_WM_WINDOW_TYPE
                            ;; xcb:Atom:_NET_WM_WINDOW_TYPE_DESKTOP
                            xcb:Atom:_NET_WM_WINDOW_TYPE_DOCK
                            xcb:Atom:_NET_WM_WINDOW_TYPE_TOOLBAR
                            xcb:Atom:_NET_WM_WINDOW_TYPE_MENU
                            xcb:Atom:_NET_WM_WINDOW_TYPE_UTILITY
                            xcb:Atom:_NET_WM_WINDOW_TYPE_SPLASH
                            xcb:Atom:_NET_WM_WINDOW_TYPE_DIALOG
                            xcb:Atom:_NET_WM_WINDOW_TYPE_DROPDOWN_MENU
                            xcb:Atom:_NET_WM_WINDOW_TYPE_POPUP_MENU
                            xcb:Atom:_NET_WM_WINDOW_TYPE_TOOLTIP
                            xcb:Atom:_NET_WM_WINDOW_TYPE_NOTIFICATION
                            xcb:Atom:_NET_WM_WINDOW_TYPE_COMBO
                            xcb:Atom:_NET_WM_WINDOW_TYPE_DND
                            xcb:Atom:_NET_WM_WINDOW_TYPE_NORMAL
                            ;;
                            xcb:Atom:_NET_WM_STATE
                            ;; xcb:Atom:_NET_WM_STATE_MODAL
                            ;; xcb:Atom:_NET_WM_STATE_STICKY
                            ;; xcb:Atom:_NET_WM_STATE_MAXIMIZED_VERT
                            ;; xcb:Atom:_NET_WM_STATE_MAXIMIZED_HORZ
                            ;; xcb:Atom:_NET_WM_STATE_SHADED
                            ;; xcb:Atom:_NET_WM_STATE_SKIP_TASKBAR
                            ;; xcb:Atom:_NET_WM_STATE_SKIP_PAGER
                            xcb:Atom:_NET_WM_STATE_HIDDEN
                            ;;NOTE: COMMENTED OUT FOR FULLSCREEN SHENANIGANS

                            ;; xcb:Atom:_NET_WM_STATE_FULLSCREEN
                            ;; xcb:Atom:_NET_WM_STATE_ABOVE
                            ;; xcb:Atom:_NET_WM_STATE_BELOW
                            xcb:Atom:_NET_WM_STATE_DEMANDS_ATTENTION
                            ;; xcb:Atom:_NET_WM_STATE_FOCUSED
                            ;;
                            xcb:Atom:_NET_WM_ALLOWED_ACTIONS
                            xcb:Atom:_NET_WM_ACTION_MOVE
                            xcb:Atom:_NET_WM_ACTION_RESIZE
                            xcb:Atom:_NET_WM_ACTION_MINIMIZE
                            ;; xcb:Atom:_NET_WM_ACTION_SHADE
                            ;; xcb:Atom:_NET_WM_ACTION_STICK
                            ;; xcb:Atom:_NET_WM_ACTION_MAXIMIZE_HORZ
                            ;; xcb:Atom:_NET_WM_ACTION_MAXIMIZE_VERT
                            ;; NOTE: COMMENTED OUT FOR FULLSCREEN SHENANIGANS

                            ;; xcb:Atom:_NET_WM_ACTION_FULLSCREEN
                            xcb:Atom:_NET_WM_ACTION_CHANGE_DESKTOP
                            xcb:Atom:_NET_WM_ACTION_CLOSE
                            ;; xcb:Atom:_NET_WM_ACTION_ABOVE
                            ;; xcb:Atom:_NET_WM_ACTION_BELOW
                            ;;
                            xcb:Atom:_NET_WM_STRUT
                            xcb:Atom:_NET_WM_STRUT_PARTIAL
                            ;; xcb:Atom:_NET_WM_ICON_GEOMETRY
                            ;; xcb:Atom:_NET_WM_ICON
                            xcb:Atom:_NET_WM_PID
                            ;; xcb:Atom:_NET_WM_HANDLED_ICONS
                            ;; xcb:Atom:_NET_WM_USER_TIME
                            ;; xcb:Atom:_NET_WM_USER_TIME_WINDOW
                            xcb:Atom:_NET_FRAME_EXTENTS
                            ;; xcb:Atom:_NET_WM_OPAQUE_REGION
                            ;; xcb:Atom:_NET_WM_BYPASS_COMPOSITOR

                            ;; Window manager protocols.
                            xcb:Atom:_NET_WM_PING
                            ;; xcb:Atom:_NET_WM_SYNC_REQUEST
                            ;; xcb:Atom:_NET_WM_FULLSCREEN_MONITORS

                            ;; Other properties.
                            xcb:Atom:_NET_WM_FULL_PLACEMENT)))
  ;; Create a child window for setting _NET_SUPPORTING_WM_CHECK
  (let ((new-id (xcb:generate-id exwm--connection)))
    (setq exwm--guide-window new-id)
    (xcb:+request exwm--connection
        (make-instance 'xcb:CreateWindow
                       :depth 0
                       :wid new-id
                       :parent exwm--root
                       :x -1
                       :y -1
                       :width 1
                       :height 1
                       :border-width 0
                       :class xcb:WindowClass:InputOnly
                       :visual 0
                       :value-mask xcb:CW:OverrideRedirect
                       :override-redirect 1))
    ;; Set _NET_WM_NAME.  Must be set to the name of the window manager, as
    ;; required by wm-spec.
    (xcb:+request exwm--connection
        (make-instance 'xcb:ewmh:set-_NET_WM_NAME
                       :window new-id :data "EXWM"))
    (dolist (i (list exwm--root new-id))
      ;; Set _NET_SUPPORTING_WM_CHECK
      (xcb:+request exwm--connection
          (make-instance 'xcb:ewmh:set-_NET_SUPPORTING_WM_CHECK
                         :window i :data new-id))))
  ;; Set _NET_DESKTOP_VIEWPORT (we don't support large desktop).
  (xcb:+request exwm--connection
      (make-instance 'xcb:ewmh:set-_NET_DESKTOP_VIEWPORT
                     :window exwm--root
                     :data [0 0]))
  (xcb:flush exwm--connection))

(defun exwm--wmsn-acquire (replace)
  "Acquire the WM_Sn selection.

REPLACE specifies what to do in case there already is a window
manager.  If t, replace it, if nil, abort and ask the user if `ask'."
  (exwm--log "%s" replace)
  (with-slots (owner)
      (xcb:+request-unchecked+reply exwm--connection
          (make-instance 'xcb:GetSelectionOwner
                         :selection xcb:Atom:WM_S0))
    (when (/= owner xcb:Window:None)
      (when (eq replace 'ask)
        (setq replace (yes-or-no-p "Replace existing window manager? ")))
      (when (not replace)
        (user-error "Other window manager detected")))
    (let ((new-owner (xcb:generate-id exwm--connection)))
      (xcb:+request exwm--connection
          (make-instance 'xcb:CreateWindow
                         :depth 0
                         :wid new-owner
                         :parent exwm--root
                         :x -1
                         :y -1
                         :width 1
                         :height 1
                         :border-width 0
                         :class xcb:WindowClass:CopyFromParent
                         :visual 0
                         :value-mask 0
                         :override-redirect 0))
      (xcb:+request exwm--connection
          (make-instance 'xcb:ewmh:set-_NET_WM_NAME
                         :window new-owner :data "EXWM: exwm--wmsn-window"))
      (xcb:+request-checked+request-check exwm--connection
          (make-instance 'xcb:SetSelectionOwner
                         :selection xcb:Atom:WM_S0
                         :owner new-owner
                         :time xcb:Time:CurrentTime))
      (with-slots (owner)
          (xcb:+request-unchecked+reply exwm--connection
              (make-instance 'xcb:GetSelectionOwner
                             :selection xcb:Atom:WM_S0))
        (unless (eq owner new-owner)
          (error "Could not acquire ownership of WM selection")))
      ;; Wait for the other window manager to terminate.
      (when (/= owner xcb:Window:None)
        (let (reply)
          (cl-dotimes (i exwm--wmsn-acquire-timeout)
            (setq reply (xcb:+request-unchecked+reply exwm--connection
                            (make-instance 'xcb:GetGeometry :drawable owner)))
            (when (not reply)
              (cl-return))
            (message "Waiting for other window manager to quit... %ds" i)
            (sleep-for 1))
          (when reply
            (error "Other window manager did not release selection in time"))))
      ;; announce
      (let* ((cmd (make-instance 'xcb:ClientMessageData
                                 :data32 (vector xcb:Time:CurrentTime
                                                 xcb:Atom:WM_S0
                                                 new-owner
                                                 0
                                                 0)))
             (cm (make-instance 'xcb:ClientMessage
                                               :window exwm--root
                                               :format 32
                                               :type xcb:Atom:MANAGER
                                               :data cmd))
             (se (make-instance 'xcb:SendEvent
                         :propagate 0
                         :destination exwm--root
                         :event-mask xcb:EventMask:NoEvent
                         :event (xcb:marshal cm exwm--connection))))
        (xcb:+request exwm--connection se))
      (setq exwm--wmsn-window new-owner))))

;;;###autoload
(cl-defun exwm-init (&optional frame)
  "Initialize EXWM."
  (interactive)
  (exwm--log "%s" frame)
  (if frame
      ;; The frame might not be selected if it's created by emacslicnet.
      (select-frame-set-input-focus frame)
    (setq frame (selected-frame)))
  (when (not (eq 'x (framep frame)))
    (message "[EXWM] Not running under X environment")
    (cl-return-from exwm-init))
  (when exwm--connection
    (exwm--log "EXWM already running")
    (cl-return-from exwm-init))
  (condition-case err
      (progn
        (exwm-enable 'undo)               ;never initialize again
        (setq exwm--connection (xcb:connect))
        (set-process-query-on-exit-flag (slot-value exwm--connection 'process)
                                        nil) ;prevent query message on exit
        (setq exwm--root
              (slot-value (car (slot-value
                                (xcb:get-setup exwm--connection) 'roots))
                          'root))
        ;; Initialize ICCCM/EWMH support
        (xcb:icccm:init exwm--connection t)
        (xcb:ewmh:init exwm--connection t)
        ;; Try to register window manager selection.
        (exwm--wmsn-acquire exwm-replace)
        (when (xcb:+request-checked+request-check exwm--connection
                  (make-instance 'xcb:ChangeWindowAttributes
                                 :window exwm--root
                                 :value-mask xcb:CW:EventMask
                                 :event-mask
                                 xcb:EventMask:SubstructureRedirect))
          (error "Other window manager is running"))
        ;; Disable some features not working well with EXWM
        (setq use-dialog-box nil
              confirm-kill-emacs #'exwm--confirm-kill-emacs)
        (exwm--lock)
        (exwm--init-icccm-ewmh)
        (exwm-layout--init)
        (exwm-floating--init)
        (exwm-manage--init)
        (exwm-workspace--init)
        (exwm-input--init)
        (exwm--unlock)
        (exwm-workspace--post-init)
        (exwm-input--post-init)
        (run-hooks 'exwm-init-hook)
        ;; Manage existing windows
        (exwm-manage--scan))
    (user-error)
    ((quit error)
     (exwm-exit)
     ;; Rethrow error
     (warn "[EXWM] EXWM fails to start (%s: %s)" (car err) (cdr err)))))


;;;###autoload
(defun exwm-exit ()
  "Exit EXWM."
  (interactive)
  (exwm--log)
  (run-hooks 'exwm-exit-hook)
  (setq confirm-kill-emacs nil)
  ;; Exit modules.
  (exwm-input--exit)
  (exwm-manage--exit)
  (exwm-workspace--exit)
  (exwm-floating--exit)
  (exwm-layout--exit)
  (when exwm--connection
    (xcb:flush exwm--connection)
    (xcb:disconnect exwm--connection))
  (setq exwm--connection nil))

;;;###autoload
(defun exwm-enable (&optional undo)
  "Enable/Disable EXWM."
  (exwm--log "%s" undo)
  (pcase undo
    (`undo                              ;prevent reinitialization
     (remove-hook 'window-setup-hook #'exwm-init)
     (remove-hook 'after-make-frame-functions #'exwm-init))
    (`undo-all                          ;attempt to revert everything
     (remove-hook 'window-setup-hook #'exwm-init)
     (remove-hook 'after-make-frame-functions #'exwm-init)
     (remove-hook 'kill-emacs-hook #'exwm--server-stop)
     (dolist (i exwm-blocking-subrs)
       (advice-remove i #'exwm--server-eval-at)))
    (_                                  ;enable EXWM
     (setq frame-resize-pixelwise t     ;mandatory; before init
           window-resize-pixelwise t)
     ;; Ignore unrecognized command line arguments.  This can be helpful
     ;; when EXWM is launched by some session manager.
     (push #'vector command-line-functions)
     ;; In case EXWM is to be started from a graphical Emacs instance.
     (add-hook 'window-setup-hook #'exwm-init t)
     ;; In case EXWM is to be started with emacsclient.
     (add-hook 'after-make-frame-functions #'exwm-init t)
     ;; Manage the subordinate Emacs server.
     (add-hook 'kill-emacs-hook #'exwm--server-stop)
     (dolist (i exwm-blocking-subrs)
       (advice-add i :around #'exwm--server-eval-at)))))

(defun exwm--server-stop ()
  "Stop the subordinate Emacs server."
  (exwm--log)
  (server-force-delete exwm--server-name)
  (when exwm--server-process
    (delete-process exwm--server-process)
    (setq exwm--server-process nil)))

(defun exwm--server-eval-at (&rest args)
  "Wrapper of `server-eval-at' used to advice subrs."
  ;; Start the subordinate Emacs server if it's not alive
  (exwm--log "%s" args)
  (unless (server-running-p exwm--server-name)
    (when exwm--server-process (delete-process exwm--server-process))
    (setq exwm--server-process
          (start-process exwm--server-name
                         nil
                         (car command-line-args) ;The executable file
                         "-d" (frame-parameter nil 'display)
                         "-Q"
                         (concat "--daemon=" exwm--server-name)
                         "--eval"
                         ;; Create an invisible frame
                         "(make-frame '((window-system . x) (visibility)))"))
    (while (not (server-running-p exwm--server-name))
      (sit-for 0.001)))
  (server-eval-at
   exwm--server-name
   `(progn (select-frame (car (frame-list)))
           (let ((result ,(nconc (list (make-symbol (subr-name (car args))))
                                 (cdr args))))
             (pcase (type-of result)
               ;; Return the name of a buffer
               (`buffer (buffer-name result))
               ;; We blindly convert all font objects to their XLFD names. This
               ;; might cause problems of course, but it still has a chance to
               ;; work (whereas directly passing font objects would merely
               ;; raise errors).
               ((or `font-entity `font-object `font-spec)
                (font-xlfd-name result))
               ;; Passing following types makes little sense
               ((or `compiled-function `finalizer `frame `hash-table `marker
                    `overlay `process `window `window-configuration))
               ;; Passing the name of a subr
               (`subr (make-symbol (subr-name result)))
               ;; For other types, return the value as-is.
               (t result))))))

(defun exwm--confirm-kill-emacs (prompt &optional force)
  "Confirm before exiting Emacs."
  (exwm--log)
  (when (cond
         ((and force (not (eq force 'no-check)))
          ;; Force killing Emacs.
          t)
         ((or (eq force 'no-check) (not exwm--id-buffer-alist))
          ;; Check if there's any unsaved file.
          (pcase (catch 'break
                   (let ((kill-emacs-query-functions
                          (append kill-emacs-query-functions
                                  (list (lambda ()
                                          (throw 'break 'break))))))
                     (save-buffers-kill-emacs)))
            (`break (y-or-n-p prompt))
            (x x)))
         (t
          (yes-or-no-p (format "[EXWM] %d window(s) will be destroyed.  %s"
                               (length exwm--id-buffer-alist) prompt))))
    ;; Run `kill-emacs-hook' (`server-force-stop' excluded) before Emacs
    ;; frames are unmapped so that errors (if any) can be visible.
    (if (memq #'server-force-stop kill-emacs-hook)
        (progn
          (setq kill-emacs-hook (delq #'server-force-stop kill-emacs-hook))
          (run-hooks 'kill-emacs-hook)
          (setq kill-emacs-hook (list #'server-force-stop)))
      (run-hooks 'kill-emacs-hook)
      (setq kill-emacs-hook nil))
    ;; Exit each module, destroying all resources created by this connection.
    (exwm-exit)
    ;; Set the return value.
    t))



(provide 'exwm)

;;; exwm.el ends here
