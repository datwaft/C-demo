# ===================
# Variable definition
# ===================
MAKEFILE := $(lastword $(MAKEFILE_LIST))
README := README.md

# ----------------
# Folder variables
# ----------------
SRC_DIR := src
HEADER_DIR := include
TEST_DIR := tests

BUILD_DIR := build
OBJ_DIR := $(BUILD_DIR)/obj
TEST_BUILD_DIR := $(BUILD_DIR)/tests

# ---------------------
# Source file variables
# ---------------------
SRCS := $(wildcard $(SRC_DIR)/*.c)
HEADERS := $(wildcard $(HEADER_DIR)/*.h)
TEST_SRCS := $(wildcard $(TEST_DIR)/*.c)

# -------------------
# Byproduct variables
# -------------------
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

.SECONDARY: $(OBJS) $(DEPS)

# ----------------
# Target variables
# ----------------
TARGET := $(BUILD_DIR)/main
TEST_TARGETS := $(TEST_SRCS:$(TEST_DIR)/%.c=$(TEST_BUILD_DIR)/%)

# ----------------------
# Distribution variables
# ----------------------
DIST := Abreu-Chaves-Guevara-Ortiz-Yip.tgz

# ---------------------
# Compilation variables
# ---------------------
CC := clang
CFLAGS += -Wall -Wextra -Wpedantic \
					-Wformat=2 -Wno-unused-parameter -Wshadow \
					-Wwrite-strings -Wstrict-prototypes -Wold-style-definition \
					-Wredundant-decls -Wnested-externs -Wmissing-include-dirs
CFLAGS += -std=c11
CPPFLAGS += -I$(HEADER_DIR) -MMD -MP
LDLIBS += -lm

# =================
# Compilation rules
# =================
.PHONY: all
all: $(TARGET)

.PHONY: dist
dist: $(DIST)

$(TARGET): $(OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) $^ -o $@

$(TEST_BUILD_DIR)/%: LDLIBS += -lcriterion
$(TEST_BUILD_DIR)/%: $(TEST_DIR)/%.c $(OBJS) | $(TEST_BUILD_DIR)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(LDLIBS) $^ -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(MAKEFILE) | $(OBJ_DIR)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

# =================
# Distribution rule
# =================
$(DIST): $(SRCS) $(HEADERS) $(TEST_SRCS) $(MAKEFILE) $(README)
	tar -zcvf $@ $^

# =====================
# Folder creation rules
# =====================
$(BUILD_DIR):
	mkdir $@

$(OBJ_DIR): | $(BUILD_DIR)
	mkdir $@

$(DEPS_DIR): | $(BUILD_DIR)
	mkdir $@

$(TEST_BUILD_DIR): | $(BUILD_DIR)
	mkdir $@

# ========================
# Pseudo-target definition
# ========================
.PHONY: test
test: $(TEST_TARGETS)
	for test_file in $^; do ./$$test_file; done

.PHONY: clean
clean:
	$(RM) -rf $(BUILD_DIR)
	$(RM) -f $(DIST)

.PHONY: install-hooks
install-hooks:
	pre-commit install
	pre-commit install --hook-type commit-msg

.PHONY: run-hooks
run-hooks:
	pre-commit run --all-files

.PHONY: lint
lint:
	clang-tidy $(SRCS) $(TEST_SRCS)

# -------------
-include $(DEPS)
