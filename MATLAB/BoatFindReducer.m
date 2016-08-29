function BoatFindReducer(intermKeysIn, intermValsIter, outKVStore)

outVal={};

while hasnext(intermValsIter)

   outVal= [ outVal; getnext(intermValsIter)];
   
 
end 
  [TripName,~,~]= unique(outVal,'stable');

   add(outKVStore, intermKeysIn, TripName);

end 