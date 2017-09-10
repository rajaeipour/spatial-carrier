function varargout = FTP10(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FTP10_OpeningFcn, ...
                   'gui_OutputFcn',  @FTP10_OutputFcn, ...
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


% --- Executes just before FTP10 is made visible.
function FTP10_OpeningFcn(hObject, eventdata, handles, varargin)

% IMTEK Logo read
logo_im = imread('imtek-logo.png','BackgroundColor',[0.93 0.93 0.93]);
axes(handles.axes5);
imshow(logo_im, []);
% Define Zernike table size
% set(handles.ZernFitTable,'Data',cell(10,1));
% Camera input setting
handles.DepthVid = videoinput('linuxvideo', 1, 'RGB24_1920x1200');% 'YUY2_1920x1200'); % make object for depth camera
set(handles.DepthVid,'FramesPerTrigger',1); % capture 1 frame every time DepthVid is trigered
set(handles.DepthVid,'TriggerRepeat',Inf); % infinite amount of triggers
%set(handles.DepthVid, 'ReturnedColorspace', 'RGB');
triggerconfig(handles.DepthVid, 'Manual');% trigger Depthvid manually within program

% handles.DepthVid.LoggingMode = 'disk';
% diskLogger = VideoWriter('/home/pouya/Desktop/1.avi', 'Uncompressed AVI');
% handles.DepthVid.DiskLogger = diskLogger;
% diskLogger.FrameRate = 1;

% Define frame aquisition frequency
handles.FrameAquiFreq = 1;
writefreqtoedit = handles.FrameAquiFreq;
set(handles.FrameFreq, 'String', num2str(writefreqtoedit));
% Define algorithm timers
handles.t1 = timer('TimerFcn',{@FTP_MainFunc, gcf}, 'BusyMode', 'drop',...
                   'Period',1/handles.FrameAquiFreq,'executionMode','fixedRate');
handles.t2 = timer('TimerFcn',{@FTP_PlotFunc, gcf}, 'BusyMode', 'drop',...
                   'Period',1/handles.FrameAquiFreq,'executionMode','fixedRate');
% Define primary frequency filter diameter
set(handles.FilterDiam,'Value',0.12);
% Make axes1 units normalized
set(handles.axes1,'Units','normalized');
% Set sliders step values
set(handles.FilterDiam,'SliderStep',[0.001, 0.01]);
set(handles.FilterX,'SliderStep',[0.0005, 0.01]);
set(handles.FilterY,'SliderStep',[0.0005, 0.01]);
% Set realtime sign off
set(handles.realtime,'foregroundcolor',[1 1 1]);
% set (handles.ZernFitTable,'ColumnWidth', {100,52})

% Choose default command line output for FTP10
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FTP10 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FTP10_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
handles.DepthVid.FramesAvailable



function LightWaveLength_Callback(hObject, eventdata, handles)
% hObject    handle to LightWaveLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LightWaveLength as text
%        str2double(get(hObject,'String')) returns contents of LightWaveLength as a double


% --- Executes during object creation, after setting all properties.
function LightWaveLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LightWaveLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SystemMode.
function SystemMode_Callback(hObject, eventdata, handles)
% hObject    handle to SystemMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SystemMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SystemMode


% --- Executes during object creation, after setting all properties.
function SystemMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SystemMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function FilterDiam_Callback(hObject, eventdata, handles)
% hObject    handle to FilterDiam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function FilterDiam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterDiam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function FilterX_Callback(hObject, eventdata, handles)
% hObject    handle to FilterX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function FilterX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function FilterY_Callback(hObject, eventdata, handles)
% hObject    handle to FilterY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function FilterY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Crop4_Callback(hObject, eventdata, handles)
% hObject    handle to Crop4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Crop4 as text
%        str2double(get(hObject,'String')) returns contents of Crop4 as a double


% --- Executes during object creation, after setting all properties.
function Crop4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Crop4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Crop3_Callback(hObject, eventdata, handles)
% hObject    handle to Crop3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Crop3 as text
%        str2double(get(hObject,'String')) returns contents of Crop3 as a double


% --- Executes during object creation, after setting all properties.
function Crop3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Crop3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Crop1_Callback(hObject, eventdata, handles)
% hObject    handle to Crop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Crop1 as text
%        str2double(get(hObject,'String')) returns contents of Crop1 as a double


% --- Executes during object creation, after setting all properties.
function Crop1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Crop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Crop2_Callback(hObject, eventdata, handles)
% hObject    handle to Crop2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Crop2 as text
%        str2double(get(hObject,'String')) returns contents of Crop2 as a double


% --- Executes during object creation, after setting all properties.
function Crop2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Crop2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Crop7_Callback(hObject, eventdata, handles)
% hObject    handle to Crop7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Crop7 as text
%        str2double(get(hObject,'String')) returns contents of Crop7 as a double


