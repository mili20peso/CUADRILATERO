"
dadocuadrilatero
"
Class {
	#name : #DadoCuadrilateros,
	#superclass : #Object,
	#instVars : [
		'aleatorio'
	],
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
DadoCuadrilateros >> aplicarModificadores: modificadores numeroBase: tiradaBase [
    "Genera una tirada aplicando las reglas del diccionario de configuración."
    
    | resultado |
    resultado := tiradaBase.
    
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
DadoCuadrilateros >> generarValor: modificadores [
    | resultado |
    resultado := aleatorio nextInt: 6. "Genera la tirada del dado y consulta si existen modificadores"
    (modificadores isNil or: [ modificadores isEmpty ]) 
        ifTrue: [ ^ resultado ] 
        ifFalse: [ ^ self aplicarModificadores: modificadores numeroBase: resultado ].
]

{ #category : #'as yet unclassified' }
DadoCuadrilateros >> iniciar [
    super initialize.
    "Creamos una única instancia de Random para no generar seeds todo el tiempo"
    aleatorio := Random new.
]

{ #category : #'as yet unclassified' }
DadoCuadrilateros >> tirar: modificadores [
    "realiza las tiradas de x e y. Devuelve un dato de estructura de dos elementos ordenados"
    | valX valY |
    
    valX := self generarValor: modificadores.
    valY := self generarValor: modificadores.
    
    ^ valX @ valY  "Esto devuelve un objeto Point"
]
