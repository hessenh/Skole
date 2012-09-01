all: pi ps1

pi : pi.c
	mpicc -std=c99 -Wall -o pi pi.c -g
  
ps1 : ps1.c
	cc -std=c99 -Wall -o ps1 ps1.c -g

clean:
	if [ -e ps1 ]; then rm ps1; fi
	if [ -e pi ]; then rm pi; fi

.phony: clean