% --- Executes during object creation, after setting all properties.
function Crop7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Crop7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Crop5_Callback(hObject, eventdata, handles)
% hObject    handle to Crop5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Crop5 as text
%        str2double(get(hObject,'String')) returns contents of Crop5 as a double


% --- Executes during object creation, after setting all properties.
function Crop5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Crop5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Crop6_Callback(hObject, eventdata, handles)
% hObject    handle to Crop6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Crop6 as text
%        str2double(get(hObject,'String')) returns contents of Crop6 as a double


% --- Executes during object creation, after setting all properties.
function Crop6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Crop6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CropDone.
function CropDone_Callback(hObject, eventdata, handles)
% hObject    handle to CropDone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CropDone



function Crop8_Callback(hObject, eventdata, handles)
% hObject    handle to Crop8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Crop8 as text
%        str2double(get(hObject,'String')) returns contents of Crop8 as a double


% --- Executes during object creation, after setting all properties.
function Crop8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Crop8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)

set(handles.Crop5,'String',num2str(0));
set(handles.Crop6,'String',num2str(0));
set(handles.Crop7,'String',num2str(1920));
set(handles.Crop8,'String',num2str(1200));

set(handles.CropDone,'Value',0);
set(handles.CropDone,'backgroundcolor',[0.93 0.93 0.93]);
set(handles.LoopTime,'String','');
set(handles.peak_valley,'String','');
set(handles.RMS,'String','');
% set(handles.ZernFitTable, 'Data', cell(size(get(handles.ZernFitTable,'Data'))));
set(handles.uibuttongroup2,'selectedobject',handles.AutoFilter)

set(handles.FourierPlot,'Value',0);
set(handles.FilterPlot,'Value',0);
set(handles.ReferencePlot,'Value',0);
% set(handles.WUTPlot,'Value',0);
set(handles.WrappedPlot,'Value',0);
set(handles.D2Plot,'Value',0);
set(handles.D3Plot,'Value',0);
set(handles.ZernikeTable,'Value',0);

cla(handles.axes2,'reset');
cla(handles.axes3,'reset');
cla(handles.axes4,'reset');

% --- Executes on button press in Apply.
function Apply_Callback(hObject, eventdata, handles)

stoppreview(handles.DepthVid)
crop_x = str2double(get(handles.Crop5,'String'));
crop_y = str2double(get(handles.Crop6,'String'));
crop_width = str2double(get(handles.Crop7,'String'));
crop_height = str2double(get(handles.Crop8,'String'));
set(handles.DepthVid,'ROIPosition',[crop_x crop_y crop_width crop_height]);
axes(handles.axes1)
videoRes = get(handles.DepthVid, 'VideoResolution');
numberOfBands = get(handles.DepthVid, 'NumberOfBands');
handleToImageInAxes = image( zeros([videoRes(2), videoRes(1), numberOfBands], 'uint8') );

preview(handles.DepthVid,handleToImageInAxes)
set(handles.axes1title,'String','Live View');
axis equal

% --- Executes on button press in FourierPlot.
function FourierPlot_Callback(hObject, eventdata, handles)
% hObject    handle to FourierPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FourierPlot


% --- Executes on button press in WrappedPlot.
function WrappedPlot_Callback(hObject, eventdata, handles)
% hObject    handle to WrappedPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WrappedPlot


% --- Executes on button press in D2Plot.
function D2Plot_Callback(hObject, eventdata, handles)
% hObject    handle to D2Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of D2Plot


% --- Executes on button press in D3Plot.
function D3Plot_Callback(hObject, eventdata, handles)
% hObject    handle to D3Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of D3Plot


% --- Executes on button press in ZernikeTable.
function ZernikeTable_Callback(hObject, eventdata, handles)
% hObject    handle to ZernikeTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ZernikeTable


