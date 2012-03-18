//#define RANDOM_TREE_F_
/*
 * decision_tree_learning.c
 *
 *  Created on: Mar 4, 2012
 *      Author: stian
 */
#include <stdlib.h>
#include <math.h>
#include "importance.h"


/* Declare importance implementations */
int
rand_importance(obj** examples, int num_examples, int* attribs, int num_attribs);

int
gain_importance(obj** examples, int num_examples, int* attribs, int num_attribs);

/*
 * Choose what algorithm importance should point to.
 */
void
init_importance(int use_random)
{
  if (use_random)
    importance = &rand_importance;
  else
    importance = &gain_importance;
}

/**
 * Random
 */
int
rand_importance(obj** examples, int num_examples, int* attribs, int num_attribs)
{
  return attribs[rand() % num_attribs];
}

/*
 * Function declarations needed by the Information Gain algorithm.
 * They are declared here rather than in the header file since they should not be visible to other files.
 */
double
gain(obj** examples, int num_examples, int attrib_num);
double
func_b(double q);
void
num_pos(obj** examples, int num_examples, int attrib_num, int* pos, int* pospos,
    int* ipos, int* ipospos);

/**
 * Information Gain
 */
int
gain_importance(obj** examples, int num_examples, int* attribs, int num_attribs)
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

/**
 * This function calculates the inverse of the entropy for a given set of examples on a special attribute.
 * This may be used to find the most important attribute of a set.
 */
double
gain(obj** examples, int num_examples, int attrib_num)
{
  if (!num_examples)
    return 0;
  int pos, pospos, ipos, ipospos;

  /* Calculate number of examples where attrib is 1 and 2 (i and not i) and where class is 1
   * See num_pos function comment for more expl.
   */
  num_pos(examples, num_examples, attrib_num, &pos, &pospos, &ipos, &ipospos);

  /* Sum all weighted entropies */
  double inv_gain = 0.0f;
  if (pos)
    inv_gain = ((double) pos / num_examples) * func_b((float) pospos / pos);
  if (ipos)
    inv_gain += ((double) ipos / num_examples)
        * func_b((double) ipospos / ipos);

  /* And return the inverse */
  return 1 - inv_gain;
}

/*
 * The entropy of a Boolean random variable
 */
double
func_b(double q)
{
  /* This if is needed because log2(0)=NaN */
  if (q > 0.00000f && q < 1.00000f)
    {
      return -(q * log2(q) + (1 - q) * log2(1 - q));
    }
  else
    {
      return 0;
    }
}

/*
 * This function calculates the number of examples where the following is true:
 * pos: attribute n = 1
 * ipos: attribute n = 2
 * pospos: attribute n = 1 and class = 1
 * ipospos: attribute n = 2 and class = 1
 */
void
num_pos(obj** examples, int num_examples, int attrib_num, int* pos, int* pospos,
    int* ipos, int* ipospos)
{
  *pos = 0;
  *pospos = 0;
  *ipos = 0;
  *ipospos = 0;
  for (int i = 0; i < num_examples; i++)
    {
      *pos += examples[i]->attribs[attrib_num] == 1;
      *pospos += (examples[i]->attribs[attrib_num] == 1
          && examples[i]->object_class == 1);
      *ipos += examples[i]->attribs[attrib_num] == 2;
      *ipospos += (examples[i]->attribs[attrib_num] == 2
          && examples[i]->object_class == 1);
    }
}
