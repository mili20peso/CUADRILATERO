"
Clase dados
"
Class {
	#name : #CuadrilaterosDice,
	#superclass : #Object,
	#instVars : [
		'random'
	],
	#category : #'Cuadrilateros-Juego'
}

{ #category : #accesing }
CuadrilaterosDice >> aplicarRerollsA: res with: modifiers [

   | resTemporal | "Declaramos una variable temporal"
    
    resTemporal := res. "Asignamos el valor del argumento a la variable temporal"

    "Si tiene <3 (Debe ser menor a 3). Mientras sea >= 3, tira de nuevo."
    (modifiers includesKey: '<3') ifTrue: [ 
        [ resTemporal >= 3 ] whileTrue: [ resTemporal := random nextInt: 6 ]
    ].

    "Si tiene >3 (Debe ser mayor a 3). Mientras sea <= 3, tira de nuevo."
    (modifiers includesKey: '>3') ifTrue: [ 
        [ resTemporal <= 3 ] whileTrue: [ resTemporal := random nextInt: 6 ] 
    ].
    
    ^ resTemporal 
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
    
    valX := self rollMod: modifiers.
    valY := self rollMod: modifiers.
    
    ^ valX @ valY  "Esto devuelve un objeto Point (ej: 3@5)"
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
	result:= self aplicarRerollsA: result with: modifiers .
    
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
