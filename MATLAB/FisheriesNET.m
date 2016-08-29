function varargout = FisheriesNET(varargin)
% FISHERIESNET MATLAB code for FisheriesNET.fig
%      FISHERIESNET, by itself, creates a new FISHERIESNET or raises the existing
%      singleton*.
%
%      H = FISHERIESNET returns the handle to a new FISHERIESNET or the handle to
%      the existing singleton*.
%
%      FISHERIESNET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FISHERIESNET.M with the given input arguments.
%
%      FISHERIESNET('Property','Value',...) creates a new FISHERIESNET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FisheriesNET_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FisheriesNET_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FisheriesNET

% Last Modified by GUIDE v2.5 18-Apr-2016 11:01:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FisheriesNET_OpeningFcn, ...
                   'gui_OutputFcn',  @FisheriesNET_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before FisheriesNET is made visible.
function FisheriesNET_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FisheriesNET (see VARARGIN)

% Choose default command line output for FisheriesNET
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FisheriesNET wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%-------------------------Start Parallels--------------------------
gcp;

%-------------------------Set Background--------------------------
set(gcf,'Color','w');

GuiFig=gcf;
handles.GuiFig=GuiFig;
dcm_obj=datacursormode(GuiFig);
set(dcm_obj,'UpdateFcn',@myupdatefcn);
%-------------------------Initialize GoogleMap--------------------------


set(handles.PLOT,'xtick',[]);
set(handles.PLOT,'ytick',[]);
set(handles.PLOT,'layer','top','FontWeight','bold');
box on
xlim([-120,-80]);ylim([10,35]);
handles.GooglePlot=plot_google_map();%'MapType');%,'satellite');

%------------------------Dynamic Panel----------------------

zoom reset

% %------------------------ListBox----------------------------
%%%handles.listbox=uicontrol('Parent',handles.uipanelTracks,'HandleVisibility','on','Style','listbox','String',{'none'},'Max',2,'Min',0,'Value',1,'Position',[15 18 335 200],'Units','normalized');%[15 18 234 150]
hPanel=handles.uipanelTracks;
[mtree, container] = uitree('v0', 'Root','Trackers', 'Parent',hPanel,'Position',[15 18 335 200]); % Parent is ignored
set(container, 'Parent', hPanel);  % fix the uitree Parent
handles.mtree=mtree;

%------------------------TabBars------------------------

tabgp=uitabgroup('Parent',handles.uipanel1);
handles.tab1=uitab('Parent',tabgp,'Title','Summary','BackgroundColor','w');
handles.tab2=uitab('Parent',tabgp,'Title','Speed/Distance','BackgroundColor','w');

%------------------------TabBar1------------------------
handles.ax1=axes('Parent',handles.tab1,'Units','normalized','Position',[0 0 1 1],'HandleVisibility','on');

image=imread('FisheriesNET_logo.jpg','jpg');
imshow(image,[]);
clear image

%------------------------TabBar2------------------------

handles.ax=axes('Parent',handles.tab2,'Units','normalized','Position',[.12 .1 .82 .75],'HandleVisibility','on');
imshow(imread('FisheriesNET_logo(Fish).jpg'))
set(handles.ax,'xtick',[]);
set(handles.ax,'ytick',[]);
set(handles.ax,'layer','top','FontWeight','bold');
% Update handles structure
guidata(hObject, handles)

handles.yaxisText=uicontrol('Parent',handles.tab2,'Style','text','String','Y-axis:','HorizontalAlignment','left','Position',[10 300 100 20],'Units','normalized','BackgroundColor','w');

% Update handles structure
guidata(hObject, handles);

handles.yaxisPopUp=uicontrol('Parent',handles.tab2,'Style','popup','String',{'Speed vs Time','Distance vs Time'},'Position',[80 305 170 20],'Units','normalized','callback',@(hObject,eventdata)FisheriesNET('popup_menu_Callback',hObject,eventdata,guidata(hObject)));

%-----------------Table Update-------------------------

set(handles.uitable,'ColumnWidth',{125 125 125 125 126},'Units','normalized');
jUIScrollPane=findjobj(handles.uitable);
jtable=jUIScrollPane.getViewport.getView;


jtable.setNonContiguousCellSelection(false);
jtable.setColumnSelectionAllowed(false);
jtable.setRowSelectionAllowed(true);
jtable = handle(jtable, 'CallbackProperties');

 %---------------------------Initialize--------------------------------
handles.Counter=0;
handles.ColorCount=0;
handles.SpeedCount=0;
handles.DontPlot=0;
handles.FileCount=0;
handles.SpeedCounter=0;

 
% Update handles structure
guidata(hObject, handles);

set(jtable, 'MousePressedCallback',{@MyCellSelectionCallback,GuiFig});

% Calls the function checkForReturn everytime a key is pressed in the responceBox
set(handles.SpeedRange,'KeyPressFcn',{@checkForReturn,GuiFig});
 
% Update handles structure
guidata(hObject, handles)


