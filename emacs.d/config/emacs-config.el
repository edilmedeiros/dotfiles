(setq user-full-name "José Edil G. de Medeiros"
      user-mail-address "jose.edil@gmail.com"
      user-work-mail-address "j.edil@ene.unb.br"
      calendar-latitude -15.77972
      calendar-longitude -47.92972
      calendar-location-name "Brasília, Brasil")

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
(column-number-mode)
(savehist-mode)

(global-display-line-numbers-mode t)
;; Override some modes which derive from the above
(dolist (mode '(org-mode-hook
                term-mode-hook
                vterm-mode-hook
                shell-mode-hook
                eshell-mode-hook
                treemacs-mode-hook
                dired-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

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

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)

(global-set-key (kbd "s-<right>") 'move-end-of-line)
(global-set-key (kbd "s-<left>") 'move-beginning-of-line)

(setq scroll-error-top-bottom t)
(global-set-key (kbd "s-<up>") 'scroll-down-command)
(global-set-key (kbd "s-<down>") 'scroll-up-command)

(setq
;; insert newlines if the point is at the end of the buffer
 next-line-add-newlines t)

;; (use-package which-key
;;   :init (which-key-mode)
;;   :diminish which-key-mode
;;   :config
;;   (setq which-key-idle-delay 0.3))

(global-set-key (kbd "C-x b") 'counsel-switch-buffer)

(use-package s)
(use-package dash :config (pt/unbind-bad-keybindings))
(use-package shut-up)

(set-fontset-font "fontset-default" 'unicode "Apple Color Emoji" nil 'prepend)

(bind-key* "C-h" #'backward-delete-char)
(bind-key* "M-h" #'backward-delete-word)
(bind-key* "C-c h k" #'describe-key)
(bind-key* "C-c h f" #'describe-function)
(bind-key* "C-c h m" #'describe-mode)
(bind-key* "C-c h v" #'describe-variable)
(bind-key* "C-c h l" #'view-lossage)

(bind-key "s-<up>" #'ff-find-related-file)
(bind-key "C-c a f" #'ff-find-related-file)

(bind-key "C-s" #'isearch-forward-regexp)
(bind-key "C-c s" #'isearch-forward-symbol)

;; Whitespace treatment will be done using ws-butler later
;; (add-hook 'before-save-hook #'delete-trailing-whitespace)

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

;; (add-hook 'go-mode-hook #'abbrev-mode)
(setq abbrev-suggest t)

(defun check-config ()
  "Warn if exiting Emacs with a readme.org that doesn't load."
  (or
   (ignore-errors (org-babel-load-file "~/.emacs.d/config/emacs-config.org"))
   (y-or-n-p "Configuration file may be malformed: really exit?")))

(push #'check-config kill-emacs-query-functions)

;; (setq type-break-file-name nil)
;; (type-break-mode)

(use-package fancy-compilation :config (fancy-compilation-mode))

(set-face-attribute 'default nil :font "Fira Code-13")
(set-face-attribute 'variable-pitch nil :font "Helvetica Neue-12")

(let ((installed (package-installed-p 'all-the-icons)))
  (use-package all-the-icons)
  (unless installed (all-the-icons-install-fonts)))

(use-package all-the-icons-dired
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode))

; Enable ligatures on macos
(mac-auto-operator-composition-mode t)

;; (add-to-list 'default-frame-alist '(fullscreen . maximized))

(add-to-list 'default-frame-alist '(height . 70))
(add-to-list 'default-frame-alist '(width . 210))
;; (add-to-list 'default-frame-alist '(width . 150))
(add-to-list 'default-frame-alist '(left . 0))
(add-to-list 'default-frame-alist '(top . 0))

(when (window-system)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1)
  (pixel-scroll-mode)
  (set-fringe-mode 10)  ; Give some breating room
  (global-visual-line-mode 1) ; Propper line wrapping.
  (global-font-lock-mode t) ; Turn synctex highlighting on whenever possible.
  )

(when (eq system-type 'darwin)
  (setq ns-auto-hide-menu-bar t))

(use-package doom-themes
  :config
  (let ((chosen-theme 'doom-dracula))
    (doom-themes-visual-bell-config)
    (doom-themes-org-config)
    (setq doom-themes-enable-bold t
          doom-themes-enable-italic t
          doom-challenger-deep-brighter-comments t
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

;; (use-package centered-window
;;   :custom
;;   (cwm-centered-window-width 180))

(add-hook 'compilation-mode-hook 'visual-line-mode)

(global-goto-address-mode)

;; (shut-up
;;   (use-package tree-sitter
;;     :config (global-tree-sitter-mode))

;;   (use-package tree-sitter-langs))

;; (use-package centaur-tabs
;;   :config
;;   (centaur-tabs-mode t)
;;   :custom
;;   (centaur-tabs-set-icons t)
;;   (centaur-tabs-show-new-tab-button nil)
;;   (centaur-tabs-set-close-button nil)
;;   (centaur-tabs-enable-ido-completion nil)
;;   (centaur-tabs-gray-out-icons t)

;;   :bind
;;   (("s-{" . #'centaur-tabs-backward)
;;    ("s-}" . #'centaur-tabs-forward)))

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

;; (shut-up (use-package iedit
;;            :bind (:map iedit-mode-keymap ("C-h" . #'sp-backward-delete-char))
;;            :bind ("C-;" . #'iedit-mode)))

(use-package smartparens
  :bind (("C-(" . #'sp-backward-sexp)
         ("C-)" . #'sp-forward-sexp)
         ("C-c d w" . #'sp-delete-word)
         ("C-M-<left>" . #'sp-backward-sexp)
         ("C-M-<right>" . #'sp-forward-sexp)
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
  (sp-local-pair 'prog-mode "(" nil :post-handlers '((indent-between-pair "RET")))

  (sp-with-modes
      '(tex-mode plain-tex-mode latex-mode)
    (sp-local-pair "\\(" "\\)"
                   :unless '(sp-point-before-word-p
                             sp-point-before-same-p
                             sp-latex-point-after-backslash)
                   :trigger-wrap "$"
                   :trigger "$")
    (sp-local-pair "\\[" "\\]"
                   :unless '(sp-point-before-word-p
                             sp-point-before-same-p
                             sp-latex-point-after-backslash)))
  )

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
  (find-file "~/.emacs.d/config/emacs-config.org"))

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

(setq insert-directory-program "gls")
(use-package dired
    :ensure nil
    ;;:straight nil
    :commands (dired dired-jump)
    :bind (("s-<up>" . dired-single-up-directory))
    :config
    (setq dired-listing-switches "-aghoq --group-directories-first"
          ;;dired-omit-files "^\\.[^.].*"
          dired-omit-verbose nil
          dired-hide-details-hide-symlink-targets nil
          dired-create-destination-dirs 'ask
          dired-kill-when-opening-new-dired-buffer t
          dired-do-revert-buffer t
          dired-mark-region t)

    (autoload 'dired-omit-mode "dired-x")
    (add-hook 'dired-load-hook
              (lambda ()
                (interactive)
                (dired-collapse)))

    (add-hook 'dired-mode-hook
              (lambda ()
                (interactive)
                (dired-omit-mode 1)
                (dired-hide-details-mode 1)
                (all-the-icons-dired-mode 1)
                (hl-line-mode 1)))
    )

;; (setq
;;  ;; I use exa, which doesn't have a --dired flag
;;  dired-use-ls-dired nil
;;  ;; Why wouldn't you create destination directories when copying files, Emacs?
;;  dired-create-destination-dirs 'ask
;;  ;; Before the existence of this option, you had to either hack
;;  ;; dired commands or use the dired+ library, the maintainer
;;  ;; of which refuses to use a VCS. So fuck him.
;;  dired-kill-when-opening-new-dired-buffer t
;;  ;; Update directory listings automatically (again, why isn't this default?)
;;  dired-do-revert-buffer t
;;  ;; Sensible mark behavior
;;  dired-mark-region t
;;  )

(use-package dired-single
  :after (dired)
  :init
  (define-key dired-mode-map [remap dired-find-file]
    'dired-single-buffer)
  (define-key dired-mode-map [remap dired-mouse-find-file-other-window]
    'dired-single-buffer-mouse)
  (define-key dired-mode-map [remap dired-up-directory]
    'dired-single-up-directory))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :bind
  (:map dired-mode-map
   ("H" . dired-hide-dotfiles-mode)))

(use-package dired-rainbow
  :after (dired)
  :config
  (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
  (dired-rainbow-define
   html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
  (dired-rainbow-define
   xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
  (dired-rainbow-define
   document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
  (dired-rainbow-define
   markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
  (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
  (dired-rainbow-define
   media "#de751f" ("mp3" "mp4" "mkv" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
  (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
  (dired-rainbow-define log "#c17d11" ("log"))
  (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
  (dired-rainbow-define
   interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
  (dired-rainbow-define
   compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
  (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
  (dired-rainbow-define
   compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
  (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
  (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
  (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
  (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
  (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
  (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*"))

(use-package dired-subtree
  :after (dired)
  :bind
  (:map dired-mode-map
        ("i" . je/dired-subtree-insert)
        (";" . je/dired-subtree-remove)
        ("<tab>" . je/dired-subtree-toggle)
        ("<backtab>" . je/dired-subtree-cycle)))

;; Define custom functioons to always revert the dired buffer to keep icons nice!
(defun je/dired-subtree-insert () (interactive) (dired-subtree-insert) (revert-buffer))
(defun je/dired-subtree-remove () (interactive) (dired-subtree-remove) (revert-buffer))
(defun je/dired-subtree-toggle () (interactive) (dired-subtree-toggle) (revert-buffer))
(defun je/dired-subtree-cycle () (interactive) (dired-subtree-cycle) (revert-buffer))

(use-package dired-collapse
  :after dired)

(use-package dired-filter :after (dired))
(use-package dired-narrow
  :after (dired)
  :bind (:map dired-mode-map
              ("C-f" . dired-narrow)))

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
  (which-key-setup-side-window-right)
  (setq which-key-idle-delay 0.3))

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

;; (bind-key "C-x 1" #'revert-to-two-windows)
;; (bind-key "C-x !" #'delete-other-windows) ;; Access to the old keybinding.

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

  :bind* (("C-<" . other-window) ("C-," . ace-window) ("C-c ," . ace-window) ("M-o" . ace-window))
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l) "Designate windows by home row keys, not numbers.")
  (aw-background nil)
  (aw-minibuffer-flag t)
  (aw-dispatch-always nil)
  :config
  (ace-window-display-mode 1)
)

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
  ;; :hook ((org-src-mode . display-line-numbers-mode))
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
  (org-directory "~/org")
  (org-special-ctrl-a/e t)

  ;; (org-default-notes-file (concat org-directory "/notes.org"))
  (org-return-follows-link t)
  (org-src-ask-before-returning-to-edit-buffer nil "org-src is kinda needy out of the box")
  (org-src-window-setup 'current-window)
  ;; (org-agenda-files (list (concat org-directory "/todo.org")))
  (org-pretty-entities t)
  (org-startup-folded t)
  (org-hide-emphasis-markers t)
  ;; (org-fontify-whole-heading-line t)
  ;; (org-fontify-done-headline t)
  ;; (org-fontify-quote-and-verse-blocks t)
  (org-indent-indentation-per-level 1)
  ;;(org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-edit-src-content-indentation 0)


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

;; (use-package org-roam
;;   :bind
;;   (("C-c o r" . #'org-roam-capture)
;;    ("C-c o f" . #'org-roam-node-find)
;;    ("C-c o t" . #'org-roam-tag-add)
;;    ("C-c o i" . #'org-roam-node-insert)
;;    ("C-c o :" . #'org-roam-buffer-toggle))
;;   :custom
;;   (org-roam-directory (expand-file-name "~/Dropbox/txt/roam"))
;;   (org-roam-completion-everywhere t)
;;   (org-roam-v2-ack t)
;;   :config
;;   (org-roam-db-autosync-mode))

(use-package org-alert
  :config (org-alert-enable)
  :custom (alert-default-style 'osx-notifier))

(use-package ob-mermaid)

(use-package obsidian
  :ensure t
  :demand t
  :config
  (obsidian-specify-path "/Users/jose.edil/Library/Mobile Documents/iCloud~md~obsidian/Documents/Eeny, meeny, miny, moe")
  (global-obsidian-mode t)
  :custom
  ;; This directory will be used for `obsidian-capture' if set.
  (obsidian-inbox-directory "+ Inbox")
  :bind (:map obsidian-mode-map
  ;; Replace C-c C-o with Obsidian.el's implementation. It's ok to use another key binding.
  ("C-c C-o" . obsidian-follow-link-at-point)
  ;; Jump to backlinks
  ("C-c C-b" . obsidian-backlink-jump)
  ;; If you prefer you can use `obsidian-insert-link'
  ("C-c C-l" . obsidian-insert-wikilink)))

(server-start)

; Makes emacs behave nicely with OSX open command: 'open with emacs'
; will send the file to the fullsscreen frame instead of create a new
; frame.
(setq ns-pop-up-frames nil)

;; (setq visible-bell nil
;;       ring-bell-function 'flash-mode-line)
;; (defun flash-mode-line ()
;;   (unless (memq this-command         ; Disable bell in the following situations
;; 		            '(isearch-abort
;;                   abort-recursive-edit
;;                   exit-minibuffer
;;                   keyboard-quit))
;;   (invert-face 'mode-line)
;;   (run-with-timer 0.1 nil #'invert-face 'mode-line)))

;;  (setq sentence-end-double-space nil)

;;  (delete-selection-mode t)

;;  (fset 'yes-or-no-p 'y-or-n-p)

;; (column-number-mode)
;; (delete-selection-mode t)
;; (global-display-line-numbers-mode t)


;; ;; Enable line numbers for some modes
;; ;; (dolist (mode '(text-mode-hook
;; ;; 		            prog-mode-hook
;; ;; 		            conf-mode-hook))
;; ;;   (add-hook mode (lambda () (display-line-numbers-mode))))

;; ;; Override some modes which derive from the above
;; (dolist (mode '(org-mode-hook
;; 		            term-mode-hook
;; 		            shell-mode-hook
;; 		            eshell-mode-hook
;;                treemacs-mode-hook
;;                dired-mode-hook))
;;   (add-hook mode (lambda () (display-line-numbers-mode 0))))


;; (add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; (add-hook 'text-mode-hook 'display-line-numbers-mode)
;; (add-hook 'conf-mode-hook 'display-line-numbers-mode)

;;  (setq large-file-warning-threshold nil)

;;  (setq vc-follow-symlinks t)

;;  (setq ad-redefinition-action 'accept)

(setq display-time-format "%H:%M %e/%b"
display-time-default-load-average nil)

(use-package minions
  :hook (doom-modeline-mode . minions-mode))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :init
  (display-time-mode 1)
  ;;:custom-face
  ;;(mode-line ((t (:height 0.85))))
  ;;(mode-line-inactive ((t (:height 0.85))))
  :custom
  ;; How tall the mode-line should be. It's only respected in GUI.
  ;; If the actual char height is larger, it respects the actual height.
  (doom-modeline-height 15)
  ;; How wide the mode-line bar should be. It's only respected in GUI.
  (doom-modeline-bar-width 6)

  ;; The limit of the window width.
  ;; If `window-width' is smaller than the limit, some information won't be displayed.
  ;; (doom-modeline-window-width-limit fill-column)
  ;; How to detect the project root.
  ;; The default priority of detection is `ffip' > `projectile' > `project'.
  ;; nil means to use `default-directory'.
  ;; The project management packages have some issues on detecting project root.
  ;; e.g. `projectile' doesn't handle symlink folders well, while `project' is unable
  ;; to hanle sub-projects.
  ;; You can specify one if you encounter the issue.
  ;; (doom-modeline-project-detection 'project)
  ;; Determines the style used by `doom-modeline-buffer-file-name'.
  ;;
  ;; Given ~/Projects/FOSS/emacs/lisp/comint.el
  ;;   auto => emacs/lisp/comint.el (in a project) or comint.el
  ;;   truncate-upto-project => ~/P/F/emacs/lisp/comint.el
  ;;   truncate-from-project => ~/Projects/FOSS/emacs/l/comint.el
  ;;   truncate-with-project => emacs/l/comint.el
  ;;   truncate-except-project => ~/P/F/emacs/l/comint.el
  ;;   truncate-upto-root => ~/P/F/e/lisp/comint.el
  ;;   truncate-all => ~/P/F/e/l/comint.el
  ;;   truncate-nil => ~/Projects/FOSS/emacs/lisp/comint.el
  ;;   relative-from-project => emacs/lisp/comint.el
  ;;   relative-to-project => lisp/comint.el
  ;;   file-name => comint.el
  ;;   buffer-name => comint.el<2> (uniquify buffer name)
  ;;
  ;; If you are experiencing the laggy issue, especially while editing remote files
  ;; with tramp, please try `file-name' style.
  ;; Please refer to https://github.com/bbatsov/projectile/issues/657.
  (doom-modeline-buffer-file-name-style 'auto)

  ;; Whether display icons in the mode-line.
  ;; While using the server mode in GUI, should set the value explicitly.
  (doom-modeline-icon (display-graphic-p))
  ;; Whether display the icon for `major-mode'. It respects `doom-modeline-icon'.
  (doom-modeline-major-mode-icon t)
  ;; Whether display the colorful icon for `major-mode'.
  ;; It respects `all-the-icons-color-icons'.
  (doom-modeline-major-mode-color-icon t)
  ;; Whether display the icon for the buffer state. It respects `doom-modeline-icon'.
  (doom-modeline-buffer-state-icon t)

  ;; Whether display the modification icon for the buffer.
  ;; It respects `doom-modeline-icon' and `doom-modeline-buffer-state-icon'.
  (doom-modeline-buffer-modification-icon t)

  ;; Whether to use unicode as a fallback (instead of ASCII) when not using icons.
  ;; (doom-modeline-unicode-fallback nil)

  ;; Whether display the minor modes in the mode-line.
  (doom-modeline-minor-modes t)

  ;; If non-nil, a word count will be added to the selection-info modeline segment.
  (doom-modeline-enable-word-count t)
  ;; Major modes in which to display word count continuously.
  ;; Also applies to any derived modes. Respects `doom-modeline-enable-word-count'.
  ;; If it brings the sluggish issue, disable `doom-modeline-enable-word-count' or
  ;; remove the modes from `doom-modeline-continuous-word-count-modes'.
  ;; (doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode))

  ;; Whether display the buffer encoding.
  (doom-modeline-buffer-encoding nil)
  ;; Whether display the indentation information.
  (doom-modeline-indent-info nil)

  ;; If non-nil, only display one number for checker information if applicable.
  ;; (doom-modeline-checker-simple-format t)
  ;; The maximum number displayed for notifications.
  ;; (doom-modeline-number-limit 99)
  ;; The maximum displayed length of the branch name of version control.
  ;; (doom-modeline-vcs-max-length 12)

  ;; Whether display the workspace name. Non-nil to display in the mode-line.
  ;; (doom-modeline-workspace-name t)

  ;; Whether display the perspective name. Non-nil to display in the mode-line.
  (doom-modeline-persp-name nil)
  ;; If non nil the default perspective name is displayed in the mode-line.
  ;; (doom-modeline-display-default-persp-name nil)
  ;; If non nil the perspective name is displayed alongside a folder icon.
  ;; (doom-modeline-persp-icon t)

  ;; Whether display the `lsp' state. Non-nil to display in the mode-line.
  (doom-modeline-lsp t)

  ;; Whether display the GitHub notifications. It requires `ghub' package.
  (doom-modeline-github nil)
  ;; The interval of checking GitHub.
  ;; (doom-modeline-github-interval (* 30 60))

  ;; Whether display the modal state icon.
  ;; Including `evil', `overwrite', `god', `ryo' and `xah-fly-keys', etc.
  ;; (doom-modeline-modal-icon t)

  ;; Whether display the mu4e notifications. It requires `mu4e-alert' package.
  (doom-modeline-mu4e nil)

  ;; Whether display the gnus notifications.
  ;; (doom-modeline-gnus t)
  ;; Wheter gnus should automatically be updated and how often (set to 0 or smaller than 0 to disable)
  ;; (doom-modeline-gnus-timer 2)
  ;; Wheter groups should be excluded when gnus automatically being updated.
  ;; (doom-modeline-gnus-excluded-groups '("dummy.group"))

  ;; Whether display the IRC notifications. It requires `circe' or `erc' package.
  (doom-modeline-irc nil)
  ;; Function to stylize the irc buffer names.
  ;; (doom-modeline-irc-stylize 'identity)

  ;; Whether display the environment version.
  ;; (doom-modeline-env-version t)
  ;; Or for individual languages
  ;; (doom-modeline-env-enable-python t)
  ;; (doom-modeline-env-enable-ruby t)
  ;; (doom-modeline-env-enable-perl t)
  ;; (doom-modeline-env-enable-go t)
  ;; (doom-modeline-env-enable-elixir t)
  ;; (doom-modeline-env-enable-rust t)
  ;; Change the executables to use for the language version string
  ;; (doom-modeline-env-python-executable "python") ; or `python-shell-interpreter'
  ;; (doom-modeline-env-ruby-executable "ruby")
  ;; (doom-modeline-env-perl-executable "perl")
  ;; (doom-modeline-env-go-executable "go")
  ;; (doom-modeline-env-elixir-executable "iex")
  ;; (doom-modeline-env-rust-executable "rustc")
  ;; What to display as the version while a new one is being loaded
  ;; (doom-modeline-env-load-string "...")

  ;; Hooks that run before/after the modeline version string is updated
  ;; (doom-modeline-before-update-env-hook nil)
  ;; (doom-modeline-after-update-env-hook nil)
  )

;;  (use-package super-save
;;    :diminish super-save-mode
;;    :config
;;    (super-save-mode +1)
;;    (setq super-save-auto-save-when-idle t))

;; (defvar --backup-directory (concat user-emacs-directory "backup"))
;; (if (not (file-exists-p --backup-directory))
;;     (make-directory --backup-directory t))
;; (setq backup-directory-alist `(("." . ,--backup-directory)))

;; (setq make-backup-files t               ; backup of a file the first time it is saved.
;;       backup-by-copying t               ; don't clobber symlinks
;;       version-control t                 ; version numbers for backup files
;;       delete-old-versions t             ; delete excess backup files silently
;;       delete-by-moving-to-trash t       ;
;;       kept-old-versions 0               ; oldest versions to keep when a new numbered backup is made (default: 2)
;;       kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
;;       auto-save-default t               ; auto-save every buffer that visits a file
;;       auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
;;       auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
;;       )
;; (setq vc-make-backup-files t)

;; ;; Default and per-save backups go here:
;; (setq backup-directory-alist '(("" . "~/.emacs.d/backup/per-save")))

;; (defun force-backup-of-buffer ()
;;   ;; Make a special "per session" backup at the first save of each
;;   ;; emacs session.
;;   (when (not buffer-backed-up)
;;     ;; Override the default parameters for per-session backups.
;;     (let ((backup-directory-alist '(("" . "~/.emacs.d/backup/per-session")))
;;           (kept-new-versions 3))
;;       (backup-buffer)))
;;   ;; Make a "per save" backup on each save.  The first save results in
;;   ;; both a per-session and a per-save backup, to keep the numbering
;;   ;; of per-save backups consistent.
;;   (let ((buffer-backed-up nil))
;;     (backup-buffer)))

;; (add-hook 'before-save-hook  'force-backup-of-buffer)

;;  (setq create-lockfiles nil)

;; (add-hook 'before-save-hook
;; 	  (when '(not markdown-mode))
;; 	  'delete-trailing-whitespace)
;; (setq require-final-newline t)

;;  (setq vc-follow-symlinks t)

;; (add-hook 'after-save-hook
;;           'executable-make-buffer-file-executable-if-script-p)

;; Revert Dired and other buffers
;; (setq global-auto-revert-non-file-buffers t)

;; ;; Revert buffers when the underlying file has changed
;; (global-auto-revert-mode 1)

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(global-set-key (kbd "C-x C-b") 'ibuffer)

(setq kill-whole-line t)

(setq-default tab-width 2)

(setq-default indent-tabs-mode nil)

(use-package highlight-indent-guides
  :diminish
  :commands highlight-indent-guides-mode
  :custom
  ;(highlight-indent-guides-auto-enabled t)
  (highlight-indent-guides-responsive 'stack)
  (highlight-indent-guides-method 'bitmap)
  :hook
  (prog-mode . highlight-indent-guides-mode)
  )

(use-package ws-butler
  :hook (;(text-mode . ws-butler-mode)
         (prog-mode . ws-butler-mode)))

(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))

(use-package ivy
  :diminish
  :init
  (ivy-mode 1)
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-f" . ivy-alt-done)
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
  (setq ivy-use-virtual-buffers t)
  (setq ivy-wrap t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  (setq ivy-use-selectable-prompt t)

  ;; Use different regex strategies per completion command
  (push '(completion-at-point . ivy--regex-fuzzy) ivy-re-builders-alist) ;; This doesn't seem to work...
  (push '(swiper . ivy--regex-ignore-order) ivy-re-builders-alist)
  (push '(counsel-M-x . ivy--regex-ignore-order) ivy-re-builders-alist)

  ;; Set minibuffer height for different commands
  (setf (alist-get 'counsel-projectile-ag ivy-height-alist) 15)
  (setf (alist-get 'counsel-projectile-rg ivy-height-alist) 15)
  (setf (alist-get 'swiper ivy-height-alist) 15)
  (setf (alist-get 'counsel-switch-buffer ivy-height-alist) 7))

;; (use-package ivy-hydra
;;   :defer t
;;   :after hydra)

(use-package ivy-rich
  :init
  (ivy-rich-mode 1)
  :after counsel
  :config
  (setq ivy-format-function #'ivy-format-function-line)
  (setq ivy-rich-display-transformers-list
        (plist-put ivy-rich-display-transformers-list
                   'ivy-switch-buffer
                   '(:columns
                     ((ivy-rich-candidate (:width 40))
                      (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right)); return the buffer indicators
                      (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))          ; return the major mode info
                      (ivy-rich-switch-buffer-project (:width 15 :face success))             ; return project name using `projectile'
                      (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))  ; return file path relative to project root or `default-directory' if project is nil
                     :predicate
                     (lambda (cand)
                       (if-let ((buffer (get-buffer cand)))
                           ;; Don't mess with EXWM buffers
                           (with-current-buffer buffer
                             (not (derived-mode-p 'exwm-mode)))))))))

(use-package counsel
  :demand t
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         ;; ("C-M-j" . counsel-switch-buffer)
         ("C-M-l" . counsel-imenu)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

(use-package flx  ;; Improves sorting for fuzzy-matched results
  :after ivy
  :defer t
  :init
  (setq ivy-flx-limit 10000))

(use-package wgrep
  :defer 3)

(use-package ivy-posframe
  :disabled
  :custom
  (ivy-posframe-width      115)
  (ivy-posframe-min-width  115)
  (ivy-posframe-height     10)
  (ivy-posframe-min-height 10)
  :config
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
  (setq ivy-posframe-parameters '((parent-frame . nil)
                                  (left-fringe . 8)
                                  (right-fringe . 8)))
  (ivy-posframe-mode 1))

(use-package prescient
  :after counsel
  :config
  (prescient-persist-mode 1))

(use-package ivy-prescient
  :after prescient
  :config
  (ivy-prescient-mode 1))

;; (dw/leader-key-def
;;   "r"   '(ivy-resume :which-key "ivy resume")
;;   "f"   '(:ignore t :which-key "files")
;;   "ff"  '(counsel-find-file :which-key "open file")
;;   "C-f" 'counsel-find-file
;;   "fr"  '(counsel-recentf :which-key "recent files")
;;   "fR"  '(revert-buffer :which-key "revert file")
;;   "fj"  '(counsel-file-jump :which-key "jump to file"))

(use-package default-text-scale
  :defer 1
  :config
  (default-text-scale-mode))

;; (use-package ace-window
;;   :bind (("M-o" . ace-window))
;;   :custom
;;   (aw-scope 'frame)
;;   (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
;;   (aw-minibuffer-flag t)
;;   (aw-dispatch-always nil)
;;   :config
;;   (ace-window-display-mode 1))

(use-package winner
  :defer 1
  :config
  (winner-mode))

(setq display-buffer-base-action
      '(display-buffer-reuse-mode-window
        display-buffer-reuse-window
        display-buffer-same-window))

;; If a popup does happen, don't resize windows to be equal-sized
(setq even-window-sizes nil)

(use-package magit
  :diminish magit-auto-revert-mode
  :diminish auto-revert-mode
  :commands (magit-status magit-get-current-branch)
  :bind (("C-c g s" . magit-status)
         ("C-c g g" . magit-dispatch-popup))
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  )

(global-set-key [f6] 'magit-status)

(use-package forge
  :after magit)

(use-package magit-todos
  :after magit)

(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode)
  (diff-hl-margin-mode)
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  :custom
  (diff-hl-disable-on-remote t)
  (diff-hl-margin-symbols-alist
   '((insert . " ")
     (delete . " ")
     (change . " ")
     (unknown . "?")
     (ignored . "i"))))

;; (use-package git-link
;;   :commands git-link
;;   :config
;;   (setq git-link-open-in-browser t))

;; (use-package git-gutter
;;   :straight git-gutter-fringe
;;   :diminish
;;   :hook ((text-mode . git-gutter-mode)
;;          (prog-mode . git-gutter-mode))
;;   :config
;;   (setq git-gutter:update-interval 2)
;;   (unless dw/is-termux
;;     (require 'git-gutter-fringe)
;;     (set-face-foreground 'git-gutter-fr:added "LightGreen")
;;     (fringe-helper-define 'git-gutter-fr:added nil
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       ".........."
;;       ".........."
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       ".........."
;;       ".........."
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX")

;;     (set-face-foreground 'git-gutter-fr:modified "LightGoldenrod")
;;     (fringe-helper-define 'git-gutter-fr:modified nil
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       ".........."
;;       ".........."
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       ".........."
;;       ".........."
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX")

;;     (set-face-foreground 'git-gutter-fr:deleted "LightCoral")
;;     (fringe-helper-define 'git-gutter-fr:deleted nil
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       ".........."
;;       ".........."
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       ".........."
;;       ".........."
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"
;;       "XXXXXXXXXX"))

;;   ;; These characters are used in terminal mode
;;   (setq git-gutter:modified-sign "≡")
;;   (setq git-gutter:added-sign "≡")
;;   (setq git-gutter:deleted-sign "≡")
;;   (set-face-foreground 'git-gutter:added "LightGreen")
;;   (set-face-foreground 'git-gutter:modified "LightGoldenrod")
;;   (set-face-foreground 'git-gutter:deleted "LightCoral"))

(use-package eglot
  :ensure
  :hook ((prog-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (haskell-mode . eglot-ensure)
         (python-mode . eglot-ensure))
  :bind (:map eglot-mode-map
              ("C-c a r" . #'eglot-rename)
              ("C-<down-mouse-1>" . #'xref-find-definitions)
              ("C-S-<down-mouse-1>" . #'xref-find-references)
              ("C-c C-c" . #'eglot-code-actions))
  :custom
  (eglot-autoshutdown t)
  ;; :config
  ;; (add-to-list 'eglot-server-programs '(rust-mode "rust-analyzer"))
  ;; (add-to-list 'eglot-server-programs '(haskell-mode ("haskell-language-server-wrapper" "--lsp")))
  ;; (add-to-list 'eglot-server-programs '(python-mode "pyright"))
  )

(use-package xref
  :pin gnu
  :bind (("s-r" . #'xref-find-references)
         ("s-[" . #'xref-go-back)
         ("C-<down-mouse-2>" . #'xref-go-back)
         ("s-]" . #'xref-go-forward))
  )

(use-package eldoc
  :pin gnu
  :diminish
  :bind ("s-d" . #'eldoc)
  :custom (eldoc-echo-area-prefer-doc-buffer t)
  )

(use-package flymake
  :config
  (setq elisp-flymake-byte-compile-load-path load-path)
  :hook ((emacs-lisp-mode . flymake-mode))
  :bind (("C-c f n" . flymake-goto-next-error)
         ("C-c f p" . flymake-goto-prev-error)
         ("C-c f b" . flymake-show-buffer-diagnostics)
         ("C-c f p" . flymake-show-project-diagnostics))
  )

;; (use-package lsp-mode
;;   :ensure t
;;   :init
;;   ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
;;   (setq lsp-keymap-prefix "C-c l")
;;   :hook ((python-mode . lsp-deferred)
;;          (rust-mode . lsp-deferred)
;;          (haskell-mode . lsp-deferred)
;;          ;;(text-mode . lsp-deferred)
;;          ;;(markdown-mode . lsp-deferred)
;;          (lsp-mode . lsp-enable-which-key-integration))
;;   :commands (lsp lsp-deferred)
;;   :config
;;   (add-hook 'lsp-mode-hook 'lsp-ui-mode)
;;   :custom
;;   ;;(setq lsp-enable-snippet nil)
;;   ;; For Rust
;;   (lsp-rust-analyzer-cargo-watch-command "clippy")
;;   (lsp-eldoc-render-all t)
;;   (lsp-idle-delay 0.6)
;;   (lsp-rust-analyzer-server-display-inlay-hints t))

;; (use-package lsp-ui
;;   :ensure t
;;   :hook (lsp-mode . lsp-ui-mode)
;;   :commands lsp-ui-mode
;; ;;  :config
;; ;;  (lsp-ui-doc-show)
;; ;;  (setq lsp-ui-sideline-enable t)
;; ;;  (setq lsp-ui-sideline-show-hover nil)
;;   :custom
;;   (setq lsp-ui-doc-position 'bottom)
;;   ;; For Rust
;;   (lsp-ui-peek-always-show t)
;;   (lsp-ui-sideline-show-hover t)
;;   (lsp-ui-doc-enable nil))

;; (use-package lsp-ivy
;;   :commands lsp-ivy-workspace-symbol)

;; (use-package lsp-treemacs
;;   :after lsp
;;   :commands lsp-treemacs-errors-list
;;   :config
;;   (lsp-treemacs-sync-mode 1))

;; (use-package flycheck
;;   :ensure t
;;   :init
;;   (global-flycheck-mode))

;; (use-package yasnippet
;;   :commands yas-minor-mode
;;   :hook (
;;          (go-mode . yas-minor-mode)
;;          (python-mode . yas-minor-mode)
;;          ))

;; (setq lsp-ui-doc-enable t
;;       lsp-ui-peek-enable t
;;       lsp-ui-sideline-enable t
;;       lsp-ui-imenu-enable t
;;       lsp-ui-flycheck-enable t)

(use-package dap-mode
  :ensure
  :commands dap-debug
  :hook
  ;; Open hydra when the debugger stops (at a breakpoint)
  (dap-stopped . (lambda (arg) (call-interactively #'dap-hydra)))
  :config
  ;; (dap-ui-mode)
  (require 'dap-hydra)
  (require 'dap-lldb)
  (require 'dap-gdb-lldb)
  ;; installs .extension/vscode
  (dap-gdb-lldb-setup)
  (dap-register-debug-template
  "Rust::LLDB Run Configuration"
  (list :type "lldb"
        :request "launch"
        :name "LLDB::Run"
	      :gdbpath "rust-lldb"
        ;;:gdbpath "/opt/local/libexec/llvm-13/bin/lldb"
        ;;:gdbpath "lldb-vscode"
        :target nil
        :cwd nil)
  ;; Bind `C-c l d` to `dap-hydra` for easy access
  ;; (general-define-key
  ;;   :keymaps 'lsp-mode-map
  ;;   :prefix lsp-keymap-prefix
  ;;   "d" '(dap-hydra t :wk "debugger"))
  ;; :custom
  ;; (setq dap-ui-controls-mode nil)
  ))

(use-package haskell-mode
  :ensure t
  ;; :custom
  ;; (haskell-compile-cabal-build-command (string-join haskell-compile-cabal-build-command " -funclutter-valid-hole-fits"))
  :config
  (defcustom haskell-formatter 'ormolu
    "The Haskell formatter to use. One of: 'ormolu, 'stylish, nil. Set it per-project in .dir-locals."
    :safe 'symbolp)

  (defun haskell-smart-format ()
    "Format a buffer based on the value of 'haskell-formatter'."
    (interactive)
    (cl-ecase haskell-formatter
      ('ormolu (ormolu-format-buffer))
      ('stylish (haskell-mode-stylish-buffer))
      (nil nil)
      ))


  (defun haskell-switch-formatters ()
    "Switch from ormolu to stylish-haskell, or vice versa."
    (interactive)
    (setq haskell-formatter
          (cl-ecase haskell-formatter
            ('ormolu 'stylish)
            ('stylish 'ormolu)
            (nil nil))))

  (setq haskell-compile-cabal-build-command "stack build")

  :bind (:map haskell-mode-map
         ("C-c a c" . haskell-cabal-visit-file)
         ("C-c a i" . haskell-navigate-imports)
         ("C-c m"   . haskell-compile)
         ("C-c a I" . haskell-navigate-imports-return)
         ("C-c C-l" . haskell-process-load-or-reload)
         ("C-c C-r" . haskell-interactive-bring)
         :map haskell-cabal-mode-map
         ("C-c m"   . haskell-compile))
  )

(use-package ormolu)

  ;; :delight "λ"
  ;; :config
  ;; ;; Flycheck is usually slow for Haskell stuff - only run on save.
  ;; (setq flycheck-check-syntax-automatically '(mode-enabled save))
  ;; (setq haskell-program-name "stack repl")
  ;; (setq haskell-compile-cabal-build-command "stack build")

  ;; :init
  ;; ;; (defun rvl/enable-subword-mode ()
  ;; ;;   "Navigate within identifier names"
  ;; ;;   (subword-mode +1))

  ;; ;; (defun rvl/stylish-on-save ()
  ;; ;;   (setq haskell-stylish-on-save t)

  ;; ;; :hook ((haskell-mode . rvl/display-fill-column)
  ;; ;;        (haskell-mode . rvl/stylish-on-save)
  ;; ;;        (haskell-mode . rvl/font-lock-keywords)
  ;; ;;        (haskell-mode . direnv-update-environment)

  ;; ;;        (haskell-mode . rvl/enable-subword-mode)
  ;; ;;        (haskell-mode . haskell-indentation-mode)
  ;; ;;        (haskell-mode . imenu-add-menubar-index))

  ;; :bind (:map haskell-mode-map
  ;;       ("C-c C-c" . haskell-process-cabal-build)
  ;;       ("C-c c" . haskell-process-cabal)
  ;;       ("C-c v c" . haskell-cabal-visit-file)
  ;;       ("C-c i" . haskell-navigate-imports)

  ;;       ;; YMMV with haskell-interactive-mode - LSP is a better bet
  ;;       ("C-`" . haskell-interactive-bring)
  ;;       ("C-c C-l" . haskell-process-load-file)
  ;;       ("C-c C-t" . haskell-process-do-type)
  ;;       ("C-c C-i" . haskell-process-do-info)
  ;;       ("C-c C-k" . haskell-interactive-mode-clear)

  ;;       ;; These are usually set by default, but just make sure:
  ;;       ("M-." . xref-find-definitions)
  ;;       ("M-," . xref-pop-marker-stack)
  ;;       ("M-," . xref-find-references)

  ;;       :map haskell-cabal-mode-map
  ;;       ("C-c C-c" . haskell-process-cabal-build)
  ;;       ("C-c c" . haskell-process-cabal))
  ;; :custom
  ;; (display-line-numbers-mode t)
  ;; (haskell-process-suggest-remove-import-lines t)
  ;; (haskell-process-auto-import-loaded-modules t)
  ;; (haskell-process-log t)
  ;; (haskell-process-type 'stack-ghci)
  ;; )



;; (use-package lsp-haskell
;;   :ensure t
;;   :after (haskell-mode eglot)
;;   :hook
;;   (haskell-mode . lsp)
;;   (haskell-literate-mode . lsp)
;;   :config
;;   (setq lsp-haskell-server-path "haskell-language-server-wrapper")
;;   (setq lsp-haskell-server-args ())
;;   (setq lsp-log-io t)
;;   ;;:custom
;;   ;;(setq lsp-haskell-completion-snippets-on nil)
;;   )

;; (require 'haskell-interactive-mode)
;; (require 'haskell-process)
;; (add-hook 'haskell-mode-hook 'interactive-haskell-mode)

;(autoload 'octave-mode "octave-mod" nil t)
;(setq auto-mode-alist
;      (cons '("\\.m$" . octave-mode) auto-mode-alist))

;(add-hook 'octave-mode-hook
;          (lambda ()
;            (abbrev-mode 1)
;            (auto-fill-mode 1)
;            (if (eq window-system 'x)
;                (font-lock-mode 1))))

;;(setq lsp-julia-package-dir nil)
;;(setq lsp-julia-flags `("-J/Users/jose.edil/.julia/images/languageserver.so"))

;; (use-package lsp-julia
;;   :init
;;   (setq lsp-julia-package-dir nil)
;;   (setq lsp-julia-flags `("-J/Users/jose.edil/.julia/images/languageserver.so"))
;;   :config
;;   (setq lsp-julia-default-environment "~/.julia/environments/v1.7")
;;   (setq lsp-julia-package-dir "~/.julia/environments/v1.7")
;;   (setq lsp-julia-command "/Applications/Julia-1.7.app/Contents/Resources/julia/bin/julia")
;;   (setq lsp-julia-flags '("--project=/Users/jose.edil/.julia/environments/v1.7" "--startup-file=no" "--history-file=no"))
;;   (setq lsp-julia-timeout 12000)
;;   (setq lsp-enable-folding t)
;;   (setq julia-indent-offset 4)
;;   (setq lsp-julia-format-indents nil)
;;   (setq lsp-enable-indentation nil)
;;   (add-hook 'julia-mode-hook 'lsp)
;;   (add-hook 'julia-mode-hook #'julia-snail-mode)
;;   ;; Julia snail mode
;;   (add-hook 'julia-snail-mode-hook #'lsp)
;;   (setq julia-snail-executable "/Applications/Julia-1.7.app/Contents/Resources/julia/bin/julia")
;;   )

;; (use-package julia-snail
;;   :ensure t
;;   :requires vterm
;; ;  :hook
;; ;  (julia-mode . julia-snail-mode)
;; ;  :config
;; ;  (setq julia-snail-executable "/Applications/Julia-1.7.app/Contents/Resources/julia/bin/julia")
;;   )

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)
  (setq rustic-lsp-format t)
  (setq rustic-format-trigger nil)
  ;; comment to disable rustfmt on save
  ;;(setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook)

  ;;(setq rustic-cargo-run-use-comint t)
  )

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm, but don't try to
  ;; save rust buffers that are not file visiting. Once
  ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
  ;; no longer be necessary.
  (when buffer-file-name
    (setq-local buffer-save-without-query t)))

;; Polymode is necessary to rustic-cargo-run-use-comint
(use-package poly-markdown
  :ensure t)

;; (use-package lsp-pyright
;;   :ensure t
;;   :hook (python-mode . (lambda ()
;; 			 (require 'lsp-pyright)
;; 			 (lsp-deferred))))

;; (use-package python-mode
;;   :hook (python-mode . lsp-deferre)
;;   :custom
;;   (dap-python-debugger 'debugpy)
;;   :config
;;   (require 'dap-python))

;; ;; (use-package pyenv
;; ;;   :after python-mode
;; ;;   :config
;; ;;   (pyenv-mode 1))

;; (use-package py-isort
;;   :after python
;;   :hook ((python-mode . pyenv-mode)
;; 	 (before-save . py-isort-before-save)))

;; (use-package blacken
;;   :delight
;;   :hook (python-mode . blacken-mode)
;;   :custom (blacken-line-length 79))

(use-package eglot-java
  :ensure t
  :pin melpa
  :defer t
  :hook ((java-mode . eglot-java-mode)))

;; (use-package lsp-java
;;   :ensure t
;;   :demand t
;;   :after lsp-mode
;;   :when (and openjdk-21-path
;;              (file-exists-p openjdk-21-path))
;;   :custom
;;   (lsp-java-java-path openjdk-21-path))

;; (use-package lsp-java
;;   :no-require
;;   :hook (java-mode . eglot-ensure))

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :hook
  (projectile-after-switch-project . treemacs-display-current-project-exclusively)
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   t
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)
    (treemacs-resize-icons 17)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-c t 1"   . treemacs-delete-other-windows)
        ("C-c t t"   . treemacs)
        ("C-c t e"   . treemacs-display-current-project-exclusively)
        ("C-c t B"   . treemacs-bookmark)
        ("C-c t f"   . treemacs-find-file)
        ("C-c t M-t" . treemacs-find-tag)
        ))


(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package vterm
  :ensure t
  :commands (vterm)
  :config
  (setq vterm-max-scrollback 10000)
  ;; (setq term-prompt-regexp "^[^#$%>\\n]*[#$%>] *")
  (setq vterm-shell "zsh"))

(defun vterm-counsel-yank-pop-action (orig-fun &rest args)
  (if (equal major-mode 'vterm-mode)
      (let ((inhibit-read-only t)
            (yank-undo-function (lambda (_start _end) (vterm-undo))))
           (cl-letf (((symbol-function 'insert-for-yank)
             (lambda (str) (vterm-send-string str t))))
             (apply orig-fun args)))
      (apply orig-fun args)))

(advice-add 'counsel-yank-pop-action :around #'vterm-counsel-yank-pop-action)

(use-package term
  :config
  (setq explicit-shell-file-name "zsh"))
  ;; (setq explicit-zsh-args '())
  ;; (setq term-prompt-regexp "^[^#$%>\\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package projectile
  :diminish projectile-mode
  :config
  (setq projectile-switch-project-action #'projectile-dired)
  (projectile-mode)
  :custom
  (projectile-completion-system 'ivy)
  :bind-keymap ("C-c p" . projectile-command-map))

;; Discover projects in folders
;(setq projectile-project-search-path '("~/projects/" "~/work/" ("~/github" . 1)))
(setq projectile-project-search-path '(("~/0-research/" . 2) ("~/2-development/" . 2)))

;; (require 'winum)
;; (winum-mode)

(use-package company
  :ensure
  :after lsp-mode
  :hook (prog-mode . company-mode)
;  :init (global-company-mode)
  :bind
  (:map company-active-map
	("<tab>" . company-complete-selection)
	("C-n" . company-select-next)
	("C-p" . company-select-previous)
	("M-<" . company-select-first)
	("M->" . company-select-last))
  ;;(:map lsp-mode-map
	;;("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.5)
  ;;(company-begin-commands nil) ;; uncomment to disable popup
  (company-tooltip-align-annotations t)
  (company-show-numbers t)
  (company-dabbrev-downcase nil)
  ;; :config
  ;; (progn
  ;;   ;; Use Company for completion
  ;;   (bind-key [remap completion-at-point] #'company-complete company-mode-map)

  ;;   (setq company-tooltip-align-annotations t
  ;;         ;; Easy navigation to candidates with M-<n>
  ;;         company-show-numbers t)
  ;;   (setq company-dabbrev-downcase nil))
  :diminish company-mode)

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :custom
  ;;(markdown-css-paths '("/Users/jose.edil/2-development/emacs/splendor/css/splendor.css"))
  (markdown-css-paths '("/Users/jose.edil/2-development/emacs/github-markdown-css/github-markdown-light.css"))
  (markdown-xhtml-header-content
   "<style>
	    .markdown-body {
		    box-sizing: border-box;
		    min-width: 200px;
		    max-width: 980px;
		    margin: 0 auto;
		    padding: 45px;
	    }

	  @media (max-width: 767px) {
		  .markdown-body {
			  padding: 15px;
		  }
	  }
  </style>")
  (markdown-xhtml-body-preamble
   "<article class=\"markdown-body\">")
  (markdown-xhtml-body-epilogue
   "</article>")
  )

;; (use-package yaml-mode
;;   :ensure t)

;; (defun je/org-font-setup ()
;;   ;; Replace list hyphen with dot
;;   (font-lock-add-keywords
;;    'org-mode
;;    '(("^ *\\([-]\\) "
;;       (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
;;   ;; Set faces for heading levels
;;   (dolist (face '((org-level-1 . 1.2)
;;                   (org-level-2 . 1.1)
;;                   (org-level-3 . 1.05)
;;                   (org-level-4 . 1.0)
;;                   (org-level-5 . 1.1)
;;                   (org-level-6 . 1.1)
;;                   (org-level-7 . 1.1)
;;                   (org-level-8 . 1.1)))
;;   ))
;;     ;; (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face))
;;     ;; ;; Ensure that anything that should be fixed-pitch in Org files appears that way
;;     ;; (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
;;     ;; (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
;;     ;; (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
;;     ;; (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
;;     ;; (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
;;     ;; (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
;;     ;; (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
;;     ;; (set-face-attribute 'org-formula nil :inherit 'fixed-pitch)
;;     ;; (set-face-attribute 'org-latex-and-related nil :inherit 'fixed-pitch)
;;     ;; (set-face-attribute 'org-hide nil :inherit 'fixed-pitch)))


;; (defun je/org-mode-setup ()
;;   (org-indent-mode)
;;   ;; (variable-pitch-mode 1)
;;   (visual-line-mode 1)
;;   (je/org-font-setup )
;; )

;; (use-package org
;;   :hook (org-mode . je/org-mode-setup)
;;   :config
;;   (setq org-ellipsis " ▾"
;;         org-startup-folded t
;;         org-pretty-entities t
;;         org-hide-emphasis-markers t
;;         org-fontify-whole-heading-line t
;;         org-fontify-done-headline t
;;         org-fontify-quote-and-verse-blocks t
;;         org-adapt-indentation nil
;;         org-indent-indentation-per-level 1
;;         org-src-fontify-natively t
;;         org-src-tab-acts-natively t
;;         org-edit-src-content-indentation 0)
;;   )

;; (use-package org-bullets
;;   :after org
;;   :hook (org-mode . org-bullets-mode)
;;   :custom
;;   (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●"))
;; )

;; (defun je/org-mode-visual-fill ()
;;   (setq visual-fill-column-width 120
;;         visual-fill-column-center-text t)
;;   (visual-fill-column-mode 1))

;; (use-package visual-fill-column
;;   :hook (org-mode . je/org-mode-visual-fill))

(use-package tex-site
  :ensure auctex
  :mode ("\\.tex\\'" . latex-mode)
  :bind ("\\" . "\\")
  ;:init (unbind-key "\\")
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (add-hook 'LaTeX-mode-hook
    (lambda ()
      ;;(setq TeX-command-default "latexmk")
      (rainbow-delimiters-mode)
      (company-mode)
      (turn-on-reftex)
      (setq reftex-plug-into-AUCTeX t)
      (reftex-isearch-minor-mode)
      (setq TeX-PDF-mode t)
      (setq LaTeX-includegraphics-read-file 'LaTeX-includegraphics-read-file-relative)
      (setq TeX-source-correlate-method 'synctex
            TeX-source-correlate-mode t
            TeX-source-correlate-start-server t)
      (TeX-fold-mode)
      (LaTeX-math-mode)
      (setq LaTeX-electric-left-right-brace t
            TeX-electric-sub-and-superscript t
            ; Removed in favor of smartparens
            ;TeX-electric-math (cons "\\(" "\\)")
            TeX-electric-escape t)
      )))

(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(setq ispell-dictionary "english")

(eval-after-load "tex"
  '(add-to-list 'TeX-command-list
                '("Make" "make" TeX-run-command nil nil)))
(add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "Make")))

(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
  '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))

(use-package reftex
  :mode ("\\.tex\\'" . latex-mode)
  :config
  (setq reftex-cite-prompt-optional-args t)) ; Prompt for empty optional arguments in cite

(use-package lsp-grammarly
  :ensure t
  ;; :hook ((text-mode . (lambda ()
  ;;                      (require 'lsp-grammarly)
  ;;                      (lsp)))
  ;; (markdown-mode . (lambda ()
  ;;                    (require 'lsp-grammarly)
  ;;                    (lsp)))
  ;; )
  )

(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
(setenv "DICTIONARY" "en_US")

; Set $DICPATH to "$HOME/Library/Spelling" for hunspell.
(setenv
  "DICPATH"
  (concat (getenv "HOME") "/Library/Spelling"))

; Tell ispell-mode to use hunspell.
(setq
  ispell-program-name
  "/opt/local/bin/hunspell")

;(defun fd-switch-dictionary()
;(interactive)
;(let* ((dic ispell-current-dictionary)
;  (change (if (string= dic "brasileiro") "english" "brasileiro")))
;  (ispell-change-dictionary change)
;  (message "Dictionary switched from %s to %s" dic change)))
;(global-set-key (kbd "<f7>")   'fd-switch-dictionary)

(let ((langs '("american" "brasileiro")))
      (setq lang-ring (make-ring (length langs)))
      (dolist (elem langs) (ring-insert lang-ring elem)))
(defun cycle-ispell-languages ()
      (interactive)
      (let ((lang (ring-ref lang-ring -1)))
        (ring-insert lang-ring lang)
        (ispell-change-dictionary lang)))

(defun endless/org-ispell ()
;  "Configure `ispell-skip-region-alist' for `org-mode'."
  (make-local-variable 'ispell-skip-region-alist)
  (add-to-list 'ispell-skip-region-alist '(org-property-drawer-re))
  (add-to-list 'ispell-skip-region-alist '("~" "~"))
  (add-to-list 'ispell-skip-region-alist '("=" "="))
  (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC")))
(add-hook 'org-mode-hook #'endless/org-ispell)

;; Make gc pauses faster by decreasing the threshold.
;(setq gc-cons-threshold (* 2 1000 1000))

; Allow 20MB of memory before calling garbage collection (default is
;0.76MB). This means less GC calls and might speed up some operations.
;(setq gc-cons-threshold (* 20 1000 1000))
;(setq gc-cons-threshold 1800000)

; When using the minibuffer, try to avoid garbage collecting.
; Taken from http://bling.github.io/blog/2016/01/18/why-are-you-changing-gc-cons-threshold/
(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

; Normal threshold out of minibuffer.
(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold (* 20 1000 1000)))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)
