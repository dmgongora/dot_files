(add-to-list 'load-path "~/org-8.2.10/lisp")
(add-to-list 'load-path "~/org-8.2.10/contrib/lisp" t)

(load-theme 'tango-dark t)

(setq-default truncate-lines 1)

;; Enable MELPA repositories
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line


;; ==============================
;; ==== Org-capture configuration starts here ===
;; ==============================
;; Org-capture will look for this file
(setq org-directory "~/Dropbox/Lab/")
(setq org-default-notes-file (concat org-directory "./notes.org"))
;; Bind Org Capture to C-c c
(global-set-key "\C-cc" 'org-capture)
;; Bind Org Capture to C-c a
(global-set-key "\C-ca" 'org-agenda)

;; Define some templates
;; Simple templates are made of ('keys', "description", type (target) template)
;; type can be:
;;    entry (Org-mode node or section)
;;    item (as in a list)
;;    checkitem
;;    table-line,
;;    plain (raw text)
;; and target:
;;    (file "path/to/file")                                           Text will be placed at the beginning or end of that file. 
;;    (file+headline "path/to/file" "node headline")   Fast configuration if the target heading is unique in the file.
;;    (file+datetree "path/to/file"                             Will create a heading in a date tree for today's date
;;    (file+datetree+prompt "path/to/file")               Will create a heading in a date tree, but will prompt for the date.
;; and template:
;;    %?             After completing the template, position cursor here.
;;    %t             Timestamp, date only.
;;    %T            Timestamp, with date and time.
;;    %u, %U      Like the above, but inactive timestamps. That is, it won't appear as an agenda entry
;;    %^t           Like %t, but prompt for date.  Similarly %^T, %^u, %^U
(setq org-capture-templates
      '(("t" "Normal task" entry (file+headline (concat org-directory "./notes.org") "Tasks") "* TODO %?\n  %u")
	("i" "Important task (deadline)" entry (file+headline (concat org-directory "./notes.org") "Tasks")  "* TODO %?\n DEADLINE: %^t")
	("s" "Schedule task" entry (file+headline (concat org-directory "./notes.org") "Tasks")  "* TODO %?\n SCHEDULED: %^t")
	("p" "Meeting plan" entry (file+datetree+prompt (concat org-directory "./meetings.org")) "* TODO %?\n  %^t ")
	("d" "Diary entry" plain (file+datetree (concat org-directory "./labdiary.org")) "%?" :unnarrowed t)
	("c" "Concept" entry (file (concat org-directory "./concepts.org") ) "* TODO %?\n ")
	))
;; =============================
;; ==== Org-capture configuration ends here ===
;; =============================

;; Make this work!!!
;;(require 'ox-reveal)
;;(setq org-reveal-root "file:///home/dan/org-8.2.7c/reveal.js-master/")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-list
   (quote
    (("Evince"
      ("evince --page-index=%(outpage) %o")
      "evince"))))
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "5d9351cd410bff7119978f8e69e4315fd1339aa7b3af6d398c5ca6fac7fd53c7" default)))
 '(org-agenda-files
   (quote
    ("~/Dropbox/Lab/concepts.org" "~/Dropbox/Lab/notes.org" "~/Dropbox/Lab/meetings.org" "~/Dropbox/Lab/theHUB.org")))
 '(org-file-apps
   (quote
    ((auto-mode . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default)
     ("\\.pdf\\'" . "evince %s"))))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil))

(setq x-select-enable-clipboard t)

;; Set pdf as the default output for LaTeX/XeLaTeX
(setq-default TeX-PDF-mode t)
;; Reftex config
(defun my-org-mode-setup ()
 (when (and (buffer-file-name)
            (file-exists-p (buffer-file-name)))
  (load-library "reftex")
  (and (buffer-file-name)
        (file-exists-p (buffer-file-name))
        (reftex-parse-all))
   (reftex-set-cite-format
     '((?b . "[[bib::%l]]")
       (?h . "[[papers:%l][%l]]: %t \n")
       (?n . "[[note::%l]]"))))
   (define-key org-mode-map "\C-c\C-g" 'reftex-citation)
   (define-key org-mode-map (kbd "C-c (") 'org-mode-reftex-search)
)
(add-hook 'org-mode-hook 'my-org-mode-setup)

(defun org-mode-reftex-search ()
  ;;jump to the notes for the paper pointed to at from reftex search
  (interactive)
  (org-open-link-from-string (format "[[note:%s]]" (first (reftex-citation t)))))

;;(require 'package)
;;(add-to-list 'package-archives
;;  '("melpa" . "http://melpa.milkbox.net/packages/") t)


;;(setq org-todo-keyword-faces
;;      '(("NOTREAD" . org-warning) ("READING" . "yellow")
;;	("READ" . (:foreground "green" :weight bold))))

(setq org-todo-keyword-faces
      '(
	("TODO" . org-warning)
	("STARTED" . "yellow")
	("WAITING" . "orange")
	("DONE" . (:foreground "green" :weight bold) )
	)
      )

(org-babel-do-load-languages
 'org-babel-load-languages
 '((ditaa . t) ; this line activates ditaa
   (sh . t)    ; this one allows me to run sh code
   (C . t)     ; this one allows me to run C code
   (sh . t)    ; this one allows me to run sh code
   (python . t)    ; this one allows me to run python code
   (gnuplot . t)    ; this one allows me to run sh code
   ))

; PRESENTATION
;;(add-to-list 'load-path "~/org-html5presentation.el")
;;(require 'ox-html5presentation)

;;(add-to-list 'load-path "~/org-impress-js.el")
;;(require 'ox-impress-js)

;; (add-to-list 'load-path "~/.emacs.d/lisp")

;;(add-to-list 'load-path "~/.emacs.d/python-mode.el-6.2.0") 
;;(setq py-install-directory "~/.emacs.d/python-mode.el-6.2.0")
;;(require 'python-mode)
;; (require 'ipython)

;; (autoload 'python-mode "python-mode" "Python Mode." t)
;; (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;; (add-to-list 'interpreter-mode-alist '("python" . python-mode))
;; (defvar server-buffer-clients)
;; (when (and (fboundp 'server-start) (string-equal (getenv "TERM") 'xterm))
;;   (server-start)
;;   (defun fp-kill-server-with-buffer-routine ()
;;     (and server-buffer-clients (server-done)))
;;     (add-hook 'kill-buffer-hook 'fp-kill-server-with-buffer-routine))

;; Start emacs with my agenda
(setq inhibit-splash-screen t)
(org-agenda-list)
(delete-other-windows)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Droid Sans Mono" :foundry "unknown" :slant normal :weight normal :height 152 :width normal)))))
(put 'narrow-to-region 'disabled nil)
;; +++++++++++++++++
;; Free mind support
;; +++++++++++++++++
(require 'ox-freemind)
