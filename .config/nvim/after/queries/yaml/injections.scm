; extends
;
; Highlight Jinja ({{ ... }}, {% ... %}, {# ... #}) inside YAML string values.
; Mainly for Ansible, but harmless elsewhere: the predicate only matches
; scalars that actually contain a Jinja opening delimiter.

([
  (double_quote_scalar)
  (single_quote_scalar)
  (plain_scalar)
] @injection.content
  (#lua-match? @injection.content "{[{%%#]")
  (#set! injection.language "jinja_inline"))
