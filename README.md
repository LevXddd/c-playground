# c-playground

[![build](https://github.com/LevXddd/c-playground/actions/workflows/ci.yml/badge.svg)](https://github.com/LevXddd/c-playground/actions/workflows/ci.yml)

My personal C practice repo — small programs written while learning C
(mainly from *Modern C* by Jens Gustedt). All code here is my own.

Every program is also a reverse-engineering exercise: I write it in C,
then look at what the compiler actually produced.

> This is a learning repo, not production code. Expect rough edges.

## Layout

```
c-playground/
├── src/                  # one .c file per program
├── scripts/hardening.sh  # mitigation report (PIE, NX, RELRO, canary)
├── .github/workflows/    # CI: gcc + clang, -Werror, sanitizers, cppcheck
├── build/                # compiled binaries (git-ignored)
└── Makefile
```

## Build & run

Requires `gcc` or `clang` and `make`. Optional: `gdb`, `cppcheck`, `binutils`.

| Command | What it does |
|---------|--------------|
| `make` | Build every `src/*.c` into `build/` |
| `make hello` | Build just `src/hello.c` |
| `make run NAME=hello` | Build and run |
| `make asan` | Build with AddressSanitizer + UBSan into `build/asan/` — catches out-of-bounds, use-after-free, overflow |
| `make disasm NAME=hello` | Disassemble to `build/hello.asm` (Intel syntax) |
| `make debug NAME=hello` | Open in GDB |
| `make hardening` | Table of exploit mitigations in each binary |
| `make lint` | Static analysis with cppcheck |
| `make clean` | Remove `build/` |

Compiler flags: `-std=c2x -Wall -Wextra -g` (CI adds `-Werror`).

## C → assembly workflow

```sh
make disasm NAME=hello
grep -A20 '<main>:' build/hello.asm
```

Things to look for:
- **Prologue/epilogue** — `push rbp; mov rbp,rsp` … `pop rbp; ret`
- **Calling convention** — on x86-64 Linux, args go in `rdi, rsi, rdx, rcx, r8, r9`
- **Compiler rewrites** — e.g. `printf("text\n")` with no format args becomes a call to `puts`
- **Optimization** — rebuild with `make CFLAGS="-std=c2x -O2 -g"` and compare

For GDB, [pwndbg](https://github.com/pwndbg/pwndbg) or
[GEF](https://github.com/hugsy/gef) make the stack and registers much easier to read.

## Programs

<!-- Add a row each time you add a program. -->

| File | What it does | Concepts |
|------|--------------|----------|
| `src/hello.c` | Minimal starter | `main`, `printf`, return codes |

## Notes

<!-- Things you learned, gotchas, links. -->
