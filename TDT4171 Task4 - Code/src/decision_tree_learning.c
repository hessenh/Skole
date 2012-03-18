/*
 * decision_tree_learning.c
 *
 *  Created on: Mar 4, 2012
 *      Author: stian
 */
#include <stdlib.h>
#include <stdio.h>

#include "decision_tree_learning.h"
#include "plurality_value.h"
#include "importance.h"

/*
 * This function uses the generated tree to guess the value of an example.
 */
int
guess_value(node* tree, obj* example)
{
  if (tree->num_children)
    {
      for (int i = 0; i < tree->num_children; i++)
        {
          if (example->attribs[tree->attrib] == tree->children[i]->value)
            return guess_value(tree->children[i], example);
        }
    }
  return tree->attrib;
}

/*
 * This function prints the given subtree with a given indentation.
 */
void
print_subtree(node* root, int indent)
{
  char space[indent * 3 + 1];
  for (int i = 0; i < indent * 3; i++)
    {
      space[i++] = ' ';
      space[i++] = '|';
      space[i] = ' ';
    }
  space[indent] = 0;
  if (root->value)
    printf("%sVal:%d ", space, root->value);
  if (root->num_children)
    printf("Attrib:%d\n", root->attrib + 1);
  else
    printf("Class:%d\n", root->attrib);

  for (int i = 0; i < root->num_children; i++)
    {
      print_subtree(root->children[i], indent + 3);
    }
}

/*
 * This function prints the entire tree.
 */
void
print_tree(node* root)
{
  print_subtree(root, 0);
}

/*
 * This function returns true (1) if all examples have the same classification. False (0) if not.
 */
int
same_class(obj** examples, int num_examples)
{
  if (num_examples > 0)
    {
      int prev = examples[0]->object_class;
      for (int i = 1; i < num_examples; i++)
        {
          if (prev != examples[i]->object_class)
            {
              return 0;
            }
        }
      return 1;
    }
  else
    {
      return 1;
    }
}

/*
 * This function puts all examples there a given attribute has a given value into the new_examples-array. It also returns the size of the new array.
 */
int
get_examples(obj** examples, int num_examples, int attrib_index, int attrib_val,
    obj*** new_examples)
{
  int size = num_examples / 2;
  int index = 0;
  *new_examples = malloc(sizeof(obj*) * size);
  for (int i = 0; i < num_examples; i++)
    {
      if (examples[i]->attribs[attrib_index] == attrib_val)
        {
          if (index >= size)
            *new_examples = realloc(*new_examples, sizeof(obj*) * (size *= 2));
          (*new_examples)[index++] = examples[i];
        }
    }
  return index; /* Now equal to the number of examples in new_examples */
}

/*
 * This function removes the attribute 'remove' from the set attribs.
 */
int*
remove_attrib(int* attribs, int num_attribs, int remove)
{
  int* new_attribs = malloc(sizeof(int) * (num_attribs - 1));
  int j = 0;
  for (int i = 0; i < num_attribs; i++)
    {
      if (attribs[i] != remove)
        new_attribs[j++] = attribs[i];
    }
  return new_attribs;
}

/*
 * This function creates a leaf node (A node with no children)
 */
node*
leaf_node(int attrib, int value)
{
  return create_node(NULL, 0, attrib, value);
}

/*
 * This is the main function of this file. It is the implementation of Fig 18.5 from AIMA.
 */
node*
decision_tree_learning(obj** examples, int num_examples, int* attribs,
    int num_attribs, obj** parent_examples, int num_parent_examples, int value)
{
  /* Check for various reasons to return right here */
  if (num_examples == 0)
    {
      return leaf_node(plurality_value(parent_examples, num_parent_examples),
          value);
    }
  else if (same_class(examples, num_examples))
    {
      return leaf_node(examples[0]->object_class, value);
    }
  else if (num_attribs == 0)
    {
      return leaf_node(plurality_value(examples, num_examples), value);
    }
  else
    {
      int most_important = importance(examples, num_examples, attribs,
          num_attribs);

      /* Create a new node which should be the root of our current (sub-)tree */
      node* learning_tree = malloc(sizeof(node));
      learning_tree->attrib = most_important;
      learning_tree->value = value;
      learning_tree->children = malloc(sizeof(node*) * 2);
      learning_tree->num_children = 0;

      /* Attributes has values between 1 and 2, here we loop over those two */
      for (int attrib_val = 1; attrib_val < 3; attrib_val++)
        {
          /* Get the examples that has the given value for the most important attribute */
          obj** new_examples;
          int num_new_examples = get_examples(examples, num_examples,
              most_important, attrib_val, &new_examples);

          /* Get the attributes where the most important one is NOT pressent */
          int* new_attribs = remove_attrib(attribs, num_attribs,
              most_important);

          /* Generate the (sub-)tree from the given examples and attributes */
          learning_tree->children[learning_tree->num_children++] =
              decision_tree_learning(
                  new_examples, num_new_examples,
                  new_attribs, num_attribs - 1,
                  examples, num_examples,
                  attrib_val
              );

          /* Cleanup */
          free(new_examples);
          free(new_attribs);
        }
      return learning_tree;
    }
}

/*
 * This function cleans the memory where a learning tree has had its residence.
 */
void
clean_tree(node* tree)
{
  if (tree->children)
    {
      for (int i = 0; i < tree->num_children; i++)
        if (tree->children[i])
          clean_tree(tree->children[i]);
      free(tree->children);
    }
  free(tree);
}
