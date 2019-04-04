


function varargout = MIT1(varargin)


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MIT1_OpeningFcn, ...
                   'gui_OutputFcn',  @MIT1_OutputFcn, ...
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





function Open_LAS_1_Callback(hObject, eventdata, handles)
% hObject    handle to Open_LAS_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes just before MIT1 is made visible.
function MIT1_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using MIT1.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes MIT1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MIT1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function output_txt = FormatDataCursor(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos = get(event_obj,'Position');
output_txt = {['Depth: ',num2str(pos(1),7)],...
    ['Number Radius: ',num2str(pos(2),7)]};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Value Radius: ',num2str(pos(3),7)];
end



function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------



% --------------------------------------------------------------------
function Open_LAS_Callback(hObject, eventdata, handles)
% hObject    handle to Open_LAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%main_OpeningFcn(gcf);


[fname,pname]=uigetfile('*.las');

p=fopen(fname,'r');
%p=-1*p;
row_start='';
row_stop='';
row_step='';
count=0;  count_data=1;
flag_dig_beg=0;
pos_dig_beg=0;  pos_dig_end=0;
line_size=0;
digit=0;
global Size_Z_D;
global X_D; X_D = [  ];
global X_D_Depth; X_D_Depth = [  ];
global Y_D; Y_D = [  ];
global Z_D; Z_D = [  ];

global checkedAxis;
checkedAxis=0;
global Handle_fig;

number_Radius=40;

clear U;
clear V;
clear W;

clear Z_data;


clear Y;
clear Y;
clear Z;
clear X_D;
clear X_D_Depth;
clear Y_D;
clear Z_D;
clear Size_Z_D;
 Warning_Set_Value=false;
%while feof(p)==0
while feof(p)==0          %begin cycle
    
clear Z_data;
    
line=fgetl(p);

if count==5
    start_t=fscanf(p,'%s',1);
    start=fscanf(p,'%g',1);    
end   % if(count==5)
  
  if count==6
    stop_t=fscanf(p,'%s',1);
    stop=fscanf(p,'%g',1);
  end
  
  if count==7
    step_t=fscanf(p,'%s',1);
    step=fscanf(p,'%g',1);
  end
  
   if count==8
    null_t=fscanf(p,'%s',1);
    null_v=fscanf(p,'%g',1);
  end

  digit=fscanf(p,'%g',1);
  
  
  if digit>0    
      Warning_Set_Value=false;
      Z_data=fscanf(p,'%g',number_Radius);
       for i=1:1:number_Radius
         if Warning_Set_Value==false
           if Z_data(i)~=null_v
               Z_D(i,count_data)=Z_data(i);
           else 
           
            j=i;  
            while Z_data(j) == null_v&&j>1 
                Z_data(j) = Z_data(j);
                j=j-1;
            end
              if Z_data(j)~=null_v 
                  Prev_Z_data = Z_data(j);
              else
                  j=number_Radius; 
                 while Z_data(j) == null_v&&j>i 
                       Z_data(j) = Z_data(j);
                       j=j-1;
                 end
                 if Z_data(j)~=null_v 
                      Prev_Z_data = Z_data(j);
                      k=j;  %fix position prev 
                   else
                   Warning_Set_Value=true; 
                   %Z_D(i,count_data)=Z_data(i);%if all values = null_v - save as is
                    end                
              end
              
              if Warning_Set_Value==false
               j=i;  
                 while Z_data(j) == null_v&&j<number_Radius 
                   Z_data(j) = Z_data(j);
                   j=j+1;
                 end 
                  if Z_data(j)~=null_v 
                  After_Z_data = Z_data(j);
                   Z_D(i,count_data)=(Prev_Z_data+After_Z_data)/2;
                  else
                   j=1; 
                       while Z_data(j) == null_v&&j<i 
                       Z_data(j) = Z_data(j);
                       j=j+1;
                       end
                       if Z_data(j)~=null_v 
                        After_Z_data = Z_data(j);
                        k1=j;  %fix position prev 
                        Z_D(i,count_data)=(Prev_Z_data+After_Z_data)/2;
                       end
                  end
              end
              
               %EndAnalise;   
           end
         else
             Z_D(i,count_data)=Z_data(i);%if all values = null_v - save as is
         end
       
           X_D_Depth(i,count_data)= digit;
       end
 
      count_data=count_data+1; 
      clear digit;
  end
  
  count=count+1;
end   % end while

global Size_Z_D; 
Size_Z_D = size(Z_D);


%clc;
%clf;
[X_D,Y_D] = meshgrid(1:1:Size_Z_D(2), 1:1:number_Radius);

%levels=0:0.01:0.5;
%surfc(X_D,Y_D,Z_D);
Handle_fig=handles.Axes1;
surf(Handle_fig,X_D_Depth,Y_D,Z_D);

%surf(X_D,Y_D,Z_D);
%mesh(handles.axes2,X_D_Depth,Y_D,Z_D);
shading interp;
MinMaxX = xlim;
MinMaxY = ylim;
MinMaxZ = zlim;

set (handles.X_min,'String', MinMaxX(1));
set (handles.X_max,'String', MinMaxX(2));

set (handles.Y_min,'String', MinMaxY(1));
set (handles.Y_max,'String', MinMaxY(2));

set (handles.Z_min,'String', MinMaxZ(1));
set (handles.Z_max,'String', MinMaxZ(2));

dcm_obj = datacursormode(gcf);
set(dcm_obj,'UpdateFcn',@FormatDataCursor);





% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObjec
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)

printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)

% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)




% --- Executes on key press with focus on pushbutton1 and none of its controls.
function pushbutton1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------


% --------------------------------------------------------------------






% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Fig_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname,pname]=uiputfile('*.fig');

saveas(gcf,fname);
%uisave;


% --------------------------------------------------------------------
function Edit_Color_Map_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Color_Map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormapeditor;


% --------------------------------------------------------------------
function Edit_1_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Axis_1_Callback(hObject, eventdata, handles)
% hObject    handle to Axis_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global checkedAxis;
 a = get(hObject, 'Checked');
% match = strcmp(a, 'on');
 
if strcmp(a, 'on') == 0 
set(hObject, 'Checked', 'On');

set (handles.X_min,'Visible', 'On');
set (handles.textX_min,'Visible', 'On');
set (handles.X_max,'Visible', 'On');
set (handles.textX_max,'Visible', 'On');

set (handles.Y_min,'Visible', 'On');
set (handles.textY_min,'Visible', 'On');
set (handles.Y_max,'Visible', 'On');
set (handles.textY_max,'Visible', 'On');

set (handles.Z_min,'Visible', 'On');
set (handles.textZ_min,'Visible', 'On');
set (handles.Z_max,'Visible', 'On');
set (handles.textZ_max,'Visible', 'On');

end

if strcmp(a, 'off') == 0 
set(hObject, 'Checked', 'off');

set (handles.X_min,'Visible', 'Off');
set (handles.textX_min,'Visible', 'Off');
set (handles.X_max,'Visible', 'Off');
set (handles.textX_max,'Visible', 'Off');

set (handles.Y_min,'Visible', 'Off');
set (handles.textY_min,'Visible', 'Off');
set (handles.Y_max,'Visible', 'Off');
set (handles.textY_max,'Visible', 'Off');

set (handles.Z_min,'Visible', 'Off');
set (handles.textZ_min,'Visible', 'Off');
set (handles.Z_max,'Visible', 'Off');
set (handles.textZ_max,'Visible', 'Off');

end

%checkedAxis=checkedAxis+1;
%plotbrowser;
%propertyeditor(gcf);



function X_min_Callback(hObject, eventdata, handles)
% hObject    handle to X_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of X_min as text
%        str2double(get(hObject,'String')) returns contents of X_min as a double
MinMax_Xmin=xlim;
temp_Xmin = str2double(get(hObject,'String'));
xlim([temp_Xmin MinMax_Xmin(2)]);%(1) - min; (2) - max 

% --- Executes during object creation, after setting all properties.
function X_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function X_max_Callback(hObject, eventdata, handles)
% hObject    handle to X_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of X_max as text
%        str2double(get(hObject,'String')) returns contents of X_max as a double
 MinMax_Xmax=xlim;
temp_Xmax = str2double(get(hObject,'String'));
xlim([MinMax_Xmax(1) temp_Xmax]);%(1) - min; (2) - max 



% --- Executes during object creation, after setting all properties.
function X_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Y_min_Callback(hObject, eventdata, handles)
% hObject    handle to Y_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Y_min as text
%        str2double(get(hObject,'String')) returns contents of Y_min as a double
MinMax_Ymin=ylim;
temp_Ymin = str2double(get(hObject,'String'));
ylim([temp_Ymin MinMax_Ymin(2)]);%(1) - min; (2) - max 


% --- Executes during object creation, after setting all properties.
function Y_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Y_max_Callback(hObject, eventdata, handles)
% hObject    handle to Y_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Y_max as text
%        str2double(get(hObject,'String')) returns contents of Y_max as a double
 MinMax_Ymax=ylim;
temp_Ymax = str2double(get(hObject,'String'));
ylim([MinMax_Ymax(1) temp_Ymax]);%(1) - min; (2) - max 


% --- Executes during object creation, after setting all properties.
function Y_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Z_min_Callback(hObject, eventdata, handles)
% hObject    handle to Z_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Z_min as text
%        str2double(get(hObject,'String')) returns contents of Z_min as a double
MinMax_Zmin=zlim;
temp_Zmin = str2double(get(hObject,'String'));
zlim([temp_Zmin MinMax_Zmin(2)]);%(1) - min; (2) - max 

