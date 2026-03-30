# Troubleshooting

Use this page as the central diagnostics map.

## `nicy` not recognized

Refresh PATH or open a new terminal.

## `failed to load symbol 'nicy_start'`

Usually runtime/CLI mismatch or wrong runtime artifact.

## `failed to load symbol 'nicy_version'`

Usually wrong runtime binary package or stale file in PATH.

## PowerShell script execution blocked

Use one-time bypass or user-level `RemoteSigned`.

## Native module load failure

Validate extension, architecture, exports, and dependent libraries.

## Where to go next

- [Install](/install)
- [nicyrtdyn Guide](/nicyrtdyn)
- [FFI / Bare Metal Guide](/ffi-bare-metal)
- [Error Catalog](/reference/error-catalog)
