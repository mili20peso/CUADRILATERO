"
Clase dado, se encarga de generar las dimensiones de la figura a colocar, ademas es afectada por los potenciadores de dado, que pueden adulterar los resultados de los valores que devuelve
"
Class {
	#name : #CuadrilaterosDice,
	#superclass : #Object,
	#instVars : [
		'random'
	],
	#category : #'Cuadrilateros-Juego'
}

{ #category : #random }
CuadrilaterosDice >> generator: modifiers [
	|result|
	result := random nextInt: 6. "Genera la tirada del dado y consulta si existen modificadores"
	 (modifiers isNil or: [ modifiers isEmpty ]) 
        ifTrue: [ ^ result ] 
        ifFalse: [ ^ self rollMod: modifiers num:result ]. 

]

{ #category : #initialization }
CuadrilaterosDice >> initialize [
    super initialize.
    "Creamos una única instancia de Random para no generar seeds todo el tiempo"
    random := Random new.
]

{ #category : #random }
CuadrilaterosDice >> roll: modifiers [
    "realiza las tiradas de x e y. Devuelve un dato de estructura de dos elementos ordenados"
    | valX valY |
    
    valX := self generator: modifiers.
    valY := self generator: modifiers.
    
    ^ valX @ valY  "Esto devuelve un objeto Point"
]

{ #category : #random }
CuadrilaterosDice >> rollMod: modifiers num: tirada [
	
    "Genera una tirada aplicando las reglas del diccionario de configuración."
    
    | result |

    result:= tirada.

    
    "Si tiene <3 (tirada menor a 3). Mientras sea >= 3, tira de nuevo."
    (modifiers includesKey: '<3') ifTrue: [ 
        [ result >= 3 ] whileTrue: [ result := random nextInt: 6 ]
    ].

    "Si tiene >3 (tirada mayor a 3). Mientras sea <= 3, tira de nuevo."
    (modifiers includesKey: '>3') ifTrue: [ 
        [ result <= 3 ] whileTrue: [ result := random nextInt: 6 ] 
    ].
    
    "Caso: +1"
    (modifiers includesKey: '+1') ifTrue: [ 
        result := result + 1 
    ].

    "Caso: -1"
    (modifiers includesKey: '-1') ifTrue: [ 
        result := result - 1.
    ].

    "Restriccion para no tener el valor 0"
    ^ result max: 1
]
