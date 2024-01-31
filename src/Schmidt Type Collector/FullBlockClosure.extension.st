Extension { #name : 'FullBlockClosure' }

{ #category : '*Schmidt Type Collector' }
FullBlockClosure >> asPdmTypeCollectorType [ 

	| collectorType newClosure |
	
	collectorType := SchmidtTypeCollectorBlockType new.
	
	newClosure := ShiftClassInstaller basicNew
		oldClass: FullBlockClosure;
		copyObject: self to: CollectingFullBlockClosure.
		
	newClosure addCollectorType: collectorType.
		
	newClosure become: self.
	
	^ collectorType
	


]