% --- Outputs from this function are returned to the command line.
function varargout = FisheriesNET_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function uiImportTrips_ClickedCallback(hObject, ~, handles)
% hObject    handle to uiImportTrips (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%------------------------User Defined File------------------------------
[filename, pathname]=uigetfile({'*.csv'},'File Selector','MultiSelect','on');

if isequal([filename, pathname],[0,0])
    return
else
   

% progressbar('Filtering Land Coordinates...');
% 
% %------Filtering---------
% data = readtable(filename);
% 
% lat_outliers=data.latitude>mean(data.latitude)+50;
% lon_outliers=data.longitude>mean(data.longitude)+50;
% 
% 
% if isempty(find(lat_outliers,1))==0
%     
% data=data(~lat_outliers,:);
% end
% 
% if isempty(find(lon_outliers,1))==0
%     
% data=data(~lon_outliers,:);
% end
% 
% 
% 
% 
% land=landmask(data.latitude,data.longitude,'landmass','North and South America');
% 
% progressbar(.6);
% 
% %writetable(data(~land,:),[name '_new.csv'])
% writetable(data(~land,:),filename)
% 
% clearvars data lon_outliers lat_outliers
% 
% progressbar(1);
% 
% 
% %------Filtering---------

progressbar('Importing Trips...');
%---------------------read file using datastore-------------------------
ds = datastore(filename);
%ds = datastore([name '_new.csv']);

        type BoatFindMapper

        type BoatFindReducer

ds.SelectedVariableNames={'boat','trip'};
result = mapreduce(ds, @BoatFindMapper, @BoatFindReducer);

filepth=result.Files{1,1};
%save('filepath.mat','filepth')
result = readall(result);
%[result.Key.Value,Idx]=sort_nat(result.Key.Value{i,1});
%result.Value=result.Value(Idx);


% Root node
root = uitreenode('v0', 'Trackers', 'Trackers', [], false);

for i=1:numel(result.Key)
    
%list=result.Value{i,1};
BoatName = uitreenode('v0', result.Key{i,1}, result.Key{i,1}, [], false);

for j=1:numel(result.Value{i,1})
TripName=sprintf('Trip%d',table2array(result.Value{i,1}(j,1)));
BoatName.add(uitreenode('v0', TripName,  TripName,  [], true));
end
root.add(BoatName);

end

clearvars ds result Idx

progressbar(.9)
pause(.5)
progressbar(1);

    % pop up a dialog
    msgbox('Trips Successfully Imported');
     
end 

  %set(handles.listbox,'String',list);
  
 hPanel=handles.uipanelTracks;
[mtree, container] = uitree('v0', 'Root',root, 'Parent',hPanel,'Position',[15 18 335 200]); % Parent is ignored
mtree.setMultipleSelectionEnabled(true)
set(container, 'Parent', hPanel);  % fix the uitree Parent

handles.mtree=mtree;

%------------deleting------------------
  
  handles.FileCount=1;

  clearvars  mtree container hPanel
  
  handles.filename=filename;

  [~, name, ~] = fileparts(filename);
  handles.name=name;
  
  clearvars filename name result 
  clearvars result 
  delete(filepth);
  delete('PassData.mat')
% Update handles structure
guidata(hObject,handles)



% --- Executes on button press in GetStats.
function GetStats_Callback(hObject, ~, handles)
% hObject    handle to GetStats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------Update Counters----------------------------
handles.FishCount=0;

if handles.Counter==1
    set(handles.Legend2,'visible','off');
    handles=rmfield(handles,'Legend2');
   
    if handles.ColorCount==1
    set(handles.ColorCoded,'Visible','off')
    handles=rmfield(handles,'ColorCoded');
    set(handles.PlotStore,'Visible','off')
    set(handles.PlotTab2,'Visible','off')
    handles=rmfield(handles,'PlotStore');
    handles=rmfield(handles,'PlotTab2');

    else
    set(handles.PlotStore,'Visible','off')
    set(handles.PlotTab2,'Visible','off')
    handles=rmfield(handles,'PlotStore');
    handles=rmfield(handles,'PlotTab2');
    end
else
end
%--------------------Initialize--------------
handles.FirstTime=0;
handles.ColorCount=0;
handles.SpeedCount=0;
handles.DontPlot=0;
handles.Counter2=0;

progressbar('Acquiring Statistics...');

%-----------------Check For Speed Range--------------------

SpeedRangeValue=get(handles.SpeedRange,'String');


%-----------------Get Track Choices--------------------
%trackChoices=get(handles.listbox,'Value');
mtree=handles.mtree;
selNodes = mtree.selectedNodes;
for i=1:numel(selNodes)
selNode = selNodes(i);
selNodeName = char ( selNode.getName() );

trackChoices(i)=cell2mat(textscan(selNodeName,'Trip%f'));
end

path=selNode.getPath;
boatNode = char(path( (length(path))-1 ).getName);

save('trackChoices.mat','trackChoices')

MinTrip=trackChoices(1);
MaxTrip=trackChoices(end);

NumTrips=numel(trackChoices);
handles.NumTrips=NumTrips;

%-----------------Set Mapping Colors--------------------
Color=hsv(NumTrips);

%---------------read file using datastore---------------
filename=handles.filename;

        ds = datastore(filename);
        
%------------------------Listbox Selection Count-----------------------------
if numel(trackChoices)>10
    
handles.DontPlot=1;
    if isempty(SpeedRangeValue) 
    
    PassData=struct('trackChoices',trackChoices,'boatNode',boatNode);
    save('PassData.mat','PassData');
    
    type TripMapper2

    type TripReducer

ds.SelectedVariableNames={'trip','date_time','speed','latitude','longitude','distance','boat'};
result = mapreduce(ds, @TripMapper2, @TripReducer);
filepth=result.Files{1,1};
result = readall(result);
[result.Key,Idx]=sort_nat(result.Key);
result.Value=result.Value(Idx);

handles.results=result;
clearvars ds filename PassData Idx
delete('PassData.mat');

    else
        
        handles.SpeedCount=1;    
    
Speed=get(handles.SpeedRange,'string');
Speed=textscan(Speed,'%f-%f');
PassData=struct('trackChoices',trackChoices,'MinSpeed',Speed{1},'MaxSpeed',Speed{2});
save('PassData.mat','PassData');

ds = datastore(filename);

type TripMapperSpeed2

type TripReducer

ds.SelectedVariableNames={'LATITUDE','LONGITUDE','ID','SPEED','TIME'};
result = mapreduce(ds, @TripMapperSpeed2, @TripReducer);
filepth=result.Files{1,1};
result = readall(result);
[result.Key,Idx]=sort_nat(result.Key);
result.Value=result.Value(Idx);

clearvars ds filename PassData Idx
delete('PassData.mat');

handles.results=result;
        
    end

progressbar(.8)
%-----------------Initialize Table Update Variables-------------------------
TotalDistance=zeros(1,NumTrips)';
TrackName=result.Key;

StartTime=[];
EndTime=[];
Duration=[];

for i=1:NumTrips
LATITUDE=table2array(result.Value{i,1}(:,4))';
LONGITUDE=table2array(result.Value{i,1}(:,5))';
Distances=pathdist(LATITUDE,LONGITUDE,'km');
TotalDistance(i,1)=Distances(end);

%-----------------------------Table Update----------------------------

StartTime=vertcat(StartTime,cellstr(datestr(result.Value{i,1}.date_time(1),0))); %'mm/dd/yy HH:MM:SS'
EndTime=vertcat(EndTime,result.Value{i,1}.date_time(end));
Difference=datenum(result.Value{i,1}.date_time(end))-datenum(result.Value{i,1}.date_time(1));
Duration=vertcat(Duration,cellstr(datestr(Difference,'HH:MM:SS')));

end
%-----------------------------Update Table----------------------------
Data=[TrackName, StartTime,EndTime, Duration, num2cell(TotalDistance),];
set(handles.uitable,'Data',Data)

handles.StartTime=StartTime;
handles.EndTime=EndTime;
handles.Duration=Duration;
handles.TotalDistance=TotalDistance;
handles.TripNums=trackChoices;
clearvars StartTime EndTime TotalDistance Duration Distances TrackName trackChoices PlotStore

%------------------------------------------------------------------------    
%----------------------------IfLessThan10Plots----------------------------    
%------------------------------------------------------------------------    
else
    
    if handles.Counter==0
    cla(handles.ax,'reset');
    handles.Counter=1;
    else
    end
        
if isempty(SpeedRangeValue) 

    PassData=struct('trackChoices',trackChoices,'boatNode',boatNode);
    save('PassData.mat','PassData');
    
        type TripMapper2

        type TripReducer

ds.SelectedVariableNames={'trip','date_time','speed','latitude','longitude','distance','boat'};
result = mapreduce(ds, @TripMapper2, @TripReducer);
filepth=result.Files{1,1};
result = readall(result);
[result.Key,Idx]=sort_nat(result.Key);
result.Value=result.Value(Idx);

handles.results=result;
clearvars ds filename PassData Idx

%-----------------Initialize Table Update Variables-------------------------
progressbar(.8)
TotalDistance=zeros(1,NumTrips)';
TrackName=result.Key;

StartTime=[];
EndTime=[];
Duration=[];


axes(handles.PLOT)
for i=1:NumTrips
LATITUDE=table2array(result.Value{i,1}(:,4))';
LONGITUDE=table2array(result.Value{i,1}(:,5))';

Distances=pathdist(LATITUDE,LONGITUDE,'km');
TotalDistance(i,1)=Distances(end);

%-----------------------------Table Update----------------------------

StartTime=vertcat(StartTime,result.Value{i,1}.date_time(1));
EndTime=vertcat(EndTime,result.Value{i,1}.date_time(end));
Difference=datenum(result.Value{i,1}.date_time(end))-datenum(result.Value{i,1}.date_time(1));
Duration=vertcat(Duration,cellstr(datestr(Difference,'HH:MM:SS')));

%---------------------------googlePlot----------------------------
PlotStore(i)=plot(LONGITUDE, LATITUDE,'Color',Color(i,:));
hold on

end
set(handles.PLOT,'xtick',[]);
set(handles.PLOT,'ytick',[]);
set(handles.PLOT,'XLim',[min(LONGITUDE)-.3, max(LONGITUDE)+.3],'YLim',[min(LATITUDE)-.3, max(LATITUDE)+.3] );
set(handles.PLOT,'layer','top','FontWeight','bold');
handles.GooglePlot=plot_google_map();%'MapType');%,'satellite');
handles.Legend1=legend(PlotStore,result.Key,'location','southeast');
id='MATLAB:handle_graphics:exceptions:SceneNode';
warning('off',id);
%-----------------------------Update Table----------------------------
Data=[TrackName, StartTime,EndTime, Duration , num2cell(TotalDistance)];
set(handles.uitable,'Data',Data)

