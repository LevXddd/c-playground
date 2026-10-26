# c-playground

My personal C practice repo — small programs written while learning C
(mainly from *Modern C* by Jens Gustedt). All code here is my own.

> This is a learning repo, not production code. Expect rough edges.

## Layout

```
c-playground/
├── src/        # one .c file per program
├── build/      # compiled binaries (git-ignored)
└── Makefile
```

## Build & run

Requires `gcc` (or `clang`) and `make`.

```sh
make            # build every src/*.c into build/
make hello      # build just src/hello.c
./build/hello   # run it
make clean      # remove build/
```

Compiler flags: `-std=c2x -Wall -Wextra -g`

## Programs

<!-- Add a row each time you add a program. -->

| File | What it does | Concepts |
|------|--------------|----------|
| `src/hello.c` | Minimal starter | `main`, `printf`, return codes |

## Notes

<!-- Things you learned, gotchas, links. -->
