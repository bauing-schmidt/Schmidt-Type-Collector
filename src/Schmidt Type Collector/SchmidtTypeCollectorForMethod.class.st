"
Manages Type Collector Metalinks for a single class.
"
Class {
	#name : 'SchmidtTypeCollectorForMethod',
	#superclass : 'Object',
	#instVars : [
		'mode',
		'collector',
		'targetMethod',
		'tempLinks',
		'argLink',
		'argNames',
		'returnLink',
		'blockArgLinks',
		'instVarLinks',
		'collectedTempClasses',
		'collectedArgClasses',
		'collectedReturnClasses',
		'collectedBlockArgClasses',
		'sequenceNodes',
		'originalSource'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'instance creation' }
SchmidtTypeCollectorForMethod class >> forMethod: aCompiledMethod [
	^ self new
		method: aCompiledMethod
]

{ #category : 'utility' }
SchmidtTypeCollectorForMethod >> availableArgNames [

	^ targetMethod temporaryVariables select: [ :temp | temp isArgumentVariable ] thenCollect: [ :each | each name ]
]

{ #category : 'utility' }
SchmidtTypeCollectorForMethod >> availableTempNames [

	^ targetMethod temporaryVariables select: [ :temp | temp isTempVariable ] thenCollect: [ :each | each name ]
]

{ #category : 'metalink methods' }
SchmidtTypeCollectorForMethod >> blockArgInContext: aContext node: aNode [ 

	| index |
	index := (sequenceNodes indexOf: aNode).

	aNode parent argumentNames do: [ :argName | 
		| key value | 
		value := aContext tempNamed: argName.
		value _assigned.
		key := collector useBlockArgPrefix 
			ifTrue: [  ('_', index asString, '_', argName) asSymbol ]
			ifFalse: [ argName asSymbol ].
		(collectedBlockArgClasses at: key ifAbsentPut: [ Set new ])
				add: value asPdmTypeCollectorType.
	]


]

{ #category : 'collected values' }
SchmidtTypeCollectorForMethod >> collectedArgClasses [

	^ collectedArgClasses
]

{ #category : 'collected values' }
SchmidtTypeCollectorForMethod >> collectedBlockArgClasses [

	^ collectedBlockArgClasses
]

{ #category : 'collected values' }
SchmidtTypeCollectorForMethod >> collectedReturnClasses [ 

	^ collectedReturnClasses
]

{ #category : 'collected values' }
SchmidtTypeCollectorForMethod >> collectedTempClasses [

	^ collectedTempClasses
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> collector [

	^ collector
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> collector: anObject [

	collector := anObject
]

{ #category : 'API' }
SchmidtTypeCollectorForMethod >> collectorTypesFrom: aLiteral [

	aLiteral isArray ifFalse: [ 
		^ { SchmidtTypeCollectorSimpleType fromClass: (Smalltalk classNamed: aLiteral) } asSet 
	].

	(aLiteral size = 3 and: [ (aLiteral second = #of) ])
		ifTrue: [  ^ { SchmidtTypeCollectorCollectionType fromClass: (Smalltalk at: aLiteral first) itemClasses:  (self collectorTypesSimpleFrom: aLiteral third) }  asSet ].
		
	(aLiteral size = 5 and: [ (aLiteral second = #of) and: [aLiteral fourth = #keys] ])
		ifTrue: [ ^ { SchmidtTypeCollectorDictionaryType fromClass: (Smalltalk at: aLiteral first) itemClasses:  (self collectorTypesSimpleFrom: aLiteral third) keyClasses: (self collectorTypesSimpleFrom: aLiteral fifth) }  asSet ].

	^ aLiteral flatCollect: [ :each |
		self collectorTypesFrom: each.
	] as: Set

]

{ #category : 'API' }
SchmidtTypeCollectorForMethod >> collectorTypesSimpleFrom: aLiteral [

	aLiteral isArray ifFalse: [ 
		^ { Smalltalk at: aLiteral } asSet
	].

	^ aLiteral flatCollect: [ :each |
		self collectorTypesSimpleFrom: each.
	] as: Set.

]

{ #category : 'initialization' }
SchmidtTypeCollectorForMethod >> initialize [

	super initialize.
	collectedTempClasses := IdentityDictionary new.
	collectedArgClasses := IdentityDictionary new.
	collectedBlockArgClasses := IdentityDictionary new.
	collectedReturnClasses := Set new.
	
	tempLinks := OrderedCollection new.
	instVarLinks := OrderedCollection new.
	sequenceNodes := OrderedCollection new.
	blockArgLinks := OrderedCollection new.
	
	mode := #variables.
]

{ #category : 'metalink methods' }
SchmidtTypeCollectorForMethod >> instVarWriteInContext: aContext node: aNode [ 

	| varName value |

	varName := aNode variable name asSymbol.
	value := aContext receiver instVarNamed: varName.
	value _assigned.

	collector 
		recordSlotWrite: varName 
		inClass: targetMethod methodClass 
		type: value asPdmTypeCollectorType.

]

{ #category : 'API' }
SchmidtTypeCollectorForMethod >> install [

	Transcript show: 'Installing collector to '; show: targetMethod name; cr.
	World doOneCycle.
	
	originalSource := targetMethod sourceCode.

	collector merging ifTrue: [ 
		self readCurrentTypesFromPragmas ].
	
	mode = #variables 
		ifTrue: [ 
			self installTempLinks.
			self installArgLink.
			self installBlockArgLinks.
			self installInstVarLinks.
		].
	
	mode = #returnValues
		ifTrue: [ 		
			self installLeaveLink.
		]

]

{ #category : 'installing' }
SchmidtTypeCollectorForMethod >> installArgLink [

	argNames := self availableArgNames.
	
	argLink := self newArgLink.
	targetMethod ast link: argLink

]

{ #category : 'installing' }
SchmidtTypeCollectorForMethod >> installBlockArgLinks [

	targetMethod ast allSequenceNodes allButFirst do: [ :seqNode |
		| link |
		sequenceNodes add: seqNode.
		link := self newBlockArgLink.
		seqNode link: link.
	].
]

{ #category : 'installing' }
SchmidtTypeCollectorForMethod >> installInstVarLinks [

	targetMethod methodClass instanceVariables do: [ :var |
		| link varName |
		varName := var name.
		link := self newInstVarLink.
		targetMethod
			link: link
			toVariableNamed: varName
			option: #write.
		instVarLinks add: link
	].
	
]

{ #category : 'installing' }
SchmidtTypeCollectorForMethod >> installLeaveLink [

	returnLink := self newLeaveLink.
	targetMethod ast link: returnLink

]

{ #category : 'installing' }
SchmidtTypeCollectorForMethod >> installReturnLink [

	returnLink := self newLeaveLink.
	targetMethod ast link: returnLink

]

{ #category : 'installing' }
SchmidtTypeCollectorForMethod >> installTempLinks [

	| link |

	self availableTempNames do: [ :tempName |
		link := self newTempVarLink.
		targetMethod
			link: link
			toVariableNamed: tempName
			option: #write.
		tempLinks add: link
	].
		
			

]

{ #category : 'metalink methods' }
SchmidtTypeCollectorForMethod >> leaveInContext: aContext node: aNode [ 

	| value |
	value := aContext top.
	value _assigned.

	collectedReturnClasses add: value asPdmTypeCollectorType.
	
	"store types of all temporaries because collections may be changed in lifetime of the method"	

"	aContext method tempNames do: [ :tempName |
		(collectedTempClasses at: tempName ifAbsentPut: [ Set new ])
			add: (aContext tempNamed: tempName) asPdmTypeCollectorType.
	]
"	
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> method [ 

	^ targetMethod
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> method: anObject [
	targetMethod := anObject
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> mode [

	^ mode
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> mode: anObject [

	mode := anObject
]

{ #category : 'links' }
SchmidtTypeCollectorForMethod >> newArgLink [
	"for now it should just halt in base level"

	^ MetaLink new
		  metaObject: self;
		  selector: #valueInContext:node:;
		  arguments: #(#context #node)
]

{ #category : 'links' }
SchmidtTypeCollectorForMethod >> newBlockArgLink [
	"for now it should just halt in base level"

	^ MetaLink new
		  metaObject: self;
		  selector: #blockArgInContext:node:;
		  options: #(+ optionCompileOnLinkInstallation);
		  arguments: #(#context #node);
		  control: #before
]

{ #category : 'links' }
SchmidtTypeCollectorForMethod >> newInstVarLink [

	^ MetaLink new
		  metaObject: self;
		  selector: #instVarWriteInContext:node:;
		  arguments: #(#context #node);
		  control: #after
]

{ #category : 'links' }
SchmidtTypeCollectorForMethod >> newLeaveLink [
	"for now it should just halt in base level"

	^ MetaLink new
		  metaObject: self;
		  selector: #leaveInContext:node:;
		  arguments: #(#context #node);
		  control: #after		
]

{ #category : 'links' }
SchmidtTypeCollectorForMethod >> newLink [
	"for now it should just halt in base level"

	^ MetaLink new
		  metaObject: self;
		  selector: #writeInContext:node:;
		  options: #(+ optionCompileOnLinkInstallation);
		  arguments: #(#context #node);
		  control: #after
]

{ #category : 'links' }
SchmidtTypeCollectorForMethod >> newTempVarLink [

	^ MetaLink new
		  metaObject: self;
		  selector: #writeInContext:node:;
		  options: #(+ optionCompileOnLinkInstallation);
		  arguments: #(#context #node);
		  control: #after
]

{ #category : 'API' }
SchmidtTypeCollectorForMethod >> readCurrentTypesFromPragmas [

	targetMethod pragmas do: [ :pragma | 
		(#(arg:type: arg:type:generated:) includes: pragma selector) 
			ifTrue: [ 
				collectedArgClasses at: pragma arguments first asSymbol put: (self collectorTypesFrom: pragma arguments second)  ].
			
		(#(var:type: var:type:generated:) includes: pragma selector) 
			ifTrue: [ 
				collectedTempClasses at: pragma arguments first asSymbol put: (self collectorTypesFrom: pragma arguments second)  ].
			
		(#(blockArg:type: blockArg:type:generated:) includes: pragma selector) 
			ifTrue: [ 
				collectedBlockArgClasses at: pragma arguments first asSymbol put: (self collectorTypesFrom: pragma arguments second)  ].

		(#(returns: returns:generated:) includes: pragma selector) 
			ifTrue: [ 
				collectedReturnClasses addAll: (self collectorTypesFrom: pragma arguments first)  ].
			
	]
]

{ #category : 'API' }
SchmidtTypeCollectorForMethod >> remove [

	Transcript show: 'Removing collector from '; show: targetMethod name; cr.

	mode = #variables 
		ifTrue: [ 
			tempLinks, {argLink}, {returnLink}, blockArgLinks, instVarLinks do: [ :metalink | 
			metalink ifNotNil: [ 
				metalink uninstall ]
			].
		].
	
	mode = #returnValues
		ifTrue: [ 		
			{returnLink} do: [ :metalink | 
				metalink ifNotNil: [ 
					metalink uninstall ]
				].
		].

	targetMethod methodClass compile: originalSource.
	
]

{ #category : 'metalink methods' }
SchmidtTypeCollectorForMethod >> valueInContext: aContext node: aNode [ 

	argNames do: [ :argName |
		| value |
		value := aContext tempNamed: argName.
		argName _assigned.
		(collectedArgClasses at: argName ifAbsentPut: [ Set new ])
			add: value asPdmTypeCollectorType ] 
]

{ #category : 'metalink methods' }
SchmidtTypeCollectorForMethod >> writeInContext: aContext node: aNode [
	
	| varName value |
	
	varName := aNode variable name asSymbol.
	value := aContext tempNamed: varName.
	value _assigned.
	
	(collectedTempClasses at: varName ifAbsentPut: [ Set new ])
		add: value asPdmTypeCollectorType.
	
]
