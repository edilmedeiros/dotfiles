;; -*- coding: utf-8; lexical-binding: t -*-

(require 'use-package)

(setq gc-cons-threshold 100000000)
(setq max-specpdl-size 5000)

(bind-key* "C-c ;" #'execute-extended-command)
(bind-key* "C-c 4" #'execute-extended-command) ;; for a purely left-handed combo
(bind-key* "C-c C-;" #'execute-extended-command-for-buffer)

;; exec-path-from shell was misbehaving, this hack seems to mollify it
(use-package exec-path-from-shell
  :init
  (exec-path-from-shell-initialize))

(use-package use-package-ensure-system-package)

(use-package try)

(setq
 ;; No need to see GNU agitprop.
 inhibit-startup-screen t
 ;; No need to remind me what a scratch buffer is.
 initial-scratch-message nil
 ;; Double-spaces after periods is morally wrong.
 sentence-end-double-space nil
 ;; Never ding at me, ever.
 ring-bell-function 'ignore
 ;; Save existing clipboard text into the kill ring before replacing it.
 save-interprogram-paste-before-kill t
 ;; Prompts should go in the minibuffer, not in a GUI.
 use-dialog-box nil
 ;; Fix undo in commands affecting the mark.
 mark-even-if-inactive nil
 ;; Let C-k delete the whole line.
 kill-whole-line t
 ;; search should be case-sensitive by default
 case-fold-search nil
 ;; accept 'y' or 'n' instead of yes/no
 ;; the documentation advises against setting this variable
 ;; the documentation can get bent imo
 use-short-answers t
 ;; my source directory
 ;; default-directory "~/src/"
 ;; eke out a little more scrolling performance
 fast-but-imprecise-scrolling t
 ;; prefer newer elisp files
 load-prefer-newer t
 ;; when I say to quit, I mean quit
 confirm-kill-processes nil
 ;; if native-comp is having trouble, there's not very much I can do
 native-comp-async-report-warnings-errors 'silent
 ;; unicode ellipses are better
 truncate-string-ellipsis "…"
 ;; I want to close these fast, so switch to it so I can just hit 'q'
 help-window-select t
 ;; this certainly can't hurt anything
 delete-by-moving-to-trash t
 ;; keep the point in the same place while scrolling
 scroll-preserve-screen-position t
 ;; more info in completions
 completions-detailed t
 ;; highlight error messages more aggressively
 next-error-message-highlight t
 ;; don't let the minibuffer muck up my window tiling
 read-minibuffer-restore-windows t
 ;; scope save prompts to individual projects
 save-some-buffers-default-predicate 'save-some-buffers-root
 ;; don't keep duplicate entries in kill ring
 kill-do-not-save-duplicates t
 )

;; Never mix tabs and spaces. Never use tabs, period.
;; We need the setq-default here because this becomes
;; a buffer-local variable when set.
(setq-default indent-tabs-mode nil)

(set-charset-priority 'unicode)
(prefer-coding-system 'utf-8-unix)

(delete-selection-mode t)
(global-display-line-numbers-mode t)
(column-number-mode)
(savehist-mode)

(require 'hl-line)
(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'text-mode-hook #'hl-line-mode)

(setq
 make-backup-files nil
 auto-save-default nil
 create-lockfiles nil)

(setq custom-file (make-temp-name "/tmp/"))

(setq custom-safe-themes t)

(setq package-check-signature nil)

(defun pt/unbind-bad-keybindings ()
  "Remove unhelpful keybindings."
  (-map (lambda (x) (unbind-key x)) '("C-x C-f" ;; find-file-read-only
                                      "C-x C-d" ;; list-directory
                                      "C-z" ;; suspend-frame
                                      "C-x C-z" ;; again
                                      "<mouse-2>" ;; pasting with mouse-wheel click
                                      "<C-wheel-down>" ;; text scale adjust
                                      "<C-wheel-up>" ;; ditto
                                      "s-n" ;; make-frame
                                      "s-t" ;; ns-popup-font-panel
                                      "s-p" ;; ns-print-buffer
                                      "C-x C-q" ;; read-only-mode
                                      )))

(use-package s)
(use-package dash :config (pt/unbind-bad-keybindings))
(use-package shut-up)

(set-fontset-font "fontset-default" 'unicode "Apple Color Emoji" nil 'prepend)

(bind-key* "C-h" #'backward-delete-char)
(bind-key* "M-h" #'backward-delete-word)
(bind-key* "C-c C-h k" #'describe-key)
(bind-key* "C-c C-h f" #'describe-function)
(bind-key* "C-c C-h m" #'describe-mode)
(bind-key* "C-c C-h v" #'describe-variable)
(bind-key* "C-c C-h l" #'view-lossage)

(bind-key "s-<up>" #'ff-find-related-file)
(bind-key "C-c a f" #'ff-find-related-file)

(bind-key "C-s" #'isearch-forward-regexp)
(bind-key "C-c s" #'isearch-forward-symbol)

(add-hook 'before-save-hook #'delete-trailing-whitespace)
(setq require-final-newline t)
(bind-key "C-c q" #'fill-paragraph)
(bind-key "C-c Q" #'set-fill-column)

(defun pt/indent-just-yanked ()
  "Re-indent whatever you just yanked appropriately."
  (interactive)
  (exchange-point-and-mark)
  (indent-region (region-beginning) (region-end))
  (deactivate-mark))

(bind-key "C-c I" #'pt/indent-just-yanked)

(use-package keychain-environment
  :config
  (keychain-refresh-environment))

(defalias 'view-emacs-news 'ignore)
(defalias 'describe-gnu-project 'ignore)
(defalias 'describe-copying 'ignore)

(use-package vundo
  :diminish
  :bind* (("C-c _" . vundo))
  :custom (vundo-glyph-alist vundo-unicode-symbols))

(setq enable-local-variables :all)

(setq mouse-wheel-tilt-scroll t
      mouse-wheel-flip-direction t)
(setq-default truncate-lines t)

(use-package dabbrev
  :bind* (("C-/" . #'dabbrev-completion))
  :custom
  (dabbrev-case-replace nil))


;; TODO: I want to use the fancy-dabbrev package everywhere,
;; but it uses popup.el rather than read-completion, and
;; I don't like how quickly it operates on its inline suggestions

(add-hook 'go-mode-hook #'abbrev-mode)
(setq abbrev-suggest t)

(defun check-config ()
  "Warn if exiting Emacs with a readme.org that doesn't load."
  (or
   (ignore-errors (org-babel-load-file "~/.emacs.d/config/emacs-config.test.org"))
   (y-or-n-p "Configuration file may be malformed: really exit?")))

(push #'check-config kill-emacs-query-functions)

(setq type-break-file-name nil)
(type-break-mode)

(use-package fancy-compilation :config (fancy-compilation-mode))

(set-face-attribute 'default nil :font "Menlo-13")
(set-face-attribute 'variable-pitch nil :font "Helvetica Neue")

(let ((installed (package-installed-p 'all-the-icons)))
  (use-package all-the-icons)
  (unless installed (all-the-icons-install-fonts)))

(use-package all-the-icons-dired
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(when (window-system)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1)
  (pixel-scroll-mode))

(when (eq system-type 'darwin)
  (setq ns-auto-hide-menu-bar t))

(use-package doom-themes
  :config
  (let ((chosen-theme 'doom-dracula))
    (doom-themes-visual-bell-config)
    (doom-themes-org-config)
    (setq doom-challenger-deep-brighter-comments t
          doom-challenger-deep-brighter-modeline t
          doom-rouge-brighter-comments t
          doom-ir-black-brighter-comments t
          modus-themes-org-blocks 'gray-background
          doom-dark+-blue-modeline nil)
    (load-theme chosen-theme)))

(use-package diminish
  :config
  (diminish 'visual-line-mode))

(defun pt/project-relative-file-name (include-prefix)
  "Return the project-relative filename, or the full path if INCLUDE-PREFIX is t."
  (letrec
      ((fullname (if (equal major-mode 'dired-mode) default-directory (buffer-file-name)))
       (root (project-root (project-current)))
       (relname (if fullname (file-relative-name fullname root) fullname))
       (should-strip (and root (not include-prefix))))
    (if should-strip relname fullname)))

(use-package mood-line
  :config
  (defun pt/mood-line-segment-project-advice (oldfun)
    "Advice to use project-relative file names where possible."
    (let
        ((project-relative (ignore-errors (pt/project-relative-file-name nil))))
         (if
             (and (project-current) (not org-src-mode) project-relative)
             (propertize (format "%s  " project-relative) 'face 'mood-line-buffer-name)
           (funcall oldfun))))

  (advice-add 'mood-line-segment-buffer-name :around #'pt/mood-line-segment-project-advice)
  (mood-line-mode))

(use-package rainbow-delimiters
  :disabled
  :hook ((prog-mode . rainbow-delimiters-mode)))

(use-package centered-window
  :custom
  (cwm-centered-window-width 180))

(add-hook 'compilation-mode-hook 'visual-line-mode)

(global-goto-address-mode)

(shut-up
  (use-package tree-sitter
    :config (global-tree-sitter-mode))

  (use-package tree-sitter-langs))

(use-package centaur-tabs
  :config
  (centaur-tabs-mode t)
  :custom
  (centaur-tabs-set-icons t)
  (centaur-tabs-show-new-tab-button nil)
  (centaur-tabs-set-close-button nil)
  (centaur-tabs-enable-ido-completion nil)
  (centaur-tabs-gray-out-icons t)

  :bind
  (("s-{" . #'centaur-tabs-backward)
   ("s-}" . #'centaur-tabs-forward)))

(use-package multiple-cursors
  :bind (("C-c C-e m" . #'mc/edit-lines)
         ("C-c C-e d" . #'mc/mark-all-dwim)))

(setq-default fill-column 135)

(use-package expand-region
  :bind (("C-c n" . er/expand-region)))

(bind-key* "C-c /" #'comment-dwim)
(bind-key* "C-c 0" #'upcase-dwim)

(use-package avy
  :bind (:map prog-mode-map ("C-'" . #'avy-goto-line))
  :bind (:map org-mode-map ("C-'" . #'avy-goto-line))
  :bind (("C-c l" . #'avy-goto-line)
         ("C-c j k" . #'avy-kill-whole-line)
         ("C-c j j" . #'avy-goto-line)
         ("C-c j h" . #'avy-kill-region)
         ("C-c j w" . #'avy-copy-line)
         ("C-z" . #'avy-goto-char)
         ("C-c v" . #'avy-goto-char)))

(use-package avy-zap
  :bind (("C-c z" . #'avy-zap-to-char)
         ("C-c Z" . #'avy-zap-up-to-char)))

(shut-up (use-package iedit
           :bind (:map iedit-mode-keymap ("C-h" . #'sp-backward-delete-char))
           :bind ("C-;" . #'iedit-mode)))

(use-package smartparens
  :bind (("C-(" . #'sp-backward-sexp)
         ("C-)" . #'sp-forward-sexp)
         ("C-c d w" . #'sp-delete-word)
         ("<left>" . #'sp-backward-sexp)
         ("<right>" . #'sp-forward-sexp)
         ("C-c C-(" . #'sp-up-sexp)
         ("C-c j s" . #'sp-copy-sexp)
         ("C-c C-)" . #'sp-down-sexp))
  :config
  (require 'smartparens-config)
  (setq sp-show-pair-delay 0
        sp-show-pair-from-inside t)
  (smartparens-global-mode)
  (show-smartparens-global-mode t)
  ;; (set-face-attribute 'sp-pair-overlay-face nil :background "#0E131D")
  (defun indent-between-pair (&rest _ignored)
    (newline)
    (indent-according-to-mode)
    (forward-line -1)
    (indent-according-to-mode))

  (sp-local-pair 'prog-mode "{" nil :post-handlers '((indent-between-pair "RET")))
  (sp-local-pair 'prog-mode "[" nil :post-handlers '((indent-between-pair "RET")))
  (sp-local-pair 'prog-mode "(" nil :post-handlers '((indent-between-pair "RET"))))

(use-package nameless
  :custom
  (nameless-private-prefix t))

(defun pt/eol-then-newline ()
  "Go to end of line, then newline-and-indent."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(bind-key "s-<return>" #'pt/eol-then-newline)

(bind-key "C-c U" #'insert-char)

(defun pt/split-window-thirds ()
  "Split a window into thirds."
  (interactive)
  (split-window-right)
  (split-window-right)
  (balance-windows))

(bind-key "C-c 3" #'pt/split-window-thirds)

(defun open-init-file ()
  "Open this very file."
  (interactive)
  (find-file "~/.emacs.d/config/emacs-config-test.org"))

(bind-key "C-c E" #'open-init-file)

(defun pt/insert-current-date ()
  "Insert the current date (Y-m-d) at point."
  (interactive)
  (insert (shell-command-to-string "echo -n $(date +%Y-%m-%d)")))

(bind-key "s-w" #'kill-this-buffer)

(defun pt/check-file-modification (&optional _)
  "Clear modified bit on all unmodified buffers."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and buffer-file-name (buffer-modified-p) (not (file-remote-p buffer-file-name)) (current-buffer-matches-file-p))
        (set-buffer-modified-p nil)))))

(defun current-buffer-matches-file-p ()
  "Return t if the current buffer is identical to its associated file."
  (autoload 'diff-no-select "diff")
  (when buffer-file-name
    (diff-no-select buffer-file-name (current-buffer) nil 'noasync)
    (with-current-buffer "*Diff*"
      (and (search-forward-regexp "^Diff finished \(no differences\)\." (point-max) 'noerror) t))))

;; (advice-add 'save-some-buffers :before #'pt/check-file-modification)

;; (add-hook 'before-save-hook #'pt/check-file-modification)
;; (add-hook 'kill-buffer-hook #'pt/check-file-modification)
(advice-add 'magit-status :before #'pt/check-file-modification)
(advice-add 'save-buffers-kill-terminal :before #'pt/check-file-modification)

(use-package sudo-edit)

(setq
 ;; I use exa, which doesn't have a --dired flag
 dired-use-ls-dired nil
 ;; Why wouldn't you create destination directories when copying files, Emacs?
 dired-create-destination-dirs 'ask
 ;; Before the existence of this option, you had to either hack
 ;; dired commands or use the dired+ library, the maintainer
 ;; of which refuses to use a VCS. So fuck him.
 dired-kill-when-opening-new-dired-buffer t
 ;; Update directory listings automatically (again, why isn't this default?)
 dired-do-revert-buffer t
 ;; Sensible mark behavior
 dired-mark-region t
 )

(global-so-long-mode)

(use-package duplicate-thing
  :init
  (defun pt/duplicate-thing ()
    "Duplicate thing at point without changing the mark."
    (interactive)
    (save-mark-and-excursion (duplicate-thing 1))
    (call-interactively #'next-line))
  :bind (("C-c u" . pt/duplicate-thing)
         ("C-c C-u" . pt/duplicate-thing)))

(use-package evil-numbers
  :bind ("C-c a 1" . #'evil-numbers/inc-at-pt))

(setq read-process-output-max (* 1024 1024)) ; 1mb

(use-package which-key
  :diminish
  :custom
  (which-key-enable-extended-define-key t)
  :config
  (which-key-mode)
  (which-key-setup-side-window-right))

(defun display-startup-echo-area-message ()
  "Override the normally tedious startup message."
  (message "Welcome back."))

(setq executable-prefix-env t)
(add-hook 'after-save-hook #'executable-make-buffer-file-executable-if-script-p)

(context-menu-mode)
(bind-key "C-c C-m" #'tmm-menubar)

(defun revert-to-two-windows ()
  "Delete all other windows and split it into two."
  (interactive)
  (delete-other-windows)
  (split-window-right))

(bind-key "C-x 1" #'revert-to-two-windows)
(bind-key "C-x !" #'delete-other-windows) ;; Access to the old keybinding.

(defun pt/abort ()
  "Remove auxiliary buffers."
  (interactive)
  (ignore-errors (exit-recursive-edit))
  (ignore-errors (ctrlf-cancel))
  (popper-close-latest)
  (call-interactively #'keyboard-quit))

(bind-key* "s-g" #'pt/abort)

(defun kill-this-buffer ()
  "Kill the current buffer."
  (interactive)
  (pt/check-file-modification)
  (kill-buffer nil)
  )

(bind-key "C-x k" #'kill-this-buffer)
(bind-key "C-x K" #'kill-buffer)

(defun kill-all-buffers ()
  "Close all buffers."
  (interactive)
  (let ((lsp-restart 'ignore))
    ;; (maybe-unset-buffer-modified)
    (delete-other-windows)
    (save-some-buffers)
    (let
        ((kill-buffer-query-functions '()))
      (mapc 'kill-buffer (buffer-list)))))

(bind-key "C-c K" #'kill-all-buffers)

(defun copy-file-name-to-clipboard (do-not-strip-prefix)
  "Copy the current buffer file name to the clipboard. The path will be relative to the project's root directory, if set. Invoking with a prefix argument copies the full path."
  (interactive "P")
  (let
      ((filename (pt/project-relative-file-name do-not-strip-prefix)))
    (kill-new filename)
    (message "Copied buffer file name '%s' to the clipboard." filename)))

(bind-key "C-c p" #'copy-file-name-to-clipboard)

(use-package ace-window
  :config
  ;; Show the window designators in the modeline.
  (ace-window-display-mode)

  :bind* (("C-<" . other-window) ("C-," . ace-window) ("C-c ," . ace-window))
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l) "Designate windows by home row keys, not numbers.")
  (aw-background nil))

(setq enable-recursive-minibuffers t)
(minibuffer-depth-indicate-mode)

(defun switch-to-scratch-buffer ()
  "Switch to the current session's scratch buffer."
  (interactive)
  (switch-to-buffer "*scratch*"))

(bind-key "C-c a s" #'switch-to-scratch-buffer)

(use-package popper
  :bind* ("C-c :" . popper-toggle-latest)
  :bind (("C-`"   . popper-toggle-latest)
         ("C-\\"  . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :hook (prog-mode . popper-mode)
  :config
  (popper-mode +1)
  (popper-echo-mode +1)
  :custom
  (popper-window-height 24)
  (popper-reference-buffers '("\\*Messages\\*"
                              "Output\\*$"
                              "\\*Async Shell Command\\*"
                              "\\*rustic-compilation\\*"
                              help-mode
                              prodigy-mode
                              "magit:.\*"
                              "\\*deadgrep.\*"
                              "\\*eldoc.\*"
                              "\\*Codespaces\\*"
                              "\\*xref\\*"
                              "\\*org-roam\\*"
                              "\\*direnv\\*"
                              "\\*Checkdoc Status\\*"
                              "\\*Warnings\\*"
                              "\\*Go Test\\*"
                              "\\*Bookmark List\\*"
                              haskell-compilation-mode
                              compilation-mode
                              bqn-inferior-mode)))

(use-package org
  :hook ((org-mode . visual-line-mode) (org-mode . pt/org-mode-hook))
  :hook ((org-src-mode . display-line-numbers-mode))
  :bind (("C-c o c" . org-capture)
         ("C-c o a" . org-agenda)
         ("C-c o A" . consult-org-agenda)
         :map org-mode-map
         ("M-<left>" . nil)
         ("M-<right>" . nil)
         ("C-c c" . #'org-mode-insert-code)
         ("C-c a f" . #'org-shifttab)
         ("C-c a S" . #'zero-width))
  :custom
  (org-adapt-indentation nil)
  (org-directory "~/txt")
  (org-special-ctrl-a/e t)

  (org-default-notes-file (concat org-directory "/notes.org"))
  (org-return-follows-link t)
  (org-src-ask-before-returning-to-edit-buffer nil "org-src is kinda needy out of the box")
  (org-src-window-setup 'current-window)
  (org-agenda-files (list (concat org-directory "/todo.org")))
  (org-pretty-entities t)

  :config
  (defun pt/org-mode-hook ())
  (defun make-inserter (c) '(lambda () (interactive) (insert-char c)))
  (defun zero-width () (interactive) (insert "​"))

  (defun org-mode-insert-code ()
    "Like markdown-insert-code, but for org instead."
    (interactive)
    (org-emphasize ?~)))

(use-package org-modern
  :config (global-org-modern-mode)
  :custom (org-modern-variable-pitch nil))

(use-package org-ref
  :disabled ;; very slow to load
  :config (defalias 'dnd-unescape-uri 'dnd--unescape-uri))

(use-package org-roam
  :bind
  (("C-c o r" . #'org-roam-capture)
   ("C-c o f" . #'org-roam-node-find)
   ("C-c o t" . #'org-roam-tag-add)
   ("C-c o i" . #'org-roam-node-insert)
   ("C-c o :" . #'org-roam-buffer-toggle))
  :custom
  (org-roam-directory (expand-file-name "~/Dropbox/txt/roam"))
  (org-roam-completion-everywhere t)
  (org-roam-v2-ack t)
  :config
  (org-roam-db-autosync-mode))

(use-package org-alert
  :config (org-alert-enable)
  :custom (alert-default-style 'osx-notifier))

(use-package ob-mermaid)
