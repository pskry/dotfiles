(
  (value) @jinja
  (#match? @jinja "{{|{%|{#")
  (#set! injection.language "jinja2")
)
