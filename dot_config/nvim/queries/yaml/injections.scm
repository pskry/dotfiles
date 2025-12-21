(
  (block_scalar) @jinja
  (#match? @jinja "{{|{%|{#")
  (#set! injection.language "jinja2")
)
