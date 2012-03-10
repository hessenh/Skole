//#define RANDOM_TREE_F_
/*
 * decision_tree_learning.c
 *
 *  Created on: Mar 4, 2012
 *      Author: stian
 */
#include <stdio.h>
#include <math.h>
#include "importance.h"

#ifdef RANDOM_TREE_F_

/**
 * Random
 */
int
importance(obj** examples, int num_examples, int* attribs, int num_attribs)
{
  return rand() % num_attribs;
}

#endif /* RANDOM_TREE_F_ */
#ifndef RANDOM_TREE_F_

double gain(obj** examples, int num_examples, int attrib_num);
double func_b(double q);
void num_pos(obj** examples, int num_examples, int attrib_num, int* pos, int* pospos, int* ipos, int* ipospos);

/**
 * Information Gain
 */ 
int
importance(obj** examples, int num_examples, int* attribs, int num_attribs)
{

  double max_gain = -1;
  int max_attrib = 0;
  for (int i = 0; i < num_attribs; i++)
  {
    double current_gain = gain(examples, num_examples, attribs[i]);
    if (current_gain - max_gain > 0.00001) /* > or >= gives a small difference. I found >= to be more accurate with out test data */
    {
        max_gain = current_gain;
        max_attrib = i;
    }
  }
  return attribs[max_attrib];
}

double gain(obj** examples, int num_examples, int attrib_num)
{
    if (!num_examples)
        return 0;
    int pos, pospos, ipos, ipospos;
    num_pos(examples, num_examples, attrib_num, &pos, &pospos, &ipos, &ipospos);

    double inv_gain = 0.0f;
    if (pos)
        inv_gain= ((double)pos/num_examples)*func_b((float)pospos/pos);
    if (ipos)
        inv_gain += ((double)ipos/num_examples)*func_b((double)ipospos/ipos);
    return 1 - inv_gain;
}


double func_b(double q)
{
    if (q > 0.00000f && q < 1.00000f)
    {
        return -(q*log2(q) + (1-q)*log2(1-q));
    }
    else
    {
        return 0;
    }
}

void num_pos(obj** examples, int num_examples, int attrib_num, int* pos, int* pospos, int* ipos, int* ipospos)
{
    *pos = 0;
    *pospos = 0;
    *ipos = 0;
    *ipospos = 0;
    for (int i = 0; i < num_examples; i++)
    {
        *pos += examples[i]->attribs[attrib_num] == 1;
        *pospos += (examples[i]->attribs[attrib_num] == 1 && examples[i]->object_class == 1);
        *ipos += examples[i]->attribs[attrib_num] == 2;
        *ipospos += (examples[i]->attribs[attrib_num] == 2 && examples[i]->object_class == 1);
    }
}

#endif /* RANDOM_TREE_F_ */
