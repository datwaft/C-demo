# Compilation
CC=clang
CFLAGS=-g -Wall

# Folders
SRC=src
OBJ=obj
BIN=bin
TEST=test
TEST_BIN=$(TEST)/bin

# Targets
BINS=$(BIN)/main
TEST_BINS=$(patsubst $(TEST)/%.c,$(TEST_BIN)/%,$(TESTS))

# Files
MAIN=$(patsubst $(BIN)/%,$(OBJ)/%.o,$(BINS))
SRCS=$(wildcard $(SRC)/*.c)
OBJS=$(filter-out $(MAIN),$(patsubst $(SRC)/%.c,$(OBJ)/%.o,$(SRCS)))
TESTS=$(wildcard $(TEST)/*.c)

# Compilation rules
all: $(BINS)

release: CFLAGS=-Wall -O2 -DNDEBUG
release: $(BINS)

$(BINS): $(OBJS) $(MAIN) | $(BIN)
	$(CC) $(CFLAGS) $^ -o $@

$(TEST_BIN)/%: $(TEST)/%.c $(OBJS) | $(TEST_BIN)
	$(CC) $(CFLAGS) $^ -o $@ -lcriterion

$(OBJ)/%.o: $(SRC)/%.c | $(OBJ)
	$(CC) $(CFLAGS) -c $< -o $@

# Create folders if they don't exist
$(OBJ):
	mkdir $@

$(BIN):
	mkdir $@

$(TEST_BIN):
	mkdir $@

# Pseudo-targets
.PHONY: clean test

test: $(TEST_BINS)
	for test_file in $^; do ./$$test_file; done

clean:
	rm -rf $(OBJ)
	rm -rf $(BIN)
	rm -rf $(TEST_BIN)
