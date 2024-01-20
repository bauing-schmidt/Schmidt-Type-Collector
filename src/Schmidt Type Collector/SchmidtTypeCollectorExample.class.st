Class {
	#name : 'SchmidtTypeCollectorExample',
	#superclass : 'Object',
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'examples' }
SchmidtTypeCollectorExample class >> example [

	<script>
	
	| method collector1 |
	method := (SchmidtTypeCollectorExample>>#methodWithTempsAndArg:arg2:).

	collector1 := (SchmidtTypeCollectorForMethod
		forMethod: method)
		install.
		
	self new methodWithTempsAndArg: 42 arg2: #aSymbol.
	self new methodWithTempsAndArg: 42 arg2: nil.

	collector1 remove.
	
"	result :=	 { collector1 } select: [: each | each collectedTempClasses notEmpty ] thenCollect: [ :each | 
		{ each method. each targetVariableName. each collectedClasses  } ].
"	
	{ 
		collector1 collectedTempClasses.
		collector1 collectedArgClasses.
		collector1 collectedReturnClasses
	} inspect.
]

{ #category : 'examples' }
SchmidtTypeCollectorExample class >> example2 [ 

	| methods collectors |
	methods := 'Documaps Items' asPackage methods select: [ :each | each methodClass isInstanceSide ].
[ 
	collectors := (methods flatCollect: [ :method |
		| temps | 
		temps := method temporaryVariables select: [ :temp | temp isTempVariable ].	
		temps collect: [ :temp | (SchmidtTypeCollectorForMethod 
			newForVariable: temp name
			forMethod: method)
				accessStrategy: #write;
				install.		
		]
	]).

	"-- open app here --"

	collectors do: [ :each | each remove ].

	collectors select: [: each | each collectedClasses notEmpty ] thenCollect: [ :each | 
		{ each method. each targetVariableName. each collectedClasses  } ]
]
]

{ #category : 'accessing' }
SchmidtTypeCollectorExample >> arg1: arg arg2: arg2 [

	<returns: #Object generated: true>
	<arg: #arg type: #Object generated: true>
	<var: #temp1 type: #Object generated: true>
	<var: #temp2 type: #Number generated: true>

	| temp1 temp2 |
	#start traceCr.
	temp1 := arg + 1.
	temp2 := (temp1 + 2) asString.
	temp2 yourself.
	#(1 2 nil someting) do: [ :each | each yourself ].
	#beforeEnd traceCr.
	^ temp1 -44
]

{ #category : 'accessing' }
SchmidtTypeCollectorExample >> arg: arg arg2: arg2 [

	<returns: #Num>
	<ivar: #arg1 type: #(Object) generated: true>

	<var: #temp1 type: #Object generated: true>
	<var: #temp2 type: #Number generated: false>

	| temp1 temp2 |
	#start traceCr.
	temp1 := arg + 1.
	temp2 := (temp1 + 2) asString.
	temp2 yourself.
	#(1 2 nil someting) do: [ :each | each yourself ].
	#beforeEnd traceCr.
	^ temp1 -44
]

{ #category : 'accessing' }
SchmidtTypeCollectorExample >> methodWithTempsAndArg: arg arg2: arg2 [
	| temp1 temp2 |
	#start traceCr.
	temp1 := arg + 1.
	temp2 := (temp1 + 2) asString.
	temp2 yourself.
	#(1 2 nil someting) do: [ :each | each yourself ].
	#beforeEnd traceCr.
	^ temp1 -44
]
