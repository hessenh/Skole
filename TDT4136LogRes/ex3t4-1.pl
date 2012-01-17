last(cons(U, nil), U).
last(cons(X, Y), Z) :- last(Y,Z).
