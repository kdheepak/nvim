;; extends

;; _VARARG
((symbol) @constant.builtin
 (#any-of? @constant.builtin
  "_VARARG")
 (#set! priority 150))

;; Lambdas
; (["lambda" "λ"] @keyword.function @conceal
;   (#set! conceal "λ"))

((symbol) @keyword.function @conceal
 (#any-of? @keyword.function
  "lambda" "λ")
 (#set! conceal "λ"))

;; Functions
; (("fn") @keyword.function @conceal
;   (#set! conceal "󰊕"))

((symbol) @keyword.function @conceal
 (#any-of? @keyword.function
  "fn")
 (#set! conceal "󰊕"))

;; Hash Functions
((symbol) @keyword.function @conceal
 (#any-of? @keyword.function
  "hashfn" "#")
 (#set! conceal "#"))

((string) @keyword (#match? @keyword "^:"))

;; {:variable.member something}
(table_pair
  key: (string) @variable.member)

;; (. something :variable.member :variable.member ...)
((list
   call: (symbol) @_dot
   .
   item: _
   item: (string) @variable.member)
 (#eq? @_dot "."))

;; (: something :function.method.call something)
((list
   call: (symbol) @_colon
   .
   _
   .
   item: (string) @function.method.call)
 (#eq? @_colon ":"))

;; (tset something :variable.member ... something)
((list
   call: (symbol) @_tset
   .
   item: _
   item: (string) @variable.member
   item: _
   .)
 (#eq? @_tset "tset"))