% --- Executes during object creation, after setting all properties.
function Z_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Z_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Z_max_Callback(hObject, eventdata, handles)
% hObject    handle to Z_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Z_max as text
%        str2double(get(hObject,'String')) returns contents of Z_max as a double
MinMax_Zmax=zlim;
temp_Zmax = str2double(get(hObject,'String'));
zlim([MinMax_Zmax(1) temp_Zmax]);%(1) - min; (2) - max 

% --- Executes during object creation, after setting all properties.
function Z_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Z_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%global Handle_fig;
%Handle_fig=handles.Axes1;
% Hint: place code in OpeningFcn to populate Axes1


% --- Executes during object deletion, before destroying properties.
function Axes1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to Axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool15_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%button = questdlg('Viever LAS from MIT40\n Gazodinamic','About','OK','default');
global str_ver;
global str_Name;
str = char(str_Name,str_ver, '', 'Petrophysical research and Development Center-methodical works','', 'Laboratory of gas-dynamic researches','','Ivanov Oleg','','2014'); 
handle=msgbox(str,'About');
javaFrame = get(handle,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('ico_mtlab.png'));
%dialog('WindowStyle', 'modal', 'Name', 'About');


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global str_ver;
str_ver = 'Version 1.03';
global str_Name;
str_Name = 'Viever LAS from MIT40 for 3D Visualization (with use MATLAB Runtime) ';
str_NameOut = [str_Name str_ver];
javaFrame = get(gcf,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('ico_mtlab.png')); % need ICO (or png - only they have a transparent background!!!!)
set(hObject, 'Name',str_NameOut ); 

hFileMenu = findall(gcf, 'tag', 'figMenuFile');
%set (hFileMenu,'Label','File Fig');
%if need add new item in menu figure%
%hMruMenu = uimenu('Label','OpenLAS1', 'Parent',hFileMenu);
hAllMenuItems = allchild(hFileMenu);
hNew = findall(hFileMenu, 'Label', '&New');
set(hNew, 'Visible','off');

%bbb=get(hAllMenuItems , 'Label');


%in hAllMenuItems array data end to 1 -> the position of the menu from top to bottom!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%set(hFileMenu, 'Children',fliplr(hAllMenuItems([2:end-1,1,end]))); % change sequence items in menu % place in 2nd position, just above the "Open" item
%hOpenLas = findall(hFileMenu, 'Label', 'OpenLAS1');
%set(hOpenLas, 'Callback',@Open_LAS_File_Callback);







%set(hObject, 'WindowStyle','docked'); 
%for icon need ver MATLAB 2013b and and above


% --------------------------------------------------------------------
function Axis_1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Axis_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(handles.figure1,'units','normalized','outerposition',[0 0.02 1 0.98]);%full screen - 1 variant

jFrame = get(handles.figure1,'JavaFrame');
jFrame.setMaximized(true);              %full screen - 2 variant (is better)

hFileMenu = findall(gcf, 'tag', 'figMenuFile'); %change 'File' to 'Figure' in menu figure
set (hFileMenu,'Label','Figure');

%{
global Handle_fig;
Handle_fig=handles.Axes1;

MinMaxX = xlim;
MinMaxY = ylim;
MinMaxZ = zlim;

set (handles.X_min,'String', MinMaxX(1));
set (handles.X_max,'String', MinMaxX(2));

set (handles.Y_min,'String', MinMaxY(1));
set (handles.Y_max,'String', MinMaxY(2));

set (handles.Z_min,'String', MinMaxZ(1));
set (handles.Z_max,'String', MinMaxZ(2));
%}



% --------------------------------------------------------------------
function Help_1_Callback(hObject, eventdata, handles)
% hObject    handle to Help_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function File_Fig_Callback(hObject, eventdata, handles)
% hObject    handle to File_Fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Open_fig_Callback(hObject, eventdata, handles)
% hObject    handle to Open_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName, PathName] = uigetfile('*.fig','Open FIG Files','Multiselect','off');
if ~isequal(FileName,0)
    if iscell(FileName)
         for k=1:length(FileName)
             open(strcat(PathName,FileName{k}));
         end
    else
        open(strcat(PathName,FileName));
    end
end


% --------------------------------------------------------------------
function Save_fig_Callback(hObject, eventdata, handles)
% hObject    handle to Save_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[filename,pname]=uiputfile('*.jpg');
%hgexport(handles.figure1,filename);

%saveas(handles.figure1,filename)-djpeg -f2 -r300 handles.figure;
[filename, pathname, filterindex] = uiputfile( ...
{'*.fig;*.bmp;*.jpg;*.pcx','Files (*.fig,*.bmp,*.jpg,*.pcx)';
 '*.fig', 'Figures (*.fig)';...
 '*.bmp','bmp (*.bmp)';...
 '*.jpg','jpg (*.jpg)';...
 '*.pcx','Paintbrush 24-bit file(*.pcx)';...
 '*.*',  'All Files (*.*)'},...
 'Save Image');
%hgexport(handles.figure1,filename);
     saveas(handles.figure1,filename, 'bmp'); 


% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
