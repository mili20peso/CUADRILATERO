"
Clase dados
"
Class {
	#name : #CuadrilaterosDice,
	#superclass : #Object,
	#instVars : [
		'random',
		'x',
		'y'
	],
	#category : #'Cuadrilateros-Juego'
}

{ #category : #initialization }
CuadrilaterosDice >> initialize [
    super initialize.
    "Creamos una única instancia de Random para no generar seeds todo el tiempo"
    random := Random new.
]

{ #category : #random }
CuadrilaterosDice >> roll [
    "Retorna un número para las columnas (X) de 1 a 6"
    x:= random nextInt: 6.
	 y:= random nextInt:6. 
]

{ #category : #random }
CuadrilaterosDice >> roll: modifiers [
    "Recibe el diccionario, calcula los nuevos valores y actualiza el estado interno"
    
    x := self rollMod: modifiers.
    y := self rollMod: modifiers.
]

{ #category : #random }
CuadrilaterosDice >> rollMod: modifiers [
	
    "Genera una tirada aplicando las reglas del diccionario de configuración.
     Claves esperadas: '+1', '-1', '<3', '>3'"
    
    | result |

	 (modifiers isNil or: [ modifiers isEmpty ]) ifTrue: [ ^ random nextInt: 6 ]. 
	"interrumpe si no hay modifiers"
    
    "BASE"
    result := random nextInt: 6.
    
    "REROLL"
    
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

{ #category : #accesing }
CuadrilaterosDice >> x [
	^x
]

{ #category : #accesing }
CuadrilaterosDice >> y [
	^y
]
