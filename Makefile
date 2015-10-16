CC=gcc
FLAGS=-Wall -Werror -m32

%.o: %.c
	$(CC) $(FLAGS) -c -o $@ $^

main:main.o ctx.o 
	$(CC) $(FLAGS) -o $@ $^

clean:
	rm ctx.o main.o
