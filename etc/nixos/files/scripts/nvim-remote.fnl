(when (not (os.getenv "NVIM"))
  (print "No running neovim instance found! Exiting.")
  (os.exit))

(fn system [command opts]
  (let [fd (io.popen command)
        output (fd:read opts)]
    ; close the fd
    (fd:close)
    output))

(fn prepend-abs-path [arg-array]
  (each [idx str (ipairs arg-array)]
    ; we don't want to change absolute paths
    (when (~= "/" (string.sub str 1 1))
      ; read only a line since a command can't contain newlines
      ; (reading *all will cause a newline to be read, adds nothing for `pwd`)
      (tset arg-array idx (.. (system "pwd" "*line") "/" str))))
  arg-array)

(fn sleep [time]
  (os.execute (.. "sleep " time)))

; build the final command
(os.execute (.. "nvim --server \"$NVIM\" --remote-tab "
                ; add processed args
                (table.concat (prepend-abs-path _G.arg) " ")))

(sleep "infinity")
