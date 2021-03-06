;;; my/js-mode/main.el --- description
;;; Commentary:
;;; Code:

(require 'flycheck)
(require 'js2-mode)
(require 'web-mode)
(require 'emmet-mode)

(defun my/js-mode/set-style ()
  "Set the style for the JavaScript mode."
  (setq js-indent-level 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-markup-indent-offset 2))

(defun my/js-mode/bind-keys ()
  "Bind keys for the JavaScript mode."
  (local-set-key (kbd "<f8>")
                 (lambda ()
                   (interactive)
                   (indent-region (point-min)
                                  (point-max))))
  (local-set-key (kbd "<tab>") 'indent-for-tab-command)
  (local-set-key (kbd "C-<tab>") 'emmet-expand-yas))

(defun my/js-mode/add-hooks ()
  "Add hooks for the JavaScript mode.")

(defun my/js-mode/update-for-typescript ()
  (setq js-indent-level 4)
  (setq web-mode-code-indent-offset 4)
  (setq web-mode-markup-indent-offset 4))

(defun my/js-mode/hook ()
  "The JavaScript mode hook."
  (projectile-mode)
  (my/js-mode/set-style)
  (emmet-mode)
  (my/js-mode/bind-keys)
  (my/js-mode/add-hooks)
  (setq js2-highlight-level 3)
  (flycheck-mode t)

  (if (or (string-equal (file-name-extension buffer-file-name) "ts")
           (string-equal (file-name-extension buffer-file-name) "tsx"))
      (my/js-mode/update-for-typescript)))

(add-to-list 'auto-mode-alist '("\\.js$" .  web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ts$" .  web-mode))
(add-to-list 'auto-mode-alist '("\\.tsx$" . web-mode))

(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
      (let ((web-mode-enable-part-face nil)) ad-do-it) ad-do-it))

(defadvice web-mode-highlight-part (around tweak-tsx activate)
  (if (equal web-mode-content-type "tsx")
      (let ((web-mode-enable-part-face nil)) ad-do-it) ad-do-it))

;; Add the hooks
(add-hook 'web-mode-hook 'my/js-mode/hook)
(add-hook 'web-mode-hook (lambda ()
                           ;; short circuit js mode and just do everything in jsx-mode
                           (if (equal web-mode-content-type "javascript")
                               (web-mode-set-content-type "jsx")
                             (message "now set to: %s" web-mode-content-type))))

(provide 'my/js-mode/main)
;;; main.el ends here
