# Builds every src/*.c into its own binary in build/.
#
#   make               build all programs
#   make NAME          build src/NAME.c -> build/NAME
#   make run NAME=x    build and run build/x
#   make asan          build all with AddressSanitizer + UBSan into build/asan/
#   make disasm NAME=x disassemble build/x (Intel syntax) into build/x.asm
#   make debug NAME=x  build and open build/x in GDB
#   make hardening     show security mitigations (PIE, NX, RELRO, canary) per binary
#   make lint          static analysis with cppcheck
#   make clean         remove build/

CC      ?= gcc
CFLAGS  := -std=c2x -Wall -Wextra -g
SAN     := -fsanitize=address,undefined -fno-omit-frame-pointer
SRC_DIR := src
BIN_DIR := build

SRCS  := $(wildcard $(SRC_DIR)/*.c)
BINS  := $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%,$(SRCS))
ASANS := $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/asan/%,$(SRCS))
NAMES := $(notdir $(BINS))

.PHONY: all clean asan run disasm debug hardening lint need-name $(NAMES)

all: $(BINS)

# Shortcut: `make hello` -> build/hello
$(NAMES): %: $(BIN_DIR)/%

$(BIN_DIR)/%: $(SRC_DIR)/%.c | $(BIN_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(BIN_DIR)/asan/%: $(SRC_DIR)/%.c | $(BIN_DIR)/asan
	$(CC) $(CFLAGS) $(SAN) $< -o $@

$(BIN_DIR) $(BIN_DIR)/asan:
	mkdir -p $@

asan: $(ASANS)

need-name:
	@test -n "$(NAME)" || { echo "usage: make $(MAKECMDGOALS) NAME=<program>"; exit 1; }

run: need-name $(BIN_DIR)/$(NAME)
	./$(BIN_DIR)/$(NAME)

disasm: need-name $(BIN_DIR)/$(NAME)
	objdump -d -M intel --no-show-raw-insn $(BIN_DIR)/$(NAME) > $(BIN_DIR)/$(NAME).asm
	@echo "wrote $(BIN_DIR)/$(NAME).asm — try: grep -A20 '<main>:' $(BIN_DIR)/$(NAME).asm"

debug: need-name $(BIN_DIR)/$(NAME)
	gdb -q $(BIN_DIR)/$(NAME)

hardening: $(BINS)
	@./scripts/hardening.sh $(BINS)

lint:
	cppcheck --enable=warning,style,performance,portability --std=c11 \
		--error-exitcode=1 --inline-suppr --quiet $(SRC_DIR)

clean:
	rm -rf $(BIN_DIR)
