%------ Base de conhecimento ----------------------
homem(americo).
homem( daniel ).
homem( paulo ).
homem( carlos ).
homem( joaquim ).
homem( filipe ).

mulher( teresa ).
mulher( sonia ).
mulher( ana ).
mulher( carla ).
mulher( barbara ).
mulher( maria ).

idade( americo , 18).
idade( daniel , 60).
idade( paulo , 25).
idade( carlos , 37).
idade( joaquim , 80).
idade( filipe , 32).
idade( teresa , 18).
idade( sonia , 28).
idade( ana , 17).
idade( carla , 26).
idade( barbara , 51).
idade( maria , 79).

irmaos( americo , paulo ).
irmaos( carlos , sonia ).

pai( carlos , teresa ).
pai( daniel , americo ).
pai( daniel , paulo ).
pai( joaquim , daniel ).
mae( maria , daniel ).
mae( barbara , ana ).

casados( filipe , carla ).
casados( americo , teresa ).
casados( joaquim , maria ).
%--------------------------------------------------------------------

avof(Mul, Pess) :- mulher(Mul), mae(Mul, Z), mulher(Z), mae(Z, Pess).
avof(Mul, Pess) :- mulher(Mul), mae(Mul, Z), homem(Z), pai(Z, Pess).

avom(Hom, Pess) :- homem(Hom), pai(Hom, Z), mulher(Z), mae(Z, Pess).
avom(Hom, Pess) :- homem(Hom), pai(Hom, Z), homem(Z), pai(Z, Pess).

bizavom(Hom, Pess) :- homem(Hom), avom(Hom, Z), homem(Z), pai(Z, Pess).
bizavom(Hom, Pess) :- homem(Hom), avom(Hom, Z), mulher(Z), mae(Z, Pess).

primo_1(P1, P2) :- pai(X, P1), pai(Y, P2), irmaos(X,Y).
primo_1(P1, P2) :- pai(X, P1), mae(Y, P2), irmaos(X,Y).
primo_1(P1, P2) :- mae(X, P1), mae(Y, P2), irmaos(X,Y).
primo_1(P1, P2) :- mae(X, P1), pai(Y, P2), irmaos(X,Y).

primo(P1, P2) :- primo_1(P1, P2).
primo(P1, P2) :- primo_1(pai(P1), pai(P2)).
primo(P1, P2) :- primo_1(pai(P1), mae(P2)).
primo(P1, P2) :- primo_1(mae(P1), pai(P2)).
primo(P1, P2) :- primo_1(mae(P1), mae(P2)).

maior_de_idade(Pess) :- idade(Pess, Idade), Idade > 17.

pessoas(Lista) :- findall(X, homem(X) ; mulher(X), Lista).

mais_velho(Pess) :- idade(Pess, Age), forall(idade(_, I), \+(I > Age)).

lista_pessoas(Lista, Sexo) :- Sexo = f, findall([X, I], (mulher(X), idade(X,I)), Lista).
lista_pessoas(Lista, Sexo) :- Sexo = m, findall([X, I], (homem(X), idade(X,I)), Lista).


adequados(Hom, Mul) :- 
    homem(Hom), 
    mulher(Mul), 
    forall(mulher(X), \+( casados(Hom, X) ; casados(X, Hom) )), % testa se Hom é casado com alguma mulher.
    forall(homem(X), \+( casados(Mul, X) ; casados(X, Mul) )), 	% testa se Mul é casada com algum homem.
    idade(Hom, Ih), 
    idade(Mul, Im), 
    (  
    	(   Im - Ih >= 0 ), ( Im - Ih < 2 ) ; %Se Mulher for mais velha que homem, então a diferença de idade deve ser de, no máximo, 2 anos.
    	(	Ih - Im >=0  ), ( Ih - Im < 10 )  %Se Homem for mais velho que mulher, então a diferença de idade deve ser de, no máximo, 10 anos.
    ),
    \+primo(Hom, Mul),
    \+avof(Mul, Hom),
    \+avom(Hom, Mul),
    \+pai(Hom, Mul),
    \+mae(Mul, Hom),
    \+irmaos(Hom, Mul),
	\+bizavom(Hom,Mul).
   
