function TripFindMapper2(data, ~, intermKVStore)

[idName,~,~]= unique(data.trip,'stable');

    
    add(intermKVStore, 'Trips', idName);
end