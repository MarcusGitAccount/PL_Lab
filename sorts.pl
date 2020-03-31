
% Marcus Pop 30239. Lab 05 PL

% delete minim of a list and return it in O(n)
% and one single pass

min2(A, B, R) :- B < A, R = B, !.
min2(A, _, A).

concat_on_non_equality(X, H, T, L) :- X =:= H, L = T, !.
concat_on_non_equality(_, H, T, L) :- L = [H | T].

delete_min([], MinAcc, Min, []) :- Min = MinAcc.
delete_min([H | T], MinAcc, Min, LNew) :- 
  min2(H, MinAcc, Curr),
  delete_min(T, Curr, MinNext, LNext),
  !,
  ((H =:= MinNext, LNew = LNext);
    LNew = [H | LNext]),
  Min = MinNext.
delete_min(L, Min, LNew) :- delete_min(L, 10000, Min, LNew).

% 1. rewrite perm predicate wthout using append

delete1(H, [H|T], T).
delete1(H, [X|T], [X|R]):- delete1(H, T, R).

perm([],[]).
perm(L, [X|RI]):- perm_select(X, L, LX), perm(LX, RI).

perm_select(X, L, LX):- member(X, L), delete1(X, L, LX).

% 2. selection sort descrescător

max2(A, B, R) :- B > A, R = B, !.
max2(A, _, A).

maxL([], _) :- fail.
maxL([H], H) :- !.
maxL([H | T], R) :- maxL(T, Next), max2(H, Next, R).

delete1_det(H, [H|T], T) :- !.
delete1_det(H, [X|T], [X|R]):- delete1_det(H, T, R).

sel_sort(L, [M|R]):- maxL(L, M), delete1_det(M, L, L1), sel_sort(L1, R).
sel_sort([], []) :- !.

% 3. For exercises 3 and 4: map the list to [value, element], sort by value using
%    some implemented sort, map element to new list

min2Pair([Ka, _], B, R) :- [Kb, _] = B, Kb < Ka, R = B, !.
min2Pair(A, _, A).

minLPair([], _) :- fail.
minLPair([H], H) :- !.
minLPair([H | T], R) :- minLPair(T, Next), min2Pair(H, Next, R).

pair_reverse_map([_, Value], Value).

char_key_map(C, R) :- char_code(C, Code), R = [Code, C].

sel_sort_by_key(L, [M|R]):- 
  minLPair(L, M), 
  delete1_det(M, L, L1), 
  sel_sort_by_key(L1, R).
sel_sort_by_key([], []) :- !.

sort_chars(L, R) :-
  maplist(char_key_map, L, LPairs),
  sel_sort_by_key(LPairs, LPSorted),
  maplist(pair_reverse_map, LPSorted, R).

% 4. sort a list of lists by their length

list_len_map(L, R) :- length(L, Len), R = [Len, L].

sort_len(L, R) :-
  maplist(list_len_map, L, LPairs),
  sel_sort_by_key(LPairs, LPSorted),
  maplist(pair_reverse_map, LPSorted, R).