handles.PlotStore=PlotStore;
handles.StartTime=StartTime;
handles.EndTime=EndTime;
handles.Duration=Duration;
handles.TotalDistance=TotalDistance;
handles.TripNums=trackChoices;
clearvars StartTime EndTime TotalDistance Duration Distances TrackName trackChoices PlotStore

%---------------------------------------------------------------------------%
%------------------------------UpdateTab2-----------------------------------%
%---------------------------------------------------------------------------%


%Speed vs Time
axes(handles.ax)
hold on
for i=1:NumTrips
    
%Speed=table2array(result.Value{i,1}(:,3))';
%TIME=table2array(result.Value{i,1}(:,2))';
Speed=(result.Value{i,1}.speed)';
TIME=(result.Value{i,1}.date_time)';
time=datenum(TIME)';
PlotTab2(i)=fill([time time(end) time(1)], [Speed 0 0],Color(i,:));
set(PlotTab2(i),'FaceAlpha',.5);

hold on

end
dateFormat=13;
datetick('x',dateFormat);

NumTicks=5;
L=get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),NumTicks));

zoom reset
xlabel('Time')
ylabel('Speed(km/hr)')
set(handles.ax,'layer','top','FontWeight','bold');
handles.Legend2=clickableLegend(PlotTab2,result.Key,'location','northeast');

hold off

handles.PlotTab2=PlotTab2;
clearvars PlotTab2 time TIME
%--------------------------------------------------------------------%
%----------------------SpeedRangeFilter------------------------------%
%--------------------------------------------------------------------%

else
    
handles.SpeedCount=1;    
    
Speed=get(handles.SpeedRange,'string');
Speed=textscan(Speed,'%f-%f');
%Save data to be passed on to TripMapper Function
PassData=struct('trackChoices',trackChoices,'MinSpeed',Speed{1},'MaxSpeed',Speed{2});
save('PassData.mat','PassData');

%read file using datastore
ds = datastore(filename);

type TripMapperSpeed2

type TripReducer

ds.SelectedVariableNames={'trip','date_time','speed','latitude','longitude','distance'};
result = mapreduce(ds, @TripMapperSpeed2, @TripReducer);
filepth=result.Files{1,1};
result = readall(result);
[result.Key,Idx]=sort_nat(result.Key);
result.Value=result.Value(Idx);

clearvars ds filename PassData Idx
delete('PassData.mat');

%-----------------Table Update-------------------------
TotalDistance=zeros(1,NumTrips)';
TrackName=result.Key;

StartTime=[];
EndTime=[];
Duration=[];

axes(handles.PLOT)
for i=1:NumTrips
LATITUDE=table2array(result.Value{i,1}(:,4))';
LONGITUDE=table2array(result.Value{i,1}(:,5))';
if length(LATITUDE)<=1
    Distances=0;
else
Distances=pathdist(LATITUDE,LONGITUDE,'km');
end
TotalDistance(i,1)=Distances(end);
StartTime=vertcat(StartTime,result.Value{i,1}.date_time(1));
EndTime=vertcat(EndTime,result.Value{i,1}.date_time(end));
Difference=datenum(result.Value{i,1}.date_time(end))-datenum(result.Value{i,1}.date_time(1));
Duration=vertcat(Duration,cellstr(datestr(Difference,'HH:MM:SS')));

%---------------------------googlePlot----------------------------
PlotStore(i)=plot(LONGITUDE, LATITUDE,'.','Color',Color(i,:));
hold on

end
set(handles.PLOT,'xtick',[]);
set(handles.PLOT,'ytick',[]);
set(handles.PLOT,'XLim',[min(LONGITUDE)-.3, max(LONGITUDE)+.3],'YLim',[min(LATITUDE)-.3, max(LATITUDE)+.3] );
set(handles.PLOT,'layer','top','FontWeight','bold');
handles.GooglePlot=plot_google_map();%'MapType');%,'satellite');
handles.Legend1=clickableLegend(PlotStore,result.Key,'location','southeast');

Data=[TrackName, StartTime,EndTime, Duration, num2cell(TotalDistance)];
set(handles.uitable,'Data',Data)

%---------------------------SaveHandles----------------------------%
handles.PlotStore=PlotStore;
handles.results=result;
handles.StartTime=StartTime;
handles.EndTime=EndTime;
handles.Duration=Duration;
handles.TotalDistance=TotalDistance;
handles.TripNums=trackChoices;
clearvars StartTime EndTime Duration Distances TrackName trackChoices PlotStore

%---------------------------------------------------------------------------%
%------------------------------UpdateTab2-----------------------------------%
%---------------------------------------------------------------------------%
axes(handles.ax);
hold on

%Speed vs Time
for i=1:NumTrips
    
Speed=table2array(result.Value{i,1}(:,3))';
TIME=table2array(result.Value{i,1}(:,2))';
time=datenum(TIME)';
PlotTab2(i)=plot(time,Speed,'.','Color',Color(i,:));

end
dateFormat=13;
datetick('x',dateFormat);

NumTicks=5;
L=get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),NumTicks));

zoom reset
xlabel('time')
ylabel('Speed(km/hr)')
set(handles.ax,'layer','top','FontWeight','bold');
handles.Legend2=clickableLegend(PlotTab2,result.Key,'Location','northeast');

handles.PlotTab2=PlotTab2;
clearvars PlotTab2

end
clearvars LATITUDE LONGITUDE 

end

clearvars result 
delete(filepth);

progressbar(.9)
pause(.5)
progressbar(1)

% Update handles structure
guidata(hObject,handles)


function MyCellSelectionCallback(hObject, ~, currFig)

%handles=guidata(ancestor(hObject,'figure'));
%guidata(hObject,handles)

handles=guidata(currFig);
if handles.SpeedCounter==1;
    set(handles.NEW_PlotStore,'Visible','off') 
    handles.SpeedCounter=0;
else

end


rows=hObject.getSelectedRows+1;
handles.Rows=rows;

switch handles.DontPlot
    
%----------------------------LessThan10Plots-----------------------
case 0

if length(rows)==1

    if handles.ColorCount==0
    handles.ColorCount=1;
    else
    set(handles.ColorCoded,'Visible','off')
    end
    
    if handles.Counter==0
        handles.Counter=1;
    else
        cla(handles.ax1,'reset');
        set(handles.ax1,'xtick',[]);
        set(handles.ax1,'ytick',[]);
    end
set(handles.PlotTab2,'Visible','off')
set(handles.PlotTab2(rows),'Visible','on')
set(handles.PlotStore,'Visible','off')
set(handles.Legend1,'visible','off')

LATITUDE=table2array(handles.results.Value{rows,1}(:,4))';
LONGITUDE=table2array(handles.results.Value{rows,1}(:,5))';

Speed=table2array(handles.results.Value{rows,1}(:,3))';
idx1=Speed<=5;
idx2=Speed<=10 & Speed>5; 
idx3=Speed<=15 & Speed>10;
idx4=Speed<=20 & Speed>15;
idx5=Speed<=25 & Speed>20;
idx6=Speed<=30 & Speed>25;
idx7=Speed>30;

c(idx1)=.1;c(idx2)=.2;c(idx3)=.3;c(idx4)=.4;c(idx5)=.5;c(idx6)=.6;c(idx7)=.7;

axes(handles.PLOT)
LATITUDE=table2array(handles.results.Value{rows,1}(:,4))';
LONGITUDE=table2array(handles.results.Value{rows,1}(:,5))';

