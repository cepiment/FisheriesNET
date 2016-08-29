

data = readtable('Mexico.csv');
writetable(data,'test.csv')
clearvars data

land=landmask(data.latitude,data.longitude,'landmass','North and South America');
idx=find(land==0);
plot(data.latitude(idx),data.longitude(idx))

