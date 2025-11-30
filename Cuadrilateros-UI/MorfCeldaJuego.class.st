"
Esta clase representa un cuadradito en la pantalla. Sabe de qué color pintarse y qué ícono de PowerUp mostrar.
"
Class {
	#name : #MorfCeldaJuego,
	#superclass : #BorderedMorph,
	#instVars : [
		'fila',
		'columna'
	],
	#category : #'Cuadrilateros-UI'
}

{ #category : #'as yet unclassified' }
MorfCeldaJuego class >> colorParaIdentificadorJugador: unId [ 
    "Método de CLASE para mapear un ID de jugador a un Color."
    unId = 1 ifTrue: [ ^ Color red ].
    unId = 2 ifTrue: [ ^ Color blue ].
    unId = 3 ifTrue: [ ^ Color green ].
    unId = 4 ifTrue: [ ^ Color yellow ].
    ^ Color gray

]

{ #category : #'as yet unclassified' }
MorfCeldaJuego >> actualizarEstadoDesde: unValor [ 
    "Actualiza la visualización de la celda según el contenido del tablero"
    
    "--- CORRECCIÓN ---"
    self removeAllMorphs.
    "------------------"

    "1. Caso Vacío"
    unValor isNil ifTrue: [ 
        self color: Color white.
        ^ self 
    ].

    "2. Caso Jugador (Número)"
    unValor isNumber ifTrue: [ 
        self color: (self class colorParaIdentificadorJugador: unValor). "Llamada al método de CLASE"
        ^ self 
    ].

    "3. Caso Potenciador"
    (unValor isKindOf: Potenciador) ifFalse: [ ^ self ].
    "Dibujar Potenciador"
    self color: Color lightGray.
    self addMorph: (StringMorph new
                contents: (self iconoParaPotenciador: unValor);
                color: Color black;
                yourself).
    "Centrar el ícono recién agregado"
    self submorphs notEmpty ifTrue: [ 
        self submorphs first center: self center]

]

{ #category : #accessing }
MorfCeldaJuego >> columna [ 
    ^ columna


]

{ #category : #accessing }
MorfCeldaJuego >> fila [ 
    ^ fila

]

{ #category : #'as yet unclassified' }
MorfCeldaJuego >> fila: f columna: c [ 
    fila := f.
    columna := c.

]

{ #category : #'as yet unclassified' }
MorfCeldaJuego >> iconoParaPotenciador: unPotenciador [ 
    "Retorna un string/emoji segun la clase"
    (unPotenciador isKindOf: PotenciadorMasUno) ifTrue: [ ^ '+1' ].
    (unPotenciador isKindOf: PotenciadorMenosUno) ifTrue: [ ^ '-1' ].
    (unPotenciador isKindOf: PotenciadorTiradaBaja) ifTrue: [ ^ '<3' ].
    (unPotenciador isKindOf: PotenciadorTiradaAlta) ifTrue: [ ^ '>3' ].
    (unPotenciador isKindOf: PotenciadorBloqueAleatorio) ifTrue: [ ^ 'RB' ].
	 (unPotenciador isKindOf: PotenciadorVidaExtra) ifTrue: [ ^ 'V' ].
    ^ '?'
"* 
↕ ↖ ↗ ↘ ↙ ▶ ↓ ↔ ← → ↑ ⇐ ⇑ ⇒ ⇓ ◄ ►  ◀ ▲ ▼ 
∞ ∫ ≤ ≠ ‰ π ± √ ∑ ×"


]

