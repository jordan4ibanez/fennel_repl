;; mod-version:3

;; Have you wanted to make a plugin without restarting the editor?
;; Well I have good news for you.

(local fennel (require :plugins.fennel_compiler))

(local core (require :core))
(local config (require :core.config))
(local command (require :core.command))
(local style (require :core.style))
(local common (require :core.common))
(local View (require :core.view))
(local keymap (require :core.keymap))
(local StatusView (require :core.statusview))
(local DocView (require :core.docview))

(local Terminal (. (require :plugins.terminal) :class))

(print Terminal)
;; Goals:
;; Spawn a terminal that contains a repl, that's the program you're in itself!
;; ^This one is for making plugins.
;; Spawn a terminal that is different from the program you're in.
;; CTRL+R CTRL+D rerun file, eval statement, etc

;; (command.perform "terminal:open-tab")

;; (command.perform "terminal:execute" "echo hi")

;; (var terminal-initialized false)


(fn repl-eval [raw-statement]
  (let [old-view core.active_view
        result (fennel.eval raw-statement)]
    ;; (command.perform "terminal:focus")
    (command.perform "terminal:execute" (.. "echo -e \"\n" raw-statement "\n" (tostring result) "\""))
    (core.set_active_view old-view)))
    
(fn fire-up-repl []
  "Loads up the fennel REPL in the terminal."
  (when (not core.terminal_view)
    (let [old-view core.active_view]
      (print "no terminal here!")
      (fennel.repl))))
      ; (command.perform "terminal:toggle-drawer")
      ;; Move the cursor right back to the text area.
      ; (core.set_active_view old-view))))

(fn test-command []
  (repl-eval ":hi"))

(local new-commands {})
(tset new-commands "fennel_repl:launch" fire-up-repl)
(tset new-commands "fennel_repl:do-eval" test-command)
(command.add nil new-commands)

(local new-keymaps {})
(tset new-keymaps "f12" "fennel_repl:launch")
(tset new-keymaps "f9" "fennel_repl:do-eval")
(keymap.add new-keymaps)
