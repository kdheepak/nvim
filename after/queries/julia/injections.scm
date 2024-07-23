;; extends

;; Match a prefixed string literal and capture the prefix and content.
((prefixed_string_literal
  ;; Capture the prefix identifier and assign it to @_prefix.
  prefix: (identifier) @_prefix)
  ;; Capture the entire string content and assign it to @injection.content.
  @injection.content

  ;; Check if the captured prefix is "md".
  (#eq? @_prefix "md")

  ;; If the prefix is "md", set the injection language to "markdown".
  (#set! injection.language "markdown"))

