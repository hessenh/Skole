#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>


#ifndef INIT_STACKSIZE
#define INIT_STACKSIZE 2
#endif


/*
 * Define a structure for tracking positions in text in
 * terms of line number and position on line
 */
typedef struct {
    int32_t line, count;
} position_t;

/* Pointer to the array we will use as a stack */
position_t *parens;

/* Controls the return value at program termination */
bool input_ok = true;

int32_t
    size = INIT_STACKSIZE,
    top = -1,
    num = 0;


/**
 * Added function: grow()
 * This function grows the stack to double size, including nessesary copying and cleaning
 */
void
grow()
{
    position_t* new_pos = (position_t *) malloc ( size * 2 * sizeof(position_t) );
    for (int i = 0; i < size; i++ )
    {
        new_pos[i] = parens[i];	
    }
    size = size * 2;
    free(parens);
    parens = new_pos;
}

void
push ( position_t p )
{
    /* TODO:
     * Put 'p' at the top of the 'parens' stack.
     * Grow the size of the stack if it is too small.
     */
	if (++top == size)
	{
	 grow();
	}
	parens[top] = p;
}


bool
pop ( position_t *p )
{
    /* TODO:
     * Take the top element off of the stack, and put it in the
     * location at 'p'. If the stack shrinks below zero, there's been
     * more ')'-s than '('-s, so return false to let caller know the stack
     * was empty.
     */
	if (top > -1)
	{
		*p = parens[top--];
        return true;
	} else {
        return false;
	}
}


void
check ( void )
{
    /* TODO:
     * This is called after all input has been read.
     * If there are any elements left on stack, there have been more '('-s
     * than ')'-s. Emit suitable error message(s) on std. error, and cause
     * the program to return a failure code
     */
	if (top > -1)
	{
		fprintf(stderr, "\e[1;31mSTACK NOT EMPTY AT EOF!\n\tThere are more '('-s than ')'-s, last '(' @pos %d:%d\n\nNot Happy... :-(\n\e[0m", parens[top].line, parens[top].count);
        exit( EXIT_FAILURE );
	}
}

int
main ( int argc, char **argv )
{
    int32_t c; /*  = getchar(); */ /* We don't need this, and it clumses the while loop */

    position_t
        now = {.line = 1, .count = 0 },   /* Track where we are in the input */
        balance;                           /* Space for the matching position
                                               when parentheses are closed */

    parens = (position_t *) malloc ( size * sizeof(position_t) );
    while ( ! feof(stdin) )
    {
        /* TODO:
         * - Manipulate the stack according to parentheses
         * - Update 'now' position according to read chars and line breaks
         */
        now.count += 1;
        c = getchar();

    	switch(c)               /* Switching on input character */
        {
            case '\n':
                now.line++;     /* At new line */
                now.count = 0;  /* At first character on this new line */
                break;
        	case '(':
    	    	push(now);
        		break;
            case ')':
                balance = now;
        		if ( !pop(&balance) )
                {
            		fprintf(stderr, "\e[1;31mTRYING TO POP AN EMPTY STACK!\n\tDetected ')' without predecending '(' @pos %d:%d\n\nNot Happy... :-(\n\e[0m", now.line, now.count);
                    exit ( EXIT_FAILURE );
                }
                num++;
        		break;
        	default:
        		break;
       	}

    }
    check();
    printf ( "\e[1;34mTotal of: \n\t%d lines.\n\t%d balanced parens\n\nAll Happy!!! :-)\n\e[0m", now.line-1, num );
    free ( parens );
    exit ( (input_ok) ? EXIT_SUCCESS : EXIT_FAILURE );
}
