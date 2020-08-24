
edge(a, b).
edge(a, c).
edge(b, a).
edge(b, c).
edge(c, d).
edge(c, f).
edge(d, a).

% Given an edge defined by two vertices A and B, persist it
% in the database using a generate name to improve 
% lookup time.(predicates dictionary is stored as a map => O(1) search time
% for predicates with different names)
persistEdge(A, B, Edge) :-
  atom_concat(A, B, Name), 
  Edge =..[Name, true],
  assertz(Edge).

% clause returns True if Head can be unified with a clause 
% head and Body with the corresponding clause body.
% => pentru un edge valid xy(P) -> true
%    pentru un edge nepersistat xy(P) -> false

% term_string(Term, Str)
% pentru Str = 'a(P)' returnează în Term un predicat 
% de genul a(_1023)
checkIfEdgeIsPersisted(A, B) :-
  atom_concat(A, B, EdgeName), 
  atom_concat(EdgeName, '(P)', Name),
  term_string(Term, Name),
  clause(Term, _).

removePersistedEdge(A, B) :-
  atom_concat(A, B, Name), 
  Edge =..[Name, true],
  retract(Edge).

% for testing purposes call each predicate one by one

% persistEdge(a, c, Edge).          % Edge = ac(true).
% checkIfEdgeIsPersisted(a, c).     % true.
% removePersistedEdge(a, c).        % true.
% checkIfEdgeIsPersisted(a, c).     % false