(put 'upcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(fill-column-indicator company doom-themes which-key magit ivy use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; .emacs

;; straight.el のインストールと設定
(setq straight-use-package-by-default t)

(defvar bootstrap-version)
(let ((bootstrap-file (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-url "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously bootstrap-url)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file))

;; use-package を straight.el で管理
(straight-use-package 'use-package)

;; パッケージ設定
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; use-package の設定
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; 基本設定
(setq inhibit-startup-message t)       ;; スタートアップメッセージを非表示
(setq make-backup-files nil)           ;; バックアップファイルを作成しない
(setq auto-save-default nil)           ;; 自動保存を無効化
(global-display-line-numbers-mode t)   ;; 行番号を表示

;; ivy と counsel の設定
(use-package ivy
  :straight t
  :config
  (ivy-mode 1)) ;; ivy-modeを有効にする

(use-package counsel
  :straight t
  :after ivy
  :bind (("M-x" . counsel-M-x)        ;; M-xでcounsel-M-xを使う
         ("C-s" . swiper)             ;; swiperをC-sにバインド
         ("C-c C-r" . ivy-resume)     ;; ivy-resumeをC-c C-rにバインド
         ("C-x C-f" . counsel-find-file)))  ;; counsel-find-fileをC-x C-fにバインド

;; その他のパッケージ設定
(use-package magit
  :straight t
  :bind (("C-x g" . magit-status)))

(use-package which-key
  :straight t
  :config
  (which-key-mode)) ;; which-key を有効にする

(use-package doom-themes
  :straight t
  :config
  (load-theme 'doom-one t)) ;; doom-dark+テーマ

(use-package fill-column-indicator
  :straight t
  :config
  (setq fci-rule-column 80)
  (setq fci-rule-width 1)
  (setq fci-rule-color "darkgray")
  (add-hook 'prog-mode-hook 'fci-mode)) ;; 80文字目にラインを表示

(use-package flyspell
  :straight t
  :config
  (add-hook 'text-mode-hook 'flyspell-mode)
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)) ;; スペルチェック

(use-package company
  :straight t
  :config
  (global-company-mode)) ;; 自動補完

;; カスタム関数
(defun open-init-file()
  (interactive)
  (find-file user-init-file))
(global-set-key (kbd "C-c I") 'open-init-file) ;; initファイルを開く

;; =で両端スペース
;;(defun my/insert-equal-with-spaces ()
;;  (interactive)
;;  (insert " = "))

;;(define-key prog-mode-map (kbd "=") 'my/insert-equal-with-spaces)

;; キーマッピング
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-c r") 'replace-string) ;; 文字列置換

;;Copy&Paste
;; Ctrl+Shift+C でコピー
(global-set-key (kbd "C-S-c") 'kill-ring-save)

;; Ctrl+Shift+V でペースト
(global-set-key (kbd "C-S-v") 'yank)

;; Ctrl+Shift+A で全選択
(global-set-key (kbd "C-S-a") 'mark-whole-buffer)

;;ターミナル
(global-set-key (kbd "C-c t") 'term)
(global-set-key (kbd "C-c e") 'eshell)

;; インデント設定
(setq-default indent-tabs-mode nil)  ;; タブをスペースに変換
(setq-default tab-width 4)           ;; タブ幅を4に設定
(setq indent-line-function 'insert-tab)

;; マウス操作の有効化
(xterm-mouse-mode 1)

;; 行末の空白を可視化
(setq show-trailing-whitespace t)

;; メニューバーを無効化
(menu-bar-mode -1)

;; ツールバー（アイコンが並んだバー）を無効化
(tool-bar-mode -1)

;; スクロールバーを無効化
(scroll-bar-mode -1)

;; タブバー（Emacs 27以降）を無効化
(when (fboundp 'tab-bar-mode)
  (tab-bar-mode -1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;あとから入れた拡張機能たち

;;github_copilot
(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  :ensure t)

;(add-hook 'prog-mode-hook 'copilot-mode)
(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

;; smartparens
(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1))

;;magit
(use-package magit)

;;projectile
(use-package projectile
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;;、->,
;;。->.
(defun replace-japanese-punctuation-with-ascii ()
  "Replace full-width Japanese commas and periods with ASCII equivalents."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "、" nil t)
      (replace-match ","))
    (goto-char (point-min))
    (while (search-forward "。" nil t)
      (replace-match "."))))

(global-set-key (kbd "C-c ,") 'replace-japanese-punctuation-with-ascii)


;;LaTeX
;; LaTeX設定
(use-package auctex
  :ensure t
  :defer t
  :config
  ;; LuaLaTeXを使う
  (setq TeX-engine 'luatex)

  ;; LuaLaTeXコマンドに出力ディレクトリを指定しない
  (setq TeX-command-list
        '(("LaTeX" "lualatex %t.tex" TeX-run-TeX nil t)))  ;; %t.tex に変更して拡張子を追加

  ;; デフォルトコマンドを明示的に lualatex にする
  (setq TeX-command-default "LaTeX")

  ;; 必要なら保存するように
  (setq TeX-save-query nil)
  (setq TeX-show-compilation t)

  ;; PDFビューアに Evince を使う
  (setq TeX-view-program-selection
        '((output-pdf "Evince")
          (output-dvi "xdvi")))

  (setq TeX-view-program-list
        '(("Evince" "evince %o")))

  ;; ソースとの関連付けを有効化
  (setq TeX-source-correlate-mode t)
  (setq TeX-source-correlate-start-server t)

  ;; PDF生成後に自動でPDFを開き直す
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer)
  )

;;godot
(use-package gdscript-mode
  :ensure t
  :config
  ;; 必要なら追加設定をここに
  )

;; Rust開発用設定
(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :config
  (setq rust-format-on-save t))

(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode))

(use-package lsp-mode
  :ensure t
  :hook ((rust-mode . lsp))
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

;; 警告抑制（ネイティブコンパイル関係）
(setq native-comp-async-report-warnings-errors 'silent)

