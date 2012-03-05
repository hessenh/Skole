/*
 * decision_tree_learning.h
 *
 *  Created on: Mar 4, 2012
 *      Author: stian
 */

#ifndef DECISION_TREE_LEARNING_H_
#define DECISION_TREE_LEARNING_H_

typedef struct obj_st
{
  int* attribs;
  int num_attribs;
  int object_class;
  int id;
} obj;

typedef struct node_st
{
  int attrib;
  struct node_st** children;
  int num_children;
} node;

typedef struct
{
  node* root;
} tree;

tree*
decision_tree_learning(obj** examples[], int num_examples,
    obj** parent_examples[], int num_parent_examples);

node*
create_node(node** children, int num_children, int attrib);

obj*
create_obj(int* attribs, int num_attribs, int object_class);

void
print_tree(tree* print_tree);

#endif /* DECISION_TREE_LEARNING_H_ */
