Extension { #name : 'OrderedDictionary' }

{ #category : '*Schmidt Type Collector' }
OrderedDictionary >> asSchmidtTypeCollectorTypeIn: aCollectorForMethod [ 

	^ SchmidtTypeCollectorDictionaryType fromDictionary: self
]
