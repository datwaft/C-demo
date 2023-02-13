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
TARGET=$(BIN)/hello

# Compilation rules
all: $(TARGET)

$(TARGET): $(OBJS) | $(BIN)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET)

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
