function txt= myupdatefcn(empt,event_obj,Speed)
pos=get(event_obj,'Position');
%Idx=get(event_obj,'DataIndex');

axHandle = get(event_obj.Target, 'Parent'); % Which axes is the data cursor on
axesInfo = get(axHandle, 'UserData'); % Get the axes info for that axes
%msgbox(axHandle);
%save('axesInfo.mat','axesInfo');
         try % If it is a date axes, create a date-friendly data tip
           % if strcmp(axesInfo.Type, 'dateaxes')
           if strcmp(axesInfo.gmap_params(1,2),'hybrid')==1
               
               txt = sprintf('Lat: %0.4g\nLon: %0.4g', pos(2), pos(1));
           else
               txt = sprintf('Time: %s\nSpeed: %0.4g', datestr(pos(1)), pos(2));
%            else
%                 txt = sprintf('X: %0.4g\nY: %0.4g', pos(1), pos(2));
           end       
         catch 
               txt = sprintf('Time: %s\nSpeed: %0.4g', datestr(pos(1)), pos(2));
         end
end
         