;;;; -----------------  global ----------------- ;;;;
(setq user-full-name "Y")
(global-display-line-numbers-mode)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)




;; company
(use-package company
  :ensure t
  :config
  (global-company-mode)

  ;; no delay
  (setq company-idle-delay 0)

  ;; start complition from ...
  (setq company-minimum-prefix-length 2)
  
  ;; when down at the bottom, go back to the top
  (setq company-selection-wrap-around t)
  
  ;; show numbers
  (setq company-show-numbers t)
  )

;; hs-minor-mode 
(add-hook 'c++-mode-hook
          '(lambda ()
             (hs-minor-mode 1)))
(add-hook 'c-mode-hook
          '(lambda ()
             (hs-minor-mode 1)))
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (hs-minor-mode 1)))
(add-hook 'python-mode-hook
          '(lambda ()
             (hs-minor-mode 1)))
(add-hook 'js-mode-hook
          '(lambda ()
             (hs-minor-mode 1)))
(add-hook 'typescript-mode-hook
          '(lambda ()
             (hs-minor-mode 1)))
(add-hook 'css-mode-hook
          '(lambda ()
             (hs-minor-mode 1)))
(add-hook 'yaml-mode-hook
          '(lambda ()
             (hs-minor-mode 1)))
(define-key global-map (kbd "C-\\") 'hs-toggle-hiding)




;; icomplete -> completion in mini buffer
(icomplete-mode 1)

;; auto insert
(defvar template-replacements-alists
  '(("%file%"             . (lambda () (file-name-nondirectory (buffer-file-name))))
    ("%file-without-ext%" . (lambda () (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
    ("%name%"             . user-full-name)
    ("%cyear%"            . (lambda()(substring (current-time-string) -4)))
    ("%date%"             . current-time-string)
    ))

(defun replace-template ()
  (time-stamp)
  (mapc #'(lambda(c)
        (progn
          (goto-char (point-min))
          (replace-string (car c) (funcall (cdr c)) nil)))
    template-replacements-alists)
  (goto-char (point-max))
  (message "done."))

(auto-insert-mode)
(use-package autoinsert
  :ensure t
  :config
  (setq auto-insert-directory "~/.emacs.d/insert/")
  (setq auto-insert-alist
	(nconc '(
		 ("\\.py$" . ["template.py" replace-template])
		 ) auto-insert-alist))

  (setq auto-insert-alist
	(nconc '(
		 ("\\.sh$" . ["template.sh" replace-template])
                 ) auto-insert-alist))

  (setq auto-insert-alist
	(nconc '(
		 ("\\.c$" . ["template.c" replace-template])
                 ) auto-insert-alist))
  
  (setq auto-insert-alist
	(nconc '(
		 ("\\.cpp$" . ["template.c" replace-template])
                 ) auto-insert-alist))

  (setq python-indent-guess-indent-offset nil)
 
  )


;;;; -----------------  language  ----------------- ;;;;

;; ino(Arduino)
(add-to-list 'auto-mode-alist '("\\.ino\\'" . c++-mode))


;; python
(use-package ruff-format
  :ensure t
  :hook (python-mode . ruff-format-on-save-mode)
  )
(use-package python-mode
  :ensure t
  :hook (python-mode . eglot-ensure)
  :hook (python-mode . highlight-indentation-mode)
  :hook (python-mode . highlight-indentation-current-column-mode)
  :hook (python-mode . py-yapf-enable-on-save)  
  )

;; rust
;; https://syohex.hatenablog.com/entry/2022/11/08/000610
(defun my/find-rust-project-root (dir)
   (when-let ((root (locate-dominating-file dir "Cargo.toml")))
     (list 'vc 'Git root)))

(defun my/rust-mode-hook ()
  (setq-local project-find-functions (list #'my/find-rust-project-root)))

(use-package rust-mode
  :ensure t
  :hook (rust-mode . eglot-ensure)
  :hook (rust-mode . my/rust-mode-hook)  
  :config
  (add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))
  :custom rust-format-on-save t
  )


;; typescript, tsx
(use-package tree-sitter
  :ensure t
  :hook
  (tree-sitter-after-on-hook . tree-sitter-hl-mode)
  :config
  (global-tree-sitter-mode)

  (tree-sitter-require 'tsx)
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescript-tsx-mode . tsx)))

(use-package tree-sitter-langs
  :ensure t
  :after tree-sitter
  :config
  (tree-sitter-require 'tsx)
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescript-tsx-mode . tsx)))

(use-package typescript-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . typescript-mode))
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))  
  (add-to-list 'auto-mode-alist '("\\.gs\\'" . typescript-mode))  
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
  (setq typescript-indent-level  2)  
  (setq typescript-indent-offset  2)  
  (setq typescript-tsx-indent-offset  2)

  )


;; web
(defun my-web-mode-hook ()
  "Hooks for Web mode."

  ;; インデント設定
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)

  ;; 要素のハイライト
  (setq web-mode-enable-current-element-highlight t)

  ;; タグを自動で閉じる
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-closing t)
  )

(use-package web-mode
  :ensure t
  :hook (web-mode-hook . my-web-mode-hook)
  :config
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  
  )

(use-package scss-mode
  :ensure t
  :config
  (setq indent-tabs-mode nil)
  (setq css-indent-offset 2)  
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yasnippet-snippets yaml-mode web-mode vue-mode use-package tide rust-mode ruff-format rjsx-mode python-mode py-yapf pug-mode pos-tip pdf-tools lsp-ui lsp-treemacs lsp-pyright kotlin-mode js-auto-format-mode highlight-symbol highlight-indentation helm go-mode flymake-yaml flymake-python-pyflakes flycheck-rust flycheck-gometalinter company cargo atomic-chrome add-node-modules-path)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
