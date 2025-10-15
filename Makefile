CC = clang
CFLAGS = -Wall -Wextra -Wpedantic -std=c99 -g -fsanitize=address -D _DEFAULT_SOURCE -Iinclude
LIBS_NCURSES = -lncursesw
LIBS_SDL = -lSDL2 -lSDL2_ttf -lSDL2_image -lSDL2_mixer

SRC = ./src

CORE_OBJS = game.o generation.o logs.o ai.o init.o update.o set.o

NCURSES_OBJS = main_ncurses.o display_ncurses.o $(CORE_OBJS)
SDL_OBJS     = main_sdl.o display_sdl.o music.o $(CORE_OBJS)
TEST_OBJS    = main_test.o test.o $(CORE_OBJS)

.PHONY: all clean run run_ncurses run_sdl test

all: main_ncurses main_sdl main_test

main_ncurses: $(NCURSES_OBJS)
	$(CC) -o $@ $(CFLAGS) $^ $(LIBS_NCURSES)

main_sdl: $(SDL_OBJS)
	$(CC) -o $@ $(CFLAGS) $^ $(LIBS_SDL)

main_test : $(TEST_OBJS)
	$(CC) -o $@ $(CFLAGS) $^

%.o: $(SRC)/%.c
	$(CC) -c $(CFLAGS) $< -o $@

run: 
	@echo "Choose version to run:"
	@echo "1) Terminal (ncurses)"
	@echo "2) SDL"
	@echo "3) Test"
	@read -p "Enter choice [1-2-3]: " choice; \
	if [ $$choice -eq 1 ]; then \
		$(MAKE) run_ncurses; \
	elif [ $$choice -eq 2 ]; then \
    	$(MAKE) run_sdl; \
    	elif [ $$choice -eq 3 ]; then \
    	$(MAKE) test; \
	else \
    	echo "Invalid choice."; \
	fi

run_ncurses: main_ncurses
	./main_ncurses

run_sdl: main_sdl
	./main_sdl

test : main_test
	./main_test

clean:
	rm -rf main_ncurses main_sdl main_test *.o