% % --- Executes on button press in WUTPlot.
% function WUTPlot_Callback(hObject, eventdata, handles)
% % hObject    handle to WUTPlot (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of WUTPlot


% --- Executes on button press in FilterPlot.
function FilterPlot_Callback(hObject, eventdata, handles)
% hObject    handle to FilterPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FilterPlot


% --- Executes on button press in ReferencePlot.
function ReferencePlot_Callback(hObject, eventdata, handles)
% hObject    handle to ReferencePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ReferencePlot


% --- Executes on button press in LiveView.
function LiveView_Callback(hObject, eventdata, handles)

crop_x = str2double(get(handles.Crop5,'String'));
crop_y = str2double(get(handles.Crop6,'String'));
crop_width = str2double(get(handles.Crop7,'String'));
crop_height = str2double(get(handles.Crop8,'String'));
set(handles.DepthVid,'ROIPosition',[crop_x crop_y crop_width crop_height]);
axes(handles.axes1)
videoRes = get(handles.DepthVid, 'VideoResolution');
numberOfBands = get(handles.DepthVid, 'NumberOfBands');
handleToImageInAxes = image( zeros([videoRes(2), videoRes(1), numberOfBands], 'uint8') );

preview(handles.DepthVid,handleToImageInAxes)
set(handles.axes1title,'String','Live View');
axis equal

% --- Executes on button press in Crop.
function Crop_Callback(hObject, eventdata, handles)

window1 = figure;
window1.Units = 'pixels';                    
im_crop = getsnapshot(handles.DepthVid);

figure(window1)
imshow(im_crop)
set(gca,'units','normalized','position',[0,0,1,1],'xtick',[],'ytick',[]);
ROI_rect = imrect;
ROI_crop = wait(ROI_rect);
close(window1)

ROI_crop = round(ROI_crop);
ROI_crop_length = min([ROI_crop(3) ROI_crop(4)]);

handles.ReferenceFringe_axes4 = imcrop(im_crop,[ROI_crop(1) ROI_crop(2) ROI_crop_length ROI_crop_length]);
 
set(handles.Crop1, 'String', num2str(ROI_crop(1)));
set(handles.Crop2, 'String', num2str(ROI_crop(2)));
set(handles.Crop3, 'String', num2str(ROI_crop(3)));
set(handles.Crop4, 'String', num2str(ROI_crop(4)));
set(handles.Crop5, 'String', num2str(ROI_crop(1)));
set(handles.Crop6, 'String', num2str(ROI_crop(2)));
set(handles.Crop7, 'String', num2str(ROI_crop_length));
set(handles.Crop8, 'String', num2str(ROI_crop_length));

handles.reference_im = im_crop;
handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in Measure.
function Measure_Callback(hObject, eventdata, handles)

set(handles.DepthVid,'ROIPosition',[0 0 1920 1200]) %%%% Bring ROI to default for capturing

start(handles.DepthVid); % Start Video
start(handles.t1) % Start measurement function


function realtime_Callback(hObject, eventdata, handles)
% hObject    handle to realtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of realtime as text
%        str2double(get(hObject,'String')) returns contents of realtime as a double


% --- Executes during object creation, after setting all properties.
function realtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to realtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Capture.
function Capture_Callback(hObject, eventdata, handles)

% handles = guidata(fignum);

check_timer1 = isvalid(handles.t1);
if check_timer1 == 1
    stop(handles.DepthVid);
    stop(handles.t1);
    set(handles.realtime,'foregroundcolor',[0.9 0.9 0.9],'backgroundcolor',[0.9 0.9 0.9]);
end
check_timer2 = isvalid(handles.t2);
if check_timer2 == 1
    stop(handles.t2);
end

% FTP_PlotFunc(hObject,eventdata,fignum) % Calling plot function
axes(handles.axes4)
colorbar
colormap jet
shading interp
h=rotate3d;
set(h,'Enable','on');

% assignin('base', 'Reference_fringe', handles.ReferenceFringe_axes4)
assignin('base', 'Captured_frame', handles.im_axes1)
% assignin('base', 'Fourier_Domain', handles.G_abs_axes2)
assignin('base', 'Frequency_Filter', handles.lobe1_axes3)
assignin('base', 'Wrapped_Phase', handles.Wrapped_axes3)
assignin('base', 'Deformation', handles.Deformation2D_axes3)


% --- Executes on button press in PLOT.
function PLOT_Callback(hObject, eventdata, handles)

start(handles.t2)


% --- Executes on button press in STOP.
function STOP_Callback(hObject, eventdata, handles)

check_timer1 = isvalid(handles.t1);
check_timer2 = isvalid(handles.t2);

if check_timer2 == 1
    stop(handles.t2)
end

if check_timer1 == 1
    stop(handles.DepthVid);
    stop(handles.t1);
    set(handles.realtime,'foregroundcolor',[0.9 0.9 0.9],'backgroundcolor',[0.9 0.9 0.9]);
    set(handles.LoopTime, 'String', ' ');
    stoppreview(handles.DepthVid)
else
    stoppreview(handles.DepthVid)
end



function LoopTime_Callback(hObject, eventdata, handles)
% hObject    handle to LoopTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LoopTime as text
%        str2double(get(hObject,'String')) returns contents of LoopTime as a double


% --- Executes during object creation, after setting all properties.
function LoopTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LoopTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FrameFreq_Callback(hObject, eventdata, handles)
% hObject    handle to FrameFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FrameFreq as text
%        str2double(get(hObject,'String')) returns contents of FrameFreq as a double


% --- Executes during object creation, after setting all properties.
function FrameFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function FTP_MainFunc(hObject, evendata, fignum)
tic; 
handles = guidata(fignum);

set(handles.realtime,'foregroundcolor',[0 0 0],'backgroundcolor',[0 1 0]);

trigger(handles.DepthVid)%trigger DepthVid to capture image
im=getdata(handles.DepthVid,1);%

crop_x = str2double(get(handles.Crop5,'String'));
crop_y = str2double(get(handles.Crop6,'String'));
crop_width = str2double(get(handles.Crop7,'String'));           

handles.ROI_P = [crop_x crop_y crop_width crop_width];

im = imcrop(im,[crop_x crop_y crop_width crop_width]);

handles.im_axes1 = im;
im = im(:,:,1); % reading only "red" values of the captured frame

check_crop_done = get(handles.CropDone, 'Value');

if check_crop_done == 1

set(handles.CropDone,'backgroundcolor',[0.93 0.93 0.93]);

K0 = get(handles.FilterDiam,'value');   % Radius of the filter as a fraction of pi
wave_length = str2double(get(handles.LightWaveLength,'String'))*10^(-9); % Wavelength of the light used for illumination 
mode = get(handles.SystemMode,'Value');   % If the membrane is reflective: 'reflection' , if the membrane is transimissive: 'transmission'    

img1=im2double(im);

[N,M]=size(img1); %[height, width]

% Preparing for applying hamming window
h_win=hamming(N);
hamm = zeros(N,N); 

% Initialize windows along column direction
for n=1:N
  hamm(:,n)=h_win;
end

% Apply windows along rows
hamm=hamm.*hamm'; 

% Apply hamming window to the image
img1=img1.*hamm;

% Compute fft2 of the windowed image
G=fft2(img1);
G=fftshift(G);

G_abs=abs(G);
handles.G_abs_axes2 = G_abs; % making a copy of fourier transform for plotting

% check for mode of finding the frequency filter position
Filter_Position_Auto = get(handles.AutoFilter,'value');
K0 = K0*pi;
dx = 1; 
dy = 1;

if Filter_Position_Auto == 1
    
No_X_pixel = round(N/2);
No_Y_pixel = round(M/2);
G_abs_left = zeros(N,No_Y_pixel);
G_abs_left(1:N,35:No_Y_pixel-5) = G_abs(1:N,35:No_Y_pixel-5);
maxValue=max(G_abs_left(:));
[rowOfMax, colOfMax] = find(G_abs_left == maxValue);

X_index = colOfMax;
Y_index = rowOfMax;

shift_x = -(1-X_index / No_X_pixel)*pi;    % Shift of the origin of the filter in spatial domain as a fraction of pi (Should be equal to carrier frequency)
shift_x_slider = shift_x/pi;
set(handles.FilterX,'Value',shift_x_slider);
shift_y = -(1-Y_index / No_Y_pixel)*pi;
shift_y_slider = shift_y/pi;
set(handles.FilterY,'Value',-shift_y_slider);

else

shift_x = get(handles.FilterX,'value');
shift_x = shift_x * pi;
shift_y = get(handles.FilterY,'value');
shift_y = -shift_y * pi;
    
end

handles.Filter_X = shift_x/pi;
handles.Filter_Y = shift_y/pi;
handles.Filter_D = K0/pi;

KX0 = (mod((1/2 + (0:(N-1))/N), 1) - 1/2); 
KX1 = KX0 * (2*pi/dx); 
KY0 = (mod((1/2 + (0:(M-1))/M), 1) - 1/2); 
KY1 = KY0 * (2*pi/dy); 
[KX,KY] = meshgrid(KX1,KY1); 

%Filter formulation 
lpf = ((KX-shift_x).^2 + (KY-shift_y).^2 < K0^2);
lpf = fftshift(lpf);

% Convoluting the filter with image
G=lpf.*G;

% Isolating the desired lobe

% Finding horizontal and vertical elements by scaning in 4 directions
help1=0;
scan1=zeros(N,1);

for kk=1:M
    if help1==0
        scan1=G(:,kk);
        if mean(scan1) ~= 0
            hor1=kk;
            help1=1;
        end
    end
end

help1=0;
scan1=zeros(N,1);
    
for kk=1:M
    if help1==0
        scan1=G(:,M-kk);
        if mean(scan1) ~= 0
            hor2=M-kk;
            help1=1;
        end
    end
end

help1=0;
scan2=zeros(1,hor2-hor1);

for kk=1:N
    if help1 == 0
        scan2=G(kk,:);
        if mean(scan2) ~= 0
            ver1=kk;
            help1=1;
        end
    end
end

help1=0;
scan2=zeros(1,hor2-hor1);

for kk=1:N
    if help1 == 0
        scan2=G(N-kk,:);
        if mean(scan2) ~= 0
            ver2=N-kk;
            help1=1;
        end
    end
end

lobe1_help=G(ver1:ver2,hor1:hor2);
[xxx,yyy]=size(lobe1_help);
zzz = min(xxx,yyy);
lobe1=zeros(zzz,zzz);

for ii=1:zzz
    for jj=1:zzz
        lobe1(ii,jj)=lobe1_help(ii,jj);
    end
end

handles.lobe1_axes3 = abs(lobe1);

% Taking the inverse fourier transform of the lobe ifft2
lobe1 = fftshift(lobe1);
ifft_lobe=ifft2(lobe1);

% Extracting the imaginary part
imag_ifft_lobe=imag(ifft_lobe);

abs_lobe = abs(imag_ifft_lobe); % Wavefront under test
handles.WUT_axes1 = abs_lobe; % Making a copy of the wavefront under test

% Taking arc tan of the inverse Fourier transform of the 1st lobe

% phase_lobe=2.*atan(real(ifft_lobe)./imag(ifft_lobe));
phase_lobe = angle(ifft_lobe);

phase_lobe = mod(phase_lobe+pi,2*pi)-pi;
handles.Wrapped_axes3 = phase_lobe; % Making a copy of the wrapped phase

% Unwrapping

[unwrapped] = cunwrap_nodisp(phase_lobe);

switch mode
    case 2
        unwrapped_phase = unwrapped / 2;  % Compensating for reflection path difference
    case 1
        unwrapped_phase = unwrapped;
end

Deformation = unwrapped_phase * (wave_length/(2*pi)) * 10^6; % Converting phase difference to deformations
handles.Deformation2D_axes3 = Deformation;

else  % if crop is not done 
    set(handles.CropDone,'backgroundcolor',[1 0 0]);
end

set(handles.realtime,'foregroundcolor',[0.9 0.9 0.9],'backgroundcolor',[0.9 0.9 0.9]);

handles.TimeSpent = toc;
guidata(fignum, handles);


function FTP_PlotFunc(hObject,eventdata,fignum)

handles = guidata(fignum);

set(handles.LoopTime, 'String', num2str(handles.TimeSpent));

% Plotting the captured frame
imshow(handles.im_axes1,'Parent',handles.axes1)
set(handles.axes1title,'String','Captured Frame');

% Checking the output selection checkboxes
Fourier_Plot = get(handles.FourierPlot, 'Value');
Filter_Plot = get(handles.FilterPlot, 'Value');
Reference_Plot = get(handles.ReferencePlot, 'Value');
% Wavefront_Plot = get(handles.WUTPlot, 'Value');
Fit_Plot = get(handles.Deformation_fit, 'Value');
Wrapped_Plot = get(handles.WrappedPlot, 'Value');
Deform2D_Plot = get(handles.D2Plot, 'Value');
Deform3D_Plot = get(handles.D3Plot, 'Value');
Zernike_Table = get(handles.ZernikeTable, 'Value');

% low =0;
% high =50;
% max_handles_G_abs_axes2=handles.G_abs_axes2/(max(max(handles.G_abs_axes2)));
% max_handles_G_abs_axes2=max_handles_G_abs_axes2*255;
if Fourier_Plot == 1
    GG = mat2gray(log(handles.G_abs_axes2+1));
    imshow(GG,'Parent',handles.axes2,'colormap',jet)
    set(handles.axes2title,'String','Fourier Transform');
end

if Filter_Plot == 1
    GG_lobe = mat2gray(log(handles.lobe1_axes3+1));
%     max_handles_lobe1=handles.lobe1_axes3/(max(max(handles.G_abs_axes2)));
%     max_handles_lobe1=max_handles_lobe1*255;
    imshow(GG_lobe,'Parent',handles.axes3,'colormap',jet)
    set(handles.axes3title,'String','Frequency Filtered Area');
end

if Reference_Plot == 1
    imshow(handles.ReferenceFringe_axes4,'Parent',handles.axes4)
    set(handles.axes1title,'String','Reference Fringe');
end

% if Wavefront_Plot == 1
%     set(handles.FourierPlot,'Value',0);
%     set(handles.WrappedPlot,'Value',0);
%     min_wavefront=min(min(handles.WUT_axes1));
%     wavefront_plot=handles.Wrapped_axes3+abs(min_wavefront);
%     wavefront_plot=wavefront_plot/max(max(wavefront_plot));
%     imshow(wavefront_plot,'Parent',handles.axes2)%,'colormap',jet)
%     set(handles.axes2title,'String','Wavefront under test');
% end

