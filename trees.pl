
tree1(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,nil),nil))).
tree2(t(8, t(5, nil, t(7, nil, nil)), t(9, nil, t(11, nil, nil)))).

tert(t3(6, 
  t3(4, 
    t3(2, nil, nil, nil), 
    nil, 
    t3(7, nil, nil, nil)), 
  t3(5, nil, nil, nil), 
  t3(9, 
    t3(3, nil, nil, nil), nil, nil))).


append3(A, B, C, R) :- append(A, B, AB), append(AB, C, R).

% 1. preorder on a ternary tree
preorderTert(t3(Key, Left, Mid, Right), [Key | R]) :-
  preorderTert(Left,  RL),
  preorderTert(Mid,   RM),
  preorderTert(Right, RR),
  append3(RL, RM, RR, R).
preorderTert(nil, []) :- !.

% 1. postorder on a ternary tree
postorderTert(t3(Key, Left, Mid, Right), R) :-
  postorderTert(Left,  RL),
  postorderTert(Mid,   RM),
  postorderTert(Right, RR),
  append3(RL, RM, RR, LMR),
  append(LMR, [Key], R).
postorderTert(nil, []) :- !.

% 1. inorder on a ternary tree
inorderTert(t3(Key, Left, Mid, Right), R) :-
  inorderTert(Left,  RL),
  inorderTert(Mid,   RM),
  inorderTert(Right, RR),
  append3(RL, [Key | RM], RR, R).
inorderTert(nil, []) :- !.


% 2. height of a ternary tree
max2(A, B, A) :- A > B, !. 
max2(_, B, B).

max3(A, B, C, R) :- max2(A, B, AB), max2(AB, C, R).

heightTert(t3(_, Left, Mid, Right), R) :-
  heightTert(Left,  RL),
  heightTert(Mid,   RM),
  heightTert(Right, RR),
  max3(RL, RM, RR, H),
  R is H + 1.
heightTert(nil, 0) :- !.

% 3, deletes a key in a binary search tree by using the succesor method
% in deciding which node to use as replacement when the found one has 2 children
deleteKey(Key, t(Key, L, nil), L) :- !.
deleteKey(Key, t(Key, nil, R), R) :- !.
deleteKey(Key, t(Key, L, R), t(Pred,L,NR)) :- !, getSucc(R,Pred,NR).
deleteKey(Key, t(K,L,R), t(K,NL,R)) :- Key <K ,!,deleteKey(Key,L,NL).
deleteKey(Key, t(K,L,R), t(K,L,NR)) :- deleteKey(Key,R,NR).

getSucc(t(Pred, nil, R), Pred, R) :- !.
getSucc(t(Key, L, R), Pred, t(Key, NL, R)) :- getSucc(L, Pred, NL).

% 4. collect all the leaves of a binary tree into a list
collectLeaves(nil, []) :- !.
collectLeaves(t(Key, nil, nil), [Key]) :- !.
collectLeaves(t(_, Left, Right), R) :-
  collectLeaves(Left,  RL),
  collectLeaves(Right, RR),
  append(RL, RR, R).

% 5. diameter of a binary tree
height(nil, 0).
height(t(_, Left, Right), H) :-
  height(Left,  HL),
  height(Right, HR),
  max2(HL, HR, R),
  H is R + 1.

diameter(nil, 0).
diameter(t(_, Left, Right), D) :-
  diameter(Left, DL),
  diameter(Right, DR),
  height(Left, HL),
  height(Right, HR),
  Curr is HL + HR + 1,
  max3(Curr, DL, DR, D).

prettyPrint(nil, _).
prettyPrint(t(K,L,R), D) :-
  D1 is D+1,
  prettyPrint(L, D1),
  printKey(K, D),
  prettyPrint(R, D1).

printKey(K, D):- D>0, !, D1 is D-1, write('\t'), printKey(K, D1).
printKey(K, _):- write(K), write('\n').

% 6. Collect nodes at each level of the tree.

tree2Key(t(Key, _, _), Key).

% given an array of binary tree nodes return the list made up
% of their children in the same initial order
getChildren([], []).
getChildren([t(_, L,   R)   | T], [L, R | Next]) :- getChildren(T, Next).
getChildren([t(_, L,   nil) | T], [L    | Next]) :- getChildren(T, Next).
getChildren([t(_, nil, R)   | T], [   R | Next]) :- getChildren(T, Next).

% collect nodes at each level together in separate lists. repeat the question for the
% the nodes at the next level
% initial call made by the user. the third is just to distinguish between the
% first and later calls
collectByHeight(T, R) :- collectByHeight([T], R, _).
% found all nodes at given level -> 
collectByHeight(Nodes, R, _) :- maplist(tree2Key, Nodes, R).
% go the next level
collectByHeight(Nodes, R, _) :-
  getChildren(Nodes, Children),
  collectByHeight(Children, R, _).

% 7. Check whether a tree is symmetric by its structure.

%         Key
%  (L1, R1)  (L2, R2)
% -> L1 and R2 need to have the same structure
%    R1 and L2 need to have the same structure

symmetric(nil, nil).
symmetric(t(_, L1, R1), t(_, L2, R2)) :-
  symmetric(L1, R2),
  symmetric(R1, L2).
symmetric(t(_, Left, Right)) :- symmetric(Left, Right).