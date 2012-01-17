cons(X,Y,[X|Y]).
last([X],X).
last([_|X],Y) :- last(X,Y).





















