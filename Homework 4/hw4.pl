/***** HELPER PREDICATES *****/

/* shift a list N elements to the left, discarding first N elements */
leftShift([],_,[]).
leftShift(L,0,L).
leftShift([_|T],1,T).
leftShift([_|T],N,OutputList) :-
	N1 is N-1,
	leftShift(T,N1,OutputList).

/* get head of a list */
headOf([]).
headOf([H|_],H).

/***** PREDICATES FOR SHRINKING DUPLICATES *****/

/* count number of ones in list, stopping at 1st instance of zero */
/* base case */
countOnes([],0).
/* recursive case */
countOnes([0|_],0).
countOnes([1|T],Accumulator) :-
	countOnes(T,A),
	Accumulator is 1+A.

/* count number of zeroes in list, stopping at 1st instance of one */
/* base case */
countZeroes([],0).
/* recursive case */
countZeroes([1|_],0).
countZeroes([0|T],Accumulator) :-
	countZeroes(T,A),
	Accumulator is 1+A.

/***** SHRINKING DUPLICATES *****/

/* convert >3 ones to 3 ones && >5 zeroes to 7 zeroes */

/* base case */
shrinkOnes([],[]).

/* counted only 1 one, return a list of 1 one */
shrinkOnes([H|T],L) :-
	countOnes([H|T],A),
	A is 1,
	append([1],_,L).

/* counted only 2 ones, return a list of 2 ones */
shrinkOnes([H|T],L) :-
	countOnes([H|T],A),
	A is 2,
	append([1,1],_,L).

/* counted more than 3 ones, return a list of 3 ones */
shrinkOnes([H|T],L) :-
	countOnes([H|T],A),
	A >= 3,
	append([1,1,1],_,L).

/* base case */
shrinkZeroes([],[]).

/* counted only 1 zero, return a list of 1 zero */
shrinkZeroes([H|T],L) :-
	countZeroes([H|T],A),
	A is 1,
	append([0],_,L).

/* counted only 2 zeros, return a list of 2 zeroes */
shrinkZeroes([H|T],L) :-
	countZeroes([H|T],A),
	A is 2,
	append([0,0],_,L).

/* counted 3 zeroes, return a list of 3 zeroes */
shrinkZeroes([H|T],L) :-
	countZeroes([H|T],A),
	A is 3,
	append([0,0,0],_,L).

/* counted 4 zeroes, return a list of 4 zeroes */
shrinkZeroes([H|T],L) :-
	countZeroes([H|T],A),
	A is 4,
	append([0,0,0,0],_,L).

/* counted more than 5 zeroes, return a list of 7 zeroes */
shrinkZeroes([H|T],L) :-
	countZeroes([H|T],A),
	A >= 5,
	append([0,0,0,0,0,0,0],_,L).

/* convert long strings of zeroes and ones to correct length */
/* base case */
shrinkList([],[]).

/* shrink lists beginning with 1 */
shrinkList([1|T],M) :-
	countOnes([1|T],N), /* N = # of ones before 1st zero */
	leftShift([1|T],N,L), /* L = original list with leading ones removed */
	shrinkOnes([1|T],L1), /* L1 = shortened list of ones */
	append(L1,L2,M), /* L2 = accumulated list of correct format */
	shrinkList(L,L2).

/* shrink lists beginning with 0 */
shrinkList([0|T],M) :-
	countZeroes([0|T],N), /* N = # of zeroes before 1st one */
	leftShift([0|T],N,L), /* L = original list with leading zeroes removed */
	shrinkZeroes([0|T],L1), /* L1 = shortened list of zeroes */
	append(L1,L2,M), /* L2 = accumulated list of correct format */
	shrinkList(L,L2).	

/***** REMOVE AMBIGUITY *****/

/* base case */
removeAmbiguity([],[]).

/* singleton list */
removeAmbiguity([X],[X]).
/* doubleton list */
removeAmbiguity([X,X],[X,X]).

/* space -> space */
removeAmbiguity([0,0,0,0,0,0,0|T],L) :-
	append([0,0,0,0,0,0,0],L1,L),
	removeAmbiguity(T,L1),!.

/* 5 -> separator */
removeAmbiguity([0,0,0,0,0|T],L) :-
	append([0,0,0],L1,L),
	removeAmbiguity(T,L1).

/* 5 -> space */
removeAmbiguity([0,0,0,0,0|T],L) :-
	append([0,0,0,0,0,0,0],L1,L),
	removeAmbiguity(T,L1),!.

/* 4 -> separator */
removeAmbiguity([0,0,0,0|T],L) :-
	append([0,0,0],L1,L),
	removeAmbiguity(T,L1),!.