if handles.SpeedCount==0
 
   ColorCoded= surface(...
  'XData',[LONGITUDE(:) LONGITUDE(:)],...
  'YData',[LATITUDE(:) LATITUDE(:)],...
  'ZData',zeros(length(LONGITUDE(:)),2),...
  'CData',[c(:) c(:)],...
  'FaceColor','none',...
  'EdgeColor','flat',...
  'Marker','.');
else 

   ColorCoded= surface(...
  'XData',[LONGITUDE(:) LONGITUDE(:)],...
  'YData',[LATITUDE(:) LATITUDE(:)],...
  'ZData',zeros(length(LONGITUDE(:)),2),...
  'CData',[c(:) c(:)],...
  'FaceColor','none',...
  'EdgeColor','flat',...
  'Marker','.');
end
hold on

set(handles.PLOT,'xtick',[]);
set(handles.PLOT,'ytick',[]);
set(handles.PLOT,'layer','top','FontWeight','bold');

%---------------Update Summary Tab--------------------
StartTime=handles.results.Value{rows,1}.date_time(1);
EndTime=handles.results.Value{rows,1}.date_time(end);
Difference=datenum(EndTime)-datenum(StartTime);
Duration=cellstr(datestr(Difference,'HH:MM:SS'));
MaxSpeed=max(table2array(handles.results.Value{rows,1}(:,3)));
MeanSpeed=mean(table2array(handles.results.Value{rows,1}(:,3)));

axes(handles.ax1)
cla(handles.ax1,'reset');
set(handles.ax1,'xtick',[]);
set(handles.ax1,'ytick',[]);

handles.MaxSpeed=uicontrol('Parent',handles.tab1,'Style','text','String','Max Speed:','Position',[10 180 100 20],'Units','normalized','BackgroundColor','w');
handles.MaxSpeedOut=uicontrol('Parent',handles.tab1,'Style','edit','String',MaxSpeed,'Position',[120 180 100 20],'Units','normalized','BackgroundColor','w');
handles.MeanSpeedText=uicontrol('Parent',handles.tab1,'Style','text','String','Mean Speed:','Position',[10 150 100 20],'Units','normalized','BackgroundColor','w');
handles.MeanSpeedOut=uicontrol('Parent',handles.tab1,'Style','edit','String',MeanSpeed,'Position',[120 150 100 20],'Units','normalized','BackgroundColor','w');
handles.StartTimeText=uicontrol('Parent',handles.tab1,'Style','text','String','Start Time:','Position',[10 120 100 20],'Units','normalized','BackgroundColor','w');
handles.StartTimeOut=uicontrol('Parent',handles.tab1,'Style','edit','String',StartTime,'Position',[120 120 100 20],'Units','normalized','BackgroundColor','w');
handles.EndTimeText=uicontrol('Parent',handles.tab1,'Style','text','String','End Time:','Position',[10 90 100 20],'Units','normalized','BackgroundColor','w');
handles.EndTimeOut=uicontrol('Parent',handles.tab1,'Style','edit','String',EndTime,'Position',[120 90 100 20],'Units','normalized','BackgroundColor','w');
handles.DurationText=uicontrol('Parent',handles.tab1,'Style','text','String','Duration:','Position',[10 60 100 20],'Units','normalized','BackgroundColor','w');
handles.DurationOut=uicontrol('Parent',handles.tab1,'Style','edit','String',Duration,'Position',[120 60 100 20],'Units','normalized','BackgroundColor','w');
handles.ColorCoded=ColorCoded;

clearvars Speed LATITUDE LONGITUDE idx1 idx2 idx3 idx4 idx5 idx6 idx7 ColorCoded StartTime EndTime Duration MaxSpeed MeanSpeed

%------------------------More Than One Row Selection----------------------
else 

if handles.ColorCount==1
set(handles.ColorCoded,'Visible','off')
else 
end

set(handles.Legend1,'visible','on')
set(handles.PlotStore,'Visible','off')
set(handles.PlotStore(rows),'Visible','on')
set(handles.PlotTab2,'Visible','off')
set(handles.PlotTab2(rows),'Visible','on')

end 

%------------------------MoreThan10Plots------------------------
    case 1

Color=hsv(length(rows));

cla(handles.ax,'reset');
    
%---------------------------OnlyOneSelectedRow-----------------------
     if length(rows)==1
         
         if handles.Counter==0
             handles.Counter=1;
             handles.Zoom=1;
         else
             handles.Zoom=0;
             cla(handles.ax1,'reset');
             set(handles.ax1,'xtick',[]);
             set(handles.ax1,'ytick',[]);
         end
         
         if handles.Counter2==1
            
             set(handles.PlotStore,'Visible','off')
              handles=rmfield(handles,'PlotStore');
              handles=rmfield(handles,'Legend2');
         else
             handles.Counter2=1;
         end

Speed=table2array(handles.results.Value{rows,1}(:,3))';
idx1=Speed<=5;
idx2=Speed<=10 & Speed>5; 
idx3=Speed<=15 & Speed>10;
idx4=Speed<=20 & Speed>15;
idx5=Speed<=25 & Speed>20;
idx6=Speed<=30 & Speed>25;
idx7=Speed>30;

c(idx1)=.1;c(idx2)=.2;c(idx3)=.3;c(idx4)=.4;c(idx5)=.5;c(idx6)=.6;c(idx7)=.7;

axes(handles.PLOT)
    
LATITUDE=table2array(handles.results.Value{rows,1}(:,4))';
LONGITUDE=table2array(handles.results.Value{rows,1}(:,5))';

if handles.SpeedCount==0

PlotStore= surface(...
  'XData',[LONGITUDE(:) LONGITUDE(:)],...
  'YData',[LATITUDE(:) LATITUDE(:)],...
  'ZData',zeros(length(LONGITUDE(:)),2),...
  'CData',[c(:) c(:)],...
  'FaceColor','none',...
  'EdgeColor','flat',...
  'Marker','.');
else 
    PlotStore= surface(...
  'XData',[LONGITUDE(:) LONGITUDE(:)],...
  'YData',[LATITUDE(:) LATITUDE(:)],...
  'ZData',zeros(length(LONGITUDE(:)),2),...
  'CData',[c(:) c(:)],...
  'FaceColor','none',...
  'EdgeColor','flat',...
  'Marker','.');
end
hold on

if handles.Zoom==1
set(handles.PLOT,'XLim',[min(LONGITUDE)-.3, max(LONGITUDE)+.3],'YLim',[min(LATITUDE)-.3, max(LATITUDE)+.3] );
else
end

set(handles.PLOT,'xtick',[]);
set(handles.PLOT,'ytick',[]);
set(handles.PLOT,'layer','top','FontWeight','bold');
handles.GooglePlot=plot_google_map();%'MapType');%,'satellite');

%---------------Update Summary Tab--------------------
StartTime=handles.results.Value{rows,1}.date_time(1);
EndTime=handles.results.Value{rows,1}.date_time(end);
Difference=datenum(EndTime)-datenum(StartTime);
Duration=cellstr(datestr(Difference,'HH:MM:SS'));
MaxSpeed=max(table2array(handles.results.Value{rows,1}(:,3)));
MeanSpeed=mean(table2array(handles.results.Value{rows,1}(:,3)));

axes(handles.ax1)
cla(handles.ax1,'reset');
set(handles.ax1,'xtick',[]);
set(handles.ax1,'ytick',[]);

