/*
 * types.c
 *
 *  Created on: Mar 4, 2012
 *      Author: stian
 */
#include <stdlib.h>
#include "types.h"

node*
create_node(node** children, int num_children, int attrib, int value)
{
  node* n = malloc(sizeof(node));
  n->children = children;
  n->num_children = num_children;
  n->attrib = attrib;
  n->value = value;
  return n;
}

obj*
create_obj(int* attribs, int num_attribs, int object_class)
{
  obj* o = malloc(sizeof(obj));
  o->attribs = attribs;
  o->num_attribs = num_attribs;
  o->object_class = object_class;
  return o;
}
