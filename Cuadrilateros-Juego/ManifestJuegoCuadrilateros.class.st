"
Manifest juego Cuadrilatero
"
Class {
	#name : #ManifestJuegoCuadrilateros,
	#superclass : #PackageManifest,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'code-critics' }
ManifestJuegoCuadrilateros >> ruleRBBadMessageRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#TableroCuadrilateros #puedeColocarFigura:ancho:alto:jugador: #false)) #'2025-11-24T10:34:20.238443-03:00') #(#(#RGMethodDefinition #(#JuegoCuadrilateros #siguienteTurno #false)) #'2025-11-24T12:01:14.627443-03:00') )
]

{ #category : #'as yet unclassified' }
ManifestJuegoCuadrilateros >> ruleRBCascadedNextPutAllsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#JuegoCuadrilateros #siguienteTurno #false)) #'2025-11-24T12:01:01.171443-03:00') )
]

{ #category : #'as yet unclassified' }
ManifestJuegoCuadrilateros >> ruleRBConsistencyCheckRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#JuegoCuadrilateros #inicializarConClasesJugador:tamanioTablero: #false)) #'2025-11-28T19:36:21.446045-03:00') )
]

{ #category : #'as yet unclassified' }
ManifestJuegoCuadrilateros >> ruleRBInconsistentMethodClassificationRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#JugadorCuadrilaterosFragil #agregarArea: #false)) #'2025-11-27T15:22:43.616443-03:00') )
]

{ #category : #'code-critics' }
ManifestJuegoCuadrilateros >> ruleRBNoClassCommentRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#PotenciadorCuadrilateros)) #'2025-11-21T10:53:01.86801-03:00') )
]

{ #category : #'as yet unclassified' }
ManifestJuegoCuadrilateros >> ruleRBUnclassifiedMethodsRuleV1FalsePositive [
	"Mantener PowerUpOverwrite ya que no se ha traducido esta subclase y es una referencia histórica."
	^ #(#(#(#RGClassDefinition #(#PowerUpOverwrite)) #'2025-11-24T10:33:35.244443-03:00') )
]

{ #category : #'code-critics' }
ManifestJuegoCuadrilateros >> ruleRBUtilityMethodsRuleV1FalsePositive [
	"Mantener PowerUpOverwrite ya que no se ha traducido esta subclase y es una referencia histórica."
	^ #(#(#(#RGClassDefinition #(#PowerUpOverwrite)) #'2025-11-24T10:33:39.126443-03:00') )
]

{ #category : #'as yet unclassified' }
ManifestJuegoCuadrilateros >> ruleRBWhileTrueRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#TableroCuadrilateros #generarPotenciadorAleatorio #false)) #'2025-11-21T17:29:34.43801-03:00') #(#(#RGMethodDefinition #(#TableroCuadrilateros #colocarBloqueAleatorioPara: #false)) #'2025-11-21T17:34:55.01501-03:00') )
]
