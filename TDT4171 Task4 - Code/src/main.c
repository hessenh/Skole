/*
 * main.cpp
 *
 *  Created on: Mar 4, 2012
 *      Author: stian
 */
#define  TRAINING "../training.txt"
#define NUM_ATTRIBS 7

#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#include "decision_tree_learning.h"
#include "main.h"

obj** examples;
int examples_allocated = 0;
int examples_size = -1;

void
cleanup()
{
 for (int i = 0; i <= examples_size; i++)
 {
     free(examples[i]->attribs);
     free(examples[i]);
 }
 free(examples);
 examples_allocated = 0;
 examples_size = -1;
}

void
test(node* dt)
{
    int correct = 0;
    int fail = 0;
    printf("\nTestdata-check:\n");
    for (int i = 0; i <= examples_size; i++)
    {
        if (examples[i]->object_class == guess_value(dt, examples[i]))
        {
             printf("Node %d correct!",i);
             correct++;
        }
        else
        {
            printf("\tNode %d failed!",i);
            fail++;
        }
        printf("\n");
    }
    printf("Summary:\n\tTotal: %d Correct: %d Fail: %d\n", examples_size + 1, correct, fail);
}

void
add_example(obj* example)
{
  examples_size++;
  if (examples_size >= examples_allocated)
    {
      examples_allocated *= 2;
      examples = realloc(examples, sizeof(obj*) * examples_allocated);
    }
  examples[examples_size] = example;
}


void read_file(char* file)
{
  FILE* fp;
  fp = fopen(file, "r");
  if (fp == NULL)
    perror("Error opening file ");

  int attrib_count = 0;
  obj* example = create_obj(malloc(sizeof(int) * NUM_ATTRIBS), NUM_ATTRIBS, 0);
  char c;

  int last_saved = 1;

  while ((c = fgetc(fp)) != EOF)
    {
      switch ((char) c)
        {
      case '1':
        last_saved = 0;
        if (attrib_count < NUM_ATTRIBS)
          {
            example->attribs[attrib_count++] = 1;
          }
        else
          {
            example->object_class = 1;
          }
        break;
      case '2':
        last_saved = 0;
        if (attrib_count < NUM_ATTRIBS)
          {
            example->attribs[attrib_count++] = 2;
          }
        else
          {
            example->object_class = 2;
          }
        break;
      case '\n':
        add_example(example);
        example = create_obj(malloc(sizeof(int) * NUM_ATTRIBS),
            NUM_ATTRIBS, 0);
        attrib_count = 0;
        last_saved = 1;
        break;
      default:
        break;
        }
    }
  if (!last_saved)
    {
      add_example(example); /* Last example */
    }
  fclose(fp);
}

void
init_examples()
{
    examples_allocated = 8;
    examples = malloc(sizeof(obj*)*examples_allocated);
}

int
main(int argc, char* argv[])
{
    srand ( time(NULL) );
    int rounds;
    init_examples();
    if (argc > 3)
        rounds = atoi(argv[2]);
    else
        rounds = 1;
    for (int i = 0; i < rounds; i++)
        read_file(argv[1]);
    printf("Number of examples: %d\n", examples_size + 1);
    #ifdef DEBUG
    for (int i = 0; i <= examples_size; i++)
        printf("Example:%d Type:%d\n", i, examples[i]->object_class);
    #endif
    int attributes[NUM_ATTRIBS];
    for (int i = 0; i < NUM_ATTRIBS; i++)
    {
      attributes[i] = i;
    }
    node* decision_tree = decision_tree_learning(examples, examples_size + 1, attributes, NUM_ATTRIBS, 0, 0, 0);
    print_tree(decision_tree);
    cleanup();
    if (argc > 2)
    {
        init_examples();
        read_file(argv[argc > 3 ? 3 : 2]);
        test(decision_tree);
        cleanup();
    }
    clean_tree(decision_tree);
}

