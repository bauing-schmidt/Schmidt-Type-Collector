Extension { #name : 'String' }

{ #category : '*Schmidt Type Collector' }
String >> asSchmidtTypeCollectorTypeIn: aCollectorForMethod [ 

	^ SchmidtTypeCollectorSimpleType fromClass: self class
]
