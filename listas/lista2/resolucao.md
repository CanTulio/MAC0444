# Lista 2 - Sistemas Baseados em conhecimento

## Nome : Caio Túlio de Deus Andrade

### NUSP : 9797232

***



**3**)  Considere o seguinte programa em Prolog:

```
result ([_ , E | L], [E | M ]) :- !, result (L , M ).
result (_ , []).
```

a) Após ter carregado este programa, qual seria a resposta do Prolog para a seguinte consulta? 

```
?- result ([a , b , c , d , e , f , g], X ).
```

 	A resposta seria X=[b, d, f].

b) *Descreva brevemente o que o programa faz e como ele o faz quando o primeiro argumento do predicado result/2 é instanciado com uma lista e uma variável é passada no segundo argumento, assim como no item (a).*

*Suas explicações devem incluir respostas às seguintes perguntas:*
	• *Qual(is) caso(s) é(são) coberto(s) pelo fato?*
	• *Qual efeito tem o corte na primeira linha do programa?*
	• *Por que foi utilizada a variável anônima?*



​	O programa recebe um vetor como primeiro argumento e armazena, na segunda variável, o vetor processado sem os valores do vetor de índice ímpar (para efeitos práticos, estamos indexando o vetor começando em 1).



​	Usa-se o ! porque não queremos as soluções de subproblemas, apenas a resolução do problema original. Então o cut é utilizado para impedir o backtracking (no nosso caso, impede que o prolog rode result( [b, d, f]), X).



​	A variável anônima é utilizada para ignorar a cabeça da lista. Se usássemos uma variável, ela nunca seria utilizada e o prolog acusaria um erro ("untraced variable").



***

**4)** Escreva regras para os seguintes predicados : 

a) avof(Mul, Pess) em que Mul seja avó de Pess

```
avof(Mul, Pess) :- mulher(Mul), mae(Mul, Z), mulher(Z), mae(Z, Pess).
avof(Mul, Pess) :- mulher(Mul), mae(Mul, Z), homem(Z), pai(Z, Pess).
```



b) avom(Hom, Pess) em que Hom seja avô de Pess.

```
avom(Hom, Pess) :- homem(Hom), pai(Hom, Z), mulher(Z), mae(Z, Pess).
avom(Hom, Pess) :- homem(Hom), pai(Hom, Z), homem(Z), pai(Z, Pess).
```

c) bizavom(Hom, Pess) que é verdadeiro se Hom for bisavô de Pess

```
bizavom(Hom, Pess) :- homem(Hom), avom(Hom, Z), homem(Z), pai(Z, Pess).
bizavom(Hom, Pess) :- homem(Hom), avom(Hom, Z), mulher(Z), mae(Z, Pess).
```

d) primo_1(P1, P2) que é verdadeiro se P1 e P2 forem primos em primeiro grau.

```
primo_1(P1, P2) :- pai(X, P1), pai(Y, P2), irmaos(X,Y).
primo_1(P1, P2) :- pai(X, P1), mae(Y, P2), irmaos(X,Y).
primo_1(P1, P2) :- mae(X, P1), mae(Y, P2), irmaos(X,Y).
primo_1(P1, P2) :- mae(X, P1), pai(Y, P2), irmaos(X,Y).
```

e) primo(P1, P2) que é verdadeiro se P1 e P2 forem primos em qualquer grau.

```
primo(P1, P2) :- primo_1(P1, P2).
primo(P1, P2) :- primo_1(pai(P1), pai(P2)).
primo(P1, P2) :- primo_1(pai(P1), mae(P2)).
primo(P1, P2) :- primo_1(mae(P1), pai(P2)).
primo(P1, P2) :- primo_1(mae(P1), mae(P2)).
```

f) maior_de_idade(Pess) que é verdadeiro se Pess for maior de idade.

```
maior_de_idade(Pess) :- idade(Pess, Idade), Idade > 17.
```

g)  pessoas(Lista) que devolve a Lista de todas as pessoas existentes na base de conhecimento.

```
pessoas(Lista) :- findall(X, homem(X) ; mulher(X), Lista).
```

h) mais_velho(Pess) que retorna a pessoa mais velha que consta na base de conhecimento.



```
mais_velho(Pess) :- idade(Pess, Age), forall(idade(_, I), \+(I > Age)).
```

i) lista_pessoas(Lista, Sexo) que retorna uma Lista de todas as pessoas do Sexo indicado (m/f), incluindo as suas respectivas idades. Por exemplo, lista_pessoas(Lista, m) deveria retornar:

​		Lista =[[ americo ,18] , [ daniel ,60] , [ paulo ,25] , [ carlos ,37] , [ joaquim ,80] , [ filipe ,32]]

```
lista_pessoas(Lista, Sexo) :- Sexo = f, findall([X, I], (mulher(X), idade(X,I)), Lista).
lista_pessoas(Lista, Sexo) :- Sexo = m, findall([X, I] , (homem(X), idade(X,I)), Lista).
```

j)  adequados(Hom, Mul) que é verdadeiro se Hom for um homem, Mul for uma mulher e o homem for (no máximo) 2 anos mais novo do que a mulher ou 10 anos mais velho do que ela e se ambos não tiverem nenhuma relação de parentesco nem nenhum deles for casado.

```
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
   

```

