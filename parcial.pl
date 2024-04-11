% Estructura segmento
segmento(punto(_, _), punto(_, _)).

% Regla para validar que dos segmentos esten conectados
conectados(segmento(punto(_, Y), punto(X1, Y)), segmento(punto(X2, Y), _)) :-
    X1 =:= X2.

% Regla para validar que un conjunto de segmentos formen un polígono cerrado
poligono_cerrado(Segmentos) :-
    last(Segmentos, UltimoSegmento),
    nth0(0, Segmentos, PrimerSegmento),
    conectados(UltimoSegmento, PrimerSegmento).

% Esta regla verifica si un conjunto de segmentos forma un polígono
poligono(Segmentos, Lados) :-
    length(Segmentos, Lados),
    poligono_cerrado(Segmentos).

% Regla que válida si un conjunto de segmentos forma un triángulo
triangulo(Segmentos) :-
    poligono(Segmentos, 3),
    % Verifica si alguno de los lados es horizontal o vertical
    member(segmento(punto(X1, Y1), punto(X2, Y2)), Segmentos),
    (   (X1 =:= X2, Y1 \= Y2) ; 
        (X1 \= X2, Y1 =:= Y2)).

% Regla que válida si un conjunto de segmentos forma un cuadrilátero
cuadrilatero(Segmentos) :-
    poligono(Segmentos, 4),
    % Verifica si alguno de los lados es horizontal o vertical
    member(segmento(punto(X1, Y1), punto(X2, Y2)), Segmentos),
    (   (X1 =:= X2, Y1 \= Y2) ; 
        (X1 \= X2, Y1 =:= Y2)).

% Regla que válida si un conjunto de segmentos forma un cuadrado
cuadrado(Segmentos) :-
    cuadrilatero(Segmentos),
    % Verifica que todos los lados tengan la misma longitud
    forall(
        member(segmento(punto(X,Y), punto(X1,Y)), Segmentos),
        (member(segmento(punto(X1,Y), punto(X1,Y1)), Segmentos),
         member(segmento(punto(X1,Y1), punto(X,Y1)), Segmentos),
         member(segmento(punto(X,Y1), punto(X,Y)), Segmentos),
         segmento_longitud(segmento(punto(X,Y), punto(X1,Y)), L),
         segmento_longitud(segmento(punto(X1,Y), punto(X1,Y1)), L),
         segmento_longitud(segmento(punto(X1,Y1), punto(X,Y1)), L),
         segmento_longitud(segmento(punto(X,Y1), punto(X,Y)), L))).

% Regla que calcula la longitud de un segmento
segmento_longitud(segmento(punto(X1, Y1), punto(X2, Y2)), Longitud) :-
    Longitud is sqrt((X2 - X1) ** 2 + (Y2 - Y1) ** 2).

% Regla que válida si un conjunto de segmentos forma un rectangulo
rectangulo(Segmentos) :-
    % Verifica que el conjunto de segmentos sea un cuadrilátero
    cuadrilatero(Segmentos),
    % Extrae los puntos de los segmentos
    member(segmento(punto(X,Y), punto(X1,Y)), Segmentos),
    member(segmento(punto(X1,Y), punto(X1,Y1)), Segmentos),
    member(segmento(punto(X1,Y1), punto(X,Y1)), Segmentos),
    member(segmento(punto(X,Y1), punto(X,Y)), Segmentos),
    % Verifica que los lados adyacentes sean horizontales o verticales
    (   % Lados adyacentes horizontales
        (X =:= X1, Y \= Y1, Y1 \= Y2) ; 
        % Lados adyacentes verticales
        (X \= X1, Y =:= Y1, X1 \= X2)),
    (   % Lados adyacentes horizontales
        (X1 =:= X2, Y1 \= Y2, Y \= Y1) ; 
        % Lados adyacentes verticales
        (X1 \= X2, Y1 =:= Y2, X \= X1)).

% Ejemplo de consulta para verificar si un conjunto de segmentos ordenados forma un cuadrado
ejemplo_cuadrado:- cuadrado(
                       [segmento(punto(1,1), punto(1,4)), 
                        segmento(punto(1,4), punto(4,4)), 
                        segmento(punto(4,4), punto(4,1)),
                        segmento(punto(4,1), punto(1,1))]).

% Ejemplo de consulta para verificar si un conjunto de segmentos ordenados forma un rectángulo
ejemplo_rectangulo:- rectangulo(
                       [segmento(punto(1,1), punto(1,4)), 
                        segmento(punto(1,4), punto(5,4)), 
                        segmento(punto(5,4), punto(5,1)),
                        segmento(punto(5,1), punto(1,1))]).

% Ejemplo de consulta para verificar si un conjunto de segmentos ordenados forma un triángulo
ejemplo_triangulo:- triangulo([
                              segmento(punto(1,1),punto(4,4)),
                              segmento(punto(4,4),punto(6,1)),
                              segmento(punto(6,1),punto(1,1))
                              ]).