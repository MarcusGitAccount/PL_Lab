% 2nd lab problems

woman(ana).
woman(sara).
woman(ema).
woman(maria).
woman(carmen).
woman(dorina).
woman(irina).

man(sergiu).
man(marius).
man(mihai).
man(george).
man(alex).
man(andrei).

parent(marius, maria).
parent(dorina, maria).

parent(mihai, george).
parent(irina, george).

parent(mihai, carmen).
parent(irina, carmen).

parent(george, ana).
parent(maria, ana).

parent(george, andrei).
parent(maria, andrei).

parent(carmen, sara).
parent(alex, sara).

parent(carmen, ema).
parent(alex, ema).

mother(X, Y) :- woman(X), parent(X, Y).

father(X, Y) :- man(X), parent(X, Y).

sibling(X, Y) :- X \= Y, parent(Z, X), parent(Z, Y).
% sibling(X, Y) :- sibling(Y, X). 

sister(X, Y) :- sibling(X, Y), woman(Y).

brother(X, Y) :- sibling(X, Y), man(Y).

aunt(X, Y) :- parent(Z, Y), sister(Z, X).

uncle(X, Y) :- parent(Z, Y), brother(Z, X).

grandmother(X ,Y) :- mother(X, Z), parent(Z, Y).

grandfather(X ,Y) :- father(X, Z), parent(Z, Y).

ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- ancestor(Z, Y), parent(X, Z).
