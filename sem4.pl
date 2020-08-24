
l1([6, 4, 10, 21, 4, 5, 8, 7]).
l2([1, 2, 3, 4, 5, 6]).
l3([7, 6, 5, 4, 3, 2]).

% inserts X in a sorted array
insert(X, [], [X]) :- !.
insert(X, [H | T], [X, H | T]) :- X =< H, !.
insert(X, [H | T], [H | R_]) :- insert(X, T, R_).

insertionSort([], []) :- !.
insertionSort([H | T], R) :- !, insertionSort(T, R_), insert(H, R_, R).

insertionSortFwd([], Acc, Acc) :- !.
insertionSortFwd([H | T], Acc, R) :- !, insert(H, Acc, Acc_), insertionSortFwd(T, Acc_, R).
insertionSortFwd(L, R) :- insertionSortFwd(L, [], R).

% given an array, loop over it and swap any 2 adjacent elements that are not
% ordered increasingly
swap([], [], false) :- !.
swap([A, B | T], [B | R_], true) :- A > B, !, swap([A | T], R_, _).
swap([H | T], [H | R_], Swapped) :- swap(T, R_, Swapped).

bubbleSort([], [], _) :- !.
bubbleSort(L, L, false) :- !.
bubbleSort(L, R, true) :- swap(L, L_, Swapped), !, bubbleSort(L_, R, Swapped).
bubbleSort(L, R) :- bubbleSort(L, R, true).

% ----------- %

max(A, B, A) :- A > B, !. 
max(_, B, B).

min(A, B, A) :- A < B, !. 
min(_, B, B).

maxList([H], H) :- !.
maxList([H | T], R) :- maxList(T, R_), max(H, R_, R).

minList([H], H) :- !.
minList([H | T], R) :- minList(T, R_), min(H, R_, R).

deleteFirst(_, [], []) :- !.
deleteFirst(X, [X | T], T) :- !.
deleteFirst(X, [H | T], [H | R]) :- deleteFirst(X, T, R).

%% REWRITE USING MIN DEL WITH ONE PASS ONLY
selSort([], []) :- !.
selSort(L, [Min | R]) :- minList(L, Min), deleteFirst(Min, L, L_), selSort(L_, R).