/* 3 in a row */
removeAmbiguity([X,X,X|T],L) :-
	append([X,X,X],L1,L),
	removeAmbiguity(T,L1).

/* 3 in a row */
removeAmbiguity([X,X|T],L) :-
	headOf(T,HT),
	HT is X,
	append([X,X,X],L1,L),
	removeAmbiguity(T-HT,L1).

/* 2 in a row */
removeAmbiguity([X,X|T],L) :-
	headOf(T,HT),
	\+(HT is X),
	append([X],L1,L),
	removeAmbiguity(T,L1).

/* 2 in a row */
removeAmbiguity([X,X|T],L) :-
	headOf(T,HT),
	\+(HT is X),
	append([X,X,X],L1,L),
	removeAmbiguity(T,L1).

/* 1 */
removeAmbiguity([X,Y|T],L) :-
	\+(X is Y),
	append([X],L1,L),
	removeAmbiguity([Y|T],L1).

/***** DECODE UNAMBIGUOUS LIST *****/

/* base case */
decode([],[]).

/* reached space token*/
decode([0,0,0,0,0,0,0|T],M) :-
	append(['#'],M1,M),
	decode(T,M1),!.

/* reached dah token */
decode([1,1,1|T],M) :-
	append(['-'],M1,M),
	decode(T,M1),!.

/* reached boundary token */
decode([0,0,0|T],M) :-
	append(['^'],M1,M),
	decode(T,M1),!.

/* reached dih token */
decode([1|T],M) :-
	append(['.'],M1,M),
	decode(T,M1),!.

/* reached separator token */
decode([0|T],M) :-
	decode(T,M),!.

/***** SIGNAL_MORSE *****/

/* base case */
signal_morse([],[]).

/* general case */
signal_morse([H|T],M) :-
	shrinkList([H|T],S),!, /* S = original list with long strings shortened */
	removeAmbiguity(S,R), /* R = S with ambiguities resolved */
	decode(R,M).

