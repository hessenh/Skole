/*
 * decision_tree_learning.c
 *
 *  Created on: Mar 4, 2012
 *      Author: stian
 */
#include "decision_tree_learning.h"
#include "plurality_value.h"
#include "importance.h"

#include <stdlib.h>
#include <stdio.h>

static int id = 0;

node*
create_node(node** children, int num_children, int attrib)
{
  node* n = malloc(sizeof(node));
  n->children = children;
  n->num_children = num_children;
  n->attrib = attrib;
  return n;
}

obj*
create_obj(int* attribs, int num_attribs, int object_class)
{
  obj* o = malloc(sizeof(obj));
  o->attribs = attribs;
  o->num_attribs = num_attribs;
  o->object_class = object_class;
  o->id = id++;
  return o;
}

void
print_subtree(node* root, int indent)
{
  char space[indent + 1];
  for (int i = 0; i < indent; i++)
    {
      space[i] = ' ';
    }
  space[indent] = 0;
  printf("%sNode:%d", space, root->attrib);
  for (int i = 0; i < root->num_children; i++)
    {
      print_subtree(root->children[i], indent + 1);
    }
}

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

void
print_tree(node* root)
{
  print_subtree(root, 0);
}

node*
decision_tree_learning(obj** examples, int num_examples, int* attribs,
    int num_attribs, obj** parent_examples, int num_parent_examples)
{
  if (num_examples == 0)
    {
      return plurality_value(parent_examples, num_parent_examples);
    }
  else if (same_class(examples, num_examples))
    {
      node* class_node = malloc(sizeof(node));
      class_node->attrib(examples[0]->object_class);
      class_node->num_children = 0;
      return class_node;
    }
  else if (num_attribs == 0)
    {
      return plurality_value(examples, num_examples);
    }
  else
    {
      node* learning_tree;
      return learning_tree;
    }
}
