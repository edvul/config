;; customization file
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file) (load custom-file))

;; no gui
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)



;; packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-verbose nil)
(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode
  :config (global-undo-tree-mode))

(use-package swiper
  :ensure t
  :bind ("C-s".  swiper))

;; https://stackoverflow.com/questions/45041399/proper-configuration-of-packages-in-gnu-emacs

(use-package org
  :pin org
  :ensure org-plus-contrib
  :mode (("\\.org$" . org-mode))
  :init
  (setq org-directory "~/jot/org"
	org-default-notes-file (concat org-directory "/capture.org")
	org-agenda-files (list org-directory))
  (setq org-ctrl-k-protect-subtree t
	org-catch-invisible-edits 'smart
	org-ellipsis "…"
        org-list-allow-alphabetical t
        org-list-indent-offset 2
        org-pretty-entities t
        org-startup-align-all-tables t
        org-startup-with-inline-images (display-graphic-p)
        org-support-shift-select t
	org-log-done 'time
        org-log-into-drawer t)
  (setq org-capture-templates
	'(
	  ("t" "Todo" entry
	   (file+headline "capture.org" "Tasks")
	   "* TODO %?\n%a")
	  ("d" "Diary" entry
	   (file+olp+datetree "diary.org")
	   "* %U\n%i\n%?")
	  ("n" "Note" entry
	   (file+headline "notes.org" "Notes")
	   "* Note: %U\n%?\n%a")
	  ))  
  :config
  :bind
  ("C-c l" . 'org-store-link)
  ("C-c a" . 'org-agenda)
  ("C-c c" . 'org-capture)
  ("C-c b" . 'org-switchb)
  )


;; org-roam
(use-package org-roam
      :ensure t
      :hook
      (after-init . org-roam-mode)
      :custom
      (org-roam-directory "~/jot/org/")
      :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n g" . org-roam-graph-show))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate))))

(use-package which-key
  :init
  :config
  (which-key-mode)
  (which-key-setup-side-window-right)
  )

;; ivy
(use-package ivy
   :ensure t
  :diminish (ivy-mode . "")
  :bind
  (   :map ivy-mode-map ("C-'" . ivy-avy))
  :init
;;  (setq enable-recursive-minibuffers t)
  :config
  (ivy-mode 1)
  ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
  (setq ivy-use-virtual-buffers t)
  ;; number of result lines to display
  (setq ivy-height 10)
  ;; does not count candidates
  (setq ivy-count-format "")
  ;; no regexp by default
  (setq ivy-initial-inputs-alist nil)
  ;; configure regexp engine.
  (setq ivy-re-builders-alist
	;; allow input not in order
        '((t   . ivy--regex-ignore-order))))

(use-package counsel
 :ensure t
 :bind
 (("M-x" . 'counsel-M-x)
  ("C-x C-f" . 'counsel-find-file)
  ( "<f1> f" . 'counsel-describe-function)
  ( "<f1> v" .  'counsel-describe-variable)
  ( "<f1> o" . 'counsel-describe-symbol)
  ( "<f1> l" . 'counsel-find-library)
  ( "<f2> i" . 'counsel-info-lookup-symbol)
  ( "<f2> u" . 'counsel-unicode-char))
 )

(use-package rainbow-delimiters
  :ensure t
  :hook ((prog-mode . rainbow-delimiters-mode)
	 (elisp-mode . rainbow-delimiters-mode))
)

;; 
;; ;; enable this if you want `swiper' to use it
;; (setq search-default-mode #'char-fold-to-regexp)
;; (global-set-key 
;; (global-set-key (kbd "C-c C-r") 'ivy-resume)
;; (global-set-key (kbd "<f6>") 'ivy-resume)
;; (global-set-key (kbd 
;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)

;; (global-set-key (kbd "C-c g") 'counsel-git)
;; (global-set-key (kbd "C-c j") 'counsel-git-grep)
;; (global-set-key (kbd "C-c k") 'counsel-ag)
;; (global-set-key (kbd "C-x l") 'counsel-locate)
;; (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;; (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
;; OB
