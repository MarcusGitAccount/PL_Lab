% 4th lab problems

member(X, [X | _]).
member(X, [_ | T]) :- member(X, T).

% appends the second list at the end of the first one
append1([H | T], L, [H | Rez]) :- append1(T, L, Rez).
append1([], L, R) :- R = L.

% deletes the first occurence of an element in the list
delete1(X, [X | T], T).
delete1(X, [H | T], [H | Rez]) :- delete1(X, T, Rez).
delete1(_, [], []).

% deletes all occurences  of an element in the list
deleteAll(X, [X | T], R) :- deleteAll(X, T, R).
deleteAll(X, [H | T], R) :- deleteAll(X, T, Rez), R = [H | Rez].
deleteAll(_, [], R) :- R = [].

% Lab exercises

% 1. appends 3 lists
append3(A, B, C, R) :- 
  append1(A, B, R_ab), 
  append1(R_ab, C, R_abc), 
  R = R_abc.

% 2. adds an element at the begining of the list
addFirst(X, L, [X | L]).

% 3. sums all the elements in a list
sum([], R) :- R = 0.
sum([H | T], R) :- sum(T, Rez), R is Rez + H.

% 4. separate odd and even numbers into 2 lsits
separate([], EvenAcc, OddAcc, Even, Odd) :- Even = EvenAcc, Odd = OddAcc.
separate([H | T], EvenAcc, OddAcc, Even, Odd) :-
  (mod(H, 2) =:= 0, separate(T, [H | EvenAcc], OddAcc, Even, Odd));
  (mod(H, 2) =:= 1, separate(T, EvenAcc, [H | OddAcc], Even, Odd)).
separate(L, E, O) :- separate(L, [], [], E, O).

% 5. remove all duplicates in a list
removeDuplicates([], R) :- R = [].
removeDuplicates([H | T], R) :- 
  deleteAll(H, T, DelRez), 
  removeDuplicates(DelRez, Final), 
  R = [H | Final]. 

% 6. replaces all ocurrences of X with Y in the given list
replaceAll(_, _, [], R) :- R = [].
replaceAll(X, Y, [H | T], R) :-
  replaceAll(X, Y, T, Rez),
  ((X =\= H, R = [H | Rez]);
    R = [Y | Rez]
  ).

% 7. deletes elements situated on (n * k)th positions
dropK([], _, _, Acc, _) :- Acc = [].
dropK([H | Tail], K, Curr, Acc, R) :- 
  Next is Curr + 1, 
  dropK(Tail, K, Next, Acc_, R),
  ((Curr mod K =\= 0, Acc = [H | Acc_]); 
    Acc = Acc_).
dropK(L, K, R) :- 
  dropK(L, K, 1, Acc, R), 
  R = Acc.