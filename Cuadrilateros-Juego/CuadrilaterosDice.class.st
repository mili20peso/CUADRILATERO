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
	result := random nextInt: 6.
	 (modifiers isNil or: [ modifiers isEmpty ]) 
        ifTrue: [ ^ result ] 
        ifFalse: [ ^ self rollMod: modifiers num:result ]. 
	"interrumpe si no hay modifiers"
]

{ #category : #initialization }
CuadrilaterosDice >> initialize [
    super initialize.
    "Creamos una única instancia de Random para no generar seeds todo el tiempo"
    random := Random new.
]

{ #category : #random }
CuadrilaterosDice >> roll: modifiers [
    "Calcula x e y, y devuelve un Punto (Point) listo para usar en el Tablero"
    | valX valY |
    
    valX := self generator: modifiers.
    valY := self generator: modifiers.
    
    ^ valX @ valY  "Esto devuelve un objeto Point (ej: 3@5)"
]

{ #category : #random }
CuadrilaterosDice >> rollMod: modifiers num: tirada [
	
    "Genera una tirada aplicando las reglas del diccionario de configuración.
     Claves esperadas: '+1', '-1', '<3', '>3'"
    
    | result |

    result:= tirada.

    
    "Si tiene <3 (Debe ser menor a 3). Mientras sea >= 3, tira de nuevo."
    (modifiers includesKey: '<3') ifTrue: [ 
        [ result >= 3 ] whileTrue: [ result := random nextInt: 6 ]
    ].

    "Si tiene >3 (Debe ser mayor a 3). Mientras sea <= 3, tira de nuevo."
    (modifiers includesKey: '>3') ifTrue: [ 
        [ result <= 3 ] whileTrue: [ result := random nextInt: 6 ] 
    ].
    
    "MODIFICADORES +-1"
    
    "Caso: +1"
    (modifiers includesKey: '+1') ifTrue: [ 
        result := result + 1 
    ].

    "Caso: -1 (Con restricción de mínimo 1)"
    (modifiers includesKey: '-1') ifTrue: [ 
        result := result - 1.
    ].

    "Aseguramos que el resultado nunca sea menor a 1 tras la resta"
    ^ result max: 1
]
