% Nejprve si vytvořím pomocnou funkci na vybrání všech dvojic ze seznamu, kterou složím z jednodušší funkce choose_one
choose_one(List, A, Rest) :-
    append(Init, [A|Tail], List),
    append(Init, Tail, Rest).
 
choose_two(List, A, B, Rest) :-
    choose_one(List, A, RestA),
    choose_one(RestA, B, Rest).

% Base case je že eval vrátí přímo hodnotu přijatého čísla (pokud tedy jde o číslo)
eval(X, X) :- integer(X).

% Jinak se eval rekurzivně zavolá, sčítaje výsledky, které vzejdou z rekurze,
% všechny aritmetické operace jdou vyřešit stejně.
eval(plus(X,Y),Z) :- eval(X,Result1), Result1\=0, eval(Y,Result2), Result2\=0, Z is Result1 + Result2.
eval(krat(X,Y),Z) :- eval(X,Result1), Result1\=1, eval(Y,Result2), Result2\=1, Z is Result1 * Result2.
eval(deleno(X,Y),Z) :- eval(X,Result1), eval(Y,Result2), Result2\=0, Z is Result1 / Result2.
eval(minus(X,Y),Z) :- eval(X,Result1), eval(Y,Result2), Result1>Result2,  Z is Result1 - Result2.

% Valid jen velmi  vypíše, jak můžeme A a B spojit do většího aritmetického termu
valid(A,B,plus(A,B)).
valid(A,B,krat(A,B)).
valid(A,B,deleno(A,B)).
valid(A,B,minus(A,B)).

% Base case - řešení je v hlavě seznamu

solve([Head|_], N, Head) :- eval(Head,N).
    
% Solve musíme rozšířit i na složitější případy, kdy je potřeba vybrat více než dvě
% čísla:
solve(A, N, Reseni) :- choose_two(A, X, Y, Rest), 
    % Ve složenině je teď string plus(X,Y) nebo krat(X,Y) ... nějakých dvou čísel X a Y ze seznamu A
    valid(X,Y,Slozenina),
    % Složeninu přihodím mezi nepoužitá čísla, aby jí řešič mohl použít ke konstrukci dalšího výpočtu
    solve([Slozenina|Rest], N, Reseni).

% Toto řešení pravděpodobně není úplně nejefektivnější, lepší by mohlo být přidávat do meziseznamu NovyRest čísla,
% a mezivýsledky složenin probublávat nahoru odděleně, ale to se mi bohužel nepodařilo implementovat.

% Nepřesné řešení:

unprecise_solve(A, N, Reseni) :- length(_, Len), Len =< 100, (NewN is N + Len; NewN is N - Len), NewN>0, solve(A,NewN,Reseni).

% Vlastní operátor "vojta" odečte dvojnásobek druhého vstupu od trojnásobku prvního vstupu, pokud je první vstup větší než 7
customOp(vojta, vojtaEval, vojtaValid).

vojtaEval(vojta(A, B), Result) :-
    eval(A, EA),
    eval(B, EB),
    Result is EA * 3 - EB * 2.

vojtaValid(A, B, vojta(A, B)) :-
    eval(A, EA),
    eval(B, _),
    EA > 7.

% Idea je vyhodit pro plus způsob, jak lze daný plusový výraz vyjádřit pomocí operátoru vojta

% Base case je že pro daný seznam již existuje přímo způsob jak z něj pomocí operátoru vojta dát dohromady NewResult
vojtaSolve(Seznam, NewResult, Slozenina) :-
    choose_two(Seznam, X, Y, _), 
    vojtaValid(X,Y,Slozenina),
    vojtaEval(Slozenina,NewResult).

% Jinak se vyberou dva prvky ze seznamu, A a B, udělá se z nich vojta(A,B) a to se opět přidá do seznamu mezi použitelné termy
vojtaSolve(Seznam, NewResult, Result) :-
    choose_two(Seznam, X, Y, _), 
    vojtaValid(X,Y,Slozenina),
    append([Slozenina], Seznam, NovyRest),
    vojtaSolve(NovyRest, NewResult, Result).

% New eval jen volá vojtaSolve na základě přijatého výrazu
new_eval(plus(A,B),Result) :-  
    NewResult is A + B, 
    vojtaSolve([A,B],NewResult,Result).

new_eval(krat(A,B),Result) :-  
    NewResult is A * B, 
    vojtaSolve([A,B],NewResult,Result).

new_eval(deleno(A,B),Result) :-  
    NewResult is A / B, 
    vojtaSolve([A,B],NewResult,Result).

new_eval(minus(A,B),Result) :-  
    NewResult is A - B, 
    vojtaSolve([A,B],NewResult,Result).
