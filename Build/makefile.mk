# Compiler
CC = gcc

# Compiler flags
CFLAGS = -Wall -Wextra -g -I../Account -I../Storage -I../Transaction

# Directories
SRC_DIR = ..
OBJ_DIR = obj

# Add source directories to search path
VPATH = $(SRC_DIR) $(SRC_DIR)/Account $(SRC_DIR)/Storage $(SRC_DIR)/Transaction

# Find all .c files from root and subdirectories
SRCS = $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/Account/*.c) $(wildcard $(SRC_DIR)/Storage/*.c) $(wildcard $(SRC_DIR)/Transaction/*.c)

# Replace source paths -> build paths
OBJS = $(patsubst %.c,$(OBJ_DIR)/%.o,$(notdir $(SRCS)))

# Output executable
TARGET = mini_bank.exe

# Default rule
all: $(OBJ_DIR) $(TARGET)

# Create build directory if not exists
$(OBJ_DIR):
	mkdir $(OBJ_DIR)

# Link
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Compile each .c into .o (using VPATH to find source files)
$(OBJ_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean
clean:
	@if exist $(OBJ_DIR) rmdir /S /Q $(OBJ_DIR)
	@if exist $(TARGET) del /Q $(TARGET)
	@echo Clean complete
