function BoatFindMapper(data, ~, intermKVStore)

[idName,~,~]= unique(data.boat,'stable');
%save('idName.mat','idName')

for i = 1:numel(idName)
    
    rows=ismember(data.boat,idName(i));
    vars={'trip'};
    Boat_Trips = data(rows,vars); 
    [Unique_Trips,~,~]= unique(Boat_Trips,'stable');
    %save('Boat_Trips.mat','Boat_Trips')
 
    KeyName=char(idName(i));

    add(intermKVStore, KeyName, Unique_Trips);
end



  