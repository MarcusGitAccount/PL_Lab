
pushBackDiffList(X, LS, LE, RS, RE) :- RS = LS, LE = [X | RE].

% LS1 --- LE1
%         LS2 --- LE2
appendDiff(LS1, LE1, LS2, LE2, RS, RE) :-
  RS = LS1,
  LE1 = LS2,
  RE = LE2.

tree1(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,nil),nil))).
tree2(t(8, t(5, nil, t(7, nil, nil)), t(9, nil, t(11, nil, nil)))).

% RS
% LoS -- LoE
%        HiS -- HiE
%                RE
inorder(nil, L, L).
inorder(t(Key, Lo, Hi), RS, RE) :-
  inorder(Lo, RS, [Key | LoE]),
  inorder(Hi, LoE, RE).

delete1(H, [H|T], T).
delete1(H, [X|T], [X|R]):- delete1(H, T, R).

perm([],[]).
perm(L, [X|RI]):- perm_select(X, L, LX), perm(LX, RI).

perm_select(X, L, LX):- member(X, L), delete1(X, L, LX).

all_perm(L,_):- 
  perm(L,L1),
  assertz(p(L1)),
  fail.
all_perm(_,R):- collect_perms(R).

collect_perms([L1|R]):- retract(p(L1)), collect_perms(R).
collect_perms([]).

%. Întrebări laborator

% 1. Pentru a 'curăța' predicatele create de apelurile precedente.
% 2. Pentru a avea un răspuns unic pentru generarea permutărilor unei liste.
% 3. Recursivitate înapoi, deoarece rezultatul se construiește la revenire.
% 4. Da.

%. Exerciții laborator.

% 1.

incomplete2Diff(L, L, L) :- var(L), !.
incomplete2Diff([H | T], [H | RS_], RE_) :- incomplete2Diff(T, RS_, RE_).

diff2Incomplete(RS, RE, [RE]) :- var(RS), !.
diff2Incomplete([H | T], RE, [H | R_]) :- diff2Incomplete(T, RE, R_).

% 2.

complete2Diff([], RS, RE) :- RS = RE, !.
complete2Diff([H | T], [H | RS_], RE_) :- complete2Diff(T, RS_, RE_).

diff2complete(RS, _, []) :- var(RS), !.
diff2complete([H | T], RE, [H | R_]) :- diff2complete(T, RE, R_).

% 3. Generează toate descompunerile posibile a unei liste date în două subliste.

% Scoate element din prima listă și adaugă la finalul celei de a doua
allDecompositions(L, [First | R]) :- 
  First = [L, []],
  allDecompositions(L, LE, LE, R).
allDecompositions([], _, _, []).
allDecompositions([H | T], LS, LE, [[Left, T] | R_]) :-
  pushBackDiffList(H, LS, LE, RS, RE),
  diff2complete(RS, RE, Left),
  allDecompositions(T, RS, RE, R_).

% 4. Flatten a complete list and return it in a difference list.

flattenDiff([], RE, RE) :- !.
flattenDiff([H | T], [H | RS], RE) :- atomic(H), !, flattenDiff(T, RS, RE).
flattenDiff([H | T], RS, RE) :-
% RS ---- RE_
%         RE_ ---- RE
  flattenDiff(H, RS, RE_),
  flattenDiff(T, RE_, RE).

% 5.

collectEvenKeys(nil, L, L).
collectEvenKeys(t(Key, Lo, Hi), RS, RE) :-
  Check is Key mod 2,
  Check =:= 0,
  !,
  collectEvenKeys(Lo, RS, [Key | LoE]),
  collectEvenKeys(Hi, LoE, RE).
collectEvenKeys(t(_, Lo, Hi), RS, RE) :-
  collectEvenKeys(Lo, RS, LoE),
  collectEvenKeys(Hi, LoE, RE).

% 6.

collectKeysBetweenValues(nil, _, _, L, L).
collectKeysBetweenValues(t(Key, Lo, Hi), K1, K2, RS, RE) :-
  Key > K1,
  Key < K2,
  !,
  collectKeysBetweenValues(Lo, K1, K2, RS, [Key | LoE]),
  collectKeysBetweenValues(Hi, K1, K2, LoE, RE).
collectKeysBetweenValues(t(_, Lo, Hi), K1, K2, RS, RE) :-
  collectKeysBetweenValues(Lo, K1, K2, RS, LoE),
  collectKeysBetweenValues(Hi, K1, K2, LoE, RE).