/***** MORSE CODE TABLE *****/
morse(a, [.,-]).           % A
morse(b, [-,.,.,.]).	   % B
morse(c, [-,.,-,.]).	   % C
morse(d, [-,.,.]).	   % D
morse(e, [.]).		   % E
morse('e''', [.,.,-,.,.]). % É (accented E)
morse(f, [.,.,-,.]).	   % F
morse(g, [-,-,.]).	   % G
morse(h, [.,.,.,.]).	   % H
morse(i, [.,.]).	   % I
morse(j, [.,-,-,-]).	   % J
morse(k, [-,.,-]).	   % K or invitation to transmit
morse(l, [.,-,.,.]).	   % L
morse(m, [-,-]).	   % M
morse(n, [-,.]).	   % N
morse(o, [-,-,-]).	   % O
morse(p, [.,-,-,.]).	   % P
morse(q, [-,-,.,-]).	   % Q
morse(r, [.,-,.]).	   % R
morse(s, [.,.,.]).	   % S
morse(t, [-]).	 	   % T
morse(u, [.,.,-]).	   % U
morse(v, [.,.,.,-]).	   % V
morse(w, [.,-,-]).	   % W
morse(x, [-,.,.,-]).	   % X or multiplication sign
morse(y, [-,.,-,-]).	   % Y
morse(z, [-,-,.,.]).	   % Z
morse(0, [-,-,-,-,-]).	   % 0
morse(1, [.,-,-,-,-]).	   % 1
morse(2, [.,.,-,-,-]).	   % 2
morse(3, [.,.,.,-,-]).	   % 3
morse(4, [.,.,.,.,-]).	   % 4
morse(5, [.,.,.,.,.]).	   % 5
morse(6, [-,.,.,.,.]).	   % 6
morse(7, [-,-,.,.,.]).	   % 7
morse(8, [-,-,-,.,.]).	   % 8
morse(9, [-,-,-,-,.]).	   % 9
morse(., [.,-,.,-,.,-]).   % . (period)
morse(',', [-,-,.,.,-,-]). % , (comma)
morse(:, [-,-,-,.,.,.]).   % : (colon or division sign)
morse(?, [.,.,-,-,.,.]).   % ? (question mark)
morse('''',[.,-,-,-,-,.]). % ' (apostrophe)
morse(-, [-,.,.,.,.,-]).   % - (hyphen or dash or subtraction sign)
morse(/, [-,.,.,-,.]).     % / (fraction bar or division sign)
morse('(', [-,.,-,-,.]).   % ( (left-hand bracket or parenthesis)
morse(')', [-,.,-,-,.,-]). % ) (right-hand bracket or parenthesis)
morse('"', [.,-,.,.,-,.]). % " (inverted commas or quotation marks)
morse(=, [-,.,.,.,-]).     % = (double hyphen)
morse(+, [.,-,.,-,.]).     % + (cross or addition sign)
morse(@, [.,-,-,.,-,.]).   % @ (commercial at)

% Error.
morse(error, [.,.,.,.,.,.,.,.]). % error - see below

% Prosigns.
morse(as, [.,-,.,.,.]).          % AS (wait A Second)
morse(ct, [-,.,-,.,-]).          % CT (starting signal, Copy This)
morse(sk, [.,.,.,-,.,-]).        % SK (end of work, Silent Key)
morse(sn, [.,.,.,-,.]).          % SN (understood, Sho' 'Nuff)

/***** HELPER PREDICATES *****/

/* checking symbols */
isBoundary('^').
isSpace('#').

/* pad space symbols with boundary symbols (simplifies getSymbol) */
/* base case */
padSpace([],[]).
/* special case */
padSpace(['#'|T],M) :-
	append(['^','#','^'],M1,M),
	padSpace(T,M1),!.
/* recursive case */
padSpace([H|T],M) :- 
	\+(isSpace(H)),
	append([H],M1,M),
	padSpace(T,M1),!.

/* get all morse symbols up to boundary */
/* base case */
getSymbol([],[]).
/* exit case */
getSymbol(['^'|_],[]).
/* recursive case */
getSymbol([H|T],M) :- 
	\+(isBoundary(H)),
	append([H],M1,M),
	getSymbol(T,M1),!.

/* get ASCII from morse */
getASCII(['#'|_],'#').
getASCII([H|T],S) :- morse(S,[H|T]),!. /* expletive not intentional */

/* translate morse to ASCII */
translate([],[]).
translate([H|T],M) :- 
	getSymbol([H|T],S), /* S = first symbol in morse */
	length(S,L), /* L = length of symbol in morse */
	leftShift([H|T],L+1,M1), /* M1 = everything after S */
	getASCII(S,X), /* X = symbol in ASCII */
	append([X],X1,M), /* accumulate */
	translate(M1,X1),!.

/* condition to check for */
isError('error').

/* get word up to & including hash */
getWord([],_,_).
/* W = word, L = everything after word (includes hash) */
getWord([H|T],W,L) :- 
	\+(isSpace(H)),
	\+(isError(H)),
	append([H],W1,W),
	getWord(T,W1,L).
/* exit case */
getWord(['#'|T],['#'],L) :- append(T,_,L).
/* exit case */
getWord(['error'|T],[],L) :- append(['error'|T],_,L).

/* look for error starting from 1 after hash */
/* base case */
findError([],[]).
/* accumulate # symbols until reaching error or ASCII */
findError(['#'|T],M) :-
	append(['#'],M1,M),
	findError(T,M1).
/* exit case */
findError([H|_],[]) :- 
	\+(isSpace(H)), 
	\+(isError(H)).
/* exit case */
findError(['error'|_],['error']).

/***** FIND AND REMOVE ERRORS *****/

/* base case */
removeErrors([],[]).

/* case where error is not found */
removeErrors([H|T],M) :- 
	getWord([H|T],W,L), /* W = word up to & including hash */
	findError(L,E), /* E = error after hash */
	length(E,EL), /* N = length of list up to error */
	EL is 0, /* if error does not exist */
	length(W,WL), /* WL = length of word without hash */
	append(W,E,WE), /* WE = word + hash */
	append(WE,M1,M), /* keep word + hash */
	leftShift([H|T],WL+EL,M2), /* left shift to discard word + hash */
	removeErrors(M2,M1),!.

/* case where error is found */
removeErrors([H|T],M) :- 
	getWord([H|T],W,L), /* W = word up to & including hash */
	findError(L,E), /* E = error after hash */
	length(E,EL), /* N = length of list up to error */
	EL >= 1, /* if error exists */
	length(W,WL), /* WL = length of word */
	leftShift([H|T],WL+EL,M2), /* M1 = everything after word+error */
	removeErrors(M2,M),!.

/***** SIGNAL_MESSAGE *****/ 

/* base case */
signal_message([],[]).

/* recursive case */
signal_message(L,M) :-
	signal_morse(L,M1), /* M1 = 1s and 0s converted to morse */
	padSpace(M1,M2), /* M2 = M1 with spaces padded with ^ to ease parsing */
	translate(M2,M3), /* M3 = M2 with morse converted to ASCII */
	removeErrors(M3,M). /* M = M3 with errors removed */