handles.MaxSpeed=uicontrol('Parent',handles.tab1,'Style','text','String','Max Speed:','Position',[10 180 100 20],'Units','normalized','BackgroundColor','w');
handles.MaxSpeedOut=uicontrol('Parent',handles.tab1,'Style','edit','String',MaxSpeed,'Position',[120 180 100 20],'Units','normalized','BackgroundColor','w');
handles.MeanSpeedText=uicontrol('Parent',handles.tab1,'Style','text','String','Mean Speed:','Position',[10 150 100 20],'Units','normalized','BackgroundColor','w');
handles.MeanSpeedOut=uicontrol('Parent',handles.tab1,'Style','edit','String',MeanSpeed,'Position',[120 150 100 20],'Units','normalized','BackgroundColor','w');
handles.StartTimeText=uicontrol('Parent',handles.tab1,'Style','text','String','Start Time:','Position',[10 120 100 20],'Units','normalized','BackgroundColor','w');
handles.StartTimeOut=uicontrol('Parent',handles.tab1,'Style','edit','String',StartTime,'Position',[120 120 100 20],'Units','normalized','BackgroundColor','w');
handles.EndTimeText=uicontrol('Parent',handles.tab1,'Style','text','String','End Time:','Position',[10 90 100 20],'Units','normalized','BackgroundColor','w');
handles.EndTimeOut=uicontrol('Parent',handles.tab1,'Style','edit','String',EndTime,'Position',[120 90 100 20],'Units','normalized','BackgroundColor','w');
handles.DurationText=uicontrol('Parent',handles.tab1,'Style','text','String','Duration:','Position',[10 60 100 20],'Units','normalized','BackgroundColor','w');
handles.DurationOut=uicontrol('Parent',handles.tab1,'Style','edit','String',Duration,'Position',[120 60 100 20],'Units','normalized','BackgroundColor','w');
handles.PlotStore=PlotStore;

clearvars Speed LATITUDE LONGITUDE idx1 idx2 idx3 idx4 idx5 idx6 idx7 ColorCoded StartTime EndTime Duration MaxSpeed MeanSpeed

        %Speed vs Time
        axes(handles.ax)
        hold on       

        Speed=table2array(handles.results.Value{rows,1}(:,3))';
        TIME=table2array(handles.results.Value{rows,1}(:,2))';
        time=datenum(TIME)';
    
        if handles.SpeedCount==0
            
        PlotTab2=fill([time time(end) time(1)], [Speed 0 0],Color(1,:));
        
        else
        PlotTab2=plot(time,Speed,'.','Color',Color(1,:));
        end
dateFormat=13;
datetick('x',dateFormat);
zoom reset
xlabel('time')
ylabel('Speed(km/hr)')
set(handles.ax,'layer','top','FontWeight','bold');
handles.Legend2=clickableLegend(PlotTab2,handles.results.Key(min(rows):max(rows),:),'Location','northeast');
handles.PlotTab2=PlotTab2;
         
%--------------------------MoreThanOneRowSelected------------------------        
     else     
        
         if handles.Counter==0
             handles.Counter=1;
             handles.Zoom=1;

         else
             handles.Zoom=0;

         end
         if handles.Counter2==1
              set(handles.PlotStore,'Visible','off')
              handles=rmfield(handles,'PlotStore');
              handles=rmfield(handles,'Legend2');
         else
              handles.Counter2=1;
         end
    
        axes(handles.PLOT)
        hold on
        
        if handles.SpeedCount==0
        
        for i=1:numel(rows)
            
        LATITUDE=table2array(handles.results.Value{i,1}(:,4))';
        LONGITUDE=table2array(handles.results.Value{i,1}(:,5))'; 
        PlotStore(i)=plot(LONGITUDE, LATITUDE,'Color',Color(i,:));
        hold on
        
        end
handles.PlotStore=PlotStore;        
set(handles.PLOT,'xtick',[]);
set(handles.PLOT,'ytick',[]);

if handles.Zoom==1
set(handles.PLOT,'XLim',[min(LONGITUDE)-.3, max(LONGITUDE)+.3],'YLim',[min(LATITUDE)-.3, max(LATITUDE)+.3] );
else
end

set(handles.PLOT,'layer','top','FontWeight','bold');
handles.GooglePlot=plot_google_map();%'MapType','satellite');
handles.Legend1=clickableLegend(PlotStore,handles.results.Key(min(rows):max(rows),:),'location','southeast');

        %Speed vs Time
        axes(handles.ax)
        hold on       
        
        for i=1:numel(rows)
    
        Speed=table2array(handles.results.Value{i,1}(:,3))';
        TIME=table2array(handles.results.Value{i,1}(:,2))';
        time=datenum(TIME)';
        PlotTab2(i)=fill([time time(end) time(1)], [Speed 0 0],Color(i,:));
        %PlotTab2(i)=plot(time,Speed,'Color',Color(i,:));
        %set(PlotTab2(i),'FaceAlpha',.7);

        end
dateFormat=13;
datetick('x',dateFormat);%,'keeplimits');
zoom reset
xlabel('time')
ylabel('Speed(km/hr)')
set(handles.ax,'layer','top','FontWeight','bold');
handles.PlotTab2=PlotTab2;
handles.Legend2=clickableLegend(PlotTab2,handles.results.Key(min(rows):max(rows),:),'Location','northeast');


        else
            for i=1:numel(rows)
            
        LATITUDE=table2array(handles.results.Value{i,1}(:,4))';
        LONGITUDE=table2array(handles.results.Value{i,1}(:,5))'; 
        PlotStore(i)=plot(LONGITUDE, LATITUDE,'.','Color',Color(i,:));
        hold on
        
            end
handles.PlotStore=PlotStore;               
set(handles.PLOT,'xtick',[]);
set(handles.PLOT,'ytick',[]);

if handles.Zoom==1
set(handles.PLOT,'XLim',[min(LONGITUDE)-.3, max(LONGITUDE)+.3],'YLim',[min(LATITUDE)-.3, max(LATITUDE)+.3] );
else
end

set(handles.PLOT,'layer','top','FontWeight','bold');
handles.GooglePlot=plot_google_map();%'MapType','satellite');
handles.Legend1=clickableLegend(PlotStore,handles.results.Key(min(rows):max(rows),:),'location','southeast');

        %Speed vs Time
        axes(handles.ax)
        hold on       
        
        for i=1:numel(rows)
    
        Speed=table2array(handles.results.Value{i,1}(:,3))';
        TIME=table2array(handles.results.Value{i,1}(:,2))';
        time=datenum(TIME)';
        PlotTab2(i)=plot(time,Speed,'.','Color',Color(i,:));

        end
dateFormat=13;
datetick('x',dateFormat)%,'keeplimits');
zoom reset
xlabel('time')
ylabel('Speed(km/hr)')
set(handles.ax,'layer','top','FontWeight','bold');
handles.PlotTab2=PlotTab2;
handles.Legend2=clickableLegend(PlotTab2,handles.results.Key(min(rows):max(rows),:),'Location','northeast');
        
        end          
            
clearvars Speed TIME  time PlotTab2 LATITUDE LONGITUDE PlotStore

     end

end
handles.Rows=rows;
clearvars rows

%----------------------CallSpeedCursor----------------------------%
if length(handles.Rows)==1
dcm_obj=datacursormode(handles.GuiFig);
set(dcm_obj,'UpdateFcn',{@myupdatefcnSpeed,table2array(handles.results.Value{handles.Rows,1}(:,3))'});
else
dcm_obj=datacursormode(handles.GuiFig);
set(dcm_obj,'UpdateFcn',@myupdatefcn);
end

% Update handles structure
guidata(currFig,handles);

% --- Executes on selection change in yaxisPopUp.
function popup_menu_Callback(hObject, ~, handles)
% hObject    handle to yaxisPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns yaxisPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from yaxisPopUp
% 
contents = cellstr(get(hObject,'String'));

popChoice=contents{get(hObject,'Value')};

NumTrips=handles.NumTrips;

Color=hsv(NumTrips);

cla(handles.ax,'reset');

%-----------------Check For Speed Range--------------------

SpeedRangeValue=get(handles.SpeedRange,'String');

%-------------------------No Speed Range-------------------
if isempty(SpeedRangeValue) 
axes(handles.ax)
hold on

switch popChoice

    case 'Distance vs Time'
        
        if handles.DontPlot==1
            
            Color=hsv(length(handles.Rows));
            

            for i=1:numel(handles.Rows)
    
LATITUDE=table2array(handles.results.Value{i,1}(:,4))';
LONGITUDE=table2array(handles.results.Value{i,1}(:,5))';
TIME=table2array(handles.results.Value{i,1}(:,2))';
time=datenum(TIME)';
metersTraveled=pathdist(LATITUDE,LONGITUDE,'km');
PlotTab2(i)=plot(time,metersTraveled,'Color',Color(i,:));

hold on

            end

dateFormat=13;
datetick('x',dateFormat);
NumTicks=5;
L=get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),NumTicks));