if Wrapped_Plot == 1
    set(handles.FourierPlot,'Value',0);
    min_wrapped=min(min(handles.Wrapped_axes3));
    wrapped_plot=handles.Wrapped_axes3+abs(min_wrapped);
    wrapped_plot=wrapped_plot/max(max(wrapped_plot));
    imshow(wrapped_plot,'Parent',handles.axes2,'colormap',jet)
    set(handles.axes2title,'String','Wrapped Phase');
end

if Deform2D_Plot == 1
    set(handles.FilterPlot,'Value',0);
    min_deform2d = min(min(handles.Deformation2D_axes3));
    deform2d_plot = handles.Deformation2D_axes3 + abs(min_deform2d);
    deform2d_plot = deform2d_plot/max(max(deform2d_plot));
    imshow(deform2d_plot,'Parent',handles.axes3,'colormap',jet)
%     colorbar(handles.axes4)
    set(handles.axes3title,'String','Membrane Deformation 2D');
end

if Deform3D_Plot == 1
    set(handles.ReferencePlot,'Value',0);
    
    Deformation = handles.Deformation2D_axes3;
    [nnn,mmm] = size(Deformation);
    K0_unwrap_mask = pi/1.07; % Radius of circular area inside the square cropped frame
    KX0 = (mod((1/2 + (0:(nnn-1))/nnn), 1) - 1/2); 
    KX1 = KX0 * (2*pi); 
    KY0 = (mod(1/2 + (0:(mmm-1))/mmm, 1) - 1/2); 
    KY1 = KY0 * (2*pi); 
    [KX,KY] = meshgrid(KX1,KY1); 
    
    % Unwrap mask formulation 
    unwrap_mask = ((KX).^2 + (KY).^2 < K0_unwrap_mask^2);
    unwrap_mask = fftshift(unwrap_mask);
    
    Deformation_mask = unwrap_mask .* Deformation;
    
    X_UW = 1:nnn;
    Y_UW = 1:mmm;
        
    [AA,BB]=meshgrid(X_UW,Y_UW);
        
    % Applying the mask to X & Y coordinates
    AA = unwrap_mask .* AA;
    BB = unwrap_mask .* BB;
        
    length_x=nnn*mmm;
    length_y=nnn*mmm;
    length_z=nnn*mmm;
        
    X=zeros(1,length_x);
    Y=zeros(1,length_y);
    Z=zeros(1,length_z);
        
    PP=1;
    for ii=1:nnn
        X(1,PP:PP+mmm-1)=AA(ii,:);
        PP=PP+mmm;
    end
        
    PP=1;
    for ii=1:nnn
        Y(1,PP:PP+mmm-1)=BB(ii,:);
        PP=PP+mmm;
    end
        
    PP=1;
    for ii=1:nnn
        Z(1,PP:PP+mmm-1)=Deformation_mask(ii,:);
        PP=PP+mmm;
    end
        
    % Extracting X & Y & Z coordinates of only the membrane
    PP=1;
    for ii=1:length_x
        if X(ii) ~= 0
            X_circ(PP) = X(ii);
            PP = PP + 1;
        end
    end
        
    PP=1;
    for ii=1:length_y
        if Y(ii) ~= 0
            Y_circ(PP) = Y(ii);
            PP = PP + 1;
        end
    end
        
    PP=1;
    for ii=1:length_z
        if Z(ii) ~= 0
            Z_circ(PP) = Z(ii);
            PP = PP + 1;
        end
    end
    mean_Z = mean(mean(Z_circ)); 
    ZZ_circ = Z_circ-mean_Z;
    tri = delaunay(X_circ,Y_circ);
    plot(X_circ,Y_circ,'.', 'Parent',handles.axes4)
    
    % Plot it with TRISURF
    h = trisurf(tri, X_circ, Y_circ, ZZ_circ, 'Parent',handles.axes4); 
    az = 0;
    el = 90;
    view(handles.axes4,az, el);
    colorbar(handles.axes4)
    colormap(handles.axes4,'jet')
    shading(handles.axes4,'flat')
    caxis(handles.axes4,[-1,1])
    set(handles.axes4, 'ZLim', [-5,5]);
    set(handles.axes4title,'String','Membrane Deformation 3D [um]');
    PeakValley = max(Z_circ) - min(Z_circ);
    PeakValley = roundn(PeakValley,-2);
    RMS_Z = rms(Z_circ);
    RMS_Z = roundn(RMS_Z,-2);
    set(handles.peak_valley, 'String', num2str(PeakValley));
    set(handles.RMS, 'String', num2str(RMS_Z));
