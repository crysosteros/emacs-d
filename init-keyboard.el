(defun global-set-keys (alist) nil
  (mapcar (lambda (a) nil
            (setcar a (read-kbd-macro (car a)))
            (apply 'global-set-key a)) alist))

(defun delete-word (arg)
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun backward-delete-word (arg)
  (interactive "p")
  (delete-word (- arg)))

(defmacro override-keys (map)
  `(lambda nil
     (define-key ,map ,(kbd "C-c C-r") 'ido-recentf)
     (define-key ,map ,(kbd "C-c C-m") 'make-directory)
     (define-key ,map ,(kbd "C-.") 'save-buffer)))

;; Stefan Monnier <foo at acm.org>. It is the opposite of
;; fill-paragraph: Takes a multi-line paragraph and makes it into a
;; single line of text.
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun my-fill-column ()
  (interactive)
  (message "fill column set to 50")
  (setq fill-column 50))

(defun ido-execute ()
  (interactive)
  (call-interactively
   (intern
    (ido-completing-read
     "M-x "
     (let (cmd-list)
       (mapatoms
        (lambda (S)
          (when (commandp S)
            (setq cmd-list (cons (format "%S" S) cmd-list)))))
       cmd-list)))))

;; From xsteve. Thants, xsteve.
(defun ido-recentf ()
  "Use ido to select a recently opened file from the `recentf-list'"
  (interactive)
  (let ((home (expand-file-name (getenv "HOME"))))
    (find-file
     (ido-completing-read "Recentf open: "
                          (mapcar (lambda (path)
                                    (replace-regexp-in-string home "~" path))
                                  recentf-list)
                          nil t))))

(setq-default cleanliness nil)

(defun clean-on nil
  (interactive)
  (message "cleanliness on")
  (add-hook 'write-file-functions 'delete-trailing-whitespace)
  (setq require-final-newline t)
  (setq-default require-final-newline t)
  (setq-default mode-require-final-newline t))

(defun clean-off nil
  (interactive)
  (message "cleanliness off")
  (remove-hook 'write-file-functions 'delete-trailing-whitespace)
  (setq require-final-newline t)
  (setq-default require-final-newline nil)
  (setq-default mode-require-final-newline nil))

(defun clean-toggle nil
  (interactive)
  (if cleanliness (clean-off) (clean-on))
  (setq-default cleanliness (not cleanliness)))

(clean-toggle)

(global-set-keys
 '(("<f7>" markdown)
   ("<f8>" (lambda (warp)
             (interactive "sLevel warp: ")
             (desktop-change-dir
              (gethash warp warp-table))))

   ("C-c C-d" delete-region)
   ("M-d" delete-word)
   ("C-<backspace>" backward-delete-word)
   ("M-[" backward-paragraph)
   ("M-]" forward-paragraph)

   ("C-c C-f" auto-fill-mode)
   ("C-<f11>" my-fill-column)
   ("C-c C-<return>" unfill-paragraph)

   ("C-<f12>" clean-toggle)

   ("C-x C-k" (lambda () (interactive) (kill-buffer nil)))
   ("C-x C-b" electric-buffer-list)

   ("C-c C-r" ido-recentf)
   ("M-x" ido-execute)

   ("C-z" align-regexp)
   ("C-c C-m" make-directory)
   ("C-?" redo)
   ("C-." save-buffer)))

(add-hook 'python-mode-hook (override-keys python-mode-map))
(add-hook 'latex-mode-hook (override-keys latex-mode-map))
(add-hook 'matlab-mode-hook (override-keys matlab-mode-map))
(add-hook 'php-mode-hook (override-keys php-mode-map))
(add-hook 'tex-mode-hook
          (lambda nil
            (interactive)
            (define-key tex-mode-map (kbd "<f5>")
              (lambda nil
                (interactive)
                (save-buffer) (tex-file) (tex-view)))))

(set-keyboard-coding-system 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)

;; Real men end follow periods with one space only.
(setq sentence-end "[.?!][]\"')}]*\\($\\|[ \t]\\)[ \t\n]*")
(setq sentence-end-double-space nil)

(defun explorer ()
  (interactive)
  (w32-shell-execute
   "open" "explorer"
   (concat "/e,/select,"
           (convert-standard-filename buffer-file-name))))
