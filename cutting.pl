
member1(X, [X | _]) :- !.
member1(X, [_ | T]) :- member1(X, T).

delete1(X, [X | T], R) :- R = T, !.
delete1(X, [Y | T], R) :- delete1(X, T, Rez), R = [Y | Rez].
delete1(_, [], R) :- R = [].

length1([], R) :- R = 0.
length1([_ | T], R) :- length1(T, Rez), R is Rez + 1.

append1([], L, R) :- R = L.
append1([H | T], L, R) :- append1(T, L, Rez), R = [H | Rez].

reverse1([], R) :- R = [].
reverse1([X | T], R) :- reverse1(T, Rez), append1(Rez, [X], R).

min1([H | T], R) :- min1(T, R), R < H, !.
min1([H | _], R) :- R = H.

union([], L, L).
union([H|T], L2, R) :- member1(H, L2), !, union(T, L2, R).
union([H|T], L2, [H|R]) :- union(T, L2, R).

% Exerciții lab 4

% 1. intersecția a două liste

inters([], _, R) :- R = [].
inters([X | T], L, R) :- member(X, L), !, inters(T, L, Rez), R = [X | Rez].
inters([_ | T], L, R) :- inters(T, L, R).

% 2. difference of two lists

diff([], _, R) :- R = [].
diff([X | T], L, R) :-not(member(X, L)), !, diff(T, L, Rez), R = [X | Rez].
diff([_ | T], L, R) :- diff(T, L, R).

% 3. delete the min/max of the given list

deleteAll(X, [X | T], R) :- deleteAll(X, T, R), !.
deleteAll(X, [H | T], R) :- deleteAll(X, T, Rez), R = [H | Rez].
deleteAll(_, [], R) :- R = [].

max1([H | T], R) :- max1(T, R), R > H, !.
max1([H | _], R) :- R = H.

del_min(L, R) :- min1(L, Min), deleteAll(Min, L, R).

del_max(L, R) :- max1(L, Max), deleteAll(Max, L, R).

%. 4. Reverse starting from the kth element

% Împarte o listă dată într-o listă compusă din primele k elemente
% și în una din restul rămase

% splitByK(L, 0, K, LoAcc, Lo, Hi) :- Lo = LoAcc, Hi = L.
splitByK(L, 0, Lo, Hi)  :- Lo = [], Hi = L, !.
splitByK([], _, Lo, Hi) :- Lo = [], Hi = [], !.
splitByK([H | T], K, Lo, Hi) :- K_ is K - 1, splitByK(T, K_, Lo_, Hi), Lo = [H | Lo_].

reverse_k(L, K, R) :-
  splitByK(L, K, Lo, Hi),
  reverse1(Hi, HiRev),
  append1(Lo, HiRev, Rez),
  R = Rez.

% 6. Rotate a list to the right by k elements

rotate_right(L, K, R) :-
  length1(L, Len),
  K_ is K mod Len, % in case K > Len 
  LeftSize is Len - K_,
  splitByK(L, LeftSize, Lo, Hi),
  append1(Hi, Lo, Rez),
  R = Rez.

% 5. Run length encoding imlementation.
% rle_encode([1, 1, 1, 2, 3, 3, 1, 1], R).
% R = [[1, 3], [2, 1], [3, 2], [1, 2]] ;

% Removes the beginning elements in the tail equal to X
% until it founds one different. Returns the new list and 
% a counter of elements returned

removeFirstEqual([X | T], X, R, Count) :-
  removeFirstEqual(T, X, R, Count_),
  !,
  Count is Count_ + 1.
removeFirstEqual(L, _, R, Count) :- Count = 0, R = L.
 
rle_encode([], R) :- R = [].
rle_encode([H | T], R) :-
  removeFirstEqual(T, H, T_, Count),
  Count_ is Count + 1,
  Partial = [H, Count_],
  rle_encode(T_, Rez),
  R = [Partial | Rez].

%.7. Extract k random elements from a given list

% https://www.swi-prolog.org/pldoc/man?predicate=random/3
% random(Lo, Hi, R) -> extracts a random integer from [Lo, Hi)

% removes the element at position k
deleteAtPosition([], _, R) :- R = [], !.
deleteAtPosition([_ | T], 0, R) :- R = T, !.
deleteAtPosition([H | T], K, R) :-
  K_ is K - 1,
  deleteAtPosition(T, K_, Rez),
  R = [H | Rez].

rnd_select([], _, R) :- R = [], !.
rnd_select(_, 0, R)  :- R = [], !.
rnd_select(L, K, R) :-
  length1(L, Len),
  random(0, Len, Index),
  nth0(Index, L, Choice),
  deleteAtPosition(L, Index, L_), % delete selected element so it can no longer be selected
  K_ is K - 1,
  rnd_select(L_, K_, Rez),
  R = [Choice | Rez].
