
% checks whether A is sublist of B by using a sliding window
sublist(A, B) :- sublist(A, B, A, 1).
% windows is empty <=> no more elements from A to match the sublist test
sublist(_, _, [], _) :- !.
% end of the line, no more elements in the list
sublist(_, [], _, _) :- false.
% continue expanding the window
sublist(A, [H | R], [H | W], Moves) :- 
  sublist(A, R, W, Moves_).
% start again from the beginning of the window
sublist(A, [_ | R], _, _) :- sublist(A, R, A, 1).