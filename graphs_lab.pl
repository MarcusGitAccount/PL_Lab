node(a). node(b). node(c).
node(d). node(e). node(f).
node(g). node(h).

edge(a, b, 1). edge(b, a, 3).
edge(a, d, 3). edge(d, a, 2).
edge(b, c, 1). edge(c, b, 1).
edge(b, d, 1). edge(d, b, 1).
edge(c, d, 1). edge(d, c, 1).
edge(e, g, 2). edge(g, e, 2).
edge(e, f, 1). edge(f, e, 1). 

path(X,Y,Path):-path(X,Y,[X],Path). 
path(Y,Y,PPath, PPath). % când ținta este egală cu
path(X,Y,PPath, FPath):-
  edge(X,Z,_), % căutăm o muchie
  not(member(Z, PPath)), % care nu a mai fost parcursă
  path(Z, Y, [Z|PPath], FPath). % și o adăugăm în rezultatul 


% Problem lab

% 1. From edge-clause to neighbor-list-clause

nodeToA2B2(X, neighbor(X, Edges)) :- findall(Y, edge(X, Y, _), Edges).

graphToA2B2(R) :-
  findall(X, node(X), Nodes),
  maplist(nodeToA2B2, Nodes, R).

% 2.

hamilton(NN, X, Cycle) :-
  cycle(X, Cycle),
  length(Cycle, Len),
  Len =:= NN.

% 3. weight based optimal path

is_edge(X, Y) :- edge(X, Y, _); edge(Y, X, _).

getWeight(X, Y, R) :- is_edge(X, Y), edge(X, Y, R).

optimal_path(X,Y,_):-
  asserta(sol_part([],100)),
  path_best(X,Y,[X],1).

optimal_path(_,_,Path) :- retract(sol_part(Path,_)).

path_best(X,X,Path,LPath):-
  retract(sol_part(_,_)),!,
  asserta(sol_part(Path,LPath)),
  fail.

path_best(X,Y,PPath,LPath):-
  is_edge(X, Z),
  \+(member(Z,PPath)),
  getWeight(X,Z,Weight),
  LPath1 is LPath+Weight,
  sol_part(_,Lopt),
  LPath1<Lopt,
  path_best(Z,Y,[Z|PPath],LPath1).

% 4.

% nodeToPathsToTarget(Node, R) :- target(X), findall(Path, path(Node, X, Path), R).

% cycle(X, R) :-
%   findall(Y, edge(X, Y, _), Edges),
%   asserta(target(X)),
%   maplist(nodeToPathsToTarget, Edges, R),
%   retractall(target(_)).

cycle(X,[X | R]):-
  edge(X, Z, _),
  path(Z, X, Cycle),
  length(Cycle, L),
  L >= 3,
  reverse(Cycle, R).

% 5.

% Fermier, Lup, Capră, Varză
eatsEachOther([s, n, n, _]).
eatsEachOther([n, s, s, _]).
eatsEachOther([s, _, n, n]).
eatsEachOther([n, _, s, s]).

opposite(n, s).
opposite(s, n).

equalLists([], []).
equalLists([H | T], [H | T_]) :- equalLists(T, T_).

moveAll([H | T], [H_ | T_]) :-
  % farmer switches position at each step
  opposite(H, H_),
  alternateMoves(T, H, T_).

alternateMoves(L, Farmer, R) :- alternateMoves(L, R, Farmer, _), not(equalLists(L, R)). % ensure a move was made.
alternateMoves([], [], _, true).
alternateMoves([H | T], [H_ | R], Farmer, false) :- Farmer == H, opposite(H, H_), alternateMoves(T, R, Farmer, true).
alternateMoves([H | T], [H  | R], Farmer, false) :- alternateMoves(T, R, Farmer, false).
alternateMoves([H | T], [H  | R], Farmer, true)  :- alternateMoves(T, R, Farmer, true).

memberOnLists(L, [H | _]) :- equalLists(L, H), !.
memberOnLists(L, [_ | T]) :- memberOnLists(L, T).

solve(S, E, Path) :- solve(S, E, [S], Path).
solve(S, E, Path, Path) :- equalLists(S, E), !.
solve(S, E, Curr, Path) :-
  moveAll(S, Intermediate),
  not(eatsEachOther(Intermediate)),
  not(memberOnLists(Intermediate, Curr)),
  solve(Intermediate, E, [Intermediate | Curr], Path).