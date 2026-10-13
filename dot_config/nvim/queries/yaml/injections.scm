; #match? is Vim regex: a bare `{` starts a multi (E866) and `|` is literal.
; Lua patterns take `{` literally; `[{%%#]` is the set { `{`, `%`, `#` }.
(
  (block_scalar) @jinja
  (#lua-match? @jinja "{[{%%#]")
  (#set! injection.language "jinja2")
)
