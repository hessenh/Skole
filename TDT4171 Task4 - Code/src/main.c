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

#include "decision_tree_learning.h"
#include "main.h"

obj** examples;
int examples_allocated = 8;
int examples_size = -1;

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

int
main(int argc, char* argv[])
{
  FILE* fp;
  fp = fopen(argv[1], "r");
  if (fp == NULL)
    perror("Error opening file ");

  examples = malloc(sizeof(obj*) * examples_allocated);

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
            example->attribs[attrib_count] = 1;
          }
        else
          {
            example->object_class = 1;
          }
        attrib_count++;
        break;
      case '2':
        last_saved = 0;
        if (attrib_count < NUM_ATTRIBS)
          {
            example->attribs[attrib_count] = 2;
          }
        else
          {
            example->object_class = 2;
          }
        attrib_count++;
        break;
      case '\n':
        add_example(example);
        obj* example = create_obj(malloc(sizeof(int) * NUM_ATTRIBS),
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
  printf("Number of examples: %d\n", examples_size + 1);

  int attributes[NUM_ATTRIBS];
  for (int i = 0; i < NUM_ATTRIBS; i++)
    {
      attributes[i] = i;
    }
  node* decision_tree = decision_tree_learning(examples, examples_size + 1, attributes, NUM_ATTRIBS, 0, 0);
  print_tree(decision_tree);
}