zoom reset

xlabel('time')
ylabel('Meters Traveled')
set(handles.ax,'layer','top','FontWeight','bold');
handles.Legend2=clickableLegend(PlotTab2,handles.results.Key(min(handles.Rows):max(handles.Rows),:),'Location','NorthEast');

handles.PlotTab2=PlotTab2;
            

        else
            
          Color=hsv(NumTrips);
          
for i=1:NumTrips
    
LATITUDE=table2array(handles.results.Value{i,1}(:,4))';
LONGITUDE=table2array(handles.results.Value{i,1}(:,5))';
TIME=table2array(handles.results.Value{i,1}(:,2))';
time=datenum(TIME)';
metersTraveled=pathdist(LATITUDE,LONGITUDE,'km');
PlotTab2(i)=plot(time,metersTraveled,'Color',Color(i,:));

hold on

end

dateFormat=13;
datetick('x',dateFormat);
NumTicks=5;
L=get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),NumTicks));

zoom reset

xlabel('time')
ylabel('Meters Traveled')
set(handles.ax,'layer','top','FontWeight','bold');
handles.Legend2=clickableLegend(PlotTab2,handles.results.Key,'Location','NorthEast');

handles.PlotTab2=PlotTab2;
        end

    case 'Speed vs Time'
 

        if handles.DontPlot==1
            
            Color=hsv(length(handles.Rows));

            for i=1:numel(handles.Rows)
            Speed=table2array(handles.results.Value{i,1}(:,3))';
            TIME=table2array(handles.results.Value{i,1}(:,2))';
            time=datenum(TIME)';
            PlotTab2(i)=fill([time time(end) time(1)], [Speed 0 0],Color(i,:));
            set(PlotTab2(i),'FaceAlpha',.5);
            hold on

            end
dateFormat=13;
datetick('x',dateFormat);
NumTicks=5;
L=get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),NumTicks));
    
    zoom reset

xlabel('time')
ylabel('Speed(km/hr)')
set(handles.ax,'layer','top','FontWeight','bold');
handles.Legend2=clickableLegend(PlotTab2,handles.results.Key(min(handles.Rows):max(handles.Rows),:),'Location','NorthEast');
handles.PlotTab2=PlotTab2;
hold off
clearvars PlotTab2

        else
            
            Color=hsv(NumTrips);

for i=1:NumTrips
    
Speed=table2array(handles.results.Value{i,1}(:,3))';
TIME=table2array(handles.results.Value{i,1}(:,2))';
time=datenum(TIME)';
PlotTab2(i)=fill([time time(end) time(1)], [Speed 0 0],Color(i,:));
set(PlotTab2(i),'FaceAlpha',.5);
hold on

end
dateFormat=13;
datetick('x',dateFormat);
NumTicks=5;
L=get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),NumTicks));
zoom reset

xlabel('time')
ylabel('Speed(km/hr)')
set(handles.ax,'layer','top','FontWeight','bold');
handles.Legend2=clickableLegend(PlotTab2,handles.results.Key,'Location','NorthEast');
handles.PlotTab2=PlotTab2;

        end
hold off
clearvars PlotTab2

end

%------------------------------SpeedRangeInput----------------------------%
else
            axes(handles.ax)
        hold on  

    switch popChoice
        
    case 'Distance vs Time'
        
        if handles.DontPlot==1
            
            Color=hsv(length(handles.Rows));
            
            for i=1:numel(handles.Rows)
    
LATITUDE=table2array(handles.results.Value{i,1}(:,4))';
LONGITUDE=table2array(handles.results.Value{i,1}(:,5))';
TIME=table2array(handles.results.Value{i,1}(:,2))';
time=datenum(TIME)';
metersTraveled=pathdist(LATITUDE,LONGITUDE,'km');
PlotTab2(i)=plot(time,metersTraveled,'Color',Color(i,:));

hold on

            end
dateFormat=13;
datetick('x',dateFormat);
NumTicks=5;
L=get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),NumTicks));

zoom reset

xlabel('time')
ylabel('Meters Traveled')
set(handles.ax,'layer','top','FontWeight','bold');
handles.Legend2=clickableLegend(PlotTab2,handles.results.Key(min(handles.Rows):max(handles.Rows),:),'Location','NorthEast');

handles.PlotTab2=PlotTab2;
            
        else
            
            Color=hsv(NumTrips);          
       
for i=1:NumTrips
    
LATITUDE=table2array(handles.results.Value{i,1}(:,4))';
LONGITUDE=table2array(handles.results.Value{i,1}(:,5))';
TIME=table2array(handles.results.Value{i,1}(:,2))';
time=datenum(TIME)';
if length(LATITUDE)==1
metersTraveled=0;
else
metersTraveled=pathdist(LATITUDE,LONGITUDE,'km');
end
PlotTab2(i)=plot(time,metersTraveled,'Color',Color(i,:));
hold on

end
dateFormat=13;
datetick('x',dateFormat);
NumTicks=5;
L=get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),NumTicks));
zoom reset

xlabel('time')
ylabel('Meters Traveled')
set(handles.ax,'layer','top','FontWeight','bold');
handles.Legend2=clickableLegend(PlotTab2,handles.results.Key,'Location','NorthEast');
handles.PlotTab2=PlotTab2;
        end

    case 'Speed vs Time'
        
       
    if handles.DontPlot==1
        
            Color=hsv(length(handles.Rows));
            

            for i=1:numel(handles.Rows)
            Speed=table2array(handles.results.Value{i,1}(:,3))';
            TIME=table2array(handles.results.Value{i,1}(:,2))';
            time=datenum(TIME)';
            PlotTab2(i)=plot(time,Speed,'.','Color',Color(i,:));
            hold on
            
            end
             
dateFormat=13;
datetick('x',dateFormat);
NumTicks=5;
L=get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),NumTicks));
zoom reset

xlabel('time')
ylabel('Speed(km/hr)')
set(handles.ax,'layer','top','FontWeight','bold');
handles.Legend2=clickableLegend(PlotTab2,handles.results.Key(min(handles.Rows):max(handles.Rows),:),'Location','NorthEast');
handles.PlotTab2=PlotTab2;
hold off
clearvars PlotTab2

    else
        
        Color=hsv(NumTrips);
        
for i=1:NumTrips
    
Speed=table2array(handles.results.Value{i,1}(:,3))';
TIME=table2array(handles.results.Value{i,1}(:,2))';
time=datenum(TIME)';
PlotTab2(i)=plot(time,Speed,'.','Color',Color(i,:));
hold on
end

dateFormat=13;
datetick('x',dateFormat);
NumTicks=5;
L=get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),NumTicks));
zoom reset

xlabel('time')
ylabel('Speed(km/hr)')
set(handles.ax,'layer','top','FontWeight','bold');
handles.Legend2=clickableLegend(PlotTab2,handles.results.Key,'Location','NorthEast');
handles.PlotTab2=PlotTab2;
clearvars PlotTab2
hold off

    end
clearvars PlotTab2
hold off

    end
    
end
clearvars contents popChoice TIME  metersTraveled LATITUDE LONGITUDE Color

