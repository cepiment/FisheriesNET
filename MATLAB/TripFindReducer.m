function TripFindReducer(~, intermValsIter, outKVStore)

outVal=[];
%outVal={};
while hasnext(intermValsIter)

  outVal=[outVal; getnext(intermValsIter)];
  
 
end 
  [idName,~,~]= unique(outVal,'stable');

   add(outKVStore, 'Trips', idName);
end 