end 

if Fit_Plot == 1
    
    set(handles.D3Plot,'Value',0);
    
    Deformation = handles.Deformation2D_axes3;
    [nnn,mmm] = size(Deformation);
    
    if mod(nnn,2) == 0
    radious = nnn/2;
    [AA,BB]=meshgrid(-radious:radious-1,-radious:radious-1);
    else
    radious = floor(nnn/2);
    [AA,BB]=meshgrid(-radious:radious,-radious:radious);
    end

%     radious = round(nnn/2) - 1;

    [THETA_pix,Rad_Pix] = cart2pol(AA,BB);
    is_in_circle = Rad_Pix<=(radious);
    Rad = Rad_Pix(is_in_circle) ./ (radious);
    THETA = THETA_pix(is_in_circle);
    
    N = []; M = []; %make zernicke indexes m,n up to 4,4
    
    for n = 0:8
        N = [N n*ones(1,n+1)];
        M = [M -n:2:n];
    end
    
    zern_coeff = zernfun(N,M,Rad,THETA); %generate zernicke polynomial values at each pair of r,theta for each n,m index
    ZernikeCoeff = zern_coeff\Deformation(is_in_circle); %fit data to Zernicke to estimate coefficient of data
    ZernikeCoeff(1:3) = 0;
    fit_def = getFitted_mod3(ZernikeCoeff,THETA,Rad); %make fit data so we can visualize

    A = AA(is_in_circle);
    B = BB(is_in_circle);

    tri = delaunay(A,B);
    plot(A,B,'.', 'Parent',handles.axes4)
    h = trisurf(tri, A, B, fit_def, 'Parent',handles.axes4); 
    az = 0;
    el = 90;
    view(handles.axes4,az, el);
    colorbar(handles.axes4)
    colormap(handles.axes4,'jet')
    shading(handles.axes4,'flat')
    caxis(handles.axes4,[-1,1])
    set(handles.axes4, 'ZLim', [-5,5]);
    set(handles.axes4title,'String','Membrane Deformation Fit [um]');
    
    PeakValley = max(fit_def) - min(fit_def);
    PeakValley = roundn(PeakValley,-2);
    RMS_Z = rms(fit_def);
    RMS_Z = roundn(RMS_Z,-2);
    set(handles.peak_valley, 'String', num2str(PeakValley));
    set(handles.RMS, 'String', num2str(RMS_Z));
    
