function TripReducer(intermKeysIn, intermValsIter, outKVStore)

outVal={};

while hasnext(intermValsIter)

   outVal= [ outVal; getnext(intermValsIter)];
   
 
end 

   add(outKVStore, intermKeysIn, outVal);

end 