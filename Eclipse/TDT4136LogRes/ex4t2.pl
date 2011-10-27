%a)
sorted([A,B|C]):- (A<B), sorted([B|C]).
sorted([A,B]):- (A<B).

%b)
perm(L,L).
perm(L,M) :- L=[H|L1], perm(L1,L2), insert(H,L2,M).

% fra tidligere øving
insert(X,List1,List2):- List2=[X|List1]|
			[H|T]=List1,
			List2=[H|A],
			insert(X,T,A).

%c)
slow_sort(L,M)	    :-	perm(L,M),
			sorted(M).

%e)
insert_sort([],[]).
insert_sort(L,M)    :- 	smallest(L,S), delete(S,L,L2),
		   	insert_sort(L2,M1), M=[S|M1].

smallest([S],S).
smallest([A,B],S)   :-	A=<B,S=A|B<A,S=B.
smallest([A,B|T],S) :-	smallest([A,B],S1),
			smallest([S1|T],S).

delete(X,L1,L2)     :-	insert(X,L2,L1).