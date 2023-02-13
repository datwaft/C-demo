CC=clang
CFLAGS=-g -Wall

SRC=src
OBJ=obj
BIN=bin

SRCS=$(wildcard $(SRC)/*.c)
OBJS=$(patsubst $(SRC)/%.c, $(OBJ)/%.o, $(SRCS))

TARGET=$(BIN)/hello

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
