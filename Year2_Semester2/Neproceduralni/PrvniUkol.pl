% Zakódování informací z příběhu:
muz(ja).
muz(tata).
muz(mujSyn).
muz(tatuvSyn).

zena(rusovlaska).
zena(vdova).

potomek(ja,tata).
potomek(mujSyn,ja).
potomek(tatuvSyn,tata).
potomek(rusovlaska,vdova).

zenaty_s(ja,vdova).
zenaty_s(tata,rusovlaska).

% symetrické zobecnění ženatý s
partner(Kdo,Skym):- zenaty_s(Kdo,Skym);zenaty_s(Skym,Kdo).

otec(X, Y) :- muz(X), rodic(X, Y).
matka(X, Y) :- zena(X), rodic(X, Y).

vlastni_rodic(Rodic,Dite) :- potomek(Dite,Rodic).

rodic(Rodic,Dite):- vlastni_rodic(Rodic,Dite).
rodic(Rodic,Dite):- partner(Rodic,X), vlastni_rodic(X,Dite).

zet(Zet,Ci):- rodic(Ci,X),partner(Zet,X),muz(Zet).

dedecek(Deda,Vnuk):- muz(Deda),rodic(Deda,X),rodic(X,Vnuk).
babicka(Babicka,Vnuk):- zena(Babicka),rodic(Babicka,X),rodic(X,Vnuk).

% Pomocné pro definici strýce
sourozenec(Sourozenec1,Sourozenec2) :- rodic(X,Sourozenec1),rodic(X,Sourozenec2).
 
stryc(Stryc,Synovec):- muz(Stryc),bratr(Stryc,X),rodic(X,Synovec).

