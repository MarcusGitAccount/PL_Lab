
% lab 09 code


% 1. concatenate 2 incomplete lists

% first list empty edge case
% Note: Unificarea trebuie făcută neapărat în corp, altfel la final L2 = R și nu invers.
concatIL([H], L2, R) :- var(H), R = L2, !.
concatIL([H | T], L2, [H | L2]) :- var(T), !.
concatIL([H | T], L2, [H | R]) :- concatIL(T, L2, R). 

% 2. reverse an incomplete list

reverseIL([H], Acc, R) :- var(H), list2Incomplete(Acc, R), !.
reverseIL([H | T], Acc, R) :- reverseIL(T, [H | Acc], R).
reverseIL(L, R) :- reverseIL(L, [], R).

% 3. conversions

list2Incomplete([], [_]) :- !.
list2Incomplete([H], [H | _]) :- !.
list2Incomplete([H | T], [H | R]) :- list2Incomplete(T, R).

incomplete2List([H], []) :- var(H), !.
incomplete2List([H | T], [H | R]) :- incomplete2List(T, R).

% 4. traverse an incomplete tree preorder style and return the result
%    in an incomplete list

tree(t(8,
        t(6, 
          _, 
          t(7, _, _)),
        t(11, 
          t(13, _, _),
          t(9,
            _,
            t(10, _, _))))).

preorderIL(T, _) :- var(T), !.
preorderIL(t(Data, Left, Right), R) :-
  preorderIL(Left, Lo),
  preorderIL(Right, Hi),
  concatIL([Data | Lo], Hi, R).

% 5. height of an incomplete tree

max2(A, B, B) :- A < B, !.
max2(A, _, A).

heightIL(T, -1) :- var(T), !.
heightIL(t(_, Left, Right), R) :- 
  heightIL(Left, Lo),
  heightIL(Right, Hi),
  max2(Lo, Hi, Max),
  R is Max + 1.

% 6.

var2Nil(X, nil) :- var(X), !.
var2Nil(X, X).

toCompleteTree(T, nil) :- var(T), !.
toCompleteTree(t(Data, Left, Right), t(Data, Left_, Right_)) :-
  toCompleteTree(Left, Lo),
  toCompleteTree(Right, Hi),
  var2Nil(Lo, Left_),
  var2Nil(Hi, Right_).

% 7. flattens an incomplete list

flatIL([H], _) :- var(H), !.
flatIL([H | T], [H | R]) :- atomic(H), flatIL(T, R), !.
flatIL([H | T], R) :- 
  flatIL(H, H_),
  flatIL(T, T_),
  concatIL(H_, T_, R).

% 8. binary tree diameter

max3(A, B, C, R) :- max2(A, B, AB), max2(AB, C, R).

diameter(T, 0) :- var(T), !.
diameter(t(_, Left, Right), D) :-
  diameter(Left, DL),
  diameter(Right, DR),
  heightIL(Left, HL),
  heightIL(Right, HR),
  Curr is HL + HR + 1,
  max3(Curr, DL, DR, D).

% 9. sublist: nu merge 100% pe toate cazurile

% checks whether A is sublist of B by using a sliding window
sublist(A, B) :- sublist(A, B, A).
% window is empty <=> no more elements from A to match the sublist test
sublist(_, _, End) :- var(End), !.
% end of the line, no more elements in the list
sublist(_, End, _) :- var(End), false, !.
% continue expanding the window
sublist(A, [H | R], [H | W]) :- sublist(A, R, W), !.
% start again from the beginning of the window
sublist(A, [_ | R], _) :- sublist(A, R, A).