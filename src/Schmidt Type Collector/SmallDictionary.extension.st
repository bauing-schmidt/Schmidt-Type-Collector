Extension { #name : 'SmallDictionary' }

{ #category : '*Schmidt Type Collector' }
SmallDictionary >> asSchmidtTypeCollectorTypeIn: aCollectorForMethod [ 

	^ SchmidtTypeCollectorDictionaryType fromDictionary: self
]
