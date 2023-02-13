# Compilation
CC=clang
CFLAGS=-g -Wall

# Folders
SRC=src
OBJ=obj
BIN=bin

# Files
SRCS=$(wildcard $(SRC)/*.c)
OBJS=$(patsubst $(SRC)/%.c, $(OBJ)/%.o, $(SRCS))

# Targets
BINS=$(BIN)/hello

# Compilation rules
all: $(BINS)

release: CFLAGS=-Wall -O2 -DNDEBUG
release: $(BINS)

$(BINS): $(OBJS) | $(BIN)
	$(CC) $(CFLAGS) $(OBJS) -o $@

$(OBJ)/%.o: $(SRC)/%.c | $(OBJ)
	$(CC) $(CFLAGS) -c $< -o $@

# Create folders if they don't exist
$(OBJ):
	mkdir $(OBJ)

$(BIN):
	mkdir $(BIN)

# Pseudo-targets
.PHONY: clean

clean:
	rm -r $(OBJ)
	rm -r $(BIN)
