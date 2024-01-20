Extension { #name : 'SmallDictionary' }

{ #category : '*Schmidt Type Collector' }
SmallDictionary >> asPdmTypeCollectorType [ 

	^ SchmidtTypeCollectorDictionaryType fromDictionary: self
]
