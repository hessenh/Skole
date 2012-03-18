/*
 * importance.h
 *
 *  Created on: Mar 4, 2012
 *      Author: stian
 */

#ifndef IMPORTANCE_H_
#define IMPORTANCE_H_

#include "types.h"

int
(*importance)(obj** examples, int num_examples, int* attribs, int num_attribs);

void
init_importance(int random);

#endif /* IMPORTANCE_H_ */
