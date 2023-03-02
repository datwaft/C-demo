# ===================
# Variable definition
# ===================

# ---------------------
# Compilation variables
# ---------------------
CC := clang
CFLAGS += -Wall -Wextra -Wpedantic \
					-Wformat=2 -Wno-unused-parameter -Wshadow \
					-Wwrite-strings -Wstrict-prototypes -Wold-style-definition \
					-Wredundant-decls -Wnested-externs -Wmissing-include-dirs
CFLAGS += -std=c11

# ----------------
# Folder variables
# ----------------
SRC_DIR := src
TEST_DIR := tests

BUILD_DIR := build
OBJ_DIR := $(BUILD_DIR)/obj
TEST_BUILD_DIR := $(BUILD_DIR)/tests

# ---------------------
# Source file variables
# ---------------------
SRCS := $(wildcard $(SRC_DIR)/*.c)
TEST_SRCS := $(wildcard $(TEST_DIR)/*.c)

# -------------------
# Byproduct variables
# -------------------
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

.SECONDARY: $(OBJS)

# ----------------
# Target variables
# ----------------
TARGET := $(BUILD_DIR)/main
TEST_TARGETS := $(TEST_SRCS:$(TEST_DIR)/%.c=$(TEST_BUILD_DIR)/%)

# =================
# Compilation rules
# =================
all: $(TARGET)

$(TARGET): $(OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@

$(TEST_BUILD_DIR)/%: $(TEST_DIR)/%.c $(OBJS) | $(TEST_BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@ -lcriterion

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(SRC_DIR)/%.h | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# ---------------------
# Folder creation rules
# ---------------------
$(BUILD_DIR):
	mkdir $@

$(OBJ_DIR): | $(BUILD_DIR)
	mkdir $@

$(TEST_BUILD_DIR): | $(BUILD_DIR)
	mkdir $@

# ========================
# Pseudo-target definition
# ========================

.PHONY: test clean install-hooks run-hooks lint

test: $(TEST_TARGETS)
	for test_file in $^; do ./$$test_file; done

clean:
	rm -rf $(BUILD_DIR)

install-hooks:
	pre-commit install
	pre-commit install --hook-type commit-msg

run-hooks:
	pre-commit run --all-files

lint:
	clang-tidy $(SRCS) $(TEST_SRCS)
