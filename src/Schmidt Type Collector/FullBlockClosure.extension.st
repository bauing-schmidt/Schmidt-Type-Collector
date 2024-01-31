Extension { #name : 'FullBlockClosure' }

{ #category : '*Schmidt Type Collector' }
FullBlockClosure >> asSchmidtTypeCollectorTypeIn: aCollectorForMethod [ 

	| collectorType newClosure |
	
	collectorType := SchmidtTypeCollectorBlockType new.
	
	aCollectorForMethod compiledBlock: self compiledBlock ast type: collectorType.
	
	newClosure := ShiftClassInstaller basicNew
		oldClass: FullBlockClosure;
		copyObject: self to: CollectingFullBlockClosure.
		
	newClosure addCollectorType: collectorType.
		
	newClosure become: self.
	
	^ collectorType
	


]
