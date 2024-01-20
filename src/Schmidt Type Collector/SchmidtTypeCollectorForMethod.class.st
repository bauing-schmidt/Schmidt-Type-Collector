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
		'sequenceNodes'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'instance creation' }
SchmidtTypeCollectorForMethod class >> forMethod: aCompiledMethod [
	^ self new
		method: aCompiledMethod
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> availableArgNames [

	^ targetMethod temporaryVariables select: [ :temp | temp isArgumentVariable ] thenCollect: [ :each | each name ]
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> availableTempNames [

	^ targetMethod temporaryVariables select: [ :temp | temp isTempVariable ] thenCollect: [ :each | each name ]
]

{ #category : 'metalink methods' }
SchmidtTypeCollectorForMethod >> blockArgInContext: aContext node: aNode [ 

	| index |
	index := (sequenceNodes indexOf: aNode).

	aNode parent argumentNames do: [ :argName | 
		| key | 
		key := ('_', index asString, '_', argName) asSymbol.
		(collectedBlockArgClasses at: key ifAbsentPut: [ Set new ])
				add: (aContext tempNamed: argName) asPdmTypeCollectorType.
	]


]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> collectedArgClasses [

	^ collectedArgClasses
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> collectedBlockArgClasses [

	^ collectedBlockArgClasses
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> collectedReturnClasses [ 

	^ collectedReturnClasses
]

{ #category : 'accessing' }
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

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> initialize [

	super initialize.
	collectedTempClasses := IdentityDictionary new.
	collectedArgClasses := IdentityDictionary new.
	collectedBlockArgClasses := IdentityDictionary new.
	collectedReturnClasses := Set new.
	
	tempLinks := OrderedCollection new.
	instVarLinks := OrderedCollection new.
	sequenceNodes := OrderedCollection new.
	
	mode := #variables.
]

{ #category : 'metalink methods' }
SchmidtTypeCollectorForMethod >> instVarWriteInContext: aContext node: aNode [ 

	| varName value |

	varName := aNode variable name asSymbol.
	value := aContext receiver instVarNamed: varName.

	collector 
		recordSlotWrite: varName 
		inClass: targetMethod methodClass 
		type: value asPdmTypeCollectorType.

]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> install [

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

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> installArgLink [

	argNames := self availableArgNames.
	
	argLink := self newArgLink.
	targetMethod ast link: argLink

]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> installBlockArgLinks [

	targetMethod ast allSequenceNodes allButFirst do: [ :seqNode |
		| link |
		sequenceNodes add: seqNode.
		link := self newBlockArgLink.
		seqNode link: link.
	].
]

{ #category : 'accessing' }
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

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> installLeaveLink [

	returnLink := self newLeaveLink.
	targetMethod ast link: returnLink

]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> installReturnLink [

	returnLink := self newLeaveLink.
	targetMethod ast link: returnLink

]

{ #category : 'accessing' }
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

	collectedReturnClasses add: aContext top asPdmTypeCollectorType.
	
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

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> newArgLink [
	"for now it should just halt in base level"

	^ MetaLink new
		  metaObject: self;
		  selector: #valueInContext:node:;
		  arguments: #(#context #node)
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> newBlockArgLink [
	"for now it should just halt in base level"

	^ MetaLink new
		  metaObject: self;
		  selector: #blockArgInContext:node:;
		  options: #(+ optionCompileOnLinkInstallation);
		  arguments: #(#context #node);
		  control: #before
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> newInstVarLink [

	^ MetaLink new
		  metaObject: self;
		  selector: #instVarWriteInContext:node:;
		  arguments: #(#context #node);
		  control: #after
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> newLeaveLink [
	"for now it should just halt in base level"

	^ MetaLink new
		  metaObject: self;
		  selector: #leaveInContext:node:;
		  arguments: #(#context #node);
		  control: #after		
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> newLink [
	"for now it should just halt in base level"

	^ MetaLink new
		  metaObject: self;
		  selector: #writeInContext:node:;
		  options: #(+ optionCompileOnLinkInstallation);
		  arguments: #(#context #node);
		  control: #after
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> newTempVarLink [

	^ MetaLink new
		  metaObject: self;
		  selector: #writeInContext:node:;
		  options: #(+ optionCompileOnLinkInstallation);
		  arguments: #(#context #node);
		  control: #after
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> remove [


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

	targetMethod recompile.
	
]

{ #category : 'accessing' }
SchmidtTypeCollectorForMethod >> tagExec: anObject [ 

	self halt.
]

{ #category : 'metalink methods' }
SchmidtTypeCollectorForMethod >> valueInContext: aContext node: aNode [ 

	argNames do: [ :argName |
		(collectedArgClasses at: argName ifAbsentPut: [ Set new ])
			add: (aContext tempNamed: argName) asPdmTypeCollectorType ] 
]

{ #category : 'metalink methods' }
SchmidtTypeCollectorForMethod >> writeInContext: aContext node: aNode [
	
	| varName |
	
	varName := aNode variable name asSymbol.

	(collectedTempClasses at: varName ifAbsentPut: [ Set new ])
		add: (aContext tempNamed: varName) asPdmTypeCollectorType.
	
]
