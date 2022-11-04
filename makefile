# Name of the project
PROJ_NAME=cminus

# .c files
C_SOURCE=$(wildcard *.c)

# .h files
H_SOURCE=$(wildcard *.h)

# Object files
OBJ=$(C_SOURCE:.c=.o)

# Compiler
CC=gcc

# Flags for compiler
CC_FLAGS=-c         \
         -W         \
         -ansi

# compilation and linking

all: $(PROJ_NAME)

$(PROJ_NAME): cminus.tab.o lex.yy.o ast.o main.o
	@ echo 'Building binary using GCC linker: $@'
	$(CC) -o $@ $^
	@ echo 'Finished building binary: $@'
	@ echo ' '

cminus.tab.o: cminus.tab.c src/ast.h
	@ echo 'Building target using GCC compiler: $<'
	$(CC) $< $(CC_FLAGS)
	@ echo ' ' 

lex.yy.o: lex.yy.c token.h
	@ echo 'Building target using GCC compiler: $<'
	$(CC) $< $(CC_FLAGS)
	@ echo ' ' 

ast.o: src/ast.c src/ast.h
	@ echo 'Building target using GCC compiler: $<'
	$(CC) $< $(CC_FLAGS)
	@ echo ' '

main.o: src/main.c
	@ echo 'Building target using GCC compiler: $<'
	$(CC) $< $(CC_FLAGS)
	@ echo ' '

# flex and bison

lex.yy.c: src/cminus.l
	@ echo 'Generating $@'
	flex src/cminus.l
	@ echo ' ' 

cminus.tab.c: src/cminus.y
	@ echo 'Generating $@'
	bison --defines=token.h src/cminus.y
	@ echo ' ' 

clean:
	rm -rf *.o *~ lex.yy.c cminus.tab.* token.h $(PROJ_NAME)

.PHONY: all clean

