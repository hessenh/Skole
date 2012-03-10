CC=gcc
ifeq ($(OS),Windows_NT)
    #Windows stuff
	RM = del
	MV = ren
	FixPath = $(subst /,\,$1)
else
    #Linux stuff
	RM = rm
	MV = mv
	FixPath = $1
endif
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
	$(MV) $(call FixPath,src/$*.o) $(call FixPath,obj/)


clean:
	if [ -e obj ]; then $(RM) -Rf obj; fi
	
purge: clean
	if [ -e bin ]; then $(RM) -Rf bin; fi

obj:
	mkdir obj
	
bin:
	mkdir bin
