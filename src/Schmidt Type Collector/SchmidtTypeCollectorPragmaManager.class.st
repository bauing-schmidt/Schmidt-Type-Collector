Class {
	#name : 'SchmidtTypeCollectorPragmaManager',
	#superclass : 'Object',
	#instVars : [
		'method'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'instance creation' }
SchmidtTypeCollectorPragmaManager class >> for: aCompiledMethod [ 

	^ self new
		method: aCompiledMethod;
		yourself
]

{ #category : 'accessing' }
SchmidtTypeCollectorPragmaManager >> canRegenerate: aName [ 

	| pragmaName name argsCount |
	
	pragmaName := aName withoutSuffix: #generated:.

	(method hasPragmaNamed: pragmaName) 
		ifTrue: [ ^ false ].
	
	argsCount := pragmaName  count: [:e | e = $:].
	
	name := (pragmaName, #generated:) asSymbol.

	(method hasPragmaNamed: name) 
		ifFalse: [ ^ true ].

	^ ((method pragmaAt: name) arguments at: argsCount + 1) == true
]

{ #category : 'accessing' }
SchmidtTypeCollectorPragmaManager >> canRegenerate: aName argument: firstArgName [ 

	| pragmaName name argsCount matchingPragmaOrNil |
	
	pragmaName := aName withoutSuffix: #generated:.
	

	(method hasPragmaNamed: pragmaName) 
		ifTrue: [
			(method pragmas anySatisfy: [ :pragma | 
				(pragma selector = pragmaName 
				and: [ pragma arguments notEmpty ])
				and: [ pragma arguments first = firstArgName ]])
					ifTrue: [ ^ false ].
	].
	
	argsCount := pragmaName  count: [:e | e = $:].
	
	name := (pragmaName, #generated:) asSymbol.

	matchingPragmaOrNil := method pragmas 
		detect: [ :pragma | 
			(pragma selector = name 
			and: [ pragma arguments notEmpty ])
			and: [ pragma arguments first = firstArgName ] ] 
		ifNone: [ nil ].
		
	matchingPragmaOrNil ifNil: [ ^ true ].


	^ (matchingPragmaOrNil arguments at: argsCount + 1) == true
]

{ #category : 'accessing' }
SchmidtTypeCollectorPragmaManager >> hasPragmaNamed: pragmaName argument: firstArgName [

	^ (method ast pragmas 
		detect: [ :pragma | 
			(pragma selector = pragmaName 
			and: [ pragma arguments notEmpty ])
			and: [ pragma arguments first value = firstArgName ] ] 
		ifNone: [ nil ]) notNil
]

{ #category : 'accessing' }
SchmidtTypeCollectorPragmaManager >> method [

	^ method
]

{ #category : 'accessing' }
SchmidtTypeCollectorPragmaManager >> method: anObject [

	method := anObject.
	self refresh.
]

{ #category : 'accessing' }
SchmidtTypeCollectorPragmaManager >> privAddPragmaString: aString [ 

	| source start newSource |
	source := method sourceCode.
	start := method ast body start - 1.
	start = 0 "the method was empty"
		ifTrue: [ start := source size ].
	newSource := (source first: start), aString, '
	', (source allButFirst: start).
	newSource.
	method methodClass compile: newSource.
	self refresh.
]

{ #category : 'accessing' }
SchmidtTypeCollectorPragmaManager >> privPragmaReplace: pragmaName argument: firstArgName with: aString [

	| name argsCount matchingPragmaOrNil |

	(method hasPragmaNamed: pragmaName) 
		ifTrue: [
			(method pragmas anySatisfy: [ :pragma | 
				(pragma selector = pragmaName 
				and: [ pragma arguments notEmpty ])
				and: [ pragma arguments first = firstArgName ]])
					ifTrue: [ ^ false ].
	].
	
	argsCount := pragmaName  count: [:e | e = $:].
	
	name := (pragmaName, #generated:) asSymbol.

	matchingPragmaOrNil := method pragmas 
		detect: [ :pragma | 
			(pragma selector = name 
			and: [ pragma arguments notEmpty ])
			and: [ pragma arguments first = firstArgName ] ] 
		ifNone: [ nil ].
		
	matchingPragmaOrNil ifNil: [ ^ true ].


	^ (matchingPragmaOrNil arguments at: argsCount + 1) == true
]

{ #category : 'accessing' }
SchmidtTypeCollectorPragmaManager >> privReplacePragma: pragmaName argument: firstArgName with: aString [

	| matchingPragmaNodeOrNil source newSource start end |

	matchingPragmaNodeOrNil := method ast pragmas 
		detect: [ :pragma | 
			(pragma selector = pragmaName 
			and: [ pragma arguments notEmpty ])
			and: [ pragma arguments first value = firstArgName ] ] 
		ifNone: [ nil ].

	matchingPragmaNodeOrNil ifNil: [ ^ self ].
	
	source := method sourceCode.
	start := matchingPragmaNodeOrNil start.
	end := matchingPragmaNodeOrNil stop.
	
	newSource := source copyReplaceFrom: start to: end  with: aString.
	method methodClass compile: newSource.
	self refresh.	
	
	
]

{ #category : 'accessing' }
SchmidtTypeCollectorPragmaManager >> privReplacePragma: pragmaName with: aString [

	| matchingPragmaNodeOrNil source newSource start end |

	matchingPragmaNodeOrNil := method ast pragmas 
		detect: [ :pragma | 
			pragma selector = pragmaName ] 
		ifNone: [ nil ].

	matchingPragmaNodeOrNil ifNil: [ ^ self ].
	
	source := method sourceCode.
	start := matchingPragmaNodeOrNil start.
	end := matchingPragmaNodeOrNil stop.
	
	newSource := source copyReplaceFrom: start to: end  with: aString.
	method methodClass compile: newSource.
	self refresh.	
	
	
]

{ #category : 'accessing' }
SchmidtTypeCollectorPragmaManager >> refresh [ 

	method := method methodClass >> method selector.
]

{ #category : 'accessing' }
SchmidtTypeCollectorPragmaManager >> replacePragma: pragmaName argument: arg with: aString [ 

	(self canRegenerate: pragmaName argument: arg) 
		ifTrue: [ 
			(self hasPragmaNamed: pragmaName argument: arg)
				ifTrue: [ self privReplacePragma: pragmaName argument: arg with: aString ]
				ifFalse: [ self privAddPragmaString: aString ].
		]
]

{ #category : 'accessing' }
SchmidtTypeCollectorPragmaManager >> replacePragma: pragmaName with: aString [ 

	(self canRegenerate: pragmaName) 
		ifTrue: [ 
			(method hasPragmaNamed: pragmaName)
				ifTrue: [ self privReplacePragma: pragmaName with: aString ]
				ifFalse: [ self privAddPragmaString: aString ].
		]
]