guidata(hObject,handles)

% --------------------------------------------------------------------
function Ginput_ClickedCallback(hObject, ~, handles)
% hObject    handle to Ginput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom off;

Cancel=0;
 rows=handles.Rows;

save('PassCancel.mat','Cancel');
if handles.SpeedCounter==1
    comb_handles=[handles.PlotStore handles.ColorCoded];
     
    [idx,xs,ys] = selectdata('sel','lasso','Axes',handles.PLOT,'Verify','on','Ignore',comb_handles);
     speed_idx=handles.Speedidx;
     
     idx=speed_idx(cell2mat(idx(:,rows)));
else
[idx,xs,ys] = selectdata('sel','lasso','Axes',handles.PLOT,'Verify','on','Ignore',handles.ColorCoded);%handles.PlotStore 
end
load('PassCancel.mat')
 
if Cancel==1
    set(handles.Ginput,'State','off');
    return
    
else
    
    
    if handles.FishCount==handles.Rows
        
  progressbar('Exporting Fishing Events...');
        
        %----------pass FE_ID using index--------------
nRowsEvents=str2double(perl('countlines.pl','Fishing Event Table.csv'));
FE_ID=num2cell(nRowsEvents);

nRowsTrips=str2double(perl('countlines.pl','TripsDatabase.csv'));

 MeanLat=mean(cell2mat(ys));
 MeanLon=mean(cell2mat(xs));

 if handles.SpeedCounter==0
 idx=cell2mat(idx);
 else
 end
 Speeds=table2array(handles.results.Value{rows,1}(idx(1):idx(end),3));
 MeanSpeed=mean(Speeds,1);
 
 StartTime=table2array(handles.results.Value{rows,1}(idx(1),2));
 EndTime=table2array(handles.results.Value{rows,1}(idx(end),2));
 
 Difference=datenum(EndTime)-datenum(StartTime);
 Duration=cellstr(datestr(Difference,'HH:MM:SS'));
 
 %A=cell2mat([FE_ID handles.TripID num2cell(MeanLat) num2cell(MeanLon) num2cell(MeanSpeed) StartTime EndTime Duration]);
 cell2csv2('Fishing Event Table.csv',[FE_ID handles.TripID num2cell(MeanLat) num2cell(MeanLon) num2cell(MeanSpeed) StartTime EndTime Duration],',','a+');
 %dlmwrite('Fishing Event Table.csv',A,'-append')
%[~, ~]= xlsappend('Fishing Event Table.csv',[FE_ID handles.TripID num2cell(MeanLat) num2cell(MeanLon) num2cell(MeanSpeed) StartTime EndTime Duration]);

%----------------RawData Update-------------------------%

FEID=handles.FEID;

nRowsEvents=str2double(perl('countlines.pl','Fishing Event Table.csv'));

FEID(idx)=nRowsEvents-1;
handles.FEID=FEID;

progressbar(.5)

Range=sprintf('L%d:L%d',handles.nRowsRaw+1,length(FEID)-1);

xlwrite('RawData.xls',FEID,Range);%%%%%%%%%%%%%%%%%%%%%%%%%%

pause(.5)
progressbar(1)

    else 

handles.FEID=0;      
handles.FishCount=handles.Rows;

 if handles.SpeedCounter==0
 idx=cell2mat(idx);
 else
 end       

 
 progressbar('Exporting Fishing Events...');
 
 %-----------------------Export Raw and Trips DataBases-----------------%
 %----------------------------------------------------------------------%

result=handles.results;

%-------------------Read Databases-----------------------

nRowsRaw=str2double(perl('countlines.pl','RawData.csv'));

nRowsEvents=str2double(perl('countlines.pl','Fishing Event Table.csv'));
FE_ID=num2cell(nRowsEvents);

nRowsTrips=str2double(perl('countlines.pl','TripsDatabase.csv'));

%-------------------Export---Trips---Data-----------------------

TripID=num2cell(nRowsTrips);
handles.TripID=TripID;
TrackerID=cellfun(@char,repmat({'Shark'},1,1),'Un',0);
TripNum=num2cell(rows-1);
Filename=cellfun(@char,repmat({handles.filename},1,1),'Un',0);

%A=cell2mat([TripID TrackerID table2cell(handles.StartTime(rows)) handles.EndTime(rows) TripNum Filename handles.Duration(rows) num2cell(handles.TotalDistance(rows))]);

cell2csv2('TripsDatabase.csv',[TripID TrackerID handles.StartTime(rows) handles.EndTime(rows) TripNum Filename handles.Duration(rows) num2cell(handles.TotalDistance(rows))],',','a+');
%dlmwrite('TripsDatabase.csv',A,'-append')

%[~,~]= xlsappend('TripsDatabase.csv',[TripID TrackerID handles.StartTime(rows) handles.EndTime(rows) TripNum Filename handles.Duration(rows) num2cell(handles.TotalDistance(rows))]);

handles.TripID=TripID;

progressbar(.2);

rows2=height(result.Value{rows,1});

TrackerID=cellfun(@char,repmat({'Shark'},height(result.Value{rows,1}),1),'Un',0);

LogID=num2cell(nRowsRaw:nRowsRaw+rows2-1)';

[Course,~]=legs(table2array(result.Value{rows,1}(:,4))',table2array(result.Value{rows,1}(:,5))');
Course=[num2cell(Course); num2cell(0)];

Distances=pathdist(table2array(result.Value{rows,1}(:,4))',table2array(result.Value{rows,1}(:,5))','km')';

DataLength=rows2;

TripIds=repmat(TripID,DataLength,1);

%----------pass FE_ID using index--------------
L1=size(LogID,1);
FEID=zeros(1,L1);
FEID(idx)=nRowsEvents;
handles.FEID=FEID';
handles.nRowsRaw=nRowsRaw;

