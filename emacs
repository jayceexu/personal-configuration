;; .emacs

;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;;turn on mouse 
;(xterm-mouse-mode t)

;;turn off bell sound
(setq visible-bell t)
;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;;maximum color
(setq font-lock-maximum-decoration t) ;;maximum color

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" system-name))

;; indent 
(setq standard-indent 4)

;; turn off tab
(setq-default indent-tabs-mode nil) 

;; ========== Place Backup Files in Specific Directory ==========
;; Enable backup files.
(setq make-backup-files t)
;; Enable versioning with default values (keep five last versions, I think!)
(setq version-control t)
(setq kept-new-versions 3)
(setq delete-old-versions t)
(setq kept-old-versions 2)
(setq dired-kept-versions 1)

;; Save all backup file in this directory.
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))

;; UI
(menu-bar-mode nil)
;; turn on clolumn number
(setq column-number-mode t) 

;; scroll 
(setq scroll-margin 3
      scroll-conservatively 10000)

;; paren mode
(show-paren-mode t)
(setq show-paren-style 'parentheses)

(setq hippie-expand-try-functions-list      
      '(try-expand-line        
        try-expand-dabbrev        
        try-expand-line-all-buffers        
        try-expand-list        
        try-expand-list-all-buffers        
        try-expand-dabbrev-visible        
        try-expand-dabbrev-all-buffers        
        try-expand-dabbrev-from-kill        
        try-complete-file-name        
        try-complete-file-name-partially        
        try-complete-lisp-symbol        
        try-complete-lisp-symbol-partially        
        try-expand-whole-kill))
