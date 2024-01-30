Extension { #name : 'ProtoObject' }

{ #category : '*Schmidt Type Collector' }
ProtoObject >> _assigned [
]

{ #category : '*Schmidt Type Collector' }
ProtoObject >> asPdmTypeCollectorType [ 

	^ SchmidtTypeCollectorSimpleType fromClass: self class
]
