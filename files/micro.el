;; Install required packages if not installed.
(mapc #'(lambda (package)
  (unless (package-installed-p package)
    (package-install package)))
    '(projectile arduino-mode platformio-mode company irony company-irony irony-eldoc)
)

;; Projectile mode, requirement for Platformio.
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; Company mode.
(add-hook 'after-init-hook 'global-company-mode)

;; Load required packages.
(require 'company)
(require 'irony)
(require 'arduino-mode)
(require 'platformio-mode)

;; Edit '.ino' files with arduino-mode.
(add-to-list 'auto-mode-alist '("\\.ino$" . arduino-mode)) 

;; Add the required company backend.
(add-to-list 'company-backends 'company-irony)

;; Enable irony for all c++ files, and platformio-mode only
;; when needed (platformio.ini present in project root).
(add-hook 'c++-mode-hook (lambda ()
                           (irony-mode)
                           (irony-eldoc)
                           (platformio-conditionally-enable)))

;; Use irony's completion functions.
(add-hook 'irony-mode-hook
          (lambda ()
            (define-key irony-mode-map [remap completion-at-point]
              'irony-completion-at-point-async)

            (define-key irony-mode-map [remap complete-symbol]
              'irony-completion-at-point-async)

            (irony-cdb-autosetup-compile-options)))
            
;; Setup irony for flycheck.
(add-hook 'flycheck-mode-hook 'flycheck-irony-setup)

;; Set keybindings.
(global-set-key (kbd "C-c i b") 'platformio-build)
(global-set-key (kbd "C-c i c") 'platformio-clean)
(global-set-key (kbd "C-c i u") 'platformio-upload)
