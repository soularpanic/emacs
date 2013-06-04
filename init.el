;; fix the PATH variable
;; (defun set-exec-path-from-shell-PATH ()
;;   (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PATH'")))
;;     (setenv "PATH" path-from-shell)
;;     (setq exec-path (split-string path-from-shell path-separator))))

;; (when window-system (set-exec-path-from-shell-PATH))
(package-initialize)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wheatgrass)))
 '(ido-mode (quote both) nil (ido))
 '(package-archives (quote (("gnu" . "http://elpa.gnu.org/packages/") ("marmalade" . "http://marmalade-repo.org/packages/") ("mepla" . "http://melpa.milkbox.net/packages/"))))
 '(tool-bar-mode nil))



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)

;; (require 'multi-web-mode)
   ;; (setq mweb-default-major-mode 'html-mode)
   ;; (setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
   ;;                    (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
   ;;                    (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
   ;; (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
   ;; (multi-web-global-mode 1)


;; debug php with xdebug
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/geben")
;; (autoload 'geben "geben" "DBGp protocol frontend, a script debugger" t)



;; Breakpoints to always set when geben starts.
(defun my-geben-breakpoints (session)
  (message "Setting my geben breakpoints.") ; how often is this called?
  ; call debugger() in PHP, similar to debugger; in javascript.
  ; Would be nice to also set a watch on $GLOBALS['debugger'], but couldn't get that to work.
  (geben-set-breakpoint-call "debugger"))
;; (add-hook 'geben-dbgp-init-hook #'my-geben-breakpoints t) ; set breakpoints when geben starts

; Ideally, we would not break in debugger(), but instead in the place that called it.  For now we must step out to see who called us.


;; A poor man's variable watch, since dbgp doesn't seem to support watching vars.
;; geben's eval command will show result in the minibuffer.
;; More ideal would be to put the watch in the context buffer (or it's own watch buffer).  However this is the limit of my elisp.  I'm not sure how to prevent geben from writing to minibuffer when geben-dbgp-command-eval is called.
(defun my-geben-watch (session)
  ;(geben-dbgp-command-eval session "print_r($GLOBALS['watch'], 1)")) ; takes up several lines in minibuffer
  ;(geben-dbgp-command-eval session "$GLOBALS['watch']")) ; uses fewer lines, not always easy to read
  (geben-dbgp-command-eval session "function_exists('watch') ? 'watch: ' . print_r(watch(get_defined_vars()), 1) : 'watch() not yet defined.'") ; watch() keeps track of which variables to display.
)
;; (add-hook 'geben-dbgp-continuous-command-hook #'my-geben-watch t) ; display watch vars, very often.

;; This controls whether geben stops before running anything.
;; (setq geben-pause-at-entry-line nil)

;; geben won't connect because its "Already in debugging"  This might help.
(defun my-geben-release ()
  (interactive)
  (geben-stop)
  (dolist (session geben-sessions)
    (ignore-errors
      (geben-session-release session))))
