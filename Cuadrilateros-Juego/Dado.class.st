"
Clase dado, se encarga de generar las dimensiones de la figura a colocar, ademas es afectada por los potenciadores de dado, que pueden adulterar los resultados de los valores que devuelve
"
Class {
	#name : #Dado,
	#superclass : #Object,
	#instVars : [
		'aleatorio'
	],
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
Dado >> generador: modificadores [ 
	|resultado|
	resultado := aleatorio nextInt: 6. "Genera la tirada del dado y consulta si existen modificadores"
	 (modificadores isNil or: [ modificadores isEmpty ]) 
        ifTrue: [ ^ resultado ] 
        ifFalse: [ ^ self tiradaConModificador: modificadores numero: resultado ]. 


]

{ #category : #initialization }
Dado >> initialize [ 
    super initialize.
    "Creamos una única instancia de Random para no generar seeds todo el tiempo"
    aleatorio := Random new.

]

{ #category : #'as yet unclassified' }
Dado >> tiradaConModificador: modificadores numero: tirada [ 
	
    "Genera una tirada aplicando las reglas del diccionario de configuración."
    
    | resultado |

    resultado:= tirada.

    
    "Si tiene <3 (tirada menor a 3). Mientras sea >= 3, tira de nuevo."
    (modificadores includesKey: '<3') ifTrue: [ 
        [ resultado >= 3 ] whileTrue: [ resultado := aleatorio nextInt: 6 ]
    ].

    "Si tiene >3 (tirada mayor a 3). Mientras sea <= 3, tira de nuevo."
    (modificadores includesKey: '>3') ifTrue: [ 
        [ resultado <= 3 ] whileTrue: [ resultado := aleatorio nextInt: 6 ] 
    ].
    
    "Caso: +1"
    (modificadores includesKey: '+1') ifTrue: [ 
        resultado := resultado + 1 
    ].

    "Caso: -1"
    (modificadores includesKey: '-1') ifTrue: [ 
        resultado := resultado - 1.
    ].

    "Restriccion para no tener el valor 0"
    ^ resultado max: 1

]

{ #category : #'as yet unclassified' }
Dado >> tirar: modificadores [ 
    "realiza las tiradas de x e y. Devuelve un dato de estructura de dos elementos ordenados"
    | valorX valorY |
    
    valorX := self generador: modificadores.
    valorY := self generador: modificadores.
    
    ^ valorX @ valorY  "Esto devuelve un objeto Point"

]

