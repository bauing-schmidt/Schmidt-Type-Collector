Extension { #name : 'Dictionary' }

{ #category : '*Schmidt Type Collector' }
Dictionary >> asSchmidtTypeCollectorTypeIn: aCollectorForMethod [ 

	^ SchmidtTypeCollectorDictionaryType fromDictionary: self
]
