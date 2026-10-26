# Builds every src/*.c into its own binary in build/.
#   make          build all
#   make NAME     build src/NAME.c -> build/NAME
#   make clean    remove build/

CC      ?= gcc
CFLAGS  := -std=c2x -Wall -Wextra -g
SRC_DIR := src
BIN_DIR := build

SRCS := $(wildcard $(SRC_DIR)/*.c)
BINS := $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%,$(SRCS))
NAMES := $(notdir $(BINS))

.PHONY: all clean $(NAMES)

all: $(BINS)

# Shortcut: `make hello` -> build/hello
$(NAMES): %: $(BIN_DIR)/%

$(BIN_DIR)/%: $(SRC_DIR)/%.c | $(BIN_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(BIN_DIR):
	mkdir -p $@

clean:
	rm -rf $(BIN_DIR)
