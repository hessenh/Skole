/*
 * main.cpp
 *
 *  Created on: Mar 4, 2012
 *      Author: stian
 */
#define NUM_ATTRIBS 7

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <string.h>

#include "decision_tree_learning.h"
#include "importance.h"
#include "main.h"

obj** examples;
int examples_allocated = 0;
int examples_size = -1;

char** input_files;
int input_files_allocated = 0;
int input_files_size = -1;

char* test_file = 0;
int rounds = 1;
int use_random = 0;

void
add_input_file(char* file)
{
  input_files_size++;
  if (input_files_size >= input_files_allocated)
    {
      input_files_allocated *= 2;
      input_files = realloc(input_files, sizeof(char*) * input_files_allocated);
    }
  input_files[input_files_size] = file;
}

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
cleanup_file_stack()
{
  free(input_files);
  input_files_allocated = 0;
  input_files_size = -1;
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
#ifdef DEBUG
          printf("\tNode %d correct!\n", i);
#endif
          correct++;
        }
      else
        {
          printf("\tNode %d failed!\n", i);
          fail++;
        }
    }
  printf("\n");
  printf("Summary:\n\tTotal: %d Correct: %d Fail: %d\n\tCorrectness on test set: %.2f%%\n",
      examples_size + 1, correct, fail, ((float) correct / (examples_size + 1))*100);
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

void
read_file(char* file)
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
        example = create_obj(malloc(sizeof(int) * NUM_ATTRIBS), NUM_ATTRIBS, 0);
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
  examples = malloc(sizeof(obj*) * examples_allocated);
}

void
init_files()
{
  input_files_allocated = 1;
  input_files = malloc(sizeof(char*) * input_files_allocated);
}

void
read_args(int argc, char* argv[])
{
  for (int i = 1; i < argc; i++)
    {
      if (argc == 1 || strcmp(argv[i], "-h") == 0
          || strcmp(argv[i], "--help") == 0)
        {
          printf("Help for Decision Tree Learner\n");
          printf("\t%s [ARGUMENTS] {INPUT FILES}\n\n", argv[0]);
          printf("Arguments:\tShort form:\tDesc:\n");
          printf(
              "--iterations n\t-i n\t\tn is the number of times the input files are read.\n");
          printf(
              "--random\t-r\t\tIf set, the random-gain is used instead of the information gain algorithm\n");
          printf(
              "--test file\t-t file\t\tfile is the a file to check our tree against\n\n");
          printf("--help\t-h\t\tDisplays this help text and exits\n\n");
          printf(
              "Example:\n\t%s -r -i 100 -t test.txt training.txt training2.txt\n\n",
              argv[0]);
          exit(0);
        }
      else if (strcmp(argv[i], "-i") == 0
          || strcmp(argv[i], "--iterations") == 0)
        {
          rounds = atoi(argv[++i]);
        }
      else if (strcmp(argv[i], "-r") == 0 || strcmp(argv[i], "--random") == 0)
        {
          use_random = 1;
        }
      else if (strcmp(argv[i], "-t") == 0 || strcmp(argv[i], "--test") == 0)
        {
          test_file = argv[++i];
        }
      else if (argv[i][0] == '-')
        {
          printf("Invalid argument: %s\n", argv[i]);
          exit(0);
        }
      else // Arg is input file
        {
          add_input_file(argv[i]);
        }
    }

}

int
main(int argc, char* argv[])
{
  srand(time(NULL));
  init_examples();
  init_files();
  read_args(argc, argv);
  for (int i = 0; i < rounds; i++)
    for (int j = 0; j <= input_files_size; j++)
      read_file(input_files[j]);
  printf("Number of examples in training set: %d\n", examples_size + 1);
#ifdef DEBUG
  for (int i = 0; i <= examples_size; i++)
  printf("Example:%d Type:%d\n", i, examples[i]->object_class);
#endif
  int attributes[NUM_ATTRIBS];
  for (int i = 0; i < NUM_ATTRIBS; i++)
    {
      attributes[i] = i;
    }
  init_importance(use_random);
  node* decision_tree = decision_tree_learning(examples, examples_size + 1,
      attributes, NUM_ATTRIBS, 0, 0, 0);
  print_tree(decision_tree);
  cleanup();
  if (test_file)
    {
      init_examples();
      read_file(test_file);
      test(decision_tree);
      cleanup();
    }
  clean_tree(decision_tree);
  cleanup_file_stack();
}

