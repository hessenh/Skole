/*
 * plurality_value.c
 *
 *  Created on: Mar 4, 2012
 *      Author: stian
 */


#include "plurality_value.h"
#include <stdlib.h>

int val[2] =
  { 0, 0 };

/**
 * This function returns the class that is most represented
 * in the given examples. Ties are resolved by random.
 * ) Random is seeded in main())
 */
int
plurality_value(obj** examples, int num_examples)
{
  val[0] = 0;
  val[1] = 0;
  for (int i = 0; i < num_examples; i++)
    {
      val[examples[i]->object_class - 1]++;
    }
  if (val[0] > val[1])
    {
      return 1;
    }
  else if (val[0] < val[1])
    {
      return 2;
    }
  else
    {
      return (rand() % 2) + 1;
    }
}
