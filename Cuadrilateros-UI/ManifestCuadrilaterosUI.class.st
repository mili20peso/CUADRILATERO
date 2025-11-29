Class {
	#name : #ManifestCuadrilaterosUI,
	#superclass : #PackageManifest,
	#category : #'Cuadrilateros-UI'
}

{ #category : #'code-critics' }
ManifestCuadrilaterosUI class >> ruleRBBadMessageRuleV1FalsePositive [
	^ #(#(#(#RGPackage #(#'Cuadrilateros-UI')) #'2025-11-24T12:32:40.954443-03:00') )
]

{ #category : #'code-critics' }
ManifestCuadrilaterosUI class >> ruleRBCascadedNextPutAllsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CuadrilaterosGameWindow #showPowerUpOverlayFor: #false)) #'2025-11-28T22:31:06.861685-03:00') )
]

{ #category : #'code-critics' }
ManifestCuadrilaterosUI class >> ruleRBGuardingClauseRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CuadrilaterosCellMorph #updateStateFrom: #false)) #'2025-11-24T12:31:13.699443-03:00') )
]

{ #category : #'code-critics' }
ManifestCuadrilaterosUI class >> ruleReDeadMethodV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CuadrilaterosGameWindow #handlesKeyboard #false)) #'2025-11-24T12:53:15.545443-03:00') )
]
