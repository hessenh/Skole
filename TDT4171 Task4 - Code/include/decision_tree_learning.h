/*
 * decision_tree_learning.h
 *
 *  Created on: Mar 4, 2012
 *      Author: stian
 */

#ifndef DECISION_TREE_LEARNING_H_
#define DECISION_TREE_LEARNING_H_

#include "types.h"

node*
decision_tree_learning(obj** examples, int num_examples, int* attribs,
    int num_attribs, obj** parent_examples, int num_parent_examples, int value);

int
guess_value(node* tree, obj* example);

void
print_tree(node* root);

void
clean_tree(node* root);
#endif /* DECISION_TREE_LEARNING_H_ */
