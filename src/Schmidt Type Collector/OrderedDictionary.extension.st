Extension { #name : 'OrderedDictionary' }

{ #category : '*Schmidt Type Collector' }
OrderedDictionary >> asPdmTypeCollectorType [ 

	^ SchmidtTypeCollectorDictionaryType fromDictionary: self
]
