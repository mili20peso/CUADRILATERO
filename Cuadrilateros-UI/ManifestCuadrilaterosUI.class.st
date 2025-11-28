"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestCuadrilaterosUI,
	#superclass : #PackageManifest,
	#category : #'Cuadrilateros-UI-Manifest'
}

{ #category : #'code-critics' }
ManifestCuadrilaterosUI class >> ruleRBBadMessageRuleV1FalsePositive [
	^ #(#(#(#RGPackage #(#'Cuadrilateros-UI')) #'2025-11-24T12:32:40.954443-03:00') )
]

{ #category : #'code-critics' }
ManifestCuadrilaterosUI class >> ruleRBGuardingClauseRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CuadrilaterosCellMorph #updateStateFrom: #false)) #'2025-11-24T12:31:13.699443-03:00') )
]

{ #category : #'code-critics' }
ManifestCuadrilaterosUI class >> ruleReDeadMethodV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CuadrilaterosGameWindow #handlesKeyboard #false)) #'2025-11-24T12:53:15.545443-03:00') )
]
