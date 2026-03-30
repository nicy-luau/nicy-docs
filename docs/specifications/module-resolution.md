# Module Resolution Specification

## Inputs

- requester module path
- requested import string
- alias map (`.luaurc`)

## Algorithm

1. normalize request
2. apply alias mapping
3. resolve filesystem target
4. check cache by canonical key
5. compare fingerprint for invalidation
6. execute or return cached export

## Error conditions

- unresolved module
- dependency cycle
- execution error during module init
