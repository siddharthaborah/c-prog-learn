
# ============================================================
# Project Makefile
# ============================================================
# Description:
#   Compiles individual C programs and generates their
#   executable, object file, preprocessed source, assembly
#   source, assembler listing, and linker map.
#
# Directory structure:
#   .
#   ├── Makefile
#   ├── hello/
#   │   └── hello.c
#   └── calculator/
#       └── calculator.c
#
# Generated files are stored alongside their source files.
#
# ============================================================
# Usage
# ============================================================
#
# Build the default program (hello):
#   make
#
# Build a specific program:
#   make PROGRAM=calculator
#
# Remove generated files for a program:
#   make PROGRAM=calculator clean
#
# Display verbose compiler output:
#   make PROGRAM=calculator verbose
#
# Run a compiled program:
#   ./hello/hello
#   ./calculator/calculator
#
# Add a new program:
#   1. Create a directory named after the program.
#   2. Place a C source file inside it with the same name.
#      Example: example/example.c
#   3. Run: make PROGRAM=example
#
# ============================================================

# C compiler
CC = gcc

# Compiler flags:
# -Wall   : Enable common compiler warnings
# -Wextra : Enable additional warnings
# -ggdb   : Generate debugging information for GDB
CFLAGS = -Wall -Wextra -ggdb

# Linker flags:
# -static : Link libraries statically where supported
LDFLAGS = -static

# Default program to build when PROGRAM is not specified.
# Override it from the command line:
#   make PROGRAM=calculator
PROGRAM ?= hello

# Program directory and file paths
DIR = $(PROGRAM)
SRC = $(DIR)/$(PROGRAM).c
OBJ = $(DIR)/$(PROGRAM).o
TARGET = $(DIR)/$(PROGRAM)

# ============================================================
# Default target
# ============================================================
# Builds the executable and generates:
#   <program>.i   Preprocessed C source
#   <program>.s   Assembly source
#   <program>.lst Assembler listing
#   <program>.map Linker memory map
#   <program>.o   Object file
#
# Example:
#   make PROGRAM=calculator
all: $(TARGET) $(TARGET).i $(TARGET).s

# ============================================================
# Create the program directory if it does not exist
# ============================================================
$(DIR):
	mkdir -p $@

# ============================================================
# Compile C source into an object file
# ============================================================
# -c       : Compile without linking
# -Wa,-a=  : Generate an assembler listing file
# $<       : First prerequisite (the C source file)
# $@       : Target (the object file)
#
# Example output:
#   hello/hello.o
#   hello/hello.lst
$(OBJ): $(SRC) | $(DIR)
	$(CC) $(CFLAGS) -Wa,-a=$(DIR)/$(PROGRAM).lst -c $< -o $@

# ============================================================
# Link the object file into an executable
# ============================================================
# -Wl,-Map= : Ask the linker to generate a map file
#
# Example output:
#   hello/hello
#   hello/hello.map
$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-Map=$(TARGET).map -o $@ $<

# ============================================================
# Generate preprocessed C source
# ============================================================
# -E : Run only the C preprocessor.
# Useful for inspecting macros and included header files.
#
# Example output: hello/hello.i
$(TARGET).i: $(SRC) | $(DIR)
	$(CC) -E $< -o $@

# ============================================================
# Generate assembly source
# ============================================================
# -S : Compile to assembly without assembling or linking.
#
# Example output: hello/hello.s
$(TARGET).s: $(SRC) | $(DIR)
	$(CC) $(CFLAGS) -S $< -o $@

# ============================================================
# Verbose compilation
# ============================================================
# -v : Display detailed information about GCC's compilation
#      process, including the tools it invokes.
#
# Example:
#   make PROGRAM=hello verbose
verbose:
	$(CC) -v $(CFLAGS) -c $(SRC)

# ============================================================
# Clean generated files
# ============================================================
# Removes generated files for the selected program only.
# The original C source file is preserved.
#
# Example:
#   make PROGRAM=calculator clean
clean:
	rm -f $(TARGET) $(OBJ) $(TARGET).i $(TARGET).s \
	      $(TARGET).lst $(TARGET).map

# These targets are commands, not filenames.
.PHONY: all clean verbose
