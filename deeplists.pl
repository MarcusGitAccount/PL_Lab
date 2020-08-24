
heads([],[],_).
heads([H|T],[H|R],1):- atomic(H), !, heads(T,R,0).
heads([H|T],R,0):- atomic(H), !, heads(T,R,0).
heads([H|T],R,_):- heads(H,R1,1), heads(T,R2,0), append(R1,R2,R).
heads(L,R):- heads(L, R, 1).

l1([1,2,3,[4]]).
l2([[1],[2],[3],[4,5]]).
l3([[],2,3,4,[5,[6]],[7]]).
l4([[[[1]]],1,[1]]).
l5([1,[2],[[3]],[[[4]]],[5,[6,[7,[8,[9],10],11],12],13]]).
l6([alpha,2,[beta],[gamma,[8]]]).

% 1.
countAtomic([], 0) :- !.
countAtomic([H | T], R) :- atomic(H), !, countAtomic(T, R_), R is R_ + 1.
countAtomic([H | T], R) :- countAtomic(H, R1), countAtomic(T, R2), R is R1 + R2.

% 2.
sumAtomic([], 0) :- !.
sumAtomic([H | T], R) :- number(H), !, sumAtomic(T, R_), R is R_ + H.
sumAtomic([H | T], R) :- sumAtomic(H, R1), sumAtomic(T, R2), R is R1 + R2.

% 3.
memberDeep(H,[H|_]) :- !.
memberDeep(X,[H|_]):-memberDeep(X,H), !.
memberDeep(X,[_|T]):-memberDeep(X,T).

% 4. returns the last atomic element at each depth level

% Note: Aici chiar a fost nevoie să rezolv în modul acesta pentru 
%       a nu repeta apelul pe coada listei. :)
lasts([], [], false).
lasts([H | T], R, Found) :-
  % solve the problem for the tail
  lasts(T, R_, Found_),
  % if head is not a sublist
  ((atomic(H), 
    % if the atomic head of list was already found in the tail
    % => nothing to do, return it
    ((Found_, R = R_); 
    % else H is the atomic head of the list
      R = [H | R_]),
    % either way, we have found the atomic head
    Found = true, !);
  % else solve for H sublist
   (lasts(H, RSub, _), append(RSub, R_, R), Found = false)).
lasts(L, R) :- lasts(L, R, _).

% 5. replaces X by Y

replace(_, _, [], []) :- !.
replace(X, Y, [X | T], [Y | R]) :- replace(X, Y, T, R), !.
replace(X, Y, [H | T], [H | R]) :- atomic(H), !, replace(X, Y, T, R).
replace(X, Y, [H | T], R) :- replace(X, Y, H, R1), replace(X, Y, T, R2), append([R1], R2, R).

% 6. sort lists given by their depth

flatten([],[]).
flatten([H|T], [H|R]):- atomic(H), !, flatten(T,R).
flatten([H|T], R):- flatten(H,R1), flatten(T,R2), append(R1,R2,R).

% max of 2 elements
max(A, B, B) :- A < B, !.
max(A, _, A).

% depth(non list) -> 0
depth([],1) :- !.
depth(X, 0) :- atomic(X).
depth([H|T],R):- atomic(H), !, depth(T,R).
depth([H|T],R):- depth(H,R1), depth(T,R2), R3 is R1+1, max(R3,R2,R).

% checks if the first array is smaller than the second.
% works similary to strcmp in C
isSmaller([], _) :- !.
isSmaller([H1 | _], [H2 | _]) :- H1 < H2, !.
isSmaller([H1 | T1], [H1 | T2]) :- isSmaller(T1, T2).

% returns the min of elements of type [depth, list]
% if depths are equal, it uses the isSmaller predicate to determine the minimum 
min2PairList([Ka, Va], [Ka, Vb], [Ka, Va]) :- 
  flatten(Va, Fa),
  flatten(Vb, Fb),
  isSmaller(Fa, Fb), !.
min2PairList([Ka, _], [Ka, Vb], [Ka, Vb]) :- !.
min2PairList([Ka, _], B, R) :- [Kb, _] = B, Kb < Ka, R = B, !.
min2PairList(A, _, A).

minLPair([], _) :- fail.
minLPair([H], H) :- !.
minLPair([H | T], R) :- minLPair(T, Next), min2PairList(H, Next, R).

pair_reverse_map([_, Value], Value).

depth_key_map(L, R) :- depth(L, D), R = [D, L].

% deterministic delete
delete1_det(H, [H|T], T) :- !.
delete1_det(H, [X|T], [X|R]):- delete1_det(H, T, R).

sel_sort_by_key(L, [M|R]):- 
  minLPair(L, M), 
  delete1_det(M, L, L1), 
  sel_sort_by_key(L1, R).
sel_sort_by_key([], []) :- !.

sort_depth(L, R) :-
  maplist(depth_key_map, L, LPairs),
  sel_sort_by_key(LPairs, LPSorted),
  maplist(pair_reverse_map, LPSorted, R).