%A=cell2mat([LogID TrackerID table2cell(result.Value{rows,1}) num2cell(Distances) Course TripIds num2cell(FEID')]);
%save('A.mat','A')
%dlmwrite('RawData.csv',A,'-append');
cell2csv2('RawData.csv',[LogID TrackerID table2cell(result.Value{rows,1}) num2cell(Distances) Course TripIds num2cell(FEID')],',','a+');
%[~, ~]= xlsappend('RawData.xls',[LogID TrackerID table2cell(result.Value{rows,1}) num2cell(Distances) Course TripIds num2cell(FEID')]);

%------------------------Export Fishing Events------------------------ 
 nRowsEvents=str2double(perl('countlines.pl','Fishing Event Table.csv'));
 FE_ID=num2cell(nRowsEvents);

 MeanLat=mean(cell2mat(ys));
 MeanLon=mean(cell2mat(xs));

 Speeds=table2array(handles.results.Value{rows,1}(idx(1):idx(end),3));
 MeanSpeed=mean(Speeds,1);
 
 StartTime=table2array(handles.results.Value{rows,1}(idx(1),2));
 EndTime=table2array(handles.results.Value{rows,1}(idx(end),2));
 
 Difference=datenum(EndTime)-datenum(StartTime);
 Duration=cellstr(datestr(Difference,'HH:MM:SS'));
 
 progressbar(.7)
%--------------------------------Display Summary------------------------- 
axes(handles.ax1)
cla(handles.ax1,'reset');
set(handles.ax1,'xtick',[]);
set(handles.ax1,'ytick',[]);

handles.MeanLatText=uicontrol('Parent',handles.tab1,'Style','text','String','Mean Lat:','Position',[10 210 100 20],'Units','normalized','BackgroundColor','w');
handles.MeanLatOut=uicontrol('Parent',handles.tab1,'Style','edit','String',MeanLat,'Position',[120 210 100 20],'Units','normalized','BackgroundColor','w');
handles.MeanLonText=uicontrol('Parent',handles.tab1,'Style','text','String','Mean Lon:','Position',[10 180 100 20],'Units','normalized','BackgroundColor','w');
handles.MeanLonOut=uicontrol('Parent',handles.tab1,'Style','edit','String',MeanLon,'Position',[120 180 100 20],'Units','normalized','BackgroundColor','w');
handles.MeanSpeedText=uicontrol('Parent',handles.tab1,'Style','text','String','Mean Speed:','Position',[10 150 100 20],'Units','normalized','BackgroundColor','w');
handles.MeanSpeedOut=uicontrol('Parent',handles.tab1,'Style','edit','String',MeanSpeed,'Position',[120 150 100 20],'Units','normalized','BackgroundColor','w');
handles.StartTimeText=uicontrol('Parent',handles.tab1,'Style','text','String','Start Time:','Position',[10 120 100 20],'Units','normalized','BackgroundColor','w');
handles.StartTimeOut=uicontrol('Parent',handles.tab1,'Style','edit','String',StartTime,'Position',[120 120 100 20],'Units','normalized','BackgroundColor','w');
handles.EndTimeText=uicontrol('Parent',handles.tab1,'Style','text','String','End Time:','Position',[10 90 100 20],'Units','normalized','BackgroundColor','w');
handles.EndTimeOut=uicontrol('Parent',handles.tab1,'Style','edit','String',EndTime,'Position',[120 90 100 20],'Units','normalized','BackgroundColor','w');
handles.DurationText=uicontrol('Parent',handles.tab1,'Style','text','String','Duration:','Position',[10 60 100 20],'Units','normalized','BackgroundColor','w');
handles.DurationOut=uicontrol('Parent',handles.tab1,'Style','edit','String',Duration,'Position',[120 60 100 20],'Units','normalized','BackgroundColor','w');

%Write to Fishing Events Database%
 
cell2csv2('Fishing Event Table.csv',[FE_ID TripID num2cell(MeanLat) num2cell(MeanLon) num2cell(MeanSpeed) StartTime EndTime Duration],',','a+');
%dlmwrite('Fishing Event Table.csv',[FE_ID TripID num2cell(MeanLat) num2cell(MeanLon) num2cell(MeanSpeed) StartTime EndTime Duration],'-append');
%[~, ~]= xlsappend('Fishing Event Table.csv',[FE_ID TripID num2cell(MeanLat) num2cell(MeanLon) num2cell(MeanSpeed) StartTime EndTime Duration]);

clearvars idx xs ys nRowsEvents FE_ID TripID MeanLat MeanLon Speeds MeanSpeed StartTime EndTime Difference Duration
progressbar(.9)
pause(.5)
progressbar(1)
    end
end

set(handles.Ginput,'State','off');

delete('PassCancel.mat')

% Update handles structure
guidata(hObject,handles)


% --------------------------------------------------------------------
function hPrintfigure_ClickedCallback(hObject, ~, handles)
% hObject    handle to hPrintfigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hToolbar = findall(gcf,'tag','FigureToolBar');
% hPrintButton = findall(hToolbar,'tag','Standard.PrintFigure');

f_tmp=figure('visible','off');
P1=subplot(2,1,1);
P1_pos=get(P1,'position');
delete(P1);
P2=subplot(2,1,2);
P2_pos=get(P2,'position');
delete(P2);
P=copyobj(handles.PLOT,f_tmp);
set(P,'position',P1_pos)
P=copyobj(handles.ax,f_tmp);
set(P,'position',P2_pos);

printpreview(f_tmp);

delete(f_tmp)

clearvars P P1 P2 P1_pos P2_pos
% Update handles structure
guidata(hObject, handles);


function checkForReturn(~,~,currFig)
% Gets the last charactor
handles=guidata(currFig);
%------------------Check if handles exists first----------%
% if ~isempty(ObjHandle) && ishandle(ObjHandle)
%      handle exists
% else
%      handle invalid
% end
row=handles.Rows;


last_key_pressed = get(currFig,'CurrentCharacter');
 
% If the last_key_pressed is return update the text box
% note that char)13) == Return key
if isequal(last_key_pressed,char(13))
drawnow
SpeedRange=get(handles.SpeedRange,'string');
if isempty(SpeedRange)
    set(handles.NEW_PlotStore,'Visible','off')
    set(handles.ColorCoded,'Visible','on')
      
else

    
SpeedRange=textscan(SpeedRange,'%f-%f');

if handles.SpeedCounter==0;
    
    if numel(row)>1
    set(handles.PlotStore,'Visible','off')   
    else
    set(handles.ColorCoded,'Visible','off')
    end

else
set(handles.NEW_PlotStore,'Visible','off')  
end
%set(handles.PlotStore,'Visible','off')
% set( handles.PlotStore, 'Linestyle', 'none' );
% set( handles.PlotStore, 'Marker', '.' );
axes(handles.PLOT) 
comb_idx=[];
for i=1:numel(row)
Speed=table2array(handles.results.Value{row(i),1}(:,3))';

idx=find(Speed<SpeedRange{2} & Speed>SpeedRange{1});

LATITUDE=table2array(handles.results.Value{row(i),1}(idx,4))';
LONGITUDE=table2array(handles.results.Value{row(i),1}(idx,5))';

NEW_PlotStore(i)=plot(LONGITUDE, LATITUDE,'.');

comb_idx=[comb_idx idx];
end
handles.Speedidx=comb_idx;
handles.NEW_PlotStore=NEW_PlotStore;
set(handles.NEW_PlotStore,'Visible','on') 

handles.SpeedCounter=1;
end
else
end
% Update handles structure
guidata(currFig,handles);

    


% --- Executes on button press in Reset_Button.
function Reset_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Reset_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%delete(handles.PlotStore);
% cla(handles.PLOT,'reset');
% cla(handles.PlotTab2,'reset');
%cla(handles.PlotStore,'reset');


% delete(legend)
% xlabel([]); ylabel([]); 
% 
% axes(handles.PLOT)
% 
% xlim([-120,-80]);ylim([10,35]);
% handles.GooglePlot=plot_google_map();%'MapType','hybrid');
% 
% set(handles.PLOT,'layer','top','FontWeight','bold');
% set(handles.PLOT,'xtick',[]);
% set(handles.PLOT,'ytick',[]);

%--------------------------------Update Counters----------------------------
handles.FishCount=0;

if handles.Counter==1
    set(handles.Legend2,'visible','off');
    handles=rmfield(handles,'Legend2');
   
    if handles.ColorCount==1
    set(handles.ColorCoded,'Visible','off')
    handles=rmfield(handles,'ColorCoded');
    set(handles.PlotStore,'Visible','off')
    set(handles.PlotTab2,'Visible','off')
    handles=rmfield(handles,'PlotStore');
    handles=rmfield(handles,'PlotTab2');

    else
    set(handles.PlotStore,'Visible','off')
    set(handles.PlotTab2,'Visible','off')
    handles=rmfield(handles,'PlotStore');
    handles=rmfield(handles,'PlotTab2');
    end
else
end
%--------------------Initialize--------------
handles.FirstTime=0;
handles.ColorCount=0;
handles.SpeedCount=0;
handles.DontPlot=0;
handles.Counter2=0;


box on
zoom reset

set(handles.SpeedRange,'string',''); 

 %---------------------------Initialize--------------------------------
handles.Counter=0;
handles.ColorCount=0;
handles.SpeedCount=0;
handles.DontPlot=0;
handles.FileCount=0;
handles.SpeedCounter=0;



% set(handles.Legend1,'visible','on')
% set(handles.PlotStore,'Visible','off')
% set(handles.PlotStore(rows),'Visible','on')
% set(handles.PlotTab2,'Visible','off')
% set(handles.PlotTab2(rows),'Visible','on')
 
% Update handles structure
guidata(hObject,handles)
