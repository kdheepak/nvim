local utils = require("kd/utils")
local syntax = utils.syntax
local highlight = utils.highlight

syntax("match", "gitLgLine", [[/^[_\*|\/\\ ]\+\(\<\x\{4,40\}\>.*\)\?$/]])

syntax(
  "match",
  "gitLgHead",
  [[/^[_\*|\/\\ ]\+\(\<\x\{4,40\}\> - ([^)]\+)\( ([^)]\+)\)\? \)\?/ contained containedin=gitLgLine]]
)

syntax(
  "match",
  "gitLgDate",
  [[/(\u\l\l \u\l\l \d\=\d \d\d:\d\d:\d\d \d\d\d\d)/ contained containedin=gitLgHead nextgroup=gitLgRefs skipwhite]]
)

syntax("match", "gitLgRefs", [[/([^)]*)/ contained containedin=gitLgHead]])

syntax(
  "match",
  "gitLgGraph",
  [[/^[_\*|\/\\ ]\+/ contained containedin=gitLgHead,gitLgCommit nextgroup=gitHashAbbrev skipwhite]]
)

syntax("match", "gitLgCommit", [[/^[^-]\+- / contained containedin=gitLgHead nextgroup=gitLgDate skipwhite]])

syntax("match", "gitLgIdentity", [[/<[^>]*>$/ contained containedin=gitLgLine]])

highlight("default", "link", "gitLgGraph", "Comment")

highlight("default", "link", "gitLgDate", "gitDate")

highlight("default", "link", "gitLgRefs", "gitReference")

highlight("default", "link", "gitLgIdentity", "gitIdentity")

