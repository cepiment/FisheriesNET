function TripMapperSpeed2(data, ~, intermKVStore)

%[idName,~,~]= unique(data.ID,'stable'); %read in ID's and index them uniquely

load 'PassData.mat';
%MinTrip=PassData.MinTrip;
%MaxTrip=PassData.MaxTrip;

trackChoices=PassData.trackChoices;
BoatName=PassData.boatNode;
%.trackChoices;
%display(trackChoices);
%[speed, ~, speedIndex] = unique(round(data.SPEED), 'stable');


% OLD CODE

%dayNumber = days((datetime(data.Year, data.Month, data.DayofMonth) - datetime(1987,10,1)))+1;
%daysSinceEpoch = days(datetime(2008,12,31) - datetime(1987,10,1))+1;


%for i = 1:size(idName)
for i = 1:numel(trackChoices)

    rows= (data.trip==trackChoices(i) & ismember(data.boat,BoatName));
    vars={'trip','date_time','speed','latitude','longitude','distance'};
    LatLong = data(rows,vars); 
    KeyName=sprintf('Trip %d',trackChoices(i));
    add(intermKVStore, KeyName, LatLong);
end
end