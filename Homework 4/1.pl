removeAmbiguity([],[]).

removeAmbiguity([0,0,0,0,0|T],L) :-
	append([0,0,0],L1,L),
	removeAmbiguity(T,L1).

removeAmbiguity([0,0,0,0,0|T],L) :-
	append([0,0,0,0,0,0,0],L1,L),
	removeAmbiguity(T,L1).

removeAmbiguity([0,0,0,0|T],L) :-
	append([0,0,0],L1,L),
	removeAmbiguity(T,L1).

removeAmbiguity([1,1,1|T],L) :-
	append([1,1,1],L1,L),
	removeAmbiguity(T,L1).

removeAmbiguity([0,0,0|T],L) :-
	append([0,0,0],L1,L),
	removeAmbiguity(T,L1).

removeAmbiguity([0,0|T],L) :- 
	append([0],L1,L),
	removeAmbiguity(T,L1).

removeAmbiguity([0,0|T],L) :- 
	append([0,0,0],L1,L),
	removeAmbiguity(T,L1).

removeAmbiguity([1,1|T],L) :- 
	append([1],L1,L),
	removeAmbiguity(T,L1).

removeAmbiguity([1,1|T],L) :- 
	append([1,1,1],L1,L),
	removeAmbiguity(T,L1).

removeAmbiguity([0],L) :-
	append([0],L1,L),
	removeAmbiguity(T,L1).

removeAmbiguity([1],L) :-
	append([1],L1,L),
	removeAmbiguity(T,L1).

signal_morse(
     [1,1,1,0,1,1,1, % m
      0,0,
      1,1,1,0,1,1,1,0,1,1,1, % o
      0,0,0,
      1,0,1,1,1,0,1, % r
      0,0,0,
      1,0,1,0,1, % s
      0,0,0,
      1, % e
      0,0,0,0,0,0,0, % #
      1,1,1,0,1,0,1,1,1,0,1, % c
      0,0,0,
      1,1,1,0,1,1,1,0,1,1,1, % o
      0,0,0,
      1,0,1,0,1,0,1,0,1,0,1,0,1,0,1, % error
      0,0,0,
      1,0,1,0,1,0,1,0,1,0,1,0,1,0,1, % error
      0,0,0,
      1,0,1,0,1,0,1,0,1,0,1,0,1,0,1, % error
      0,0,0,
      1,0,1,1,1,0,1,0,1,0,1,0 % as
     ],
     M).