end


if Zernike_Table == 1 
    
    if Fit_Plot == 1
       Column1 = ZernikeCoeff(4:15);
    
       bar(Column1,0.5,'Parent',handles.axes6)
       set(handles.axes6, 'YLim', [-2,2]);
       set(handles.axes6,'XTickLabel',{'AST', 'DEF', 'AST', 'TFL','CMA','CMA','TFL','QUD','2AST','SPH','2AST','QUD'})
    else
    
    Deformation = handles.Deformation2D_axes3;
    [nnn,mmm] = size(Deformation);
    
    if mod(nnn,2) == 0
    radious = nnn/2;
    [AA,BB]=meshgrid(-radious:radious-1,-radious:radious-1);
    else
    radious = floor(nnn/2);
    [AA,BB]=meshgrid(-radious:radious,-radious:radious);
    end

%     radious = round(nnn/2) - 1;

    [THETA_pix,Rad_Pix] = cart2pol(AA,BB);
    is_in_circle = Rad_Pix<=(radious);
    Rad = Rad_Pix(is_in_circle) ./ (radious);
    THETA = THETA_pix(is_in_circle);
    
    N = []; M = []; %make zernicke indexes m,n up to 4,4
    
    for n = 0:8
        N = [N n*ones(1,n+1)];
        M = [M -n:2:n];
    end
    
    zern_coeff = zernfun(N,M,Rad,THETA); %generate zernicke polynomial values at each pair of r,theta for each n,m index
    ZernikeCoeff = zern_coeff\Deformation(is_in_circle); %fit data to Zernicke to estimate coefficient of data

