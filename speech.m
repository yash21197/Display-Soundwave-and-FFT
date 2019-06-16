function varargout = speech(varargin)
%SPEECH MATLAB code file for speech.fig
%      SPEECH, by itself, creates a new SPEECH or raises the existing
%      singleton*.
%
%      H = SPEECH returns the handle to a new SPEECH or the handle to
%      the existing singleton*.
%
%      SPEECH('Property','Value',...) creates a new SPEECH using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to speech_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SPEECH('CALLBACK') and SPEECH('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SPEECH.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help speech

% Last Modified by GUIDE v2.5 26-Feb-2018 18:43:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @speech_OpeningFcn, ...
                   'gui_OutputFcn',  @speech_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before speech is made visible.
function speech_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
% Choose default command line output for speech

    global Fs;
    global nBits;
    global dataType;
    global nChannels;
    global ID;
    global timePeriod;
    global sampleSize;
    global x;
    global y;
    global x_fft;
    global y_fft;
    global x_whole;
    global y_whole;
    global xlen;
    global ylen;
    global diagram1;
    global diagram2;
    global diagram3;
    global startDuration;
    global endDuration;
    global countTime;
    global maxTime;
    global start_flag;
    global stop_flag;
    global pause_flag;
    global start_file_flag;
    global stop_file_flag;
    global pause_file_flag;
    global selectfile_flag;
    global recorder;
    global audio_player;
    
    selectfile_flag = 0;    
    
    start_flag = false;
    stop_flag = false;
    pause_flag = false;
    
    start_file_flag = false;
    stop_file_flag = false;
    pause_file_flag = false;
    
    Fs = 8000;
    nBits = 8;
    nChannels = 1;
    ID = -1;
    timePeriod = 0.2;

    sampleSize = floor(Fs*timePeriod);
    countTime = 0;
    maxTime=0.5;

    if (nBits == 8)
        dataType = 'int8';
    elseif (nBits == 16)
        dataType = 'int16';
    elseif (nBits == 24) ... or 32
        dataType = 'double';
    else
        error('Unsupported sample size of %d bits', num_bits);
    end

    recorder = audiorecorder(Fs,nBits,nChannels,ID);
    set(recorder , 'TimerPeriod' ,timePeriod);
    set(recorder , 'TimerFcn' ,{@setInterval});

    startDuration = 0;
    endDuration = maxTime;
    
    x = seconds(startDuration) : seconds(1/Fs) : seconds(endDuration);
    xlen = length(x);
    y = zeros(1,xlen,dataType);
    
    ...set speech
    axes(handles.subplot1);
    diagram1 = plot(x,y);
%    ylim([-50 50]);
    
    ...set fft
    nf=1024;
    y_fft = fft(y,nf);
    x_fft = Fs/2*linspace(0,1,nf/2+1);
    axes(handles.subplot2);
    diagram2 = plot(x_fft,abs(y_fft(1:nf/2+1)));
%    ylim([0 12000]);
        
    ...set whole speech
    axes(handles.subplot3);
    x_whole = seconds(0) : seconds(1/Fs) : seconds(0);
    y_whole = zeros(1,length(x_whole),dataType);
    diagram3 = plot(x_whole,y_whole);
%    ylim([-50 50]);
    
    set(handles.select_file,'Enable','inactive');
    set(handles.save_audio,'Enable','inactive');

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes speech wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = speech_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_audio.
function start_audio_Callback(hObject, eventdata, handles)
% hObject    handle to start_audio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global recorder;
    global Fs;
    global nBits;
    global dataType;
    global nChannels;
    global ID;
    global timePeriod;
    global sampleSize;
    global x;
    global y;
    global x_fft;
    global y_fft;
    global xlen;
    global ylen;
    global diagram1;
    global diagram2;
    global diagram3;
    global startDuration;
    global endDuration;
    global countTime;
    global maxTime;
    global start_flag;
    global stop_flag;
    global pause_flag;
    global start_file_flag;
    global stop_file_flag;
    global pause_file_flag;
    global selectfile_flag;
    global y_whole_file;
    global Fs_file;
    global audio_player;
    
    set(handles.slider,'Enable','off');
    
    if selectfile_flag
        if pause_file_flag
            resume(audio_player);
        else
            if ~start_file_flag
                play(audio_player);
            end
        end
        start_file_flag = true;
        pause_file_flag = false;
        stop_file_flag = false;
    else
        set(handles.save_audio,'Enable','inactive');
        if pause_flag
            resume(recorder);
        else
            if ~start_flag
                record(recorder);
            end
        end
        set(handles.select_file,'Enable','inactive');
        start_flag = true;
        pause_flag = false;
        stop_flag = false;
    end


function [] = setInterval(obj, event, arg)
    global recorder;
    global Fs;
    global nBits;
    global dataType;
    global nChannels;
    global ID;
    global timePeriod;
    global sampleSize;
    global x;
    global y;
    global x_fft;
    global y_fft;
    global xlen;
    global ylen;
    global diagram1;
    global diagram2;
    global diagram3;
    global startDuration;
    global endDuration;
    global startsample;
    global endsample;
    global countTime;
    global maxTime;
    global start_flag;
    global stop_flag;
    global pause_flag;
    global x_whole;
    global y_whole;
    global selectfile_flag;
    
    global countTime_file;
    global startDuration_file;
    global endDuration_file;
    global Fs_file;
    global x_file;
    global y_file;
    global x_fft_file;
    global y_fft_file;
    global x_whole_file;
    global y_whole_file;
    global file_duration;
    global start_file_flag;
    global pause_file_flag;
    global stop_file_flag;
    global audio_player;
        
    if selectfile_flag
        
        if ~isplaying(obj)
            return;
        end
        try
            countTime_file = countTime_file + timePeriod;
            
            if countTime_file > file_duration
                set(arg.slider,'Enable','on');
                set(arg.slider,'Value',0);
                stop(audio_player);
                start_file_flag = false;
                pause_file_flag = false;
                stop_file_flag = true;
                
                countTime_file = 0;
                
                x_file = seconds(0) : seconds(1/Fs_file) : seconds(maxTime);
                y_file = zeros(1,length(x_file));
                nf=1024;
                y_fft_file = fft(y_file,nf);
                x_fft_file = Fs_file/2*linspace(0,1,nf/2+1);
                set(diagram1,'XData',x_file,'YData',y_file);
                set(diagram2,'XData',x_fft_file,'YData',abs(y_fft_file(1:nf/2+1)));
                return;
            end
            
            if countTime_file >= maxTime
                startDuration_file = startDuration_file + timePeriod;
                endDuration_file = endDuration_file + timePeriod;
                x_file = seconds(startDuration_file) : seconds(1/Fs_file) : seconds(endDuration_file+(1/Fs_file));
            end
            
            endsample_file = floor(countTime_file*Fs_file);
            startsample_file = endsample_file - (maxTime*Fs_file);

            if startsample_file < 1
                startsample_file = 1;
            end

            y_file = y_whole_file(startsample_file:endsample_file);
            xlen_file = length(x_file);
            ylen_file = length(y_file);

            if ylen_file < xlen_file
                y_file = [y_file, zeros(1,xlen_file-ylen_file)];
            end

            ...set speech
            set(diagram1,'XData',x_file,'YData',y_file);
            ...set fft
            nf=1024;
            y_fft_file = fft(y_file,nf);
            x_fft_file = Fs_file/2*linspace(0,1,nf/2+1);
            set(diagram2,'XData',x_fft_file,'YData',abs(y_fft_file(1:nf/2+1)));
        catch
            stop(obj);
            start_file_flag = false;
            pause_file_flag = false;
            stop_file_flag = true;
            rethrow(lasterror);
        end
    else
        if ~isrecording(obj)
            return;
        end
        try
            countTime = countTime + timePeriod;

            if countTime >= maxTime
                startDuration = startDuration + timePeriod;
                endDuration = endDuration + timePeriod;
                x = seconds(startDuration) : seconds(1/Fs) : seconds(endDuration+(1/Fs));
            end

            endsample = floor(countTime*Fs);
            startsample = endsample - (maxTime*Fs);

            if startsample < 1
                startsample = 1;
            end

            samples = getaudiodata(obj,dataType);
            y = samples(startsample:endsample)';
            xlen = length(x);
            ylen = length(y);

            if ylen < xlen
                y = [y, zeros(1,xlen-ylen)];
            end

            ...set speech
            set(diagram1,'XData',x,'YData',y);
            ...set fft
            nf=1024;
            y_fft = fft(y,nf);
            x_fft = Fs/2*linspace(0,1,nf/2+1);
            set(diagram2,'XData',x_fft,'YData',abs(y_fft(1:nf/2+1)));
            ...set whole speech
            y_whole = samples(1:endsample)';
            x_whole = seconds(0) : seconds(1/Fs) : seconds((endsample-1)/Fs);
            set(diagram3,'XData',x_whole,'YData',y_whole);
        catch
            stop(obj);
            set(arg.save_audio,'Enable','on');
            start_flag = false;
            pause_flag = false;
            stop_flag = true;
            rethrow(lasterror);
        end
    end

% --- Executes on button press in pause_audio.
function pause_audio_Callback(hObject, eventdata, handles)
% hObject    handle to pause_audio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global recorder;
    global audio_player;
    global pause_flag;
    global start_flag;
    global stop_flag;
    global pause_file_flag;
    global start_file_flag;
    global stop_file_flag;
    global selectfile_flag;
    
    if selectfile_flag
        if start_file_flag
            set(handles.slider,'Enable','on');
            set(handles.slider,'Value',0);
            pause(audio_player);
            pause_file_flag = true;
            start_file_flag = false;
            stop_file_flag = false;
        end
    else
        if start_flag
            set(handles.save_audio,'Enable','on');
            set(handles.slider,'Enable','on');
            set(handles.slider,'Value',0);
            pause(recorder);
            pause_flag = true;
            start_flag = false;
            stop_flag = false;
            temp = get(handles.file_selector,'String');
            
            if strcmp('select file',temp)
                set(handles.select_file,'Enable','inactive');
            else
                set(handles.select_file,'Enable','on');
            end
        end
    end
    
% --- Executes on button press in stop_audio.
function stop_audio_Callback(hObject, eventdata, handles)
% hObject    handle to stop_audio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global recorder;
    global audio_player;
    global stop_flag;
    global start_flag;
    global pause_flag;
    global stop_file_flag;
    global start_file_flag;
    global pause_file_flag;
    global startDuration;
    global endDuration;
    global diagram1;
    global diagram2;
    global diagram3;
    global x;
    global y;
    global xlen;
    global ylen;
    global dataType;
    global x_fft;
    global y_fft;
    global maxTime;
    global Fs;
    global countTime;
    global x_whole;
    global y_whole;
    global selectfile_flag;
    
    global x_file;
    global y_file;
    global x_fft_file;
    global y_fft_file;
    global x_whole_file;
    global y_whole_file;
    global Fs_file;
    global countTime_file;
    
    if selectfile_flag
        set(handles.slider,'Enable','on');
        set(handles.slider,'Value',0);
        stop(audio_player);
        stop_file_flag = true;
        start_file_flag = false;
        pause_file_flag = false;

        x_file = seconds(0) : seconds(1/Fs_file) : seconds(maxTime);
        y_file = zeros(1,length(x_file));
        nf=1024;
        y_fft_file = fft(y_file,nf);
        x_fft_file = Fs_file/2*linspace(0,1,nf/2+1);
        set(diagram1,'XData',x_file,'YData',y_file);
        set(diagram2,'XData',x_fft_file,'YData',abs(y_fft_file(1:nf/2+1)));
        countTime_file = 0;
    else
        set(handles.slider,'Enable','off');
        set(handles.save_audio,'Enable','inactive');
        stop(recorder);
        stop_flag = true;
        start_flag = false;
        pause_flag = false;

        startDuration = 0;
        endDuration = maxTime;
        countTime = 0;

        x = seconds(startDuration) : seconds(1/Fs) : seconds(endDuration);
        xlen = length(x);
        y = zeros(1,xlen,dataType);

        ...set speech
        set(diagram1,'XData',x,'YData',y);    
        ...set fft
        nf=1024;
        y_fft = fft(y,nf);
        x_fft = Fs/2*linspace(0,1,nf/2+1);
        set(diagram2,'XData',x_fft,'YData',abs(y_fft(1:nf/2+1)));
        ...set whole speech
        x_whole = seconds(0):seconds(1/Fs):seconds(0);
        y_whole = zeros(1,length(x_whole),dataType);
        set(diagram3,'XData',x_whole,'YData',y_whole);

        temp = get(handles.file_selector,'String');

        if strcmp('select file',temp)
            set(handles.select_file,'Enable','inactive');
        else
            set(handles.select_file,'Enable','on');
        end
    end
    


% --- Executes on button press in select_file.
function select_file_Callback(hObject, eventdata, handles)
% hObject    handle to select_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global selectfile_flag;
    global file;
    global recorder;
    global dataType;
    global startsample;
    global endsample;
    global x;
    global y;
    global xlen;
    global ylen;
    global diagram1;
    global diagram2;
    global diagram3;
    global x_fft;
    global y_fft;
    global x_whole;
    global y_whole;
    global Fs;
    global startDuration;
    global endDuration;
    global maxTime;
    global x_file;
    global y_file;
    global x_fft_file;
    global y_fft_file;
    global x_whole_file;
    global y_whole_file;
    global Fs_file;
    global audio_player;
    global timePeriod;
    global countTime_file;
    global startDuration_file;
    global endDuration_file;
    global file_duration;
    
    selectfile_flag = get(handles.select_file,'Value');
    if selectfile_flag
        set(handles.save_audio,'Visible','off');
        set(handles.open_file,'Enable','inactive');
        set(handles.slider,'Enable','on');
        set(handles.slider,'Value',0);
        file = get(handles.file_selector , 'String');
        try
            info = audioinfo(file);
            [y_whole_file,Fs_file] = audioread(file);
            audio_player = audioplayer(y_whole_file,Fs_file);
            countTime_file = 0;
            startDuration_file = 0;
            endDuration_file = maxTime;
            file_duration = info.Duration;
            set(audio_player , 'TimerPeriod' ,timePeriod);
            set(audio_player , 'TimerFcn' ,{@setInterval,handles});
            x_file = seconds(0) : seconds(1/Fs_file) : seconds(maxTime);
            y_file = zeros(1,length(x_file));
            set(diagram1,'XData',x_file,'YData',y_file);
            
            nf=1024;
            y_fft_file = fft(y_file,nf);
            x_fft_file = Fs_file/2*linspace(0,1,nf/2+1);
            set(diagram2,'XData',x_fft_file,'YData',abs(y_fft_file(1:nf/2+1)));
            
            x_whole_file = seconds(0) : seconds(1/Fs_file) : seconds(file_duration - (1/Fs_file));
            y_whole_file = y_whole_file(:,1)';
            set(diagram3,'XData',x_whole_file,'YData',y_whole_file);
        catch
            disp(lasterror);
        end
    else
        set(handles.save_audio,'Visible','on');
        set(handles.open_file,'Enable','on');
        set(handles.slider,'Enable','off');
        x = seconds(startDuration) : seconds(1/Fs) : seconds(endDuration+(1/Fs));
        if recorder.TotalSamples
            samples = getaudiodata(recorder,dataType);
            y = samples(startsample:endsample)';
            xlen = length(x);
            ylen = length(y);

            if ylen < xlen
                y = [y, zeros(1,xlen-ylen)];
            end

            ...set whole speech
            y_whole = samples(1:endsample)';
            x_whole = seconds(0) : seconds(1/Fs) : seconds((endsample-1)/Fs);
        else
            xlen = length(x);
            y = zeros(1,xlen,dataType);
            ...set whole speech
            x_whole = seconds(0) : seconds(1/Fs) : seconds(0);
            y_whole = zeros(1,length(x_whole),dataType);
        end
        ...set fft
        nf=1024;
        y_fft = fft(y,nf);
        x_fft = Fs/2*linspace(0,1,nf/2+1);
        set(diagram1,'XData',x,'YData',y);
        set(diagram2,'XData',x_fft,'YData',abs(y_fft(1:nf/2+1)));
        set(diagram3,'XData',x_whole,'YData',y_whole);        
    end

% Hint: get(hObject,'Value') returns toggle state of select_file


% --- Executes on button press in open_file.
function open_file_Callback(hObject, eventdata, handles)
% hObject    handle to open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global filename;
    global pathname;
    [filename , pathname] = uigetfile({'*.wav'},'File Selector');
    if pathname
        set(handles.file_selector,'String',pathname+'\'+filename);
    end
    
    temp = get(handles.file_selector,'String');

    if strcmp('select file',temp)
        set(handles.select_file,'Enable','inactive');
    else
        set(handles.select_file,'Enable','on');
    end


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global diagram1;
    global diagram2;
    global x;
    global y;
    global x_fft;
    global y_fft;
    global x_file;
    global y_file;
    global x_fft_file;
    global y_fft_file;
    global file_duration;
    global selectfile_flag;
    global countTime;
    global Fs;
    global maxTime;
    global recorder;
    global dataType;
    global Fs_file;
    global y_whole_file;
    global y_whole;
    
    slider_val = get(handles.slider,'Value');
    
    try
        if selectfile_flag
            show_time = file_duration*slider_val;
            
            if show_time >= maxTime
                start_Duration = show_time - maxTime;
                end_Duration = show_time;
                x_file = seconds(start_Duration) : seconds(1/Fs_file) : seconds(end_Duration+(1/Fs_file));
            end

            endsample = floor(show_time*Fs_file);
            startsample = endsample - (maxTime*Fs_file);

            if startsample < 1
                startsample = 1;
            end
            
            y_file = y_whole_file(startsample:endsample);
            xlen_file = length(x_file);
            ylen_file = length(y_file);

            if ylen_file < xlen_file
                y_file = [y_file, zeros(1,xlen_file-ylen_file)];
            end

            nf=1024;
            y_fft_file = fft(y_file,nf);
            x_fft_file = Fs_file/2*linspace(0,1,nf/2+1);

            set(diagram1,'XData',x_file,'YData',y_file);
            set(diagram2,'XData',x_fft_file,'YData',abs(y_fft_file(1:nf/2+1)));
            
        else
            show_time = countTime*slider_val;
            
            if show_time >= maxTime
                start_Duration = show_time - maxTime;
                end_Duration = show_time;
                x = seconds(start_Duration) : seconds(1/Fs) : seconds(end_Duration+(1/Fs));
            end

            endsample = floor(show_time*Fs);
            startsample = endsample - (maxTime*Fs);

            if startsample < 1
                startsample = 1;
            end

            y = y_whole(startsample:endsample);
            xlen = length(x);
            ylen = length(y);

            if ylen < xlen
                y = [y, zeros(1,xlen-ylen)];
            end

            nf=1024;
            y_fft = fft(y,nf);
            x_fft = Fs/2*linspace(0,1,nf/2+1);
            
            set(diagram1,'XData',x,'YData',y);
            set(diagram2,'XData',x_fft,'YData',abs(y_fft(1:nf/2+1)));
        end
    catch
    end
    
    
... error in length of fft of x and y


% --- Executes on button press in save_audio.
function save_audio_Callback(hObject, eventdata, handles)
% hObject    handle to save_audio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global recorder;
    global Fs;
    global nBits;
    global dataType;
    
    disp('save');

    filename = 'lastspeech.wav';
    if dataType=='int8'
        d_t = 'uint8';
    else
        d_t = dataType;
    end
    audiowrite(filename,getaudiodata(recorder,d_t),Fs,'BitsPerSample',nBits);