(global-set-key (kbd "M-;") 'hippie-expand)
; (global-set-key (kbd "M-/") 'dabbrev-expand)
;; kill-ring
(setq kill-ring-max 50) 

;; c/c++ style
; 我习惯的C和C++ 风格
(defun my-c++-mode-hook()
;;   (setq tab-width 4 indent-tabs-mode nil)
;;   (c-set-style "stroustrup")
;;   (c-set-offset 'inline-open 0)
;;   (c-set-offset 'innamespace 4)
;;   (c-set-offset 'friend '-)
;;   (c-set-offset 'inextern-lang 0) ;;extern语句块内部不需额外缩进   
)

(setq auto-mode-alist
      (append
       '(("\\.h\\'" . c++-mode)
         )
       auto-mode-alist))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)
;; (add-hook 'c-mode-hook 'my-c++-mode-hook)

(add-to-list 'load-path
             "~/.emacs.d/plugins/style")
(require 'ecom-c-style)
(add-hook 'c-mode-common-hook 'ecom-set-c-style)
(add-hook 'c-mode-common-hook 'ecom-make-newline-indent)

(add-hook 'c++-mode-hook 'yas/minor-mode-on)
(add-hook 'c-mode-hook 'yas/minor-mode-on)
(add-to-list 'load-path
             "~/.emacs.d/plugins/yasnippet-0.6.1c")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/plugins/yasnippet-0.6.1c/snippets")

(add-to-list 'load-path
             "~/.emacs.d/plugins/misc")
(require 'sr-speedbar)

;;ido mode
;;in the .emacs
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ;; enable fuzzy matching

;; recent files
(require 'recentf)
(recentf-mode 1)
(defun recentf-open-files-compl ()
  (interactive)
  (let* ((all-files recentf-list)
          (tocpl (mapcar (function 
                           (lambda (x) (cons (file-name-nondirectory x) x))) all-files))
           (prompt (append '("File name: ") tocpl))
            (fname (completing-read (car prompt) (cdr prompt) nil nil)))
    (find-file (cdr (assoc-ignore-representation fname tocpl))))) 


(global-set-key [(control x)(control r)] 'recentf-open-files-compl)

;;line mode
;; (global-hl-line-mode)

(require 'xcscope)

;; cedt plugin
(load-file "~/.emacs.d/plugins/cedet-1.0/common/cedet.el")

(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion 

;; ecb plugin
(add-to-list 'load-path 
             "~/.emacs.d/plugins/ecb-2.40")
(require 'ecb)
;; (setq ecb-primary-secondary-mouse-buttons 'mouse-1--C-mouse-1) ;click mouse 1 to select ecb tree

;; autocomplete
(add-to-list 'load-path 
             "~/.emacs.d/plugins/auto-complete-1.3.1")

(require 'auto-complete-settings)

;; clean buffer periodically
;; midnight mode
(require 'midnight)
;;kill buffers if they were last disabled more than 2 hours ago
;;(setq clean-buffer-list-delay-special 7200)
(defvar clean-buffer-list-timer nil
  "Stores clean-buffer-list timer if there is one. You can disable clean-buffer-list by (cancel-timer clean-buffer-list-timer).")
;; run clean-buffer-list every 12 hours
(setq clean-buffer-list-timer (run-at-time t 43200 'clean-buffer-list))
;; kill everything, clean-buffer-list is very intelligent at not killing
;; unsaved buffer.
;;(setq clean-buffer-list-kill-regexps
;;      '("^.*$"))

;; (autoload 'expand-member-functions "member-functions" "Expand C++ member function declarations" t)
;; (add-hook 'c++-mode-hook (lambda () (local-set-key "\C-cm" #'expand-member-functions)))

;; igrep
(autoload 'igrep "igrep"
  "*Run `grep` PROGRAM to match REGEX in FILES..." t)
(autoload 'igrep-find "igrep"
  "*Run `grep` via `find`..." t)
(autoload 'igrep-visited-files "igrep"
  "*Run `grep` ... on all visited files." t)
(autoload 'dired-do-igrep "igrep"
  "*Run `grep` on the marked (or next prefix ARG) files." t)
(autoload 'dired-do-igrep-find "igrep"
  "*Run `grep` via `find` on the marked (or next prefix ARG) directories." t)
(autoload 'Buffer-menu-igrep "igrep"
  "*Run `grep` on the files visited in buffers marked with '>'." t)
(autoload 'igrep-insinuate "igrep"
  "Define `grep' aliases for the corresponding `igrep' commands." t)

(autoload 'grep "igrep"
  "*Run `grep` PROGRAM to match REGEX in FILES..." t)
(autoload 'egrep "igrep"
  "*Run `egrep`..." t)
(autoload 'fgrep "igrep"
  "*Run `fgrep`..." t)
(autoload 'agrep "igrep"
  "*Run `agrep`..." t)
(autoload 'grep-find "igrep"
  "*Run `grep` via `find`..." t)
(autoload 'egrep-find "igrep"
  "*Run `egrep` via `find`..." t)
(autoload 'fgrep-find "igrep"
  "*Run `fgrep` via `find`..." t)
(autoload 'agrep-find "igrep"
  "*Run `agrep` via `find`..." t)

(setq igrep-find-prune-clause
      (format "-type d %s -name CVS -o -name .libs -o -name .deps -o -name .svn %s"
              (shell-quote-argument "(")
              (shell-quote-argument ")")))
(setq igrep-find-file-clause
      (format "-type f %s -name %s %s -name %s %s -name %s %s -name %s" ; -type l
              (shell-quote-argument "!")
              (shell-quote-argument "*~")	; Emacs backup
              (shell-quote-argument "!")
              (shell-quote-argument "*,v") ; RCS file
              (shell-quote-argument "!")
              (shell-quote-argument "s.*") ; SCCS file
              (shell-quote-argument "!")
              (shell-quote-argument "*.o") ; compiled object
              (shell-quote-argument "!")
              (shell-quote-argument ".#*") ; Emacs temp file
              )
      )

;; kde-emacs 
;; (add-to-list 'load-path "~/.emacs.d/plugins/kde-emacs")
;; (require 'kde-emacs)
;; (setq sourcepair-source-path    '( "." "../src" ))
;; (setq sourcepair-header-path    '( "." "../include"))
;; (setq sourcepair-recurse-ignore '( "CVS" "Obj" "Debug" "Release" ))

;; switch file utility
(require 'switch-file)
(setq switch-path (list "./" "../src/" "../include/"))

;; hot keys
(global-set-key [f1] 'kmacro-start-macro-or-insert-counter)
(global-set-key [f2] 'kmacro-end-or-call-macro)
(global-set-key [f3] 'set-mark-command)
(global-set-key [f4] 'igrep)
(global-set-key [f14] 'igrep-find)  ; on the console, shift f2 gives f12 for some reason..
(global-set-key [f5] 'query-replace-regexp)
;; (define-key c-mode-map [(f6)] 'kde-switch-cpp-h)
;; (define-key c++-mode-map [(f6)] 'kde-switch-cpp-h)
;; (define-key c++-mode-map [(f16)] 'switch-to-function-def)
;; (define-key c-mode-map [(f16)] 'switch-to-function-def)

(global-set-key [f6] 'switch-cc-to-h)
(global-set-key [f6] 'switch-c-to-h)
(global-set-key [f7] 'compile)
(global-set-key [f17] 'makeclean)
(global-set-key [f8]'gdb)
(global-set-key [f9] 'semantic-symref)
(global-set-key [f12] 'sr-speedbar-toggle)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-c /") 'comment-dwim)
(global-set-key (kbd "M-n") 'next-error)
;; add by xujay undo hotkey
(global-set-key (kbd "C-z") 'undo)


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-layout-window-sizes nil)
 '(ecb-options-version "2.40"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;;colors
;(load "256colors.el")
(put 'set-goal-column 'disabled nil)

;;(add-to-list 'default-frame-alist '(foreground-color . "#E0DFDB"))
;;(add-to-list 'default-frame-alist '(background-color . "#102372"))
