Extension { #name : 'Metaclass' }

{ #category : '*Schmidt Type Collector' }
Metaclass >> isInClassHierarchyOf: aClass [

	^ (self includesBehavior: aClass) or: [
		  aClass includesBehavior: self ]
]
