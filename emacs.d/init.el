;;; init.el --- Patrick Thomson's Emacs setup.  -*- lexical-binding: t; -*-
;;
;;; Commentary:
;; This file loads use-package, org-mode, and compiles and executes readme.org
;;
;;; Code:

(when (window-system)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1))

(when (eq system-type 'darwin)
  (setq ns-auto-hide-menu-bar t))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("ublt" . "https://elpa.ubolonton.org/packages/") t)
(setq package-native-compile t)
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (message "refreshing contents")
  (unless package-archive-contents (package-refresh-contents))
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package)
  )

(defun reload-config ()
  "Reload the literate config from ~/.emacs.d/config/emacs/emacs.org."
  (interactive)
  (org-babel-load-file "~/.emacs.d/config/emacs-config.org"))

(setq max-lisp-eval-depth 2000)

(reload-config)
(provide 'init)
;;; init.el ends here

;; Original init.el
;;
;; Load master config file
;; (org-babel-load-file "/Users/jose.edil/.emacs.d/config/emacs-config.org")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(no-littering use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
