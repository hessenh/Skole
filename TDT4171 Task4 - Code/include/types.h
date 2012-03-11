/*
 * types.h
 *
 *  Created on: Mar 4, 2012
 *      Author: stian
 */

#ifndef TYPES_H_
#define TYPES_H_

typedef struct obj_st
{
  int* attribs;
  int num_attribs;
  int object_class;
} obj;

typedef struct node_st
{
  int attrib;
  int value;
  struct node_st** children;
  int num_children;
} node;

node*
create_node(node** children, int num_children, int attrib, int value);

obj*
create_obj(int* attribs, int num_attribs, int object_class);

#endif /* TYPES_H_ */
