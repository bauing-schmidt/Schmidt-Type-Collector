Extension { #name : 'String' }

{ #category : '*Schmidt Type Collector' }
String >> asPdmTypeCollectorType [ 

	^ SchmidtTypeCollectorSimpleType fromClass: self class
]
