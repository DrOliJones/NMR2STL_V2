function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 25-Oct-2019 15:13:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

logo = imread('logo_full.png');
hAxes = gca;
imshow(logo,'Parent',hAxes);

%Setup Some Global Default Values
global dataType;
dataType = 1;
global modelType;
modelType = 1;

clc
% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.Controller);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rF = str2double(get(handles.gridSizeEditBox,'String')); %Obtain Reduction Factor
ol = str2double(get(handles.xbox,'String')); %Obtain Model Length
ow = str2double(get(handles.ybox,'String')); %Obtain Model Width
oh = str2double(get(handles.zbox,'String')); %Obtain Model Height
thick = str2double(get(handles.thickbox,'String')); %Obtain Model Thickness
open = get(handles.checkbox,'value'); %Obtain open output preference
global guiAxisMain;
guiAxisMain = findobj('Type', 'axes', 'Tag', 'axisMain'); %Find the axis

%global dataType; %Obtain Procedure
global p; %Obtain File Path

if exist(p, 'file') == 2
    nmr_print(p,rF,ol,ow,oh,thick,open,guiAxisMain); %Initiate Main Function
    set(handles.directoryField,'string','NMR Data Has Been Imported','backgroundcolor','white');
else
    set(handles.directoryField,'string','FILE NOT FOUND!!!','backgroundcolor','red');
end

set(handles.modelType, 'Enable', 'on');

% --- Executes on button press in checkbox.
function checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox



function xbox_Callback(hObject, eventdata, handles)
% hObject    handle to xbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xbox as text
%        str2double(get(hObject,'String')) returns contents of xbox as a double


% --- Executes during object creation, after setting all properties.
function xbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ybox_Callback(hObject, eventdata, handles)
% hObject    handle to ybox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ybox as text
%        str2double(get(hObject,'String')) returns contents of ybox as a double


% --- Executes during object creation, after setting all properties.
function ybox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ybox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zbox_Callback(hObject, eventdata, handles)
% hObject    handle to zbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zbox as text
%        str2double(get(hObject,'String')) returns contents of zbox as a double


% --- Executes during object creation, after setting all properties.
function zbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gridSizeEditBox_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
% hObject    handle to gridSizeEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gridSizeEditBox as text
%        str2double(get(hObject,'String')) returns contents of gridSizeEditBox as a double


% --- Executes during object creation, after setting all properties.
function gridSizeEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridSizeEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thickbox_Callback(hObject, eventdata, handles)
% hObject    handle to thickbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thickbox as text
%        str2double(get(hObject,'String')) returns contents of thickbox as a double


% --- Executes during object creation, after setting all properties.
function thickbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thickbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tv.
function tv_Callback(hObject, eventdata, handles)
% hObject    handle to tv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tv


% --- Executes on button press in browseBtn.
function browseBtn_Callback(hObject, eventdata, handles)
% hObject    handle to browseBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p;

[nmrFile,nmrPath] = uigetfile('*.*');

if exist('nmrPath', 'var') ~= 0
    if nmrPath ~= 0
        p = strcat(nmrPath,nmrFile);
    end
end

set(handles.directoryField, 'String', p);


function directoryField_Callback(hObject, eventdata, handles)
% hObject    handle to directoryField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of directoryField as text
%        str2double(get(hObject,'String')) returns contents of directoryField as a double


% --- Executes during object creation, after setting all properties.
function directoryField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to directoryField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in nmrSelect.
function nmrSelect_Callback(hObject, eventdata, handles)
% hObject    handle to nmrSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns nmrSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nmrSelect
%global dataType

% contents = get(hObject,'Value');
% 
% switch contents
%     case 1
%         dataType = 1;
%     case 2
%         dataType = 2;
%     case 3
%         dataType = 3;
%     case 4
%         dataType = 3;
%     otherwise
%         dataType = 1;
% end

% --- Executes during object creation, after setting all properties.
function nmrSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nmrSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function fileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to fileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function exitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to exitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function developMenu_Callback(hObject, eventdata, handles)
% hObject    handle to developMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function testFn1_Callback(hObject, eventdata, handles)
% hObject    handle to testFn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function testFn2_Callback(hObject, eventdata, handles)
% hObject    handle to testFn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function testFn3_Callback(hObject, eventdata, handles)
% hObject    handle to testFn3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in modelType.
function modelType_Callback(hObject, eventdata, handles)
% hObject    handle to modelType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns modelType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from modelType
global modelType
global guiAxisMain;
contents = get(hObject,'Value');

%Adjust ViewPoint
switch contents
    case 1
        modelType = 1;
        view(guiAxisMain,[0 90]);
    case 2
        modelType = 2;
        view(guiAxisMain,[90 0]);
    case 3
        modelType = 3;
        view(guiAxisMain,[45 30]);
    otherwise
        modelType = 1;
        view(guiAxisMain,[0 90]);
end


% --- Executes during object creation, after setting all properties.
function modelType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modelType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function helpMenu_Callback(hObject, eventdata, handles)
% hObject    handle to helpMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function instructMenu_Callback(hObject, eventdata, handles)
% hObject    handle to instructMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
instruct

% --------------------------------------------------------------------
function aboutMenu_Callback(hObject, eventdata, handles)
% hObject    handle to aboutMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
about
