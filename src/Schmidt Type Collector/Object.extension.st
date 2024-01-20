Extension { #name : 'Object' }

{ #category : '*Schmidt Type Collector' }
Object >> asPdmTypeCollectorType [ 

	^ SchmidtTypeCollectorSimpleType fromClass: self class
]
