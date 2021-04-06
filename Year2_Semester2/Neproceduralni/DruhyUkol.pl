% Nejprve si vytvořím pomocnou funkci na vybrání všech dvojic ze seznamu, kterou složím z jednodušší funkce choose_one
choose_one(List, A, Rest) :-
    append(Init, [A|Tail], List),
    append(Init, Tail, Rest).
 
choose_two(List, A, B, Rest) :-
    choose_one(List, A, RestA),
    choose_one(RestA, B, Rest).

% Base case je že eval vrátí přímo hodnotu přijatého čísla
eval(X, X) :- integer(X).

% Jinak se eval rekurzivně zavolá, sčítaje výsledky, které vzejdou z rekurze,
% všechny aritmetické operace jdou vyřešit stejně.
eval(plus(X,Y),Z) :- eval(X,Result1), eval(Y,Result2), Z is Result1 + Result2.
eval(krat(X,Y),Z) :- eval(X,Result1), eval(Y,Result2), Z is Result1 * Result2.
eval(deleno(X,Y),Z) :- eval(X,Result1), eval(Y,Result2), Z is Result1 / Result2, Result2 \= 0.
eval(minus(X,Y),Z) :- eval(X,Result1), eval(Y,Result2), Z is Result1 - Result2.

% Valid jen velmi  vypíše, jak můžeme A a B spojit do většího aritmetického termu
valid(A,B,plus(A,B)).
valid(A,B,krat(A,B)).
valid(A,B,deleno(A,B)).
valid(A,B,minus(A,B)).

% Base case - existuje jednoduché řešení výběrem dvou čísel
solve(A, N, Reseni) :- choose_two(A, X, Y, _), 
    valid(X,Y,Reseni),
    eval(Reseni,N).

% Solve musíme rozšířit i na složitější případy, kdy je potřeba vybrat více než dvě
% čísla:
solve(A, N, Reseni) :- choose_two(A, X, Y, Rest), 
    % Ve složenině je teď string plus(X,Y) nebo krat(X,Y) ... nějakých dvou čísel X a Y ze seznamu A
    valid(X,Y,Slozenina),
    % Složeninu přihodím mezi nepoužitá čísla, aby jí řešič mohl použít ke konstrukci dalšího výpočtu
    append([Slozenina], Rest, NovyRest),
    solve(NovyRest, N, Reseni).

% Toto řešení pravděpodobně není úplně nejefektivnější, lepší by mohlo být přidávat do meziseznamu NovyRest čísla,
% a mezivýsledky složenin probublávat nahoru odděleně, ale to se mi bohužel nepodařilo implementovat.

% Nepřesné řešení:
unprecise_solve(A, N, Reseni) :-
    solve(A, N, Reseni), !.

unprecise_solve(A, N, Reseni) :-
    length(_,Y),
    solve(A, N - Y, Reseni), !.
