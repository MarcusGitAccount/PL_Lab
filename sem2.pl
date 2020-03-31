% 2nd seminary problems

% Will fail by default for an empty list.
member(_, []) :- false.
member(X, [X | _]).
member(X, [_ | T]) :- member(X, T).

union([], [], Acc, R) :- R = Acc.
union([H | T], B,  Acc, R) :- 
  (\+ member(H, Acc), union(T, B,  [H | Acc], R)); 
    union(T,  B, Acc, R).
union([], [H | T], Acc, R) :-
   (\+ member(H, Acc), union([], T, [H | Acc], R)); 
    union([], T, Acc, R).
union(A, B, R) :- union(A, B, [], R).

intersection([], _, Acc, R) :- R = Acc.
intersection([H | T], B, Acc, R) :- 
  (member(H, B), intersection(T, B, [H | Acc], R)); 
    intersection(T, B, Acc, R).
intersection(A, [], R) :- R = A.
intersection([], B, R) :- R = B.
intersection(A, B, R)  :- intersection(A, B, [], R).

diff([], _, Acc, R) :- R = Acc.
diff([H | T], B, Acc, R) :- (\+ member(H, B), diff(T, B, [H | Acc], R)); diff(T, B, Acc, R).
diff(A, [], R) :- R = A.
diff(A, B, R)  :- diff(A, B, [], R).

% Return all the elements from a given list that divisible by K
getDivisible([], _, R) :- R = [].
getDivisible([H | T], K, R) :-
  getDivisible(T, K, NextR),
  ((H mod K =:= 0, R = [H | NextR]);
    R = NextR).