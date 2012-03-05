INCLUDEPATH+=\
	-Iinclude
CFLAGS+=-O3 ${INCLUDEPATH} --std=c99 -g
LDFLAGS+=-lm
OBJ=$(subst src,obj,$(subst .c,.o,$(shell ls src/*.c)))
PROGRAM=tree-learning.exe

.PHONY: clean all

all: bin/$(PROGRAM)

bin/$(PROGRAM): $(OBJ) $(filter-out $(wildcard bin), bin)
	gcc -o $@ $(OBJ) $(LDFLAGS)

obj/%.o: src/%.o include/%.h $(filter-out $(wildcard obj), obj)
	mv src/$*.o obj/


clean:
	if [ -e obj ]; then rm -Rf obj; fi
	
purge: clean
	if [ -e bin ]; then rm -Rf bin; fi

obj:
	mkdir obj
	
bin:
	mkdir bin