
;; Shortcuts

(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-n") 'forward-paragraph)

(global-set-key (kbd "s-w")
                (lambda () (interactive) (kill-buffer (current-buffer))))
(global-set-key (kbd "s-<return>") 'eol-and-next-line-and-indent)
(global-set-key (kbd "s-/") 'comment-or-uncomment-region-or-line-or-blank-line)
(global-set-key (kbd "s-r") 'revbufs)
(global-set-key (kbd "s-C-<return>") 'break-and-indent-brackets)
(global-set-key (kbd "s-h") 'help-command)


;; Some Yegge-isations
(global-set-key (kbd "M-h") 'help-command)
(global-set-key (kbd "C-h") 'backward-delete-char)
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key (kbd "C-c C-k") 'kill-region)
(global-set-key (kbd "C-x C-m") 'execute-extended-command)
(global-set-key (kbd "C-c C-m") 'execute-extended-command)


;; Some lovely skeleton stuff, courtesy of cmarcelo
;; http://cmarcelo.wordpress.com/2008/04/26/a-little-emacs-experiment/

(defvar my-skeleton-pair-alist
  '((?\) . ?\()
    (?\] . ?\[)
    (?} . ?{)
    (?" . ?")))

(defun my-skeleton-pair-end (arg)
  "Skip the char if it is an ending, otherwise insert it."
  (interactive "*p")
  (let ((char last-command-char))
    (if (and (assq char my-skeleton-pair-alist)
             (eq char (following-char)))
        (forward-char)
      (self-insert-command (prefix-numeric-value arg)))))

(defadvice backward-delete-char-untabify
  (before my-skeleton-backspace activate)
  "When deleting the beginning of a pair, and the ending is next char, delete it too."
  (let ((pair (assq (following-char) my-skeleton-pair-alist)))
    (and pair
         (eq (preceding-char) (rest pair))
         (delete-char 1))))

(dolist (pair my-skeleton-pair-alist)
  (global-set-key (char-to-string (first pair))
                  'my-skeleton-pair-end)
  ;; If the char for begin and end is the same,
  ;; use the original skeleton
  (global-set-key (char-to-string (rest pair))
                  'skeleton-pair-insert-maybe))


;; Support for marking a rectangle of text with highlighting.
(global-set-key (kbd "C-x r C-@") 'rm-set-mark)
(global-set-key (kbd "C-x r C-SPC") 'rm-set-mark)
(global-set-key (kbd "C-x r C-x") 'rm-exchange-point-and-mark)
(global-set-key (kbd "C-x r C-k") 'rm-kill-region)
(global-set-key (kbd "C-x r A-x") 'rm-kill-region)
(global-set-key (kbd "C-x r A-c") 'rm-kill-ring-save)
(autoload 'rm-set-mark "rect-mark"
  "Set mark for rectangle." t)
(autoload 'rm-exchange-point-and-mark "rect-mark"
  "Exchange point and mark for rectangle." t)
(autoload 'rm-kill-region "rect-mark"
  "Kill a rectangular region and save it in the kill ring." t)
(autoload 'rm-kill-ring-save "rect-mark"
  "Copy a rectangular region to the kill ring." t)


;; Functions

(defun eol-and-next-line-and-indent ()
  (interactive)
  (end-of-line)
  (newline-and-indent))

;; TextMate-like commenting
(defun comment-or-uncomment-line (&optional lines)
  "Comment current line. Argument gives the number of lines
forward to comment"
  (interactive "P")
  (comment-or-uncomment-region
   (line-beginning-position)
   (line-end-position lines)))
 
(defun comment-or-uncomment-region-or-line (&optional lines)
  "If the line or region is not a comment, comments region
if mark is active, line otherwise. If the line or region
is a comment, uncomment."
  (interactive "P")
  (if mark-active
      (if (< (mark) (point))
          (comment-or-uncomment-region (mark) (point))
  (comment-or-uncomment-region (point) (mark)))
    (comment-or-uncomment-line lines)))

(defun comment-or-uncomment-region-or-line-or-blank-line ()
  "If the curent line is blank, add a char, comment line, then delete char"
  (interactive)
  ;; If region is active, carry on
  (if mark-active
      (comment-or-uncomment-region-or-line)
    ;; Otherwise do an ugly hack, add char then delete it
    (if (and (eolp) (bolp))
        (list
         (insert "_")
         (comment-or-uncomment-region-or-line)
         (delete-char -1))
      (comment-or-uncomment-region-or-line))))

(defun break-and-indent-brackets ()
  "Split brackets and put the cursor between them.
   TODO: make it work with just return when between skeleton pairs"
  (interactive)
  (newline)
  (newline)
  (indent-relative)
  (visual-line-up 1)
  (indent-for-tab-command))

