;;; -*- lexical-binding: t -*-

(defun global-set-keys (alist) nil
  (mapcar (lambda (a) nil
            (setcar a (read-kbd-macro (car a)))
            (apply 'global-set-key a)) alist))

;; Stefan Monnier <foo at acm.org>
(defun unfill-paragraph ()
  "Take a multi-line paragraph and make it into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun xah-new-empty-buffer ()
  "Create a new empty buffer.
New buffer will be named “untitled” or “untitled<2>”, “untitled<3>”, etc.

URL `http://ergoemacs.org/emacs/emacs_new_empty_buffer.html'
Version 2016-12-27"
  (interactive)
  (let ((-buf (generate-new-buffer "untitled")))
    (switch-to-buffer -buf)
    (funcall initial-major-mode)
    (setq buffer-offer-save t)))

(global-set-keys
 '(("C-<backspace>" backward-kill-word)

   ("C-." save-buffer)
   ("C-," avy-goto-word-or-subword-1)

   ("C-S-j C-S-j" xah-new-empty-buffer)
   ("C-; C-f" projectile-find-file)
   ("C-; C-<return>" unfill-paragraph)
   ("C-; C-r" helm-projectile)
   ("C-S-k C-S-k" helm-projectile-ag)
   ("C-; C-t" helm-recentf)
   ("C-; C-m" make-directory)
   ("C-c C-i" fix-imports)
   ("C-x C-j" replace-string)
   ("C-x C-k" vr/query-replace)
   ("C-c k" helm-projectile-ag)
   ("C-i" indent-rigidly)
   ))

(global-unset-key (kbd "C-x TAB"))

(set-keyboard-coding-system 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)

;; Real men end follow periods with one space only.
(setq sentence-end "[.?!][]\"')}]*\\($\\|[ \t]\\)[ \t\n]*")
(setq sentence-end-double-space nil)

(defun open-terminal-here ()
  "Open terminal in buffer file's directory."
  (interactive)
  (let ((current default-directory))
    (shell-command (concat "open -a iTerm.app \"" current "\" 2>&1 > /dev/null & disown") nil nil)
    (kill-buffer "*Shell Command Output*")))

(defun select-current-line ()
  "Select the current line."
  (interactive)
  (end-of-line) ; move to end of line
  (set-mark (line-beginning-position)))
(global-set-key (kbd "C-\\") 'comment-region)
(global-set-key (kbd "C-M-\\") 'uncomment-region)
(global-set-key (kbd "C-8") 'select-current-line)

(provide 'init-keyboard)
;;; init-keyboard.el ends here
