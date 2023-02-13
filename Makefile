CC = clang
CFLAGS = -Wall
LFLAGS =
TARGET = hello

all: $(TARGET)
	$(CC) $(CFLAGS) -o $(TARGET) $(TARGET).c $(LFLAGS)