%     Column1 = zeros(10,1);
    Column1 = ZernikeCoeff(4:15);
    
    bar(Column1,0.5,'Parent',handles.axes6)
    set(handles.axes6, 'YLim', [-2,2]);
    set(handles.axes6,'XTickLabel',{'AST', 'DEF', 'AST', 'TFL','CMA','CMA','TFL','QUD','2AST','SPH','2AST','QUD'})
    end
end



function peak_valley_Callback(hObject, eventdata, handles)
% hObject    handle to peak_valley (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of peak_valley as text
%        str2double(get(hObject,'String')) returns contents of peak_valley as a double


% --- Executes during object creation, after setting all properties.
function peak_valley_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peak_valley (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RMS_Callback(hObject, eventdata, handles)
% hObject    handle to RMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RMS as text
%        str2double(get(hObject,'String')) returns contents of RMS as a double


% --- Executes during object creation, after setting all properties.
function RMS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SAVE.
function SAVE_Callback(hObject, eventdata, handles)
% hObject    handle to SAVE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Captured_frame = evalin('base', 'Captured_frame');
% Fourier_Domain = evalin('base', 'Fourier_Domain');
Frequency_Filter = evalin('base', 'Frequency_Filter');
Wrapped_Phase = evalin('base', 'Wrapped_Phase');
Deformation = evalin('base', 'Deformation');

uisave({'Captured_frame','Frequency_Filter','Wrapped_Phase','Deformation'})


% --- Executes on button press in loadandplot.
function loadandplot_Callback(hObject, eventdata, handles)
% hObject    handle to loadandplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiopen

f = figure('Position',[200 200 1000 450]);;

subplot(1,2,1)
min_wrapped=min(min(Wrapped_Phase));
wrapped_plot=Wrapped_Phase+abs(min_wrapped);
wrapped_plot=wrapped_plot/max(max(wrapped_plot));
imshow(wrapped_plot,'colormap',jet)
title('Wrapped Phase')
axis equal

[nnn,mmm] = size(Deformation);
K0_unwrap_mask = pi/1.07; % Radius of circular area inside the square cropped frame
KX0 = (mod((1/2 + (0:(nnn-1))/nnn), 1) - 1/2); 
KX1 = KX0 * (2*pi); 
KY0 = (mod(1/2 + (0:(mmm-1))/mmm, 1) - 1/2); 
KY1 = KY0 * (2*pi); 
[KX,KY] = meshgrid(KX1,KY1); 
    
% Unwrap mask formulation 
unwrap_mask = ((KX).^2 + (KY).^2 < K0_unwrap_mask^2);
unwrap_mask = fftshift(unwrap_mask);
    
Deformation_mask = unwrap_mask .* Deformation;
    
X_UW = 1:nnn;
Y_UW = 1:mmm;
        
[AA,BB]=meshgrid(X_UW,Y_UW);
        
% Applying the mask to X & Y coordinates
AA = unwrap_mask .* AA;
BB = unwrap_mask .* BB;
        
length_x=nnn*mmm;
length_y=nnn*mmm;
length_z=nnn*mmm;
        
X=zeros(1,length_x);
Y=zeros(1,length_y);
Z=zeros(1,length_z);
        
PP=1;
for ii=1:nnn
    X(1,PP:PP+mmm-1)=AA(ii,:);
    PP=PP+mmm;
end
        
PP=1;
for ii=1:nnn
    Y(1,PP:PP+mmm-1)=BB(ii,:);
    PP=PP+mmm;
end

PP=1;
for ii=1:nnn
    Z(1,PP:PP+mmm-1)=Deformation_mask(ii,:);
    PP=PP+mmm;
end
        
% Extracting X & Y & Z coordinates of only the membrane
PP=1;
for ii=1:length_x
    if X(ii) ~= 0
        X_circ(PP) = X(ii);
        PP = PP + 1;
    end
end
        
PP=1;
for ii=1:length_y
    if Y(ii) ~= 0
        Y_circ(PP) = Y(ii);
        PP = PP + 1;
    end
end
        
PP=1;
for ii=1:length_z
    if Z(ii) ~= 0
        Z_circ(PP) = Z(ii);
        PP = PP + 1;
    end
end
    
mean_Z = mean(mean(Z_circ));
ZZ_circ = Z_circ-mean_Z;
tri = delaunay(X_circ,Y_circ);
subplot(1,2,2)
plot(X_circ,Y_circ,'.')
   
% Plot it with TRISURF
h = trisurf(tri, X_circ, Y_circ, ZZ_circ); 
title('Deformation [um]')
az = 0;
el = 90;
view(az, el);
colorbar
colormap jet
shading flat
axis off
caxis([-0.5,0.5])
colorbar('Ticks',[-2:0.5:2])

% create the data
PeakValley = max(Z_circ) - min(Z_circ);
PeakValley = roundn(PeakValley,-2);

radious = round(nnn/2) - 1;
    
[AA,BB]=meshgrid(-radious:radious,-radious:radious);
[THETA,Rad_Pix] = cart2pol(AA,BB);
is_in_circle = Rad_Pix<=(radious-1);
Rad = Rad_Pix(is_in_circle) ./ (radious);
    
N = []; M = []; %make zernicke indexes m,n up to 4,4
    
for n = 0:8
    N = [N n*ones(1,n+1)];
    M = [M -n:2:n];
end
    
zern_coeff = zernfun(N,M,Rad,THETA(is_in_circle)); %generate zernicke polynomial values at each pair of r,theta for each n,m index
ZernikeCoeff = zern_coeff\Deformation(is_in_circle); %fit data to Zernicke to estimate coefficient of data
ZernikeCoeff(1:13);
    
d = [PeakValley ZernikeCoeff(2) ZernikeCoeff(3) ZernikeCoeff(4) ZernikeCoeff(6) ZernikeCoeff(5) ZernikeCoeff(13)];

% Create the column and row names in cell arrays 
cnames = {'Peak to Valley','Tilt X','Tilt Y','O-Astigmatism','V-Astigmatism','Defocus','Spherical'};
rnames = {'Value [um]'};

% Create the uitable
t = uitable(f,'Data',d,...
            'ColumnName',cnames,... 
            'RowName',rnames);

% Set width and height
t.Position(3) = t.Extent(3);
t.Position(4) = t.Extent(4);


% --- Executes on button press in CharacData.
function CharacData_Callback(hObject, eventdata, handles)
% hObject    handle to CharacData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base', 'Filter_X', handles.Filter_X)
assignin('base', 'Filter_Y', handles.Filter_Y)
assignin('base', 'Filter_D', handles.Filter_D)
assignin('base', 'Crop_Pix', handles.ROI_P)

Filter_X = evalin('base', 'Filter_X');
Filter_Y = evalin('base', 'Filter_Y');
Filter_D = evalin('base', 'Filter_D');
Crop_Pix = evalin('base', 'Crop_Pix');

% filename = fullfile('/home/pouya/meausre 31.05', 'Crop_and_Filter.mat');
uisave({'Filter_X','Filter_Y','Filter_D','Crop_Pix'},'Crop_and_Filter');

STOP_Callback(hObject, eventdata, handles)


% --- Executes on button press in Deformation_fit.
function Deformation_fit_Callback(hObject, eventdata, handles)
% hObject    handle to Deformation_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Deformation_fit
