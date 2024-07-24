;; fennel-ls: macro-file

(local {: nil?} (require :kd.lib.types))

(lambda set! [key ?value]
  "Set a vim option"
  (let [key (tostring key)]
    (let [value (if (nil? ?value) true ?value)]
      (match (key:sub -1)
        "+" `(doto (. vim.opt ,(key:sub 1 -2))
               (: :append ,value))
        "-" `(doto (. vim.opt ,(key:sub 1 -2))
               (: :remove ,value))
        _ `(tset vim.opt ,key ,value)))))

{: set!}

