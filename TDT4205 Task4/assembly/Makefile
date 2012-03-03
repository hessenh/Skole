src=foo.s
program: $(src)
	as $(src) -o program.o -g --32
	gcc program.o -g -o program
	rm program.o
clean:
	rm program
