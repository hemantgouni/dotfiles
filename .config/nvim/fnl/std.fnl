; Setup boilerplate to allow us to use the vim and neovim apis with a lispy
; naming scheme ("-" as separator instead of "_")

(local v {})

(setmetatable v
  {:__index
    (fn [tbl key] (. vim.fn (vim.fn.substitute key "-" "_" :g)))})

(fn compute-lookup-table-for-api []
  (let [api-functions (. (v.api-info) :functions)
        generated-lookup-table {}]
    (each [_ value (ipairs api-functions)]
      (let [actual-api-function
                (. vim.api (. value :name))
            generated-function-name
                (vim.fn.substitute (. value :name) "_" "-" :g)]
        (tset generated-lookup-table generated-function-name
              actual-api-function)))
    generated-lookup-table))

(local a (compute-lookup-table-for-api))

(fn set-options [options]
  (each [key value (pairs options)]
    (tset vim.opt key value)))

(fn set-local-options [options]
  (each [key value (pairs options)]
    (tset vim.opt_local key value)))

(fn set-global-vars [vars]
  (each [key value (pairs vars)]
    (a.nvim-set-var key value)))

(fn set-key-maps [mode maps opts]
  (each [key value (pairs maps)]
    (vim.keymap.set mode key
        (if (and (not= (type value) :function) (= mode :n))
            (.. value :<CR>) ; then 
            value) ; else 
        opts)))

(fn set-prefix-maps [prefix mode maps opts]
  (set-key-maps mode (collect [key value (pairs maps)]
                       (.. prefix key)
                       value)
                opts))

(fn set-leader-maps [maps]
  (set-prefix-maps :<Leader> :n maps {:silent true}))

(fn set-localleader-maps [maps]
  (set-prefix-maps :<LocalLeader> :n maps {:silent true :buffer 0}))

(fn open-centered-window [buf prop-width prop-height title transp]
  (let [gui (. (a.nvim-list-uis) 1)]
    (a.nvim-open-win buf true
      {:title title
       :relative :editor
       :row (math.floor (* (- (. gui :height)
                              (* (. gui :height) prop-height))
                           0.5))
       :col (math.floor (* (- (. gui :width)
                              (* (. gui :width) prop-width))
                           0.5))
       :height (math.floor (* (. gui :height) prop-height))
       :width (math.floor (* (. gui :width) prop-width))
       :border :rounded})
    (set-local-options {:winblend transp})))

; do a nil check just in case, since nil should generally be treated as an empty string
(fn str-is-empty [str]
  (or (= str nil) (= str "")))

(fn get-date-string []
  (os.date "%a-%d-%b-%Y"))

{: v
 : a
 : get-date-string
 : set-options
 : set-local-options
 : set-global-vars
 : set-leader-maps
 : set-localleader-maps
 : set-key-maps
 : str-is-empty
 : open-centered-window}
