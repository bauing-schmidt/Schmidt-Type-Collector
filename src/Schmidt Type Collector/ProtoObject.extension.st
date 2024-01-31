Extension { #name : 'ProtoObject' }

{ #category : '*Schmidt Type Collector' }
ProtoObject >> _assigned [
]

{ #category : '*Schmidt Type Collector' }
ProtoObject >> asSchmidtTypeCollectorTypeIn: aCollectorForMethod [ 

	^ SchmidtTypeCollectorSimpleType fromClass: self class
]
