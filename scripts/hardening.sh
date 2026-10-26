#!/usr/bin/env bash
# Report the exploit mitigations compiled into each ELF binary given as an argument.
# A minimal stand-in for `checksec`, using only readelf.
set -euo pipefail

printf '%-20s %-6s %-6s %-14s %-8s\n' BINARY PIE NX RELRO CANARY
for bin in "$@"; do
    hdr=$(readelf -h "$bin")
    segs=$(readelf -lW "$bin")
    dyn=$(readelf -dW "$bin" 2>/dev/null || true)
    syms=$(readelf -sW "$bin" 2>/dev/null || true)

    # PIE: position-independent executables have type DYN
    grep -q 'Type:.*DYN' <<<"$hdr" && pie=yes || pie=no

    # NX: the stack segment must not be executable (flags RW, not RWE)
    grep -A1 GNU_STACK <<<"$segs" | grep -q 'RWE' && nx=no || nx=yes

    # RELRO: GNU_RELRO segment = partial; plus BIND_NOW = full
    if grep -q GNU_RELRO <<<"$segs"; then
        grep -qE 'BIND_NOW|FLAGS.*NOW' <<<"$dyn" && relro=full || relro=partial
    else
        relro=none
    fi

    # Stack canary: the compiler inserts calls to __stack_chk_fail
    grep -q __stack_chk_fail <<<"$syms" && canary=yes || canary=no

    printf '%-20s %-6s %-6s %-14s %-8s\n' "$(basename "$bin")" "$pie" "$nx" "$relro" "$canary"
done
