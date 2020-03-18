% 3rd lab problems

cmmdc1(X, X, X).
cmmdc1(X, Y, Z) :- X>Y, Diff is X-Y, cmmdc1(Diff, Y, Z).
cmmdc1(X, Y, Z) :- X<Y, Diff is Y-X, cmmdc1(X, Diff, Z).

cmmdc2(X, 0, X).
cmmdc2(X, Y, Z) :-Y \== 0,  C is X mod Y, cmmdc2(Y, C, Z).

fact1(0,1).
fact1(N,F) :- N1 is N-1, fact1(N1,F1), F is N*F1.

fact2(N,F) :- N < 1, F = 1. % still kinda fails, returns 0 for new solutions
fact2(N,F) :- N1 is N-1, fact2(N1,F1), F is N*F1.

fact3(0,1).
fact3(N,F) :- N > 0, N1 is N-1, fact3(N1,F1), F is N*F1.

fact4(0,Acc,F) :- F = Acc.
fact4(N,Acc,F) :- N > 0, N1 is N-1, Acc1 is Acc*N, fact4(N1,Acc1,F).
fact4(N,F) :- fact4(N,1,F).

% exercises

cmmmc(_, 0, X) :- X = 0.
cmmmc(A, B, X) :- B \== 0, cmmdc2(A, B, Div), P is A * B,  X is P div Div.

% forward

pow(_, 0, Acc, X) :- X = Acc.
pow(A, B, Acc, X) :- B > 0, B_ is B - 1, Acc_ is Acc * A, pow(A, B_, Acc_, X).
pow(A, B, X) :- pow(A, B, 1, X).

fib2(0, 0).
fib2(1, 1).
fib2(N, R) :- 
  N > 1, 
  N1 is N - 1, N2 is N - 2, 
  fib2(N1, R1), fib2(N2, R2), 
  R is R1 + R2.

% fib(0, Acc, X) :- X = Acc. 
% fib(1, Acc, X) :- X = Acc.
% fib(N, Acc, X) :- N > 1, Acc_ is Acc + N, N_ is N - 1, fib(N_, Acc_, X).
% fib(N, X) :- fib(N, 1, X).

fib(0, _, _, X) :- X is 0.
fib(1, A, B, X) :- X is A + B.
fib(2, A, B, X) :- X is A + B.
fib(N, A, B, X) :- N > 2, N_ is N - 1, Acc is A + B, fib(N_, B, Acc, X).
fib(N, X) :- fib(N, 0, 1, X).

triangle(A, B, C) :- A + B > C, A + C > B, B + C > A.

% solving ax^2 + bx + c = 0
quadraticSolve(A, B, _, 0.0, X) :- Den is A * 2, X is -B / Den.
quadraticSolve(A, B, _, 0.0, X) :- Den is A * 2, X is  B / Den.
quadraticSolve(A, B, _, Delta, X) :- Delta > 0.0, Den is A * 2, Num is -B - Delta, X is Num / Den. 
quadraticSolve(A, B, _, Delta, X) :- Delta > 0.0, Den is A * 2, Num is -B + Delta, X is Num / Den.
quadraticSolve(A, B, C, X) :- sqrt(B * B - 4 * A * C, Delta), quadraticSolve(A, B, C, Delta, X).