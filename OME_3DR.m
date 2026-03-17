function varargout = OME_3DR(varargin)
    % OME_3DR MATLAB code for OME_3DR.fig
    %      OME_3DR, by itself, creates a new OME_3DR or raises the existing
    %      singleton*.
    %
    %      H = OME_3DR returns the handle to a new OME_3DR or the handle to
    %      the existing singleton*.
    %
    %      OME_3DR('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in OME_3DR.M with the given input arguments.
    %
    %      OME_3DR('Property','Max',...) creates a new OME_3DR or raises the
    %      existing singleton*.  Starting from the left, property max pairs are
    %      applied to the GUI before OME_3DR_OpeningFcn gets called.  An
    %      unrecognized property name or invalid max makes property application
    %      stop.  All inputs are passed to OME_3DR_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools Menus.  Choose "GUI allows only allcmds
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help OME_3DR

    % Last Modified by GUIDE v2.5 13-Jan-2018 14:45:33

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @OME_3DR_OpeningFcn, ...
                       'gui_OutputFcn',  @OME_3DR_OutputFcn, ...
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
function varargout = OME_3DR_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
function OME_3DR_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to OME_3DR (see VARARGIN)
    handles.output = hObject;% Choose default command line output for OME_3DR
    %{
    javaFrame = get(hObject, 'JavaFrame');
    javaFrame.setFigureIcon(javax.swing.ImageIcon('OME_3DR_icon.ico'));
    %}
    guidata(hObject, handles);  % Update handles structure
    % UIWAIT makes OME_3DR wait for user response (see UIRESUME)
    % uiwait(handles.figure);
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    D3R_new(handles,false);
%****************************************
function RecentProjects_Close_Callback(hObject, eventdata, handles)
% hObject    handle to RecentProjects_Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.RecentProjects.Visible='off';
function Recents_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Recents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Recents_Callback(hObject, eventdata, handles)
% hObject    handle to Recents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Recents contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Recents
    persistent stat;
    try
        hObject=handles.Recents;
        contents=get(hObject,'String');
        if strcmp(handles.RecentProjects.Title,'Information')
            if isempty(contents)
                msgShow(handles,1,'M> no ''Information''');
            else
                index=get(hObject,'Value');
                index=index(1);
                contents=cellstr(contents);
                info=contents{index};
                msgShow(handles,1,info);
                return;
            end
        else
            if isempty(contents)
                msgShow(handles,1,'M> no [Project]');
            else
                index=get(hObject,'Value');
                index=index(1);
                if stat==index
                    stat=[];
                else
                    stat=index;
                    return;
                end
                %---
                contents=cellstr(contents);
                filePath=contents{index};
                if exist(filePath)~=2
                    msgShow(handles,2,'M> does''t exist');
                    return;
                end
                %---
                if ~D3R_other(handles,filePath,false);return;end;
                tmpShow(handles,handles.RecentProjects,'Visible',{'off','on'},3);
            end
        end
    catch
        msgShow(handles,2,['E> ',lasterr]);
    end
function Recents_show(handles)
    set(handles.Recents,'String','','Value',1);
    prjs=D3R_project(handles);
    %---
    set(handles.Recents,'String',prjs,'Value',1);
    handles.RecentProjects.TitlePosition='lefttop';
    handles.RecentProjects.Title='Recent Projects';
    handles.RecentProjects.Visible='on';
function returnInfo=Info_show(handles,ifShow)
    global Menus Records;
    %-----------------------
    if ifShow
        set(handles.Recents,'String','','Value',1);
        handles.RecentProjects.TitlePosition='centertop';
        handles.RecentProjects.Title='Information';
        handles.RecentProjects.Visible='on';
    end
    %-----------------------
    try
    switch Records.file.fileType
        case {'Project','D3R'}
            info={
                [9,'3.1>(as below)'];
                };
        case 'Image'
            info={
                [9,'3.1>ImageWidth:',9,num2str(size(Records.raw,2)),9,'pixel'];
                [9,'3.2>ImageHeight:',9,num2str(size(Records.raw,1)),9,'pixel'];
                [9,'3.3>ChannelsPerPixel:',9,num2str(size(Records.raw,3)),9,'channel'];
                [9,'3.4>BitsPerChannel:',9,num2str(1),9,class(Records.raw)];
                [9,'3.5>BitsPerPixel:',9,num2str(size(Records.raw,3)),9,class(Records.raw)];
                };
        case 'Microscopy'
            info={
                [9,'3.1>Series:',9,num2str(Menus.reader.getSeriesCount)];
                [9,'3.2>Time:',9,num2str(Menus.reader.getSizeT)];
                [9,'3.3>Channel:',9,num2str(Menus.reader.getSizeC)];
                [9,'3.4>Zaxis:',9,num2str(Menus.reader.getSizeZ)];
                [9,'3.5>Yaxis:',9,num2str(size(Records.raw,1))];
                [9,'3.6>Xaxis:',9,num2str(size(Records.raw,2))];
                [9,'3.7>PPUnit(XYZ):',9,num2str(Records.D3.shape.ppu,'%1.3f, ')];
                [9,'3.8>Unit(XYZ):',Records.D3.shape.unit];
                [9,'3.9>CoreMetaData:',9,'(',char(Menus.reader.getFormat),')',13,char(Menus.reader.getCoreMetadataList)]
                };
        case 'Video'
            info={
                [9,'3.1>VideoFormat:',9,Menus.reader.VideoFormat];
                [9,'3.2>FramesNumber:',9,num2str(Menus.reader.NumberOfFrames)];
                [9,'3.3>FramesRate:',9,num2str(Menus.reader.FrameRat)];
                };
        otherwise
            info={'> Nothing, please do as follow:';
                '1. please ''Open'' or ''Create'' a project';
                '2. please ''Open'' a file;'
                };
            set(handles.Recents,'String',info,'Value',1);
            return;
    end
    catch
            info={'> Nothing, please do as follow:';
                '1. please ''Open'' or ''Create'' a project';
                '2. please ''Open'' a file;'
                };
            set(handles.Recents,'String',info,'Value',1);
            return;
    end
    %-----------------------
    if isempty(Records.file.projectPath)
        project=Records.file.projectTitle;
    else
        project=Records.file.projectPath;
    end
    info=[
    '1.Project(Data):';
    [9,'1.1>Project:',9,project];
    [9,'1.2>WorkSpace:',9,Records.file.rootPath];
    [9,'1.3>FilePath:',9,Records.file.filePath];
    [9,'1.4>DataType:',9,Records.file.fileType];
    ' ';
    '2.Project(D3R)';
    [9,'2.1>Center:',9,num2str(Records.D3.shape.center,'%1.3f, ')];
    [9,'2.2>Width:',9,num2str(Records.D3.shape.width)];
    [9,'2.3>Height:',9,num2str(Records.D3.shape.height)];
    [9,'2.4>Thickness(XY/Z):',9,num2str(Records.D3.shape.thickness)];
    [9,'2.5>Polar(number):',9,num2str(Records.D3.shape.polarnum)];
    [9,'2.6>Source(start:end):',9,num2str(Records.D3.source.start),9,':',9,num2str(Records.D3.source.end)];
    [9,'2.7>Target(start:end):',9,num2str(Records.D3.viewer.start),9,':',9,num2str(Records.D3.viewer.end)];
    [9,'2.8>PPUnit(XYZ):',9,num2str(Records.D3.shape.ppu,'%1.3f, ')];
    [9,'2.9>Unit(XYZ):',Records.D3.shape.unit];
    ' ';
    ['3.Outline(',Records.file.fileType,'):'];
    info;
    ' ';
    '4.Other(Last Image):';
    [9,'4.1>ImageWidth:',9,num2str(size(Records.img,2)),9,'pixel'];
    [9,'4.2>ImageHeight:',9,num2str(size(Records.img,1)),9,'pixel'];
    [9,'4.3>ChannelsPerPixel:',9,num2str(size(Records.img,3)),9,'channel'];
    [9,'4.4>BitsPerChannel:',9,num2str(1),9,class(Records.img)];
    [9,'4.5>BitsPerPixel:',9,num2str(size(Records.img,3)),9,class(Records.img)];
    ];
    %-----------------------
    if ifShow
        set(handles.Recents,'String',info,'Value',1);
    else
        returnInfo=info;
    end
%****************************************
function Recents_Menus_Callback(hObject, eventdata, handles)
function Recents_Menus_Clear_Callback(hObject, eventdata, handles)
function Recents_Menus_Clear_Selected_Callback(hObject, eventdata, handles)
    index=lstRemove(handles.Recents,handles);
    if ~all(index);return;end;
    prjs=get(handles.Recents,'String');
    D3R_project(handles,prjs);
function Recents_Menus_Clear_Down_Callback(hObject, eventdata, handles)
    index=lstRemoveDowns(handles.Recents,handles);
    if ~all(index);return;end;
    prjs=get(handles.Recents,'String');
    D3R_project(handles,prjs);
function Recents_Menus_Clear_All_Callback(hObject, eventdata, handles)
    lstEmpty(handles.Recents);
    prjs=get(handles.Recents,'String');
    D3R_project(handles,prjs);
%
function Recents_Menus_Data_Callback(hObject, eventdata, handles)
    if strcmp(handles.RecentProjects.Title,'Information')
        handles.Recents_Menus_Data_AddFile.Visible='off';
    else
        handles.Recents_Menus_Data_AddFile.Visible='on';
    end
function Recents_Menus_Data_Import_Callback(hObject, eventdata, handles)
    if strcmp(handles.RecentProjects.Title,'Information')
        suffix='info';
    else
        suffix='prjs';
    end
    number=lstImport(suffix,handles.Recents,handles);
    if ~number;return;end;
    prjs=get(handles.Recents,'String');
    D3R_project(handles,prjs);
function Recents_Menus_Data_AddFile_Callback(hObject, eventdata, handles)
    hObj=handles.Recents;
    Prjs=cellstr(get(hObj,'String'));
    if isequal(Prjs,{''});Prjs={};end;
    %
    Fs={};
    prjs=D3R_project(handles);
    if numel(prjs)
        prj=prjs{1};
        [startdir,file]=fileparts(prj);
    else
        startdir=ctfroot;
    end
    rootpath=uigetdir(startdir);
    if rootpath==0;return;end;
    fs=subDFs(rootpath,'p');
    for i=1:numel(fs)
        filePath=fs{i};
        [pathstr, name, fi] = fileparts(filePath);
        suffix=lower(fi(2:length(fi)));
        if strcmp(suffix,'omed3r');Fs=[Fs;filePath];end;
    end
    %
    Prjs=[Prjs;Fs];
    set(hObj,'String',Prjs,'Value',numel(Prjs));
    D3R_project(handles,Prjs);
function Recents_Menus_Data_Export_Callback(hObject, eventdata, handles)
    if strcmp(handles.RecentProjects.Title,'Information')
        suffix='info';
    else
        suffix='prjs';
    end
    lstExport(suffix,handles.Recents,handles);
%****************************************
function prjs=D3R_project(handles,prjs)
    path=fullfile(matlabroot,'.OME_3DR');
    if ~isdir(path);createDir(handles,path);end;
    ini=fullfile(path,'.OME_3DR.ini');
    if nargin>1%set prjpath
        if strcmp(prjs,'path')%only path
            prjs=path;
            return;
        elseif isempty(prjs)%set clear
        elseif ischar(prjs)%set one
            ps=D3R_project(handles);
            prjs=[prjs;ps(~ismember(ps,prjs))];
        else%set all
        end
        save(ini,'prjs','-mat');
    else%get prjpath
        if exist(ini)==2
            load(ini,'prjs','-mat');
            if ischar(prjs)
                prjs={prjs};
            end
        else
            prjs={};
        end
    end
%-------------
function D3R_import(handles,filePath)
    global Records;
    %----------------
    try
        if nargin<2||isempty(filePath)
            suffix='OMEd3r';
            [file,dir]=uigetfile(strcat('*.',suffix),'Input File ...');
            if ~file;return;end;
            filePath=strcat(dir,file);
        end
        %-------------
        load(filePath,'VAR','-mat');
        VARrecords=VAR.records;
        Records=VARrecords;
        %-------------
        [dirpath, title, suffix] = fileparts(filePath);
        VARrecords.file.projectTitle=['OME:3DR-',title];
        VARrecords.file.projectPath=filePath;
        if isempty(VARrecords.file.rootPath)
            msgShow(handles,2,'M> empty project');
            %---
            Records=VARrecords;
            Open_init(handles);
            return;
        end
        Dirs_init(handles,VARrecords.file.rootPath);
        cel=VAR.items;
        %-------------
        item=cel{1};
        if ~numel(item)
            find=false;
        else
            hobj=handles.Dirs;
            strs=get(hobj,'String');
            find=false;
            item=item{cel{2}};
            for i=1:length(strs)
                if strcmp(strs{i},item);
                    find=i;
                    break;
                end
            end
        end
        if find
            set(hobj,'Value',find);
            Files_init(handles,item);
            %
            item=cel{3};
            if ~numel(item)
                find=false;
            else
                hobj=handles.Files;
                strs=get(hobj,'String');
                find=false;
                item=item{cel{4}};
                for i=1:length(strs)
                    if strcmp(strs{i},item);
                        find=i;
                        break;
                    end
                end
            end
            if find
                set(hobj,'Value',find);
            else
                set(hobj,'Value',1);
            end
        else
            set(hobj,'Value',1);
        end
        %
        set(handles.Commands,'String',cel{5},'Value',cel{6});
        set(handles.Records,'String',cel{7},'Value',cel{8});
        %-------------
        Open_init(handles);
        %-------------%-------------%-------------
        if exist(VARrecords.file.readerPath)==2
            Records.file.readerPath='';%>>>for Menus.reader
            paras=VARrecords.viewer.paras;
            d3paras=VARrecords.D3.viewer.paras;
            file=VARrecords.file.readerPath;
            [path,name,suffix]=fileparts(file);
            if strcmpi(suffix,'.d3r')%D3R file
                Dir_File_read(handles,file,paras,false,true);
            elseif isequal(paras,d3paras)%source file + d3r
                Dir_File_read(handles,file,[],false,false);
            else%source
                Dir_File_read(handles,file,paras,false,true);
            end
        end
        %-------------%-------------%-------------
        set(handles.Functions,'String',VAR.string{1});set(handles.Functions,'Value',VAR.value{1});
        set(handles.Menus,'String',VAR.string{2});set(handles.Menus,'Value',VAR.value{2});
        set(handles.Parameters,'String',VAR.string{3});set(handles.Parameters,'Value',VAR.value{3});
        set(handles.Values,'String',VAR.string{4});
        set(handles.Changes,'Min',VAR.value{4},'Max',VAR.value{5},'SliderStep',VAR.value{6});set(handles.Changes,'Value',VAR.value{7});     
        set(handles.Functions,'Enable',VAR.enable{1});set(handles.Menus,'Enable',VAR.enable{2});set(handles.Parameters,'Enable',VAR.enable{3});set(handles.Values,'Enable',VAR.enable{4});set(handles.Changes,'Enable',VAR.enable{5});
        %%%
        Functions_switch(handles,'Functions',VAR.value{1});
        Functions_switch(handles,'Menus',VAR.value{2});
        Functions_switch(handles,'Parameters',VAR.value{3});
        %%%
        if isvalid(VAR.Figures);
            delete(handles.Figures);
            handles.Figures=VAR.Figures;
            handles.Figures.Parent=handles.Main;
            guidata(handles.Figures, handles);
            colors=VARrecords.D3.colormap;
            colormap(colors);
        end;
        if isvalid(VAR.Windows);
            delete(handles.Windows);
            handles.Windows=VAR.Windows;handles.Windows.Parent=handles.Main;
            guidata(handles.Windows, handles);
            colors=VARrecords.D3.colormap;
            colormap(colors);
        end;
        D3R_switch(handles,VAR.FiguresWindows);
        view(handles.Figures,VAR.view);
        %-------------
        D3R_project(handles,filePath);
        %-------------
        while ~isdir(Records.file.rootPath)
            rtn=questdlg({'[WorkSpace] doesn''t exist:',['>>> ',Records.file.rootPath],'','Please point the [WorkSpace] ?'},'Attention:','OK','OK');
            Dir_File_open([], [], handles);
        end
    catch
        msgShow(handles,2,['E> (import)> ',lasterr]);
        freeShow(handles);
        D3R_new(handles,false);
    end
function D3R_export(handles,filePath)
    global Menus Records;
    %----------------
    try
        if nargin<1 || isempty(filePath)
            suffix='OMEd3r';
            [file,dir]=uiputfile(strcat('*.',suffix),'Ouput File ...');
            if ~file;return;end;
            filePath=strcat(dir,file);
        end
        [dirpath, title, suffix] = fileparts(filePath);
        Records.file.projectTitle=['OME:3DR-',title];
        Records.file.projectPath=filePath;
        %---
        Records.D3.colormap=colormap();
        %-------------
        VAR=struct();
        VAR.records=Records;
        cel=cell(1,8);
        obj={handles.Dirs,handles.Files,handles.Commands,handles.Records};
        for i=1:length(obj)
            hobj=obj{i};
            strs=get(hobj,'String');
            stri=get(hobj,'Value');
            cel{2*i-1}=strs;
            cel{2*i}=stri;
        end
        VAR.items=cel;
        %-------------
        VAR.string={get(handles.Functions,'String'),get(handles.Menus,'String'),get(handles.Parameters,'String'),get(handles.Values,'String')};
        VAR.value={get(handles.Functions,'Value'),get(handles.Menus,'Value'),get(handles.Parameters,'Value'),get(handles.Changes,'Min'),get(handles.Changes,'Max'),get(handles.Changes,'SliderStep'),get(handles.Changes,'Value')};
        freeShow(handles);
        VAR.enable={get(handles.Functions,'Enable'),get(handles.Menus,'Enable'),get(handles.Parameters,'Enable'),get(handles.Values,'Enable'),get(handles.Changes,'Enable')};
        busyShow(handles);
        %%%
        VAR.FiguresWindows=D3R_switch(handles,[]);
        VAR.Figures=handles.Figures;
        VAR.Windows=handles.Windows;
        if VAR.FiguresWindows;ax=handles.Figures;else;ax=handles.Windows;end;
        [a,b]=view(ax);VAR.view=[a,b];
        %-------------
        save(filePath,'VAR','-mat');
        %-------------
        D3R_project(handles,filePath);
    catch
        msgShow(handles,2,['E> (export)> ',lasterr]);
    end
%-------------
function D3R_new(handles,ifask)
    global Records;
    %%%
    if ifask && ~isempty(Records.file.projectPath)
            rtn=questdlg({'Current Project:',['>>> ',Records.file.projectPath],'','Before opening new project, would you save current project ?'},'Attention:','Yes','No','Cancel','Yes');
            switch rtn
                case 'Yes'
                    D3R_export(handles,Records.file.projectPath);
                case 'No'
                case 'Cancel'
                    return;
            end
    end
    %%%
    clear global;
    D3R_init(handles);
function goon=D3R_other(handles,filePath,ifback)
    global Menus Records;
    %%%
        goon=true;
        if isempty(Records.file.projectPath)
            rtn=questdlg({'Open Project:',['>>> ',filePath],'','Are you sure to open the project ?'},'Attention:','Yes','No','Yes');
            switch rtn
                case 'Yes'
                    D3R_import(handles,filePath);
                case 'No'
                    goon=false;
                    return;
            end
        else
            rtn=questdlg({'Current Project:',['>>> ',Records.file.projectPath],'Open Project:',['>>> ',filePath],'','Before opening the project, would you save current project ?'},'Attention:','Yes','No','Cancel','Yes');
            switch rtn
                case 'Yes'
                    D3R_export(handles,Records.file.projectPath);
                    D3R_import(handles,filePath);
                case 'No'
                    D3R_import(handles,filePath);
                case 'Cancel'
                    if ifback;Records.file=Menus.file;end;
                    goon=false;
                    return;
            end
        end
function D3R_init(handles)
    %----------------------------
    %Form=figure('NumberTitle', 'off', 'Name', Commands.file.projectTitle);
    %copyobj(allchild(handles.Form),Form);
    %clear global;
    %imshow(frame2im(getframe(handles.Figures)));
    %plot3(1000,1000,1000);
    %[X,Y,Z] = peaks(25);
    %surf(X,Y,Z);
    if ~isdeployed;addpath('./bioformats');end;
    bfInitLogging;
    %----------------------------
    global Handles; Handles=handles;
    global Menus; Menus= struct(...
        'Functions','Functions',...
        'FunctionsIndex',1,...
        'Menus','Menus',...
        'MenusIndex',1,...
        'Parameters','Parameters',...
        'ParametersIndex',1,...
        'Keys','',...
        'FiguresPosition',[0.06,0.06,0.88,0.88],...
        'WindowsPosition',[0.64,0,0.32,0.032],...
        'reader',struct(),...
        'busy',[],...
        'command',struct(...
                'loop',0 ,...
                'index',0 ...
                ),...
        'clipboard',struct(...
                'copy',[]...
                ),...
        'container',struct(...
                'map',containers.Map(),...
                'polars',[],...
                'tracking',struct('centroid',[],'convexhull',[])...
                ),...
        'RepeatSmoothRatio',0.99...
    );
    global Records; Records= struct(...
        'file',struct(...
                'projectTitle','OME:3DR-untitled',...
                'projectPath','',...
                'rootPath','',...
                'dirName','',...
                'readerPath','',...%>>>reader
                'filePath','',...%>>>select
                'fileName','',...%>>>info
                'fileSuffix','',...
                'fileType',''...
                ),...
        'raw',[],...
        'img',[],...
        'imgs',{{}},...
        'commands',struct('String',{{}},'Value',[],'Color',[]),...
        'xys',[],...
        'xyzs',[],...
        'record','',...
        'viewer',struct('index',1,'start',1,'end',1,'paras',struct(),'label',''),...
        'scanner',[],...
        'D3V',struct(...
                'Caxis',[1],...
                'Caxis_mixIndex',[1],...
                'Caxis_mixColor',[1],...
                'Caxis_mixRatio',[1],...
                'Caxis_mixMethod',[1]...                
                ),...
        'D3',struct(...
                'source',struct('file','','start',0,'end',0,'paras',struct(),'label',''),...
                'viewer',struct('index',1,'start',1,'end',1,'paras',struct(),'label',''),...
                'shape',struct('polarnum',0,'center',[],'width',0,'height',0,'thickness',0,'ppu',[0,0,0],'unit',''),...
                'object',struct('main',0,'patch',0),...
                'polars',[],...
                'zoom',struct('ratio',1,'polars',[]),...
                'xyzs',[],...
                'colormap',[],...
                'show',struct(...
                    'Style',struct('val',1),...
                    'Side',struct('val',0),...
                    'Zoom',struct('val',1)...
                    )...
                )...
    );
    %----------------------------
    typeStr='im|tiff|tif|jpeg|jpg|png|gif|hdf|bmp|pcx|xwd|cur|ico';
    Menus.fileType.Image=regexp(typeStr,'\|','split');
    typeStr='';
    suffix=bfGetFileExtensions;
    suffix=suffix(:,1);
    for i=1:size(suffix,1)
        str=suffix{i};
        str=strrep(str,'*.','');
        str=strrep(str,';','|');
        str=strrep(str,'.','|');
        typeStr=[typeStr,'|',str];
    end
    typeStr=typeStr(2:end);
    Menus.fileType.Microscopy=regexp(typeStr,'\|','split');
    typeStr='av|avi|mj2|3gp|mp4';
    Menus.fileType.Video=regexp(typeStr,'\|','split');
    typeStr='d3r';
    Menus.fileType.D3R=regexp(typeStr,'\|','split');
    typeStr='OMEd3r';
    Menus.fileType.Project=regexp(typeStr,'\|','split');    
    %
    Menus.fileType.All={};
    names=fieldnames(Menus.fileType);
    for i=1:length(names)
        key=names{i};
        val=getfield(Menus.fileType,key);
        Menus.fileType.All=[Menus.fileType.All,lower(val)];
    end
    %----------------------------
    set(handles.Dirs,'String','','Value',1);
    set(handles.Files,'String','','Value',1);
    set(handles.Commands,'String','','Value',1);
    set(handles.Records,'String','','Value',1);
    %
    set(handles.Functions,'Value',1);
    set(handles.Menus,'String','Menus','Value',1,'Enable','off');
    set(handles.Parameters,'String','Parameters','Value',1,'Enable','off');
    set(handles.Values,'String','','Enable','off');
    set(handles.Changes,'Enable','off');
    %----------------------------
    handles.RecentProjects.Position=[0.08,0.3,0.85,0.5];
    %----------------------------
    Open_init(handles);
    Switch_Callback();
    Recents_show(handles);
    Figures_Menus_About_Callback(nan,nan,handles);
function Open_init(handles)
    global Menus;
    %----------------------------
    handles.Figures.Position=Menus.FiguresPosition;
    handles.Windows.Position=Menus.WindowsPosition;
    cla(handles.Figures);
    cla(handles.Windows);
    handles.Figures.Visible='off';
    handles.Windows.Visible='off';
    %----------------------------
    D3R_switch(handles,true);
%-------------
function rtn=D3R_switch(handles,truefalse)
    global Menus;persistent stat;
    rtn=true;
    %-----------------------
    if isempty(truefalse)||isnan(truefalse)
        old=truefalse;
        if isempty(stat)
            truefalse=false;
        else
            truefalse=~stat;
        end
        if isempty(old);rtn=~truefalse;return;end;
    end;
    %-----------------------
    if truefalse
        handles.Figures.Position=Menus.FiguresPosition;
        handles.Windows.Position=Menus.WindowsPosition;
                    objs=allchild(handles.Windows);
                    objs=objs(isprop(objs,'Visible'));
                    set(objs,'Visible','off');
        axes(handles.Figures);
    else
        handles.Figures.Position=Menus.WindowsPosition;
        handles.Windows.Position=Menus.FiguresPosition;
                    objs=allchild(handles.Windows);
                    objs=objs(isprop(objs,'Visible'));
                    set(objs,'Visible','on');
        axes(handles.Windows);
    end
    stat=truefalse;
function yesorno=D3R_button(handles,stat)
    %() >>> get: button or not
    %(stat) >>> set: set button
    %(stat,stat) >>> cmp: if stat
    %(handles,stat) >>> special:
        %([],'move') >>> other: if move
    persistent STAT MOVE DOUBLE;
    yesorno=false;
    switch nargin
        case 0
            yesorno= ~isempty(STAT);
            return;
        case 1
            stat=lower(handles);
            if isempty(stat)
                STAT=[];
                MOVE=[];
            elseif strcmp(stat,'move');
                MOVE=stat;
            else
                if strcmp(stat,'left2')
                    DOUBLE=[];
                    return;
                elseif strcmp(stat,'left')
                    if isempty(DOUBLE)
                        DOUBLE=1;
                        start(timer('TimerFcn',@(~,~)D3R_button('left2'),'StartDelay',0.5));
                    else
                        stat='double';
                        DOUBLE=[];
                    end
                end
                STAT=stat;                
            end
            yesorno=true;
            return;
        case 2
            stat=lower(stat);
            if ischar(handles);yesorno=(isempty(stat)&&isempty(STAT))||strcmp(STAT,stat);return;end;
            switch stat
                case 'move'
                    if strcmp(MOVE,stat);yesorno=true;return;end;
            end
    end
function D3R_loop(hObject)%Cmd>D3R_loop>Switch
    if nargin<1;hObject=[];end;
    if ~D3R_loop_switch(hObject,'start');return;end;%one start
    D3R_loop_switch('.');%>>>label >>> every RUN must be here for initiation first! 
    Switch_Callback();
    D3R_action(true);
function yesorno=D3R_loop_switch(handles,stat)
    %() >>> get: loop or not
    %(stat) >>> set: set loop
    %(stat,stat) >>> cmp: if stat
    %(handles,stat) >>> special:
        %([],'pause') >>> pause: if pause
        %(['id',minval,nowval,maxval],'pause') >>> pause: if pause
        %(hObject,'start') >>> other: one start
        %(hObject,'stop') >>> other: pair stop
        %([],'stop') >>> other: any stop
        %(1,'tmp') >>> start; (2,'tmp') >>> stop;
        
    persistent STAT LASTSTAT STARTSTOP PROGRESS LASTTIME;
    yesorno=false;
    switch nargin
        case 0
            yesorno= ~isempty(STAT);
            return;
        case 1
            stat=lower(handles);
            if isempty(stat)
                STAT=[];
                LASTSTAT=[];
                STARTSTOP=[];
            elseif strcmp(stat,'pause')
                if ~strcmp(STAT,'pause');LASTSTAT=STAT;end;
                STAT=stat;
            elseif strcmp(STAT,'pause')
                STAT=LASTSTAT;
            else
                STAT=stat;
            end
            yesorno=true;
            return;
        case 2
            stat=lower(stat);
            if ischar(handles);yesorno=(isempty(stat)&&isempty(STAT))||strcmp(STAT,stat);return;end;
            switch stat
                case 'pause'
                    if strcmp(STAT,'pause');D3R_action(false);end;
                    while strcmp(STAT,'pause')
                        pause(0.5);
                    end
                    if ~isempty(STAT);
                        if isempty(handles)
                            D3R_action(true);
                        else
                            key=handles{1};
                            val=[handles{2:end}];
                            if isequal(val,[0,0,0]);rmfield(PROGRESS,key);return;end;
                            PROGRESS.(key)=val;
                            lst=struct2array(PROGRESS);
                            all=lst(3:3:end);
                            All=prod(all);
                            one=lst(2:3:end);                            
                            One=(prod(one(1:end-1))-1)*all(end)+one(end);
                            pern=now;
                            pert=pern-LASTTIME;
                            LASTTIME=pern;
                            disr=One/All;
                            dist=pert*(All-One);
                            D3R_action(disr,dist);
                        end
                    end
                    yesorno=~isempty(STAT);
                case 'start'
                    if isempty(STARTSTOP)
                        STARTSTOP=handles;
                        PROGRESS=[];
                        LASTTIME=now;
                        yesorno=true;
                    else
                        yesorno=false;
                    end
                case 'stop'
                    if isequal(handles,STARTSTOP) || isequal(handles,[])
                        yesorno=true;
                        STARTSTOP=[];
                    else
                        yesorno=false;
                    end
                case 'tmp'
                    global Handles;
                    if handles==1
                        if D3R_loop_switch();return;end;
                        STAT='tmp';
                        set(Handles.AllCmds,'String','[Stop]','Foreground','r');
                    elseif handles==2
                        if ~D3R_loop_switch('tmp','tmp');return;end;
                        STAT='';
                        set(Handles.AllCmds,'String','[Cmds]','Foreground','k');
                        %
                        set(Handles.Action,'Visible','off');
                    else
                    end
                otherwise
            end
    end
function D3R_unloop(hObject)%Cmd>D3R_loop>Switch
    if nargin<1;hObject=[];end;
    if ~D3R_loop_switch(hObject,'stop');return;end;%one pair
    D3R_loop_switch('');
    Switch_Callback();
    D3R_action(false);
function yesorno=D3R_lock()
    global Menus;
    yesorno=~isempty(Menus.busy);
function D3R_action(FT,time)
    global Handles;
    if isnumeric(FT)
        remaining=['Remaining: (',num2str(floor(time)),' days) ', datestr(time,13)];
        set(Handles.Progress,'Value',min(1,max(0,FT)));
        set(Handles.Action,'Visible','on','Title',remaining);        
        set(Handles.Menu,'Visible','off');
    elseif FT
        set(Handles.Action,'Visible','on');        
        set(Handles.Menu,'Visible','off');        
    else
        set(Handles.Action,'Visible','off');
        set(Handles.Menu,'Visible','on');        
    end
function cvt=D3R_pallet(colORind,gryORrgb,mtd)
    %totally 8 colors;
    %every color 100 gradients
    %() > PATs
    %(ind) > ONE range in PATs gray
    %(ind,gryORrgb) > ONE gray to PATs gray
    %(inds,{[],gryORrgb},mtd) > get rgb frm gryORrgb
    %(inds,{gryORrgb1 gryORrgb2},mtd) > get rgb by mixing gryORrgb1 with gryORrgb2
    persistent PPI GRD PAT PATs COLs NUM;
    if isempty(PPI)
        PPI=256;GRD=0.25;
        ppi=PPI;grd=GRD;
        sppi=grd*ppi;eppi=(1-grd)*ppi;
        L=linspace(0,1,ppi);M=zeros(ppi,3);
        %
        PAT.a=gray(ppi);
        r=M;
        r(:,1)=L;
        PAT.r=r;
        g=M;g(:,2)=L;
        PAT.g=g;
        b=M;b(:,3)=L;
        PAT.b=b;
        v=0.6;m1=[linspace(0,1,sppi)' linspace(0,v*v*v,sppi)' linspace(0,1,sppi)'];m2=[ones(eppi,1) linspace(v*v*v,0,eppi)' linspace(v,1,eppi)'];
        PAT.m=[m1;m2];
        v=0.8;y1=[linspace(0,v,sppi)' linspace(0,v,sppi)' linspace(0,0.1*v,sppi)'];y2=[ones(eppi,1) linspace(v,1,eppi)' zeros(eppi,1)];
        PAT.y=[y1;y2];
        v=0.7;c1=[linspace(0,v*v,sppi)' linspace(0,v,sppi)' linspace(0,1,sppi)'];c2=[linspace(v*v,0,eppi)' linspace(v,1,eppi)' ones(eppi,1)];
        PAT.c=[c1;c2];
        PATs=cell2mat(struct2cell(PAT));
        COLs=cell2mat(fieldnames(PAT))';
        NUM=numel(COLs);
    end
    %---
        if nargin;if ischar(colORind);COL=lower(colORind);IND=strfind(COLs,COL);else;IND=colORind;COL=COLs(IND);end;end;
        switch nargin
            case 0
                cvt=PATs;
            case 1
                cvt=[(IND-1)/NUM IND/NUM];
            case 2
                cvt=(gryORrgb+IND-1)/NUM;
            case 3
                rgb1=gryORrgb{1};
                rgb2=gryORrgb{2};
                if isempty(rgb1)
                    if ndims(rgb2)<3;rgb2=ind2rgb(gray2ind(rgb2,PPI),PAT.(COL));end;
                    cvt=rgb2;
                    return;
                else
                    if ndims(rgb1)<3;msgShow(0,'E> ''background'' must be rgb image');return;end;
                    if ndims(rgb2)<3;rgb2=ind2rgb(gray2ind(rgb2,PPI),PAT.(COL));end;
                    if ~isequal(size(rgb1),size(rgb2));msgShow(1,'A> different size');end;
                end
                switch mtd
                    case 1%screen C=1-(1-A)*(1-B)
                        cvt=1-(1-rgb1).*(1-rgb2);
                    case 2%multiply C=A*B
                        cvt=rgb1.*rgb2;
                    case 3%overlay A<=0.5;C=A*B;A>0.5;C=1-0.5*(1-A)*(1-B)
                        i2=rgb1>0.5;i1=~i2;
                        cvt1=rgb1.*rgb2;cvt1(i2)=0;
                        cvt2=1-2*(1-rgb1).*(1-rgb2);cvt2(i1)=0;
                        cvt=cvt1+cvt2;
                    case 4%hard
                        cvt=rgb1+rgb2;
                        i=cvt>=1;
                        cvt(i)=1;cvt(~i)=0;
                    case 5%mix
                        cvt=0.5*rgb1+0.5*rgb2;
                    case 6%cover
                        i2=rgb2>0.5;i1=~i2;
                        rgb1(i2)=0;rgb2(i1)=0;
                        cvt=rgb1+rgb2;
                end
        end
%-------------
function frame=D3R_figEPS(handles,hObject,filePath)
    oldAxis=gca;
    if handles.Figures.Position(4)>handles.Windows.Position(4)
        ax=handles.Figures;
    else
        ax=handles.Windows;
    end
    axes(ax);
    fig=figure('Visible','off','Color',handles.Form.Color,'Units','normalized','Position',handles.Form.Position,'PaperPositionMode','auto');
    colormap(fig,colormap(handles.Form));
    if isempty(hObject)%raw
        global Records;
        imshow(Records.img);
    elseif isobject(hObject)
        switch hObject.Type
            case 'figure'%form
                copyobj(allchild(handles.Form),fig);
                set(fig,'paperorientation','landscape');                
            case 'axes'%figure
                fig.Position(3)=handles.Form.Position(3)*handles.Main.Position(3);
                fig.Position(4)=handles.Form.Position(4)*handles.Main.Position(4);
                copyobj(ax,fig);
                ax=gca(fig);
                ax.Position=[0,0,1,1];
        end
    elseif isnan(hObject)%frame
        fig.Position(3)=handles.Form.Position(3)*handles.Main.Position(3);
        fig.Position(4)=handles.Form.Position(4)*handles.Main.Position(4);
        copyobj(ax,fig);
    else
    end
    axes(oldAxis);
    %%%
    if isempty(filePath)
        frame=getframe(fig);
        close(fig);
        return;
    end
    %%%
    try
        saveas(fig,filePath,'psc2');
    catch
        error=['E> figEPS> ',lasterr];
        msgShow(handles,2,error);
    end
    %%%
    close(fig);
function [rst,rng]=D3R_gray(handles,raw,grayParas,ifShow)
    if ndims(raw)>2;gry=rgb2gray(raw);else gry=double(raw);end;
    maxV=max(gry(:));
    if maxV<=1
        maxV=1;
    elseif maxV<2^8
        maxV=2^8-1;
    elseif maxV<2^16
        maxV=2^16-1;
    elseif maxV<2^32
        maxV=2^32-1;
    elseif maxV<2^64
        maxV=2^64-1;
    else
        msgShow(handles,2,'E> uint64');
        return;
    end
    rng=maxV;
    %%%
    if isempty(grayParas);rst=gry;return;end;
    minV=grayParas.min;
    midV=grayParas.mid;
    maxV=grayParas.max;
    mode=grayParas.mode;
    %%%
    sel=gry;
    minv=min(sel(:));
    maxv=max(sel(:));
    rngminV=minv+rng*minV;
    rngmidV=minv+rng*midV;
    rngmaxV=minv+rng*maxV;
    sel(find(sel<rngminV|sel>rngmaxV))=0;
    %%%
    switch mode
        case 0
            rst=sel;
        case 1
            rst=zeros(size(sel),'double');
            rst(find(sel>=rngminV))=1;
    end
    %%%
    if ~D3R_loop_switch() && ifShow
    tmpShow(handles,struct('Tag','gray','XData',gry,'Data',[rngminV,rngmidV,rngmaxV]),'Visible',{'on','off'},8);
    end
function img=D3R_roi2(row,col,roiVertices)
    fg=figure('Visible','off','Units','pixels','Position',[0,0,col,row]);
    ax=axes('Color','black','Units','pixels','Position',[0,0,col,row],'XLim',[0,col],'YLim',[0,row],'XTick',0,'YTick',0);
    %%%
    pt=patch(roiVertices(:,1),roiVertices(:,2),'w','linestyle','none','Parent',ax);
    [roiImg,map]=frame2im(getframe(ax));
    bwImg=im2bw(roiImg);
    img=imresize(bwImg,[row,col]);
    %%%
    close(fg);
function img=D3R_roi(row,col,xys)
    xys(any(isnan(xys)'),:)=[];
    xs=xys(:,1);ys=xys(:,2);
    minX=floor(min(xs));maxX=ceil(max(xs));
    minY=floor(min(ys));maxY=ceil(max(ys));
    %
    img=zeros(row,col,'uint8');
    %
    imgx=minX:maxX;imgx=imgx';
    imgy=[minY;maxY]*ones(1,maxX+1-minX);
    imgy=imgy(:);imgy=imgy(1:numel(imgx));
    [xx,yy]=polyxpoly(imgx,imgy,xs,ys);
    [val,ind]=sort(xx);
    %
    id1=ind(1);
    id2=ind(2);
    lastx=xx(id1);
    lasty=yy(id1);
    x=lastx;
    y=yy(id2);
        if y>lasty
            minv=lasty;
            maxv=y;
        else
            minv=y;
            maxv=lasty;
        end
        img(round(minv):round(maxv),round(x))=1;
    for i=2:numel(xx)
        id=ind(i);
        x=xx(id);
        y=yy(id);
        if y>lasty
            minv=lasty;
            maxv=y;
        else
            minv=y;
            maxv=lasty;
        end
        img(round(minv):round(maxv),round(x))=1;
        lasty=y;
    end
    return;
function D3R_show(handles,style)
    global Records;
    stylePara=getfield(Records.D3.show,style);
    switch style
        case 'Style'
            if size(Records.D3.object.main,1)>1
                Xs=cat(1,Records.D3.object.main(:).XData)';
                Ys=cat(1,Records.D3.object.main(:).YData)';
                Zs=cat(1,Records.D3.object.main(:).ZData)';
            else
                Xs=Records.D3.object.main.XData;
                Ys=Records.D3.object.main.YData;
                Zs=Records.D3.object.main.ZData;
            end
            if stylePara.val && isfield(Records.D3.object,'main')
                delete(Records.D3.object.main);
                Records.D3.object=rmfield(Records.D3.object,'main');
            end
            hold on;
            switch stylePara.val
                case 0
                    set(Records.D3.object.main,'Visible','off');
                case 1
                    Records.D3.object.main=mesh(Xs,Ys,Zs);
                case 2
                    Records.D3.object.main=surf(Xs,Ys,Zs);
                case 3
                    Records.D3.object.main=plot3(Xs,Ys,Zs);
                case 4
                    Records.D3.object.main=plot3(Xs,Ys,Zs,'.');
            end
            axis equal;
            hold off;
            if Records.D3.show.Side.val==4;D3R_side(handles,4);end;
        case 'Side'
            D3R_side(handles,stylePara.val);
        case 'Zoom'
            Records.D3.zoom.ratio=stylePara.val;
            polars=Records.D3.zoom.ratio*Records.D3.zoom.polars;
            %%%
            D3_Polar2XYZViewer(handles,polars);
    end
function D3R_side(handles,style)
    global Records;
            if size(Records.D3.object.main,1)>1
                Xs=cat(1,Records.D3.object.main(:).XData)';
                Ys=cat(1,Records.D3.object.main(:).YData)';
                Zs=cat(1,Records.D3.object.main(:).ZData)';
            else
                Xs=Records.D3.object.main.XData;
                Ys=Records.D3.object.main.YData;
                Zs=Records.D3.object.main.ZData;
            end
            if isfield(Records.D3.object,'upper')
                delete(Records.D3.object.upper);
                Records.D3.object=rmfield(Records.D3.object,'upper');
            end
            if isfield(Records.D3.object,'lower')
                delete(Records.D3.object.lower);
                Records.D3.object=rmfield(Records.D3.object,'lower');
            end
            hold on;
            switch style
                case 0
                case 1
                    xs=Xs(1,:);ys=Ys(1,:);zs=Zs(1,:);
                    xi=find(~isnan(xs));
                    xs=xs(xi);ys=ys(xi);zs=zs(xi);
                    Records.D3.object.upper=fill3(xs,ys,zs,'r');
                case 2
                    xs=Xs(end,:);ys=Ys(end,:);zs=Zs(end,:);
                    xi=find(~isnan(xs));
                    xs=xs(xi);ys=ys(xi);zs=zs(xi);
                    Records.D3.object.lower=fill3(xs,ys,zs,'r');
                case 3;
                    xs=Xs(1,:);ys=Ys(1,:);zs=Zs(1,:);
                    xi=find(~isnan(xs));
                    xs=xs(xi);ys=ys(xi);zs=zs(xi);
                    Records.D3.object.upper=fill3(xs,ys,zs,'r');
                    xs=Xs(end,:);ys=Ys(end,:);zs=Zs(end,:);
                    xi=find(~isnan(xs));
                    xs=xs(xi);ys=ys(xi);zs=zs(xi);
                    Records.D3.object.lower=fill3(xs,ys,zs,'r');
                case 4;
                    if ~Records.D3.show.Style.val;return;end;
                    POLARS=Records.D3.polars;
                    RN=size(POLARS,1);
                    TN=size(POLARS,2);
                    AA=POLARS(1,:);AA(isnan(AA))=[];
                    BB=POLARS(end,:);BB(isnan(BB))=[];
                    if mean(AA) > mean(BB)
                        PN=1;
                        ID=RN;
                    else
                        PN=-1;
                        ID=1;
                    end
                    %
                    IS=[];Is=1:RN;
                    for thi=1:TN
                        rs=POLARS(:,thi);
                        xs=Is;
                        is=find(isnan(rs));rs(is)=[];xs(is)=[];
                        if length(xs)<3;continue;end;
                        pp=spline(xs,rs);
                        lastval=0;lastind=0;
                        for i=Is
                            ind=ID+PN*i;
                            val=ppval(pp,ind);
                            if val<0;break;end;
                            lastval=val;
                            lastind=ind;
                        end
                        if i<RN && lastval>0 %>>> 50%Z-axis for prediction
                            if abs(val)>lastval
                                IS=[IS i-1];
                            else
                                IS=[IS i];
                            end
                        end
                    end
                    if numel(IS)<0.01*TN
                        msgShow(handles,2,'A> trendline not obvious(<1%) >>> known Z-axis must be more than 50% of all Z-axis');
                        IS=1;
                    end
                    %
                    IS=ceil(mean(IS));
                    IN=ID+PN*IS;
                    PS=nan(IS+1,TN);
                    for thi=1:TN
                        rs=POLARS(:,thi)';
                        R=rs(ID);
                        if isnan(R);continue;end;
                        xs=1:RN;
                        if PN>0
                            rs=[rs 0];
                            xs=[xs IN];
                            xx=1:IN;
                        else
                            rs=[0 rs];
                            xs=[IN xs];
                            xx=IN:RN;
                        end
                        is=find(isnan(rs));rs(is)=[];xs(is)=[];
                        if length(xs)<3
                            yy=nan(1,length(xx));
                        else
                            yy=spline(xs,rs,xx);
                        end
                        if PN>0
                            Rs=yy(ID:end);
                        else
                            Rs=yy(1:IS+1);
                        end
                        Rs(Rs<0)=0;
                        Rs(Rs>R)=R;
                        PS(:,thi)=Rs;
                    end
                    %
                    %{
                    Is=1:TN+1;
                    for i=1:size(PS,1)
                        rs=PS(i,:);
                        ni=isnan(rs);
                        if any(ni)
                            [vi,ii]=find(~isnan(rs),1);
                            Rs=[rs(ii:end) rs(1:ii)];
                            is=isnan(Rs);
                            Rs(is)=[];
                            Xs=Is;
                            Xs(is)=[];
                            if length(Xs)<3
                                continue;
                            else
                                newrs=spline(Xs,Rs,Is);
                                rs(ni)=newrs(ni);
                            end
                            PS(i,:)=rs;
                        end
                    end
                    %}
                    xyzs=D3_Polar2XYZ(PS);
                    xyzsz=xyzs(:,:,3);
                    if PN>0
                        zs=repmat(xyzsz(1,:),[size(PS,1),1]);
                    else
                        zs=repmat(xyzsz(end,:),[size(PS,1),1]);
                    end
                    ZS=repmat(Zs(ID,:),[size(PS,1),1]);
                    z=ZS-zs+xyzsz;
                    xyzs(:,:,3)=z;
                    %
                    Xs=xyzs(:,:,1);Ys=xyzs(:,:,2);Zs=xyzs(:,:,3);
                    switch Records.D3.show.Style.val
                        case 0
                        case 1
                            Records.D3.object.upper=mesh(Xs,Ys,Zs);
                        case 2
                            Records.D3.object.upper=surf(Xs,Ys,Zs);
                        case 3
                            Records.D3.object.upper=plot3(Xs,Ys,Zs);
                        case 4
                            Records.D3.object.upper=plot3(Xs,Ys,Zs,'.');
                    end
            end
            hold off;
function D3R_record(handles,info,ifTag)
    global Menus Records;
    if nargin<3
        INFO=[info,9,'<<<(',9,num2str(Records.viewer.index),9,')',Menus.Functions,'$',Menus.Menus,'$',Menus.Parameters,9,'<<<',9,Records.file.fileName,9,'<<<',9,Records.file.filePath];
    elseif nargin>2 && ifTag
        INFO=[info,9,'<<<(',9,num2str(Records.viewer.index),9,')',Menus.Functions,'$',Menus.Menus,'$',Menus.Parameters,9,'<<<',9,Records.file.fileName,9,'<<<',9,Records.file.filePath];
    else
        INFO=info;
    end
    lstAdd(handles.Records,handles,INFO,0);
%****************************************
function Form_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Form (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
    global Records;
    if isempty(Records.file.projectPath)
        path=Records.file.projectTitle;
    else
        path=Records.file.projectPath;
    end
    rtn=questdlg({'Project:',['>>> ',path],'','Before closing, would you save the project ?'},'Attention:','Yes','No','Cancel','Yes');
    switch rtn
        case 'Yes'
            Dirs_Menus_Project_Save_Callback(hObject, eventdata, handles);
        case 'No'
        case 'Cancel'
            return;
    end
    %-------------
    delete(hObject);
function Form_SizeChangedFcn(hObject, eventdata, handles)
    handles.Menu.Units='points';
    pos=handles.Menu.Position;
    pos(4)=30;
    handles.Menu.Position=pos;
    handles.Menu.Units='normalized';
    
    pos=handles.Menu.Position;
    pos2=handles.Main.Position;
    pos2(4)=1-pos(4);
    pos2(2)=pos(4);
    handles.Main.Position=pos2;
    
    handles.Action.Position=handles.Menu.Position;
function Form_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to Form (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
        if strcmp(handles.RecentProjects.Visible,'on');return;end;
        try
            xyz=get(handles.Picker,'Currentpoint');
            x=xyz(1,1);y=xyz(1,2);
            if x<0 || x>1 || y<0||y>1;return;end;
        catch
            return;
        end
        %-----------------
        ax=gca;
        ratio=0.02;
        ratio=1+ratio*eventdata.VerticalScrollCount;
        pos1=ax.Position;
        center1=[pos1(1)+pos1(3)/2,pos1(2)+pos1(4)/2];
        pos2=[pos1(1),pos1(2),pos1(3)*ratio,pos1(4)*ratio];
        center2=[pos2(1)+pos2(3)/2,pos2(2)+pos2(4)/2];
        %focus(0.5,0.5)
        center2x=0.5+(center1(1)-0.5)*pos2(3)/pos1(3);
        center2y=0.5+(center1(2)-0.5)*pos2(4)/pos1(4);
        center2xy=[center2x,center2y];
        %dis
        disc=center2xy-center2;
        pos3=[pos2(1)+disc(1),pos2(2)+disc(2),pos2(3),pos2(4)];
        %move
        ax.Position=pos3;
function Form_WindowButtonDownFcn(hObject, eventdata, handles)
        if strcmp(handles.RecentProjects.Visible,'on');return;end;
        try
            xyz=get(handles.Picker,'Currentpoint');
            x=xyz(1,1);y=xyz(1,2);
            if x<0 || x>1 || y<0||y>1;return;end;
        catch
            return;
        end
        %-----------------
        if handles.Figures.Position(4)>handles.Windows.Position(4)
            ax=handles.Figures;
        else
            ax=handles.Windows;
        end
        objs=allchild(ax);num=numel(objs);persistent numChange;
        if ~isequal(ax,get(gco,'Parent'));set(objs,'Selected','off');numChange=0;end;        
        if ~isequal(num,numChange)
            numChange=num;
            for i=1:num
                obj=objs(i);
                if isempty(obj.ButtonDownFcn)
                    set(obj,'ButtonDownFcn','set(gcbo,''Selected'',''on'');refresh');
                end
                set(obj,'UIContextMenu',handles.Figures_Menus);
            end
        end
        %-----------------
        D3R_button('left');
function Form_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to Form (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        D3R_button('');
function Form_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to Form (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        if strcmp(handles.RecentProjects.Visible,'on');return;end;
        try
            xyz=get(handles.Picker,'Currentpoint');
            x=xyz(1,1);y=xyz(1,2);
            %if x<0 || x>1 || y<0||y>1;return;end;
        catch
            return;
        end
        %-----------------
        persistent X Y;
        D3R_button('move');
        %-----------------
        if D3R_button('left','left')
            tmpShow(handles,'rotate3d','Enable',{'on','off'},0.5);
        elseif D3R_button('right','right')
            ax=gca;
            pos=ax.Position;xx=pos(1);yy=pos(2);ww=pos(3);hh=pos(4);
            pos=[xx+(x-X),yy+(y-Y),ww,hh];
            ax.Position=pos;
        end
        %-----------------
        X=x;Y=y;
%****************************************
function Dirs_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function Dirs_Callback(hObject, eventdata, handles)
    % hObject    handle to listbox1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
    %        contents{get(hObject,'Max')} returns selected item from listbox1
    persistent stat;if isempty(stat);stat=1;end;
    index=get(hObject,'Value');
    if ~D3R_loop_switch() && ~D3R_lock();stat=index;else;set(hObject,'Value',stat);msgShow(handles,2,'L> [Stop/UnLoop] first');return;end;
    %------------------------
    Dirs_action(handles);
function Dirs_init(handles,parDir)
    dirs=subDFs(parDir,'d');
    dirs=['./';dirs];
    %###
    global Records;
    if ~isempty(Records.file.rootPath);old=Records.file.rootPath;else old='';end;
    hObject=handles.Dirs;
    if strcmp(old,parDir)
        try
            contents=cellstr(get(hObject,'String'));
            if ~isempty(setdiff(dirs,contents))||~isempty(setdiff(contents,dirs))
                set(hObject,'String',dirs,'Value',1);
            end;
        catch
            set(hObject,'String',dirs,'Value',1);
        end
    else
        set(hObject,'String',dirs,'Value',1);
    end
    index=get(hObject,'Value');
    %%%
    if ~isempty(dirs)
        dir=dirs{index};
        Files_init(handles,dir);
    end
function Dirs_action(handles)
    hObject=handles.Dirs;
    try
        contents=get(hObject,'String');
        if isempty(contents);msgShow(handles,2,'M> no [Directory]');return;end;
        contents=cellstr(contents);
        index=get(hObject,'Value');
        dirname=contents{index};
    catch
        return;
    end
    %###
    Files_init(handles,dirname);
%-------------
function Dirs_Menus_Callback(hObject, eventdata, handles)
    if ~D3R_loop_switch() && ~D3R_lock();set(hObject.Children,'Visible','on');else;msgShow(handles,2,'L> [Stop/UnLoop] first');set(hObject.Children,'Visible','off');return;end;
%-------------
function Dirs_Menus_Project_Callback(hObject, eventdata, handles)
function Dirs_Menus_Project_New_Callback(hObject, eventdata, handles)
% hObject    handle to Dirs_Menus_Project_New (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    D3R_new(handles,true);
function Dirs_Menus_Project_Open_Callback(hObject, eventdata, handles)
            suffix='OMEd3r';
            [file,dir]=uigetfile(strcat('*.',suffix),'Input File ...');
            if ~file;return;end;
            filePath=strcat(dir,file);
    busyShow(handles);
    D3R_other(handles,filePath,false);
    freeShow(handles);
function Dirs_Menus_Project_Recent_Callback(hObject, eventdata, handles)
% hObject    handle to Dirs_Menus_Project_Recent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Recents_show(handles);
function Dirs_Menus_Project_Save_Callback(hObject, eventdata, handles)
    global Records;
    if isempty(Records.file.projectPath)
        path=[];
    else
        path=Records.file.projectPath;
    end
    %---
    busyShow(handles);
    D3R_export(handles,path);
    freeShow(handles);
function Dirs_Menus_Project_Saveas_Callback(hObject, eventdata, handles)
    %---
    busyShow(handles);
    D3R_export(handles,[]);
    freeShow(handles);
    if strcmp(handles.RecentProjects.Visible,'on')
        if strcmp(handles.RecentProjects.Title,'Information');Info_show(handles,true);end;
    end
function Dirs_Menus_Workspace_Callback(hObject, eventdata, handles)
% hObject    handle to Dirs_Menus_Workspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Dir_File_open(hObject, eventdata, handles);
function Dirs_Menus_Refresh_Callback(hObject, eventdata, handles)
% hObject    handle to Dirs_Menus_Refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global Records;
    if isempty(Records.file.rootPath)
        Dir_File_open(hObject, eventdata, handles);
    else
        Dirs_init(handles,Records.file.rootPath);
    end
%****************************************
function Switch_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Values') returns toggle state of Switch
    global Records Handles;persistent Object;
    if nargin==0;hObject=[];end;
    sObject=hObject;
    hObject=Handles.Switch;
        %Cmd>D3R_loop>Switch
    if nargin==0%init
        while numel(Object)
            obj=Object(end);
            obj.Callback(obj.hObject,obj.label,obj.handles);
        end
        pause(0.2);
        set(hObject,'Value',0,'ForegroundColor','k','String','[Lock]');
        busyShow(Handles,nan);
        return;
    elseif nargin==1%Switch
        if isempty(sObject.Callback)%remove
            objs=[];lab=sObject.label;
            for i=1:numel(Object)
                obj=Object(i);
                if ~strcmp(obj.label,lab);objs=[objs obj];end;
            end
            Object=objs;
        else%save
            Object=[Object sObject];
        end
        %
        if isempty(Object)
            Switch_Callback();
        else
            pause(0.2);
            set(hObject,'Value',1,'ForegroundColor','m','String',Object(end).label);
        end
    elseif nargin==2%Something
    elseif isequal(sObject,hObject)%selfClick
        if get(hObject,'Value')%Callback
            if D3R_loop_switch()%loop
                Switch_Callback(struct('Callback',@Switch_Callback,'hObject',hObject,'label','[Pause]','handles',handles));
                D3R_loop_switch('pause');
            else%normal
                Switch_Callback(struct('Callback',@Switch_Callback,'hObject',hObject,'label','[Lock]','handles',handles));
                busyShow(Handles);
            end
        else
            obj=Object(end);
            if isequal(obj.hObject,hObject)%self
                if strcmp(get(hObject,'String'),'[Pause]')
                    Switch_Callback(struct('Callback',[],'hObject',hObject,'label','[Pause]','handles',handles));
                    if D3R_loop_switch()%loop
                        D3R_loop_switch('continue');
                    end
                else%normal
                    Switch_Callback(struct('Callback',[],'hObject',hObject,'label','[Lock]','handles',handles));
                    busyShow(Handles,nan);
                end
                set(hObject,'Value',0);
            else%other
                obj.Callback(obj.hObject,obj.label,obj.handles);
            end
        end
    end
%****************************************
function Files_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to listbox1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end  
function Files_Callback(hObject, eventdata, handles)
    % hObject    handle to listbox1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
    %        contents{get(hObject,'Max')} returns selected item from listbox1
    persistent stat;if isempty(stat);stat=1;end;
    index=get(hObject,'Value');
    if ~D3R_loop_switch() && ~D3R_lock();stat=index;else;set(hObject,'Value',stat);msgShow(handles,2,'L> [Stop/UnLoop] first');return;end;
    %------------------------
    Files_action(handles);
function Files_init(handles,dirname)
    global Menus Records;
    %####
    msgShow(handles,0,'M> check files ...');
    files={};
    if ~isempty(Menus.fileType.All)
        path=strcat(Records.file.rootPath,filesep,dirname);
        fs=subDFs(path,'f');
        for i=1:length(fs)
            file=fs{i};
            filePath=strcat(path,filesep,file);
            %fi=finfo(filePath);
            [pathstr, name, fi] = fileparts(filePath);
            fi=lower(fi(2:length(fi)));
            if ~isempty(fi) && any(ismember(Menus.fileType.All,fi));files=[files;file];end;
        end
    end
    msgShow(handles,0,'M> busy ...');
    %###
    if ~isempty(Records.file.dirName);old=Records.file.dirName;else old='';end;
    hObject=handles.Files;
    if strcmp(old,dirname)
        try
            contents=cellstr(get(hObject,'String'));
            if ~isempty(setdiff(files,contents))||~isempty(setdiff(contents,files))
                set(hObject,'String',files,'Value',1);
            end;
        catch
            set(hObject,'String',files,'Value',1);
            return;
        end
    else
        set(hObject,'String',files,'Value',1);
    end
    %%%
    Records.file.dirName=dirname;
    Records.file.dirPath=fullfile(Records.file.rootPath,Records.file.dirName);
function Files_action(handles)
    global Menus Records;
    if ~isempty(Records.file.dirName)
        dirname=Records.file.dirName;
    else
        hObject=handles.Dirs;
        try
            contents=get(hObject,'String');
            if isempty(contents);msgShow(handles,2,'M> no [Directory]');return;end;
            contents=cellstr(contents);
            index=get(hObject,'Value');
            dirname=contents{index};
        catch
            msgShow(handles,2,'M> no [Directory]');
            return;
        end
    end
    %
    hObject=handles.Files;
    try
        contents=get(hObject,'String');
        if isempty(contents);return;end;
        contents=cellstr(contents);
        index=get(hObject,'Value');
        filename=contents{index};
    catch
        return;
    end
    
    filePath=fullfile(Records.file.rootPath,dirname,filename);
    if ~exist(filePath)
        msgShow(handles,2,strcat('M> doesn''t exist ''',filePath,''''));
        return;
    end
    %
    Menus.file=Records.file;
    Records.file.fileName=filename;
    Records.file.filePath=filePath;
    [pathstr, name, suffix] = fileparts(filePath);
    Records.file.fileSuffix=lower(suffix(2:end));
    %
    Dir_File_read(handles,filePath,[],true,true);
function Dir_File_open(hObject, eventdata, handles)
% hObject    handle to File_Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    prjs=D3R_project(handles);
    if numel(prjs)
        prj=prjs{1};
        [startdir,file]=fileparts(prj);
    else
        startdir=ctfroot;
    end
    rootpath=uigetdir(startdir);
    if rootpath==0;return;end;
    global Records;
    Records.file.rootPath=rootpath;
    Dirs_init(handles,rootpath);
    %%%
    if strcmp(handles.RecentProjects.Visible,'on')
        if strcmp(handles.RecentProjects.Title,'Information');Info_show(handles,true);end;
    end
function imgORerr=Dir_File_read(handles,filePath,Parameters,ifShow,ifPoint)
    global Menus Records;
    %----------------------------
            [pathstr, name, fi] = fileparts(filePath);
            suffix=lower(fi(2:length(fi)));
            FunctionName='';
            names=fieldnames(Menus.fileType);
            for i=1:numel(names)
                key=names{i};
                val=getfield(Menus.fileType,key);
                val=lower(val);
                if any(ismember(val,suffix))
                    FunctionName=key;
                    break;
                end
            end
            if isempty(FunctionName);msgShow(handles,2,['M> not supported ''',suffix,'''']);return;end;
    %----------------------------
    if strcmp(FunctionName,'Project')
        if ~D3R_other(handles,filePath,true);return;end;
        %---Cmd Apply Done!
        Records.file.fileType=FunctionName;
        return;
    end
    %----------------------------
            pointedIndex=0;
            hObject=handles.Functions;
            try
                contents=cellstr(get(hObject,'String'));
                for i=1:length(contents)
                    if strcmp(contents{i},FunctionName)
                        pointedIndex=i;
                        break;
                    end
                end
                if ~pointedIndex;msgShow(handles,2,'E> file dataType');return;end;
            catch
                msgShow(handles,2,'E> Functions index');
                return;
            end
    %----------------------------
    if ifShow;Open_init(handles);end;
    try
    switch FunctionName
        case 'Image'
                if ~strcmp(Records.file.readerPath,filePath)
                    Menus.reader=struct('arr',[],'map',[],'alp',[],'NumberOfChannel',1,'NumberOfFrames',numel(imfinfo(filePath)));
                    Records.file.readerPath=filePath;
                end
                if ~isempty(Parameters)
                    LABEL='Index';
                    if isfield(Parameters,'index');Parameters.(LABEL).val=Parameters.index;end;
                    INDEX=Parameters.(LABEL).val;MAX=Parameters.(LABEL).max;
                    if INDEX<1
                        INDEX=max(1,round(INDEX*MAX));
                        INDEX=min(MAX,INDEX);
                        Parameters.(LABEL).val=INDEX;
                    end
                    %%%---------------------------
                    if Menus.reader.NumberOfFrames==1
                        [Menus.reader.arr,Menus.reader.map,Menus.reader.alp]=imread(filePath);
                    else
                        [Menus.reader.arr,Menus.reader.map,Menus.reader.alp]=imread(filePath,INDEX);
                    end
                    Menus.reader.NumberOfChannel=max([size(Menus.reader.arr,3),size(Menus.reader.map,2),1]);
                    %>>>tmp channel>>...
                    %%%
                    img=Menus.reader.arr;
                    if ~isempty(Menus.reader.map)
                        img=ind2rgb(img,Menus.reader.map);
                    end
                    if size(img,3)>1 && Parameters.Channel.val
                        img=img(:,:,Parameters.Channel.val);                            
                    end
                    %%%---------------------------
                    if Parameters.Normalize.val
                        img=mat2gray(img);
                    end
                    imgORerr=img;
                end
        case 'Microscopy'
                if ~strcmp(Records.file.readerPath,filePath)
                    Menus.reader=bfGetReader(filePath);
                    Records.file.readerPath=filePath;
                end
                if ~isempty(Parameters)
                    LABEL='Zaxis';
                    if isfield(Parameters,'index');Parameters.(LABEL).val=Parameters.index;end;
                    INDEX=Parameters.(LABEL).val;MAX=Parameters.(LABEL).max;
                    if INDEX<1
                        INDEX=max(1,round(INDEX*MAX));
                        INDEX=min(MAX,INDEX);
                        Parameters.(LABEL).val=INDEX;
                    end
                    %%%---------------------------
                    Menus.reader.setSeries(Parameters.Series.val-1);
                    img=bfGetPlane(Menus.reader,Menus.reader.getIndex(Parameters.Zaxis.val-1,Parameters.Caxis.val-1,Parameters.Taxis.val-1)+1);
                    %%%---------------------------
                    if Parameters.Normalize.val
                        img=mat2gray(img);
                    end
                    imgORerr=img;
                end
        case 'Video'
                if ~strcmp(Records.file.readerPath,filePath)
                    Menus.reader=VideoReader(filePath);
                    Records.file.readerPath=filePath;
                end
                if ~isempty(Parameters)
                    LABEL='FrameIndex';
                    if isfield(Parameters,'index');Parameters.(LABEL).val=Parameters.index;end;
                    INDEX=Parameters.(LABEL).val;MAX=Parameters.(LABEL).max;
                    if INDEX<1
                        INDEX=max(1,round(INDEX*MAX));
                        INDEX=min(MAX,INDEX);
                        Parameters.(LABEL).val=INDEX;
                    end
                    %%%---------------------------
                    img=read(Menus.reader,INDEX);
                    %%%---------------------------
                    if Parameters.Normalize.val
                        img=mat2gray(img);
                    end
                    imgORerr=img;
                end
        case 'D3R'
                %read=strcmp(Records.file.filePath,filePath);
                %>>>readerPath=filePath
                %readerPath
                %
                if ~strcmp(Records.file.readerPath,filePath) && isempty(Parameters)%Files_action
                    tmpD3=Records.D3;
                    try
                        load(filePath,'D3','-mat');
                        Records.D3=D3;
                        clear D3;
                        colors=Records.D3.colormap;
                        colormap(colors);
                    catch
                        Records.D3=tmpD3;
                        msgShow(handles,2,'E> D3 format');
                        return;
                    end
                    Menus.reader=struct();
                    Records.file.readerPath=filePath;
                end
                if ~isempty(Parameters)
                    LABEL='Zaxis';
                    if isfield(Parameters,'index');Parameters.(LABEL).val=Parameters.index;end;
                    INDEX=Parameters.(LABEL).val;MAX=Parameters.(LABEL).max;
                    if INDEX<1
                        INDEX=max(1,round(INDEX*MAX));
                        INDEX=min(MAX,INDEX);
                        Parameters.(LABEL).val=INDEX;
                    end
                    %%%---------------------------
                    Records.D3.viewer.index=INDEX;
                    Records.D3.viewer.paras=Parameters;
                    %%%
                    if D3R_loop_switch('D3R','D3R')
                        %%%XY-->Z-->(XY)=auto
                        Records.xys=[Records.D3.xyzs(INDEX,:,1)',Records.D3.xyzs(INDEX,:,2)'];
                        hold on;
                        xyzZ=Records.D3.xyzs(INDEX,:,3)';
                        plot3(Records.xys(:,1),Records.xys(:,2),xyzZ,'.b');axis ij;
                        hold off;
                    else
                         %%%Viewer
                        [Records.xys,valid]=D3_XYZViewer(handles,INDEX);
                    end
                    %%%---------------------------
                    if Parameters.Normalize.val
                        colormap(gray(100));
                    end
                    imgORerr=[];
                end
        otherwise
            msgShow(handles,2,'E> FunctionName');
            pointedIndex=0;
    end
    catch
        imgORerr=['E> ',lasterr];
        msgShow(handles,2,imgORerr);
        return;
    end
    %----------------------------
            if isempty(Parameters)||ifPoint
                Functions_switch(handles,'Functions',pointedIndex);
                Functions_switch(handles,'Menus',2);
            end;
            if isempty(Parameters)
                Functions_switch(handles,'Parameters',2);
                Functions_switch(handles,'Parameters');
                return;
            end
            %----------------------------
            Records.file.fileType=FunctionName;
            Records.viewer.label=LABEL;
            Records.viewer.index=INDEX;
            Records.viewer.paras=Parameters;
            %----------------------------
            if ifShow;Records.raw=imgORerr;figShow(handles,'hold off',imgORerr);end;
            %----------------------------
            if strcmp(handles.RecentProjects.Visible,'on')
                if strcmp(handles.RecentProjects.Title,'Information');Info_show(handles,true);end;
            end
%-------------
function Files_Menus_Callback(hObject, eventdata, handles)
    if ~D3R_loop_switch() && ~D3R_lock();set(hObject.Children,'Visible','on');else;msgShow(handles,2,'L> [Stop/UnLoop] first');set(hObject.Children,'Visible','off');return;end;
%-------------
function Files_Menus_Project_Callback(hObject, eventdata, handles)
function Files_Menus_Project_New_Callback(hObject, eventdata, handles)
% hObject    handle to Files_Menus_Project_New (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    D3R_new(handles,true);
function Files_Menus_Project_Save_Callback(hObject, eventdata, handles)
    global Records;
    if isempty(Records.file.projectPath)
        path=[];
    else
        path=Records.file.projectPath;
    end
    %---
    busyShow(handles);
    D3R_export(handles,path);
    freeShow(handles);
function Files_Menus_Project_Saveas_Callback(hObject, eventdata, handles)
    %---
    busyShow(handles);
    D3R_export(handles,[]);
    freeShow(handles);
function Files_Menus_Workspace_Callback(hObject, eventdata, handles)
% hObject    handle to Files_Menus_Workspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Dir_File_open(hObject, eventdata, handles);
function Files_Menus_Refresh_Callback(hObject, eventdata, handles)
% hObject    handle to Files_Menus_Refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global Records;
    if isempty(Records.file.dirName)
        Dir_File_open(hObject, eventdata, handles);
    else
        Files_init(handles,Records.file.dirName);
    end
%****************************************
function Message_Callback(hObject, eventdata, handles)
% hObject    handle to Message (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Message
    set(hObject,'Value',1);
    pause(0.5);
    set(hObject,'Value',0);
    pause(0.5);
    set(hObject,'Visible','off');
%****************************************
function Commands_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Commands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Commands_Callback(hObject, eventdata, handles)
    lstShow(hObject,handles);
%
function Commands_Menus_Callback(hObject, eventdata, handles)
    %if ~D3R_loop_switch() && ~D3R_lock();set(hObject.Children,'Visible','on');else;msgShow(handles,2,'L> [Stop/UnLoop] first');set(hObject.Children,'Visible','off');return;end;
%------------------------
function Commands_Menus_Command_Callback(hObject, eventdata, handles)
function Commands_Menus_Command_Undo_Callback(hObject, eventdata, handles)
        hObject=handles.Commands;
        try
            index=get(hObject,'Value');
            index=index(1);
            set(hObject,'Value',index);
            %--------------------------------------------%record
            global Records;
            Records.raw=Records.imgs{index};
            figShow(handles,'hold off',Records.raw);
            %--------------------------------------------%record
       catch
            msgShow(handles,2,strcat('E> ',lasterr));
            return;
        end
function Commands_Menus_Command_Run_Callback(hObject, eventdata, handles)
        hObject=handles.Commands;
        try
            index=get(hObject,'Value');
            contents=cellstr(get(hObject,'String'));
            index=index(1);
            set(hObject,'Value',index);
            cmd=contents{index};
            %--------------------------------------------%record
            global Records;
            Records.raw=Records.img;
            Records.imgs{index}=Records.img;
            Commands_Cmd_Decode(handles,cmd);
            %--------------------------------------------%record
       catch
            msgShow(handles,2,strcat('E> ',lasterr));
            return;
        end
function Commands_Menus_Command_Redo_Callback(hObject, eventdata, handles)
    Commands_Menus_Command_Undo_Callback(hObject, eventdata, handles);
    Commands_Menus_Command_Run_Callback(hObject, eventdata, handles);
function Commands_Menus_Command_Loop_Callback(hObject, eventdata, handles)
% hObject    handle to Commands_Menus_Command_Loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global Records;
    sObject=hObject;
    hObject=handles.Commands_Menus_Command_Loop;
    hObj=handles.Commands;
    lab=hObject.Label;
    try
        index=get(hObj,'Value');
        contents=get(hObj,'String');
        if isempty(contents);msgShow(handles,2,'M> no [Command]');return;end;
        contents=cellstr(contents);
        if strcmp(lab,'Loop')
            set(hObject,'Label','UnLoop');
            D3R_loop(hObject);
            %--------------------------------------------%loop
            Records.commands=struct('String',{contents},'Value',index,'Color',hObj.BackgroundColor);
            set(hObj,'String',contents(index),'Value',1,'BackgroundColor',[0.76,0.87,0.78]);
            %
            AllCmds_Call(handles);
            %
            set(hObj,'String',Records.commands.String,'Value',Records.commands.Value,'BackgroundColor',Records.commands.Color);
            %--------------------------------------------%loop
            set(hObject,'Label','Loop');
            D3R_unloop(hObject);
        else
            %--------------------------------------------%loop
            set(hObj,'String',Records.commands.String,'Value',Records.commands.Value,'BackgroundColor',Records.commands.Color);
            %--------------------------------------------%loop
            set(hObject,'Label','Loop');
            D3R_unloop(hObject);
        end
    catch
        msgShow(handles,2,['E> ',lasterr]);
        return;
    end
%
function Commands_Menus_Edit_Callback(hObject, eventdata, handles)
function Commands_Menus_Edit_Record_Callback(hObject, eventdata, handles)
    cmd=Commands_Cmd_Encode(handles);
    if ~isempty(cmd);
        hObject=handles.Commands;
        try
            index=get(hObject,'Value');
            contents=get(hObject,'String');
            if isempty(contents);index=0;end;
            index=lstAdd(hObject,handles,cmd,index);
            if ~all(index);return;end;
            %--------------------------------------------%record
            global Records;
            Records.raw=Records.img;
            Records.imgs{index}=Records.img;
            %--------------------------------------------%record
       catch
            msgShow(handles,2,['E> ',lasterr]);
            return;
        end
    end;
function Commands_Menus_Edit_Edit_Callback(hObject, eventdata, handles)
    global Menus;
    %---
    try
        hObject=handles.Commands;
        index=get(hObject,'Value');
        strs=cellstr(get(hObject,'String'));
        Menus.Edit.hObject=hObject;
        Menus.Edit.hIndex=index;
        if isempty(index)
            str={''};
        else
            str=strs{index};
        end
        set(handles.Edit,'String',str);
    catch
        msgShow(handles,2,strcat('E> ',lasterr));
        return;
    end
    %%%
    set(handles.Edit,'Visible','on');
    set(handles.AllCmds,'Visible','off');
    set(handles.AllFiles,'Visible','off');
    set(handles.AllDirs,'Visible','off');
    %%%
    busyShow(handles);
function Commands_Menus_Edit_Up_Callback(hObject, eventdata, handles)
    [index,number]=lstUpDown(handles.Commands,handles,true);
    if ~all(index);return;end;
    %%%
    global Records;
    IS=1:number;
                is=IS;
                is(index)=0;
                objs=Records.imgs(is==0);
                oths=Records.imgs(is>0);
                
                is=IS;
                is(index-1)=0;
                Records.imgs(is==0)=objs;
                Records.imgs(is>0)=oths;
function Commands_Menus_Edit_Down_Callback(hObject, eventdata, handles)
    [index,number]=lstUpDown(handles.Commands,handles,false);
    if ~all(index);return;end;
    %%%
    global Records;
    IS=1:number;
                is=IS;
                is(index)=0;
                objs=Records.imgs(is==0);
                oths=Records.imgs(is>0);
                
                is=IS;
                is(index+1)=0;
                Records.imgs(is==0)=objs;
                Records.imgs(is>0)=oths;
%
function Commands_Menus_Clear_Callback(hObject, eventdata, handles)
function Commands_Menus_Clear_Selected_Callback(hObject, eventdata, handles)
    index=lstRemove(handles.Commands,handles);
    if ~all(index);return;end;
    %%%
    global Records;
    is=1:numel(Records.imgs);
    is(index)=0;
    Records.imgs=Records.imgs(is>0);
function Commands_Menus_Clear_Down_Callback(hObject, eventdata, handles)
    index=lstRemoveDowns(handles.Commands,handles);
    if ~all(index);return;end;
    %%%
    global Records;
    Records.imgs=Records.imgs(1,1:index-1);
function Commands_Menus_Clear_All_Callback(hObject, eventdata, handles)
    lstEmpty(handles.Commands);
    %%%
    global Records;
    Records.imgs={};
%
function Commands_Menus_Data_Callback(hObject, eventdata, handles)
function Commands_Menus_Data_Import_Callback(hObject, eventdata, handles)
    number=lstImport('cmd',handles.Commands,handles);
    if ~number;return;end;
    %%%
    global Records;
    Records.imgs=cell(1,number);
function Commands_Menus_Data_Export_Callback(hObject, eventdata, handles)
    lstExport('cmd',handles.Commands,handles);
%****************************************
function cmd=Commands_Cmd_Encode(handles)
    global Menus Parameters;
    cmd='';
    if Menus.MenusIndex==1 || Menus.ParametersIndex==1
        msgShow(handles,2,'M> invalid incomplete [Command]');
        return;
    else
        names=fieldnames(Parameters);
        for i=1:length(names)
            name=names{i};
            paras=getfield(Parameters,name);
            val2txt=paras.val2txt;
            val=paras.val;
            if isempty(val2txt)
                if strcmp(class(val),'char')
                    cmd=strcat(cmd,'|',name,'$',val);  
                else
                    cmd=strcat(cmd,'|',name,'$',num2str(val));  
                end
            else
                cmd=strcat(cmd,'|',name,'$',val2txt);            
            end
        end
        cmd=cmd(2:length(cmd));
    end
    cmd=strcat(Menus.Functions,'$',Menus.Menus,'$',Menus.Parameters,'=',...
            num2str(Menus.FunctionsIndex),'$',num2str(Menus.MenusIndex),'$',num2str(Menus.ParametersIndex),'=',...
            cmd);
function step=Commands_Cmd_Decode(handles,cmd,cmds)
    global Menus Parameters Records;
    switch class(cmd)
        case 'char'
            cmdSourceType=1;
        case 'struct'
            paras=cmd;
            cmdSourceType=2;
        case 'double'
            index=cmd;
            cmd=cmds{index};
            paras=Commands_Cmd_DecodeforCmd(cmd);
            cmdSourceType=3;
        otherwise
            msgShow(handles,0,'E> command error(1)');
            step=numel(cmds);
            return;
    end
    %-------------------------------------------
    Menus.Functions=paras.fMenu;
    Menus.Menus=paras.mMenu;
    Menus.Parameters=paras.pMenu;
    Functions_switch(handles,'Functions',paras.fIndex);
    Functions_switch(handles,'Menus',paras.mIndex);
    Functions_switch(handles,'Parameters',paras.pIndex);
    %-------------------------------------------
    step=1;
    Parameters=Commands_Cmd_InsertforCmd(Parameters,paras);
    switch cmdSourceType
        case 1%single cmd >>> apply
            Menus.command.index=get(handles.Commands,'Value');
            %%%action
            Functions_switch(handles,'Parameters');
            Records.raw=Records.img;
            %%%next
            return;
        case 2%multiply cmd >>> loop's init=viewer
            %%%action
            Functions_switch(handles,'Parameters');
            Records.raw=Records.img;
            %%%next
            return;
        case 3%multipy cmd >>> loop + apply
            Menus.command.index=index;
            set(handles.Commands,'Value',index);
            pause(0.01);
            %%%action
            Functions_switch(handles,'Parameters');
            Records.raw=Records.img;
            %%%next
            if ~isfield(paras,'Loop')||paras.Loop.val~=1;return;end;
        otherwise
            msgShow(handles,0,'E> command error(2)');
            step=numel(cmds);
            %%%next
            return;
    end;
    %-------------------------------------------
    %%%start-end
    find=false;loopNum=0;indexNum=numel(cmds);
    for endi=index+1:indexNum
        c=cmds{endi};
        ps=Commands_Cmd_DecodeforCmd(c);
        if strcmp(ps.fMenu,paras.fMenu) && strcmp(ps.mMenu,paras.mMenu)
            if isfield(ps,'Loop')
                if ps.Loop.val==1
                    loopNum=loopNum+1;
                    msgShow(handles,2,'E > not suport for nest [Loop] !');
                    return;%Not support for nest loop
                elseif ps.Loop.val==2
                    if loopNum==0;find=true;break;end;
                    loopNum=loopNum-1;
                end
            else
                continue;
            end
        end
    end
    if ~find;msgShow(handles,2,'M> Loop:''1'' should pair with ''2''');step=indexNum;return;end;
    startIndex=index;
    endIndex=endi;
    step=endIndex-startIndex+1;
    %-------------------------------------------
    D3R_loop_switch(paras.fMenu);
    D3R_loop_switch({'AllCmds',1,1,1},'pause');
    %%%-----------------------------
    Menus.command.loop=startIndex;
    Menus.container.map=containers.Map();%Not support for nest loop
    Menus.container.polars=[];
    Menus.container.tracking=struct('centroid',[],'convexhull',[]);
    Znum=Commands_Cmd_StartEnd(handles,cmds,startIndex,endIndex);
    Records.raw=Records.img;
    %%%-----------------------------
    if D3R_loop_switch('D3R','D3R')%self
        Records.D3.viewer.paras=Records.viewer.paras;
    else%img=source
        Records.D3.source.paras=Records.viewer.paras;
    end
    %%%-----------------------------
    if D3R_loop_switch();D3R_loop_switch('.');else;return;end;
    %%%-----------------------------
    polars=Menus.container.polars;
    if ~isempty(polars)
        Nnum=size(polars,1);
        if Nnum==Znum
        elseif Nnum>Znum
            if mod(Nnum,Znum);msgShow(handles,2,'E> container error');return;end;
            polars=D3_mulPolars(polars,Nnum,Znum,Menus.RepeatSmoothMethod,Menus.RepeatSmoothRatio);
        else
            msgShow(handles,2,'E> container error');
            return;
        end
        %-----------------------
        D3_Polar2XYZViewer(handles,polars);
        %-----------------------
        D3_Polar2Zoom();
    end
function Znum=Commands_Cmd_StartEnd(handles,cmds,startIndex,endIndex,selfLoop,startParas,midParas,endParas)
    global Records;
    if nargin<5
        selfLoop='';
        startParas=Commands_Cmd_DecodeforCmd(cmds{startIndex});
        midParas=startParas;
        endParas=Commands_Cmd_DecodeforCmd(cmds{endIndex});
    end
    %%%-----------------------------
    switch startParas.fMenu
        case 'Image'
            switch startParas.mMenu
                case 'Viewer'
                    label='Index';
            end
        case 'Microscopy'
            switch startParas.mMenu
                case 'Viewer'
                    if isempty(selfLoop);selfLoop='Series';end;
                    label=selfLoop;
            end
        case 'Video'
            switch startParas.mMenu
                case 'Viewer'
                    label='FrameIndex';
            end
        case 'D3R'
            switch startParas.mMenu
                case 'Viewer'
                    label='Zaxis';
            end
        case 'fOther'
            switch startParas.mMenu
                case ''
                    label='';
            end
        otherwise
            return;
    end
    %%%-----------------------------
    STARTINDEX=startParas.(label).val;
    ENDINDEX=endParas.(label).val;
    MAX=Records.viewer.paras.(label).max;
    if STARTINDEX<1;STARTINDEX=max(1,round(STARTINDEX*MAX));end;
    if ENDINDEX<1;ENDINDEX=min(MAX,round(ENDINDEX*MAX));end;
    %%%-----------------------------
    for index=STARTINDEX:ENDINDEX
        midParas.(label).val=index;
        %%%-----------------------------
        ALL=ENDINDEX-STARTINDEX+1;
        IND=index-STARTINDEX+1;
        if ~D3R_loop_switch({label,1,IND,ALL},'pause');break;end;
        %%%-----------------------------
        switch startParas.fMenu
            case 'Microscopy'
                switch startParas.mMenu
                    case 'Viewer'
                        switch selfLoop
                            case 'Series'
                                Znum=Commands_Cmd_StartEnd(handles,cmds,startIndex,endIndex,'Taxis',startParas,midParas,endParas);
                                D3R_loop_switch({label,0,0,0},'pause');
                                continue;
                            case 'Taxis'
                                Znum=Commands_Cmd_StartEnd(handles,cmds,startIndex,endIndex,'Caxis',startParas,midParas,endParas);
                                D3R_loop_switch({label,0,0,0},'pause');
                                continue;
                            case 'Caxis'
                                Znum=Commands_Cmd_StartEnd(handles,cmds,startIndex,endIndex,'Zaxis',startParas,midParas,endParas);
                                D3R_loop_switch({label,0,0,0},'pause');
                                continue;
                        end
                end
        end
        %%%-----------------------------
        Znum=ALL;
        Commands_Cmd_Decode(handles,midParas);
        %%%-----------------------------
        i=1;is=endIndex-startIndex-1;
        while i<=is
            i=i+Commands_Cmd_Decode(handles,startIndex+i,cmds);
            if ~D3R_loop_switch([],'pause');break;end;
        end
        %%%-----------------------------
        D3R_loop_switch({label,0,0,0},'pause');
    end

function paras=Commands_Cmd_DecodeforCmd(cmd)
    paras=struct();
    if isempty(cmd);return;end;
    %%%
    strIndStr=regexp(cmd,'=','split');
    menuStr=strIndStr{1};
    indexStr=strIndStr{2};
    parasStr=strIndStr{3};
    %%%
    menus=regexp(menuStr,'\$','split');
    paras.fMenu=menus{1};
    paras.mMenu=menus{2};
    paras.pMenu=menus{3};
    indexs=str2double(regexp(indexStr,'\$','split'));
    paras.fIndex=indexs(1);
    paras.mIndex=indexs(2);
    paras.pIndex=indexs(3);
    if ~isempty(parasStr)
        paraStrs=regexp(parasStr,'\|','split');
        for i=1:length(paraStrs)
            str=paraStrs{i};
            keyval=regexp(str,'\$','split');
            key=keyval{1};
            txt=keyval{2};
            [ok,val]=txt2val(txt);
            if isfield(paras,key)
                para=getfield(paras,key);
            else
                para=struct();
            end
            if ok
                para=setfield(para,'val',val);
            else
                para=setfield(para,'val',txt);
            end
            paras=setfield(paras,key,para);
        end
    end
function Pp=Commands_Cmd_InsertforCmd(Pp,Sp)
    keys=fieldnames(Sp);
    for i=1:length(keys)
        key=keys{i};
        if ~isfield(Pp,key);continue;end;
        pps=getfield(Pp,key);
        sps=getfield(Sp,key);
        if strcmp(class(pps),'struct')
            pps=Commands_Cmd_InsertforCmd(pps,sps);
            Pp=setfield(Pp,key,pps);
        else
            Pp=setfield(Pp,key,sps);
        end
    end
%-------------
function AllCmds_Callback(hObject, eventdata, handles)
    All_Call(hObject, eventdata, handles);
function AllFiles_Callback(hObject, eventdata, handles)
    All_Call(hObject, eventdata, handles);
function AllDirs_Callback(hObject, eventdata, handles)
    All_Call(hObject, eventdata, handles);
function All_Call(hObject, eventdata, handles)
    if D3R_loop_switch();
        rtn=questdlg({'Quit:','Are you sure to quit ?'},'Attention:','Yes','No','Yes');
        if strcmp(rtn,'No');return;end;
        D3R_unloop();
        set(hObject,'Foreground','k','String',['[',cell2mat(regexp(get(hObject,'Tag'),'[CFD]\w*','match')),']']);   
        return;
    end
    %-
    COL=get(hObject,'Foreground');
    STR=get(hObject,'String');
    set(hObject,'Foreground','r','String','[Stop]');
    D3R_loop(hObject);
    %-
    try
       switch hObject
            case handles.AllCmds
                AllCmds_Call(handles);
            case handles.AllFiles
                AllFiles_Call(handles);
            case handles.AllDirs
                AllDirs_Call(handles);
        end
    catch
        D3R_unloop(hObject);
        set(hObject,'Foreground',COL,'String',STR);   
        msgShow(handles,2,strcat('E> ',lasterr));
        return;
    end
    %-
    D3R_unloop(hObject);
    set(hObject,'Foreground',COL,'String',STR);   
function AllCmds_Call(handles)
        hObj=handles.Commands;
        contents=get(hObj,'String');
        if isempty(contents)
            msgShow(handles,2,'M> no [Command]');
            return;
        end;
        contents=cellstr(contents);
        num=numel(contents);
        cmds=contents;
        %------------------------
        startIndex=0;
        i=1;is=num-startIndex;
        while i<=is
          i=i+Commands_Cmd_Decode(handles,startIndex+i,cmds);
          if ~D3R_loop_switch({'AllCmds',1,i,is},'pause');break;end;
        end
function AllFiles_Call(handles)
        hObj=handles.Files;
        contents=get(hObj,'String');
        if isempty(contents)
            msgShow(handles,2,'M> no [File]');
            return;
        end
        contents=cellstr(contents);
        is=numel(contents);       
        for i=1:is
            set(hObj,'Value',i);
            Files_action(handles);
            %
            AllCmds_Call(handles);
            if ~D3R_loop_switch({'AllFiles',1,i,is},'pause');break;end;
            %
            if i<is;set(handles.Commands,'Value',1);end;
        end
function AllDirs_Call(handles)
        hObj=handles.Dirs;
        contents=get(hObj,'String');
        if isempty(contents)
            msgShow(handles,2,'M> no [Directory]');
            return;
        end
        contents=cellstr(contents);
        is=numel(contents);
        for i=1:is
            set(hObj,'Value',i);
            Dirs_action(handles);
            %
            AllFiles_Call(handles)
            if ~D3R_loop_switch({'AllDirs',1,i,is},'pause');break;end;
        end
%****************************************
function Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Edit_Callback(hObject, eventdata, handles)
    global Menus;
    %---
    try
        str=get(hObject,'String');
        contents=get(Menus.Edit.hObject,'String');
        strs=cellstr(contents);
        index=Menus.Edit.hIndex;
        if isempty(index)
            strs=str;
        else
            strs{index}=str;
        end
        set(Menus.Edit.hObject,'String',strs);
    catch
        msgShow(handles,2,strcat('E> ',lasterr));
        return;
    end
    %%%
    set(hObject,'Visible','off');
    set(handles.AllCmds,'Visible','on');
    set(handles.AllFiles,'Visible','on');
    set(handles.AllDirs,'Visible','on');
    %%%
    freeShow(handles);
%****************************************
function Records_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Records (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Records_Callback(hObject, eventdata, handles)
% hObject    handle to Records (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns Records contents as cell array
%        contents{get(hObject,'Values')} returns selected item from Records
    persistent stat;if isempty(stat);stat=1;end;
    index=get(hObject,'Value');
    if ~D3R_loop_switch() && ~D3R_lock();stat=index;else;set(hObject,'Value',stat);msgShow(handles,2,'L> [Stop/UnLoop] first');return;end;
    %------------------------
    lstShow(hObject,handles);
%
function Records_Menus_Callback(hObject, eventdata, handles)
    
    if ~D3R_loop_switch() && ~D3R_lock();set(hObject.Children,'Visible','on');else;msgShow(handles,2,'L> [Stop/UnLoop] first');set(hObject.Children,'Visible','off');return;end;
%------------------------
function Records_Menus_Edit_Callback(hObject, eventdata, handles)
function Records_Menus_Edit_Record_Callback(hObject, eventdata, handles)
% hObject    handle to Records_Menus_Edit_Record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global Records;
                    D3R_record(handles,Records.record,false);
                    D3R_record(handles,datestr(now));
function Records_Menus_Edit_Edit_Callback(hObject, eventdata, handles)
    global Menus;
    %---
    try
        hObject=handles.Records;
        index=get(hObject,'Value');
        strs=cellstr(get(hObject,'String'));
        Menus.Edit.hObject=hObject;
        Menus.Edit.hIndex=index;
        if isempty(index)
            str='';
        else
            str=strs{index};
        end
        set(handles.Edit,'String',str);
    catch
        msgShow(handles,2,strcat('E> ',lasterr));
        return;
    end
    %%%
    set(handles.Edit,'Visible','on');
    set(handles.AllCmds,'Visible','off');
    set(handles.AllFiles,'Visible','off');
    set(handles.AllDirs,'Visible','off');
    %%%
    busyShow(handles);
function Records_Menus_Edit_Up_Callback(hObject, eventdata, handles)
    lstUpDown(handles.Records,handles,true);
function Records_Menus_Edit_Down_Callback(hObject, eventdata, handles)
    lstUpDown(handles.Records,handles,false);
%
function Records_Menus_Clear_Callback(hObject, eventdata, handles)
function Records_Menus_Clear_Selected_Callback(hObject, eventdata, handles)
    lstRemove(handles.Records,handles);
function Records_Menus_Clear_Down_Callback(hObject, eventdata, handles)
    lstRemoveDowns(handles.Records,handles);
function Records_Menus_Clear_All_Callback(hObject, eventdata, handles)
    lstEmpty(handles.Records);
%
function Records_Menus_Data_Callback(hObject, eventdata, handles)
function Records_Menus_Data_Import_Callback(hObject, eventdata, handles)
    lstImport('xls',handles.Records,handles);
function Records_Menus_Data_Export_Callback(hObject, eventdata, handles)
    lstExport('xls',handles.Records,handles);
%****************************************
function Figures_Menus_Callback(hObject, eventdata, handles)
    set(allchild(hObject),'Visible','off');
    D3R_button('right');
    pause(0.1);
    %-----------------
    if D3R_button([],'move')
        return;
    else
        D3R_button('');
        set(allchild(hObject),'Visible','on');
    end
function Figures_Menus_Info_Callback(hObject, eventdata, handles)
    Info_show(handles,true);
%
function Figures_Menus_Axis_Callback(hObject, eventdata, handles)
    ax=gca(handles.Form);
    %Off
    hObj=handles.Figures_Menus_Axis_tick;
    if strcmp(ax.Visible,'on')
        set(hObj,'Label','Tick:off');
    else
        set(hObj,'Label','Tick:on');
    end
    %Hidden
    hObj=handles.Figures_Menus_Axis_hidden;
    h=hidden;
    if strcmp(h,'off')
        set(hObj,'Label','Hidden:on');
    else
        set(hObj,'Label','Hidden:off');
    end
    %Background
    hObj=handles.Figures_Menus_Axis_background;
    if isequal(get(gca,'Color'),[1,1,1])
        set(hObj,'Label','Background:manual');
    else
        set(hObj,'Label','Background:default');
    end
    %------------
    %Equal
    minx=min(diff(ax.XAxis.MinorTickValues));
    miny=min(diff(ax.YAxis.MinorTickValues));
    hObj=handles.Figures_Menus_Axis_Equal;
    if round(minx/miny)~=1
        set(hObj,'Label','Axis:equal');
    else
        set(hObj,'Label','Axis:normal');
    end
    %ij
    hObj=handles.Figures_Menus_Axis_ij;
    if strcmp(ax.YDir,'normal')
        set(hObj,'Label','Axis:ij');
    else
        set(hObj,'Label','Axis:xy');
    end
    %3D
    [i,j]=view(ax);
    hObj=handles.Figures_Menus_Axis_3D;
    if isequal([i,j],[0,90])
        set(hObj,'Label','Axis:3D');
    else
        set(hObj,'Label','Axis:2D');
    end
%
function Figures_Menus_Axis_tick_Callback(hObject, eventdata, handles)
    lab=get(hObject,'Label');
    if strcmp(lab,'Tick:off');
        set(hObject,'Label','Tick:on');
        axis off;
    else
        set(hObject,'Label','Tick:off');
        axis on;
    end
function Figures_Menus_Axis_hidden_Callback(hObject, eventdata, handles)
% hObject    handle to Figures_Menus_Axis_hidden (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    lab=get(hObject,'Label');
    if strcmp(lab,'Hidden:off');
        set(hObject,'Label','Hidden:on');
        hidden off;
    else
        set(hObject,'Label','Hidden:off');
        hidden on;
    end
function Figures_Menus_Axis_background_Callback(hObject, eventdata, handles)
% hObject    handle to Figures_Menus_Axis_background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    lab=get(hObject,'Label');
    if strcmp(lab,'Background:default');
        set(hObject,'Label','Background:manual');
        set(gca,'Color','w');
    else
        set(hObject,'Label','Background:default');
        cols=colormap();
        set(gca,'Color',cols(1,:));
    end

function Figures_Menus_Axis_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Figures_Menus_Axis_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    fig=figSwitch(2);
    clf(fig);
    copyobj(gca(handles.Form),fig);
    colormap(fig,colormap(handles.Form));
function Figures_Menus_Axis_Delete_Callback(hObject, eventdata, handles)
    objs=allchild(gca);
    for i=1:numel(objs)
        obj=objs(i);
        if isprop(obj,'Selected') && strcmp(get(obj,'Selected'),'on')
            delete(obj);
        end
    end
function Figures_Menus_Axis_Clear_Callback(hObject, eventdata, handles)
    cla;
    axis off;
%
function Figures_Menus_Axis_3D_Callback(hObject, eventdata, handles)
    lab=get(hObject,'Label');
    if strcmp(lab,'Axis:2D')
        view(2);
        set(hObject,'Label','Axis:3D');
    else
        view(3);
        set(hObject,'Label','Axis:2D');
    end
function Figures_Menus_Axis_ij_Callback(hObject, eventdata, handles)
% hObject    handle to Figures_Menus_Axis_ij (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    lab=get(hObject,'Label');
    if strcmp(lab,'Axis:ij');
        set(hObject,'Label','Axis:xy');
        axis ij;
    else
        set(hObject,'Label','Axis:ij');
        axis xy;
    end
function Figures_Menus_Axis_Equal_Callback(hObject, eventdata, handles)
% hObject    handle to Figures_Menus_Axis_Equal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    lab=get(hObject,'Label');
    if strcmp(lab,'Axis:equal');
        set(hObject,'Label','Axis:normal');
        axis equal;
    else
        set(hObject,'Label','Axis:equal');
        axis auto;
        axis normal;
    end
%
%****************************************
function Figures_Menus_Switch_Callback(hObject, eventdata, handles)
function Figures_Menus_Switch_Animation_Callback(hObject, eventdata, handles)
    persistent Loop;
    global Records;
    sObject=hObject;
    hObject=handles.Figures_Menus_Switch_Animation;
    lab=get(hObject,'Label');
    if strcmp(lab,'Animation')
        set(hObject,'Label','Animation:off');
        Loop=true;
        %--------------------
        if handles.Figures.Position(4)>handles.Windows.Position(4)
            ax=handles.Figures;
        else
            ax=handles.Windows;
        end
        axes(ax);
        %--------------------
        if isequal(sObject,hObject)
            busyShow(handles);
        end
        [az,el]=view();
        D3R_loop_switch(1,'tmp');
        for i = 1:3:360
           if ~Loop;break;end
           e=90*cos(2*pi*i/360);
           view(i,e);
           %
           if ~isequal(sObject,hObject)
               img=figExport(handles,nan,[],[]);
               writeVideo(Records.writer,img);
           else
               pause(0.1);
           end
           %
           if ~D3R_loop_switch({'Animation',1,i,360},'pause');break;end;
        end
        D3R_loop_switch(2,'tmp');
        view(az,el);
        %%%
        if isequal(sObject,hObject)
            freeShow(handles);
        end
        %--------------------
        set(hObject,'Label','Animation');
        Loop=false;
    else
        set(hObject,'Label','Animation');
        Loop=false;
    end
function Figures_Menus_Switch_Coordinate_Callback(hObject, eventdata, handles)
% hObject    handle to Figures_Menus_Switch_Coordinate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    lab=get(hObject,'Label');
    if strcmp(lab,'Coordinate')
        set(hObject,'Label','unCoordinate');
        datacursormode on;
        Switch_Callback(struct('Callback',@Figures_Menus_Switch_Coordinate_Callback,'hObject',hObject,'label','[Coordinate]','handles',handles));
    else
        set(hObject,'Label','Coordinate');
        datacursormode off;
        Switch_Callback(struct('Callback',[],'hObject',hObject,'label','[Coordinate]','handles',handles));
   end
function Figures_Menus_Switch_Window_Callback(hObject, eventdata, handles)
    D3R_switch(handles,nan);
%****************************************
function Figures_Menus_Clipboard_Callback(hObject, eventdata, handles)
% hObject    handle to Figures_Menus_Clipboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function Figures_Menus_Clipboard_Copy_Callback(hObject, eventdata, handles)
% hObject    handle to Figures_Menus_Clipboard_Copy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global Menus Records;
    Menus.clipboard.copy=Records.img;
    colormap(handles.Windows,colormap(handles.Figures));
    tmpShow(handles,struct('Tag','img','Data',Records.img),'Visible',{'on','off'},0);
function Figures_Menus_Clipboard_Paste_Callback(hObject, eventdata, handles)
% hObject    handle to Figures_Menus_Clipboard_Paste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global Menus Records;
    Records.raw=Menus.clipboard.copy;
    tmpShow(handles,struct('Tag','img','Data',Records.raw),'Visible',{'on','off'},0.1);
    figShow(handles,'hold off',Records.raw);
function Figures_Menus_Clipboard_Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Figures_Menus_Clipboard_Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global Menus;
    Menus.clipboard.copy=[];
%****************************************
function Figures_Menus_Data_Callback(hObject, eventdata, handles)
function Figures_Menus_Data_Import_Callback(hObject, eventdata, handles)
    figImport(handles,'*.tif;*.tiff;*.png;*.jpg;*.bmp;*.gif;');
function Figures_Menus_Data_Export_Callback(hObject, eventdata, handles)
    figExport(handles,nan,'.','*.eps;*.tif;*.tiff;*.png;*.jpg;*.bmp;');
%
function Figures_Menus_About_Callback(hObject, eventdata, handles)
% hObject    handle to Figures_Menus_About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if isequal(hObject,handles.Figures_Menus_About)
        time=3;
    else
        time=0;
    end
       tmpShow(handles,struct('Tag','info','Data',{{
        'OME:3DR (version5.5 2018.01.01)';
        '';
        'Li Guang';
        'rwwb@foxmail.com';
        'Institute of Biophysics & HuaZhong Agricultural University';
        }}),'Visible',{'on','off'},time);
%****************************************
function Functions_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to Functions (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function Functions_Callback(hObject, eventdata, handles)
    % hObject    handle to Functions (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns Functions contents as cell array
    %        contents{get(hObject,'Max')} returns selected item from Functions
    %##########################
    Functions_switch(handles,'Functions');
%-------------
function Menus_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to Menus (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
function Menus_Callback(hObject, eventdata, handles)
    % hObject    handle to Menus (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns Menus contents as cell array
    %        contents{get(hObject,'Values')} returns selected item from Menus
    %###
    Functions_switch(handles,'Menus');
%-------------
function Parameters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Parameters_Callback(hObject, eventdata, handles)
% hObject    handle to Parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Parameters contents as cell array
%        contents{get(hObject,'Values')} returns selected item from Parameters
    Functions_switch(handles,'Parameters');
%-------------
function Values_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Values_Callback(hObject, eventdata, handles)
% hObject    handle to Values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Values as text
%        str2double(get(hObject,'String')) returns contents of Values as a double
    persistent stat;if isempty(stat);stat='';end;
    index=get(hObject,'Value');
    if ~D3R_loop_switch() && ~D3R_lock();stat=index;else;set(hObject,'String',stat);msgShow(handles,2,'L> [Stop/UnLoop] first');return;end;
    %------------------------
    Changes_put(handles);
function Changes_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to slider1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
function Changes_Callback(hObject, eventdata, handles)
    % hObject    handle to slider1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'Max') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    persistent stat;if isempty(stat);stat=1;end;
    index=get(hObject,'Value');
    if ~D3R_loop_switch() && ~D3R_lock();stat=index;else;set(hObject,'Value',stat);msgShow(handles,2,'L> [Stop/UnLoop] first');return;end;
    %------------------------
    Changes_get(handles)
function Changes_put(handles)
    hObject=handles.Values;
    txt=get(hObject,'String');
    [ok,type]=Changes_same(txt,handles);
    if ~ok;msgShow(handles,2,'M> input: format error');return;end;
    if strcmp(type,'char');Changes_update(txt,txt,handles);return;end;
    %
    [ok,val]=txt2num(txt);
    if ok
        minv=get(handles.Changes,'Min');
        maxv=get(handles.Changes,'Max');
        err1='M> ';
        err2=strcat(' than range','[',num2str(minv),',',num2str(maxv),']');
        if val<minv
            msgShow(handles,2,strcat(err1,'less',err2));
            return;
        elseif val>maxv
            msgShow(handles,2,strcat(err1,'more',err2));
            return;
        else
            set(handles.Changes,'Value',val);
        end
    else
        [ok,val]=txt2val(txt);
        if ~ok;msgShow(handles,2,strcat('E> ',lasterr));return;end;
    end
    %
    Changes_update(txt,val,handles);
function Changes_get(handles)
    val=get(handles.Changes,'Value');
    Changes_update(num2str(val),val,handles);
function [ok,type]=Changes_same(txtOrval,handles)
    global Menus Parameters;
    if ~isfield(Menus,'Menus');msgShow(handles,2,'M> no [Functions]/[Menus]');ok=false;type=0;return;end;
    if strcmp(Menus.Parameters,'Parameters');msgShow(handles,2,'M> [Parameters]');ok=false;type=0;return;end;
    %
    name=Menus.Parameters;
    para=getfield(Parameters,name);
    pval=para.val;

    ok=false;type=class(pval);
    if strcmp(type,'char');
        ok=true;
        return;
    elseif strcmp(class(txtOrval),'char')
        try
            val=eval(txtOrval);
        catch
            return;
        end
    else
        val=txtOrval;
    end
    if strcmp(class(val),type);ok=true;end;
function Changes_update(txt,val,handles)
    try
        global Menus Parameters;
        name=Menus.Parameters;
        paras=getfield(Parameters,name);
        paras=setfield(paras,'val2txt',txt);
        paras=setfield(paras,'val',val);
        Parameters=setfield(Parameters,name,paras);
    catch
        msgShow(handles,2,'E> Parameters update');
        return;
    end
    Functions_switch(handles,'Parameters');
%-------------
function Progress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Progress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function Progress_Callback(hObject, eventdata, handles)
function Show_Callback(hObject, eventdata, handles)
%****************************************
function Functions_switch(handles,selection,pointedIndex)
    global Menus Records;
    if nargin<=2;pointedIndex=0;end
    %selection
    if Functions_selection(handles,selection,pointedIndex);return;end;
    %Functions
    switch Menus.Functions
        case 'Image'
            switch selection
                case 'Functions'
                    if Functions_gui(handles,selection,struct(...%initialize'
                        'Parameters',struct('tip',['[',Menus.Functions,'] function']),...%
                        'Menus','Viewer|Clipboard|Transform|Color|Gray|Rgb|BWAction|FillOrErode|Edge',...%menus='Menus|Image|...'
                        'FileType','im|tiff|tif|jpeg|jpg|png|gif|hdf|bmp|pcx|xwd|cur|ico'...
                        ),pointedIndex);return;end;
                case 'Menus'
                    if ~isfield(Records,'raw');msgShow(handles,2,'M> not image file');return;end;
                    Image_fit(handles,selection,pointedIndex);
                case 'Parameters'

                    Image_fit(handles,selection,pointedIndex);

            end
        case 'Microscopy'
              switch selection
                case 'Functions'
                    if Functions_gui(handles,selection,struct(...%initialize
                        'Parameters',struct('tip',['[',Menus.Functions,'] function']),...%
                        'Menus','Viewer|D3Viewer',...%menus='Menus|Image|...'
                        'FileType','mi|dv'...
                        ),pointedIndex);return;end;
                case 'Menus'
                    Microscopy_fit(handles,selection,pointedIndex);
                case 'Parameters'

                    Microscopy_fit(handles,selection,pointedIndex);

             end
        case 'Video'
            switch selection
                case 'Functions'
                    if Functions_gui(handles,selection,struct(...%initialize
                        'Parameters',struct('tip',['[',Menus.Functions,'] function']),...%
                        'Menus','Viewer|Player',...%menus='Menus|Image|...'
                        'FileType','av|avi|mj2|3gp|mp4'...
                        ),pointedIndex);return;end;
                case 'Menus'
                    Video_fit(handles,selection,pointedIndex);
                case 'Parameters'

                    Video_fit(handles,selection,pointedIndex);

            end
        case 'Identify'
            switch selection
                case 'Functions'
                    if Functions_gui(handles,selection,struct(...%initialize
                        'Parameters',struct('tip',['[',Menus.Functions,'] function']),...%
                        'Menus','Center|Point|Line|Region|Edge|Color',...%menus='Menus|Image|...'
                        'FileType','.'...%'.'return;
                        ),pointedIndex);return;end;
                case 'Menus'
                    Identify_fit(handles,selection,pointedIndex);
                case 'Parameters'
                    if isempty(Records.raw);msgShow(handles,2,'M> no ''Image'' data');D3R_unloop();
                    elseif ~strcmp(class(Records.raw),'double');msgShow(handles,2,'M> please ''Image/Gray'' first');D3R_unloop();end;
                    %%%

                    Identify_fit(handles,selection,pointedIndex);

            end
        case 'D3R'
            switch selection
                case 'Functions'
                    if Functions_gui(handles,selection,struct(...%initialize
                        'Parameters',struct('tip',['[',Menus.Functions,'] function']),...%
                        'Menus','Viewer|Scanner|Source|Transform|Perspective',...%menus='Menus|Image|...'
                        'FileType','.'...%'.'return;
                        ),pointedIndex);return;end;
                case 'Menus'
                    D3_fit(handles,selection,pointedIndex);
                case 'Parameters'
                    if ~strcmp(Menus.Menus,'Viewer') && ~strcmp(Menus.Menus,'Scanner') && isempty(Records.D3.polars);msgShow(handles,2,'M> go to ''D3R/Scanner''');D3R_unloop();end
                    %%%

                    D3_fit(handles,selection,pointedIndex);

            end
        case 'Command'
            switch selection
                case 'Functions'
                    if Functions_gui(handles,selection,struct(...%initialize
                        'Parameters',struct('tip',['[',Menus.Functions,'] function']),...%
                        'Menus','Action|Draw|Colormap|Output',...%menus='Menus|Image|...'
                        'FileType','.'...
                        ),pointedIndex);return;end;
                case 'Menus'
                    Command_fit(handles,selection,pointedIndex);
                case 'Parameters'

                    Command_fit(handles,selection,pointedIndex);

            end
        case 'Analyse'
            switch selection
                case 'Functions'
                    if Functions_gui(handles,selection,struct(...%initialize
                        'Parameters',struct('tip',['[',Menus.Functions,'] function']),...%
                        'Menus','1D|2D|3D',...%menus='Menus|Image|...'
                        'FileType','.'...%'.'return;
                        ),pointedIndex);return;end;
                case 'Menus'
                    Analyse_fit(handles,selection,pointedIndex);
                case 'Parameters'
                    if ~strcmp(Menus.Menus,'1D') && isempty(Records.xys);msgShow(handles,2,'M> go to ''D3R/ScannerXY''');D3R_unloop();end;
                    %%%

                    Analyse_fit(handles,selection,pointedIndex);

            end
        case 'Format'
            switch selection
                case 'Functions'
                    if Functions_gui(handles,selection,struct(...%initialize
                        'Parameters',struct('tip',['[',Menus.Functions,'] function']),...%
                        'Menus','Project|D3R|Form|Frame|Figure|Raw|Video|Output',...%menus='Menus|Image|...'
                        'FileType','.'...
                        ),pointedIndex);return;end;
                case 'Menus'
                    Format_fit(handles,selection,pointedIndex);
                case 'Parameters'
                    if isempty(Records.file.rootPath);msgShow(handles,2,'M> no [WorkSpace]');D3R_unloop();end;
                    %%%

                    Format_fit(handles,selection,pointedIndex);

            end
        case 'Plugin'
            switch selection
                case 'Functions'
                    if Functions_gui(handles,selection,struct(...%initialize
                        'Parameters',struct('tip',['[',Menus.Functions,'] function']),...%
                        'Menus','Package|Java|Matlab|R|Python',...%menus='Menus|Image|...'
                        'FileType','.'...
                        ),pointedIndex);return;end;
                case 'Menus'
                    Plugin_fit(handles,selection,pointedIndex);
                case 'Parameters'

                    Plugin_fit(handles,selection,pointedIndex);

            end
        otherwise
            return;%invalid
    end
function jump=Functions_selection(handles,selection,pointedIndex) 
        global Menus Records;
        jump=true;
        %---
        if isempty(Records.file.readerPath) && ~pointedIndex
            Menus.Menus='Menus';
            set(handles.Menus,'String',Menus.Menus,'Value',1);
            Menus.Parameters='Parameters';
            set(handles.Parameters,'String',Menus.Parameters,'Value',1);
            set(handles.Values,'String','');
            set(handles.Values,'Enable','off');
            set(handles.Changes,'Enable','off');
            %%%
            msgShow(handles,2,'M> no opened [File]');
            D3R_unloop();
            return;
        end
        %---
        hObject=getfield(handles,selection);
        contents=cellstr(get(hObject,'String'));
        if pointedIndex%auto
            ind=pointedIndex;
            now=contents{ind};
            set(hObject,'Value',ind);
        else%manual
            try
                ind=get(hObject,'Value');
                now=contents{ind};
            catch
                msgShow(handles,2,strcat('E> ',lasterr));
                return;
            end
            val=getfield(Menus,[selection,'Index']);
            if strcmp(now,selection)
                set(hObject,'Value',val);
                msgShow(handles,2,['M> no [',selection,']']);        
                return;
            end
        end
        %save
        Menus=setfield(Menus,selection,now);
        Menus=setfield(Menus,[selection,'Index'],ind);
        %init
        switch selection
            case 'Functions'
                Menus.Menus='Menus';
                Menus.MenusIndex=1;
                Menus.Parameters='Parameters';
                Menus.ParametersIndex=1;
            case 'Menus'
                Menus.Parameters='Parameters';
                Menus.ParametersIndex=1;
            case 'Parameters'
            otherwise
                msgShow(handles,2,'E> selection');
                return;
        end
        %---
        %save
        if ~pointedIndex;Menus.command.index=0;end;
        Menus=setfield(Menus,'Keys',[Menus.Functions,'/',Menus.Menus,'/',Menus.Parameters,'/',num2str(Menus.command.index)]);
        %---
        jump=false;
function jump=Functions_gui(handles,selection,paras,pointedIndex)
    global Menus Parameters;
    set(handles.Values,'String','');
    set(handles.Values,'Enable','off');
    set(handles.Changes,'Enable','off');
    switch selection
        case 'Functions'
            set(handles.Functions,'TooltipString',paras.Parameters.tip);
            %---
            set(handles.Functions,'Enable','on');
            set(handles.Menus,'Enable','on','String',Menus.Menus,'Value',Menus.MenusIndex);
            set(handles.Parameters,'Enable','off','String',Menus.Parameters,'Value',Menus.ParametersIndex);
            %Menus/FileType
            if isfield(paras,'Menus');
                if ~strcmp(paras.Menus(1:min(end,5)),'Menus');paras.Menus=['Menus|' paras.Menus];end;
                set(handles.Menus,'String',paras.Menus,'Value',1);
            end
            if isfield(paras,'FileType');
                if strcmp(paras.FileType,'im')
                elseif strcmp(paras.FileType,'mi')
                    %BF=bfGetReader;
                    %type=char(BF.getSuffixes);
                    %paras.FileType=strtrim(mat2cell(type,ones(size(type,1),1)));
                    paras.FileType={'dv'};
                elseif strcmp(paras.FileType,'av')
                elseif strcmp(paras.FileType,'.')||isempty(paras.FileType)
                    paras.FileType={};
                else
                    paras.FileType=regexp(paras.FileType,'\|','split');
                end
                %Parameters
                Parameters=paras;
                if ~pointedIndex;Dirs_action(handles);end;
            end
            %%%
            if ~pointedIndex;msgShow(handles,2,'A> no [Menus]');end;
            jump=true;
            return;
        case 'Menus'
            set(handles.Menus,'TooltipString',paras.Parameters.tip);
            %---
            set(handles.Parameters,'Enable','on','String',Menus.Parameters,'Value',Menus.ParametersIndex);
            %Parameters
            Parameters=paras;
            names=fieldnames(paras);
            set(handles.Parameters,'String',names,'Value',1);
            %%%
            if ~pointedIndex;msgShow(handles,1,'A> no [Parameters]');end;
            jump=true;
            return;
        case 'Parameters'
            opts=get(handles.(selection),'String');
            set(handles.(selection),'TooltipString',paras.(opts{get(handles.(selection),'Value')}).tip);
            %---
            %%%
            %mode0 >>> text
            %mode1 >>> 0-0.01-1
            %mode2 >>> int
            %mode3 >>> 1+2
            %mode4 >>> ???
            %mode99 >>> off/off
            %Parameters>>> only read; wirte by change and auto;
            paras=getfield(Parameters,Menus.Parameters);
            if paras.min==paras.max || paras.step==1
                paras.mode=99;
                Menus.busy.Changes='off';
            else
                set(handles.Changes,'Min',paras.min);
                set(handles.Changes,'Max',paras.max);
            end
            set(handles.Changes,'Enable','on');
            set(handles.Values,'Enable','on');
            set(handles.Values,'TooltipString',paras.tip);
            val=paras.val;
            switch paras.mode
                case 0
                    set(handles.Changes,'Enable','off');
                case 1
                    set(handles.Changes,'SliderStep',[0.01,min(10/(paras.step-1),1)]);
                case 2
                    val=round(val);
                    set(handles.Changes,'SliderStep',[1/(paras.step-1),min(10/(paras.step-1),1)]);
                    paras.val=val;
                    paras.val2txt=num2str(val);
                case 3
                    if val<1
                        set(handles.Changes,'SliderStep',[0.01,min(10/(paras.step-1),1)]);
                    else
                        set(handles.Changes,'SliderStep',[1/(paras.step-1),min(10/(paras.step-1),1)]);
                    end
                case 4
                    if val<1
                        set(handles.Changes,'SliderStep',[0.001,min(1/(paras.step-1),1)]);
                    else
                        val=round(val);
                        set(handles.Changes,'SliderStep',[1/(paras.step-1),min(10/(paras.step-1),1)]);
                        paras.val=val;
                        paras.val2txt=num2str(val);
                    end
                case 99
                    set(handles.Changes,'Enable','off');
                    set(handles.Values,'Enable','off');
                case 100
                    set(handles.Changes,'Enable','off');
                    set(handles.Values,'Enable','on');
                otherwise
                    set(handles.Changes,'Enable','off');
                    set(handles.Values,'Enable','off');
            end
            try
                if strcmp(get(handles.Changes,'Enable'),'on')
                    set(handles.Changes,'Value',val);
                end
                if strcmp(get(handles.Values,'Enable'),'on')
                    set(handles.Values,'String',val);
                end
            catch
            end
            Parameters=setfield(Parameters,Menus.Parameters,paras);
            %%%
            if ~pointedIndex;jump=false;else;jump=true;end;
            return;
        otherwise
            msgShow(handles,2,'E> selection error');
            jump=true;
            return;
    end
%-------------
function Image_fit(handles,selection,pointedIndex)
    global Menus Parameters Records;
    switch Menus.Menus
        case 'Viewer'
            if ~isfield(Menus.reader,'NumberOfChannel');set(handles.Parameters,'String','Parameters');msgShow(handles,2,'M> not ''Image'' file');return;end;
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Normalize',struct('mode',2,'min',0,'val',1,'max',1,'step',2,'val2txt','','tip','Normalize:0:Off; 1:On;'),...
                'Channel',struct('mode',2,'min',0,'val',0,'max',Menus.reader.NumberOfChannel,'step',Menus.reader.NumberOfChannel+1,'val2txt','','tip','0:All; otherwise:Channel Index; The index of image channels'),...
                'Index',struct('mode',4,'min',0,'val',1,'max',Menus.reader.NumberOfFrames,'step',Menus.reader.NumberOfFrames,'val2txt','','tip','The index of image frame'),...
                'Loop',struct('mode',2,'min',0,'val',0,'max',2,'step',3,'val2txt','','tip','0:Off; 1:Start; 2:End; >>> do with the process in loop')...
                ),pointedIndex);return;end;
            %-----------------------------
            %>>>tmp Channel
            if strcmp(Menus.Parameters,'Channel');set(handles.Changes,'max',Menus.reader.NumberOfChannel);end;
            Dir_File_read(handles,Records.file.filePath,Parameters,true,false);
            return;
        case 'Clipboard'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',1,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);%{1}can't move;{2}selection=2>>>val=0(normal);val=1(must one);
                'Copy',struct('mode',99,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Copy the current image'),...
                'Paste',struct('mode',99,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Paste the last copy'),...
                'Clear',struct('mode',99,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Clear the last copy')...
                ),pointedIndex);return;end;
            %%%
            switch Menus.Parameters
                case 'Copy'
                    Menus.clipboard.copy=Records.img;
                    colormap(handles.Windows,colormap(handles.Figures));
                    tmpShow(handles,struct('Tag','img','Data',Records.img),'Visible',{'on','off'},0);
                case 'Paste'
                    Records.raw=Menus.clipboard.copy;
                    tmpShow(handles,struct('Tag','img','Data',Records.raw),'Visible',{'on','off'},0.1);
                case 'Clear'
                    Menus.clipboard.copy=[];
            end
            rst=Menus.clipboard.copy;
        case 'Transform'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Alpha',struct('mode',1,'min',0,'val',1,'max',1,'step',100,'val2txt','','tip','Transparency'),...
                'Adjust',struct('mode',3,'min',0,'val',1,'max',2^16-1,'step',2^16,'val2txt','','tip','Transform to range[0,x]'),...
                'Normalize',struct('mode',2,'min',0,'val',1,'max',1,'step',2,'val2txt','','tip','Normalize to range[0,1]'),...
                'Projection',struct('mode',2,'min',0,'val',0,'max',3,'step',4,'val2txt','','tip','Projection between current and clipboard: 0:None; 1:Min; 2:Mean; 3:Max;')...
                ),pointedIndex);return;end;
            %%%
            switch Menus.Parameters
                case 'Alpha'
                    rst=Parameters.Alpha.val*Records.raw;
                case 'Adjust'
                    rst=mat2gray(Records.raw);
                    rst=round(Parameters.Adjust.val*rst);
                case 'Normalize'
                    if Parameters.Normalize.val
                        rst=mat2gray(Records.raw);
                    else
                        rst=Records.raw;
                    end
                case 'Project'
                    rst=Menus.clipboard.copy;
                    if isempty(rst);Menus.container.map(Menus.Keys)=1;return;end;
                    switch Parameters.Project.val
                        case 0
                            return;
                        case 1
                            img=cat(3,rst,Records.raw);
                            rst=min(img,[],3);
                        case 2
                            num=Menus.container.map(Menus.Keys);
                            %
                            img=num*rst+Records.raw;
                            rst=img/(num+1);
                            %
                            Menus.container.map(Menus.Keys)=num+1;
                        case 3
                            img=cat(3,rst,Records.raw);
                            rst=max(img,[],3);
                    end
            end
        case 'Color'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Mid',struct('mode',0,'min',1,'val','[]','max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','The value of rectangle structuring element size'),...
                'Span',struct('mode',1,'min',0,'val',0.1,'max',1,'step',100,'val2txt','','tip','The span of the mid value')...
                ),pointedIndex);return;end;
            %%%
            if isempty(Parameters.Mid.val)||strcmp(Parameters.Mid.val,'[]')||strcmp(Menus.Parameters,'Mid')
                [oldx,oldz]=view();
                view(2);
                msgShow(handles,0,'M> wait for pointing ...');
                [x,y,b]=ginput(1);
                msgShow(handles,0,'M> busy ...');
                view(oldx,oldz);
                x=round(x);y=round(y);
                [r,c]=size(Records.raw);
                if x<1 || x>c || y<1 || y>r
                    msgShow(handles,2,['E> range: row[1, ',num2str(r),'];col[1,',num2str(c),']']);
                    return;
                end
                col=Records.raw(round(y),round(x),:);
                str='[';
                for i=1:length(col)
                    str=[str,num2str(col(i)),','];
                end
                str=[str(1:end-1),']'];
                Parameters.Mid.val=str;
                set(handles.Values,'String',str);
            end
            RGB=eval(Parameters.Mid.val);
            maxV=max(Records.raw(:));
            if maxV<=1
                maxV=1;
            elseif maxV<2^8
                maxV=2^8-1;
            elseif maxV<2^16
                maxV=2^16-1;
            elseif maxV<2^32
                maxV=2^32-1;
            elseif maxV<2^64
                maxV=2^64-1;
            else
                msgShow(handles,2,'E> uint64');
                return;
            end
            rgV=maxV*Parameters.Span.val;
            rst=Records.raw;
            [row,col,chn]=size(rst);
            for i=1:length(RGB)
                mid=RGB(i);
                minV=max(0,mid-rgV);
                maxV=min(maxV,mid+rgV);
                im=rst(:,:,i);
                im(im<minV|im>maxV)=0;
                rst(:,:,i)=im;
            end
            %%%map
            if isempty(Menus.reader.map)
                if ndims(rst)>2
                    [x1,m1]=rgb2ind(Records.raw,65536);
                    [x2,m2]=rgb2ind(rst,65536);
                    rst=ind2rgb(x2,m1);
                end
            else
                if ndims(rst)>2
                    [x2,m2]=rgb2ind(rst,Menus.reader.map);
                else
                    x2=rst;
                end
                rst=ind2rgb(x2,Menus.reader.map);
            end
        case 'Gray'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Mode',struct('mode',2,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Mode>>> 0:Sel; 1:BW;'),...
                'Mid',struct('mode',1,'min',0,'val',0.5,'max',1,'step',100,'val2txt','','tip','The mid value of the figure to show'),...
                'Span',struct('mode',1,'min',0,'val',0.5,'max',1,'step',100,'val2txt','','tip','The span of the mid value')...
                ),pointedIndex);return;end;
            %%%
            rgV=Parameters.Span.val;
            midV=Parameters.Mid.val;
            minV=max(0,midV-rgV);
            maxV=min(1,midV+rgV);
            %%%
            gray=struct('min',minV,'mid',midV,'max',maxV,'mode',Parameters.Mode.val);
            rst=D3R_gray(handles,Records.raw,gray,true);
        case 'Rgb'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'RgbColor',struct('mode',2,'min',1,'val',1,'max',7,'step',7,'val2txt','','tip','Current color'),...
                'RgbRatio',struct('mode',1,'min',0,'val',1,'max',1,'step',100,'val2txt','','tip','Current ratio'),...
                'RgbMethod',struct('mode',2,'min',1,'val',1,'max',6,'step',6,'val2txt','','tip','RgbMethod> 1:Screen; 2:Multiply; 3:Overlay; 4:Hard; 5:Mix; 6:Cover;'),...
                'RgbMerge',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Mix current image with clipboard(background)')...
                ),pointedIndex);return;end;
            %%%
            cpy=Menus.clipboard.copy;
            if ndims(cpy)<3;msgShow(handles,2,'A> please convert ''Clipboard''image to ''rgb''image');return;end;
            col=Parameters.RgbColor.val;
            bkg=Parameters.RgbRatio.val;
            mtd=Parameters.RgbMethod.val;
            M=Menus.Parameters;
            if strcmp(M,'RgbColor')
                colormap(D3R_pallet());
                tmpShow(handles,'colorbar','Visible',{'on','off'},1);
            end
            if ndims(Records.raw)>2;img=rgb2gray(Records.raw);else img=Records.raw;end;
            img=mat2gray(img,[0,bkg]);
            rst=D3R_pallet(col,{[],img},mtd);
            if strcmp(M,'RgbMerge')
                rst=D3R_pallet(col,{cpy,rst},mtd);                        
            end
        case 'BWAction'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',1,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Bothat',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Branchpoints',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Bridge',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Clean',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Close',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Diag',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Dilate',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Endpoints',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Erode',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Fill',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Hbreak',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Majority',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Open',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Remove',struct('mode',99,'min',0,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Shrink',struct('mode',2,'min',0,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Skel',struct('mode',2,'min',0,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Spur',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Thicken',struct('mode',2,'min',0,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Thin',struct('mode',2,'min',0,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing'),...
                'Tophat',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Processing')...
                ),pointedIndex);return;end;
            if ndims(Records.raw)>2;msgShow(handles,2,'M> go to ''Image/Gray''');return;end;
            %%%
            name=lower(Menus.Parameters);
            val=getfield(Parameters,Menus.Parameters);
            if val.min==1
                rst=Records.raw;
                for i=1:val.val
                    rst=bwmorph(rst,name);
                end
            else
                rst=bwmorph(Records.raw,name,val.val);
            end
        case 'FillOrErode'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Mode',struct('mode',2,'min',0,'val',0,'max',3,'step',4,'val2txt','','tip','Mode>>> 0:Fill; 1:Erode; 2:TopHat; 3:BotHat;'),...
                'Diamond',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','The value of diamond structuring element size'),...
                'Disk',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','The value of disk structuring element size'),...
                'Square',struct('mode',2,'min',1,'val',1,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','The value of square structuring element size')...
                ),pointedIndex);return;end;
            %%%
            if Parameters.Mode.val==0
                Parameters.Diamond.mode=99;
                Parameters.Disk.mode=99;
                Parameters.Square.mode=99;
                %%%
                rst=imfill(Records.raw,'holes');
            else
                Parameters.Diamond.mode=2;
                Parameters.Disk.mode=2;
                Parameters.Square.mode=2;
                %%%
                name=lower(Menus.Parameters);
                if strcmp(name,'mode');return;end;
                val=getfield(Parameters,Menus.Parameters);
                if val.mode
                    se=strel(name,ceil(val.val));
                else
                    se=eval(['strel(''',name,''',',val.val,')']);
                end
                switch Parameters.Mode.val
                    case 0
                        rst=imfill(Records.raw,'holes');
                    case 1
                        rst=imerode(Records.raw,se);
                    case 2
                        rst=imtophat(Records.raw,se);
                    case 3
                        rst=imbothat(Records.raw,se);
                end
            end
        case 'Edge'            
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Mode',struct('mode',2,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Mode>>> 0:Canny; 1:Prewitt;'),...
                'Threshold',struct('mode',1,'min',0,'val',0.01,'max',1,'step',100,'val2txt','','tip','The threshold of the figure to show')...
                ),pointedIndex);return;end;
            if ndims(Records.raw)>2;msgShow(handles,2,'M> go to ''Image/Gray''');return;end;
            %%%
            switch Parameters.Mode.val
                case 0
                    rst=edge(Records.raw,'canny',Parameters.Threshold.val);
                case 1
                    rst=edge(Records.raw,'prewitt',Parameters.Threshold.val);
            end
        otherwise
            return;
    end
    figShow(handles,'hold off',rst);
%-------------
function Microscopy_fit(handles,selection,pointedIndex)
    global Menus Parameters Records;
    if ~ismethod(Menus.reader,'getSeriesCount');set(handles.Parameters,'String','Parameters');msgShow(handles,2,'M> not ''Microscopy'' file');return;end;
    switch Menus.Menus
        case 'Viewer'
                if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Normalize',struct('mode',2,'min',0,'val',1,'max',1,'step',2,'val2txt','','tip','Normalize:0:Off; 1:On;'),...
                'Series',struct('mode',2,'min',1,'val',1,'max',Menus.reader.getSeriesCount,'step',Menus.reader.getSeriesCount,'val2txt','','tip','Time axis'),...
                'Taxis',struct('mode',2,'min',1,'val',1,'max',Menus.reader.getSizeT,'step',Menus.reader.getSizeT,'val2txt','','tip','Time axis'),...
                'Caxis',struct('mode',2,'min',1,'val',1,'max',Menus.reader.getSizeC,'step',Menus.reader.getSizeC,'val2txt','','tip','Channel axis'),...
                'Zaxis',struct('mode',4,'min',0,'val',1,'max',Menus.reader.getSizeZ,'step',Menus.reader.getSizeZ,'val2txt','','tip','Z axis'),...
                'Loop',struct('mode',2,'min',0,'val',0,'max',2,'step',3,'val2txt','','tip','0:Off; 1:Start; 2:End; >>> do with the process in loop')...
                ),pointedIndex);return;end;
            %-----------------------------
            Dir_File_read(handles,Records.file.filePath,Parameters,true,false);
        case 'D3Viewer'
                if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Series',struct('mode',2,'min',1,'val',1,'max',Menus.reader.getSeriesCount,'step',Menus.reader.getSeriesCount,'val2txt','','tip','Time axis'),...
                'Taxis',struct('mode',2,'min',1,'val',1,'max',Menus.reader.getSizeT,'step',Menus.reader.getSizeT,'val2txt','','tip','Time axis'),...
                'Caxis',struct('mode',2,'min',0,'val',Records.D3V.Caxis,'max',Menus.reader.getSizeC,'step',Menus.reader.getSizeC+1,'val2txt','','tip','Caxis> 0:all; else:specified; Channel axis'),...
                'Caxis_mixIndex',struct('mode',2,'min',0,'val',Records.D3V.Caxis_mixIndex(max(1,Records.D3V.Caxis)),'max',Menus.reader.getSizeC,'step',Menus.reader.getSizeC+1,'val2txt','','tip','mixIndex> 0:Exclude; else:Order; Setting the order of the channel axis specified with Caxis'),...
                'Caxis_mixColor',struct('mode',2,'min',1,'val',Records.D3V.Caxis_mixColor(max(1,Records.D3V.Caxis)),'max',7,'step',7,'val2txt','','tip','Setting colormap of the channel axis specified with Caxis'),...
                'Caxis_mixRatio',struct('mode',1,'min',0,'val',Records.D3V.Caxis_mixRatio(max(1,Records.D3V.Caxis)),'max',1,'step',100,'val2txt','','tip','Setting ratio of the channel axis specified with Caxis'),...
                'Caxis_mixMethod',struct('mode',2,'min',1,'val',Records.D3V.Caxis_mixMethod(max(1,Records.D3V.Caxis)),'max',6,'step',6,'val2txt','','tip','mixMethod> 1:Screen; 2:Multiply; 3:Overlay; 4:Hard; 5:Mix; 6:Cover; Setting method for mixing the current channel with previous channel'),...
                'Zaxis',struct('mode',2,'min',0,'val',1,'max',Menus.reader.getSizeZ,'step',Menus.reader.getSizeZ+1,'val2txt','','tip','Zaxis> 0:all; else:specified;')...
                ),pointedIndex);return;end;
            %-----------------------------
                persistent OBJs IMGs;
                M=Menus.Parameters;
                C=Menus.reader.getSizeC;
                Z=Menus.reader.getSizeZ;
            %-----------------------------
                lab='Caxis_mixIndex';
                    vals=Records.D3V.(lab);
                    if numel(vals)<C;vals=[vals numel(vals)+1:C];end;
                    Records.D3V.(lab)=vals;
                lab='Caxis_mixColor';
                    vals=Records.D3V.(lab);
                    if numel(vals)<C;vals=[vals numel(vals)+1:C];end;
                    vals(vals>Parameters.(lab).max)=1;
                    Records.D3V.(lab)=vals;
                lab='Caxis_mixRatio';
                    vals=Records.D3V.(lab);
                    if numel(vals)<C;vals=[vals ones(1,C-numel(vals))];end;
                    Records.D3V.(lab)=vals;
                lab='Caxis_mixMethod';
                    vals=Records.D3V.(lab);
                    if numel(vals)<C;vals=[vals ones(1,C-numel(vals))];end;
                    Records.D3V.(lab)=vals;
            %-----------------------------
            if strcmp(M,'Caxis')
                Records.D3V.(M)=Parameters.(M).val;
                %---
                Parameters.Zaxis=struct('mode',4,'min',0,'val',1,'max',Menus.reader.getSizeZ,'step',Menus.reader.getSizeZ,'val2txt','','tip','Z axis');
                Parameters.Normalize=struct('mode',2,'min',0,'val',1,'max',1,'step',2,'val2txt','','tip','Normalize:0:Off; 1:On;');
                if Parameters.(M).val==0;
                    for Caxis=1:C
                        Parameters.Caxis=struct('mode',2,'min',0,'val',Caxis,'max',Menus.reader.getSizeC,'step',Menus.reader.getSizeC+1,'val2txt','','tip','Caxis> 0:all; else:specified; Channel axis');
                        img=Dir_File_read(handles,Records.file.filePath,Parameters,false,false);
                        tmpShow(handles,struct('Tag','img','Data',img),'Visible',{'on','off'},1);
                        pause(0.5);
                    end
                    return;
                else
                    Parameters.Caxis_mixIndex.val=Records.D3V.Caxis_mixIndex(Records.D3V.Caxis);
                    Parameters.Caxis_mixColor.val=Records.D3V.Caxis_mixColor(Records.D3V.Caxis);
                    Parameters.Caxis_mixRatio.val=Records.D3V.Caxis_mixRatio(Records.D3V.Caxis);
                    Parameters.Caxis_mixMethod.val=Records.D3V.Caxis_mixMethod(Records.D3V.Caxis);
                end
                if all(isobject(OBJs)) && all(isvalid(OBJs))%update
                    img=Dir_File_read(handles,Records.file.filePath,Parameters,false,false);
                else
                    img=Dir_File_read(handles,Records.file.filePath,Parameters,true,false);
                end
                tmpShow(handles,struct('Tag','img','Data',img),'Visible',{'on','off'},2);
                return;
            elseif strfind(M,'Caxis_')
                    Ori=Records.D3V.(M);
                    if Parameters.Caxis.val==0
                        Records.D3V.(M)=Parameters.(M).val*ones(1,Parameters.Caxis.max);
                    else
                        Records.D3V.(M)(Parameters.Caxis.val)=Parameters.(M).val;
                        if strcmp(M,'Caxis_mixIndex')
                            lst=Records.D3V.(M);
                            now=Parameters.(M).val;
                            old=Ori(Parameters.Caxis.val);
                            if now==0
                            elseif now<old
                                lst(lst>=now & lst<old)=lst(lst>=now & lst<old)+1;
                            else
                                lst(lst>old & lst<=now)=lst(lst>old & lst<=now)-1;
                            end
                            lst(Parameters.Caxis.val)=now;
                            Records.D3V.(M)=lst;
                        end
                    end
                    if strcmp(M,'Caxis_mixColor')
                        colormap(D3R_pallet());
                        tmpShow(handles,'colorbar','Visible',{'on','off'},1);
                    end
                    msgShow(handles,0,['A> ',M,': ',num2str(Records.D3V.(M))]);                                           
                if all(isobject(OBJs)) && all(isvalid(OBJs))%update
                    INDs=Records.D3V.Caxis_mixIndex;
                    BKGs=Records.D3V.Caxis_mixRatio;
                    COLs=Records.D3V.Caxis_mixColor;
                    MTDs=Records.D3V.Caxis_mixMethod;
                    D3R_loop_switch(1,'tmp');hold on;LAB='D3Viewer';DONE=true;
                    ZZ=1:numel(OBJs);
                    [Vs,Is]=sort(INDs);Is=Is(INDs>0);Num=numel(Is);All=numel(ZZ)*Num;Pro=All>Num;
                    for Zaxis=ZZ
                        for Caxis=1:C
                            img=bfGetPlane(Menus.reader,Menus.reader.getIndex(Zaxis-1,Caxis-1,Parameters.Taxis.val-1)+1);
                            img=mat2gray(img);
                            IMGs{Zaxis,Caxis}=img;
                        end
                        IMG=[];ind=0;
                        for Caxis=Is
                            img=IMGs{Zaxis,Caxis};
                            bkg=BKGs(Caxis);
                            img=mat2gray(img,[0,bkg]);
                            col=COLs(Caxis);
                            mtd=MTDs(Caxis);
                            IMG=D3R_pallet(col,{IMG,img},mtd);
                            ind=ind+1;One=(Zaxis-1)*Num+ind;
                            if Pro;if ~D3R_loop_switch({LAB,1,One,All},'pause');DONE=false;break;end;end;
                        end
                        OBJs(Zaxis).CData=IMG;
                    end
                    D3R_loop_switch(2,'tmp');hold off;if ~DONE && strfind(M,'Caxis_');Records.D3V.(M)=Ori;end;
                    return;
                end
            end
            %-----------------------------
                omeMeta = Menus.reader.getMetadataStore();
                voxelSizeXValue = omeMeta.getPixelsPhysicalSizeX(0).value().doubleValue();
                voxelSizeYValue = omeMeta.getPixelsPhysicalSizeY(0).value().doubleValue();
                voxelSizeZValue = omeMeta.getPixelsPhysicalSizeZ(0).value().doubleValue();
                thickness=voxelSizeZValue/(voxelSizeXValue*voxelSizeYValue)^0.5;
                [Row,Col]=size(Records.img);
                [Xs,Ys]=meshgrid(1:Col,1:Row);
                Zs=ones(Row,Col);
                OBJs=[];IMGs=cell(Z,C);
                cla;colormap(D3R_pallet());hidden off;
            %-----------------------------
                Menus.reader.setSeries(Parameters.Series.val-1);
            %-----------------------------
                INDs=Records.D3V.Caxis_mixIndex;
                BKGs=Records.D3V.Caxis_mixRatio;
                COLs=Records.D3V.Caxis_mixColor;
                MTDs=Records.D3V.Caxis_mixMethod;
                D3R_loop_switch(1,'tmp');hold on;LAB='D3Viewer';DONE=true;
                if Parameters.Zaxis.val;ZZ=Parameters.Zaxis.val;else;ZZ=1:Z;end;
                [Vs,Is]=sort(INDs);Is=Is(INDs>0);Num=numel(Is);All=numel(ZZ)*Num;Pro=All>Num;
                for Zaxis=ZZ
                    for Caxis=1:C
                        img=bfGetPlane(Menus.reader,Menus.reader.getIndex(Zaxis-1,Caxis-1,Parameters.Taxis.val-1)+1);
                        img=mat2gray(img);
                        IMGs{Zaxis,Caxis}=img;
                    end
                    IMG=[];ind=0;
                    for Caxis=Is
                        img=IMGs{Zaxis,Caxis};
                        bkg=BKGs(Caxis);
                        img=mat2gray(img,[0,bkg]);
                        col=COLs(Caxis);
                        mtd=MTDs(Caxis);
                        IMG=D3R_pallet(col,{IMG,img},mtd);
                        ind=ind+1;One=(Zaxis-1)*Num+ind;
                        if Pro;if ~D3R_loop_switch({LAB,1,One,All},'pause');DONE=false;break;end;end;
                    end
                    obj=mesh(Xs,Ys,(Zaxis-1)*thickness*Zs,IMG,'ButtonDownFcn','','Tag',['D3Viewer_',num2str(Zaxis)]);
                    OBJs=[OBJs obj];
                end
                D3R_loop_switch(2,'tmp');hold off;if ~DONE && strfind(M,'Caxis_');Records.D3V.(M)=Ori;end;
        otherwise
           return; 
    end
        
function D3Viewer_click()
    global Menus Handles;
    if D3R_button('double','double')
        nam='D3Viewer_';
        tag=get(gcbo,'Tag');
        len=numel(nam);
        index=str2double(tag(len:end));
        objs=allchild(get(gcbo,'Parent'));
        num=0;
        for i=1:numel(objs)
            obj=objs(i);
            if strcmp(obj.Tag(1:len),nam)
                num=num+1;
                if num>index
                    set(obj,'Visible','off');
                end
            end
        end
        [az,el]=view();
        Menus.container.map(Menus.Keys)=[index,num,az,el];
        view(3);pause(1);view(2);
        %---
        D3Viewer_switch(Handles);
    else
        set(gcbo,'Selected','on');refresh;
    end
function D3Viewer_switch(hObject,eventdata,handles)
    global Menus;
    nam='D3Viewer_';
    if nargin>1
        vals=Menus.container.map(Menus.Keys);
        index=vals(1);num=vals(2);az=vals(3);el=vals(4);
        for i=index+1:num
            set(handles.([nam,num2str(i)]),'Visible','on');
        end
        view(3);pause(1);view(az,el);
        %---
        datacursormode off;
        Switch_Callback(struct('Callback',[],'hObject',hObject,'label','[Coordinate]','handles',handles));       
    else
        handles=hObject;
        datacursormode on;
        Switch_Callback(struct('Callback',@D3R_switch,'hObject',[],'label','[Coordinate]','handles',handles));
   end
        
%-------------
function Video_fit(handles,selection,pointedIndex)
    global Menus Parameters Records;
    persistent Pause;if isempty(Pause);Pause=1;end;
    if ~isprop(Menus.reader,'NumberOfFrames');msgShow(handles,2,'M> not ''Video'' file');return;end;
    switch Menus.Menus
        case 'Viewer'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Normalize',struct('mode',2,'min',0,'val',1,'max',1,'step',2,'val2txt','','tip','Normalize:0:Off; 1:On;'),...
                'FrameIndex',struct('mode',4,'min',0,'val',1,'max',Menus.reader.NumberOfFrames,'step',Menus.reader.NumberOfFrames,'val2txt','','tip','The index of frame'),...
                'Loop',struct('mode',2,'min',0,'val',0,'max',2,'step',3,'val2txt','','tip','0:Off; 1:Start; 2:End; >>> do with the process in loop')...
                ),pointedIndex);return;end;
            %-----------------------------
            Dir_File_read(handles,Records.file.filePath,Parameters,true,false);
        case 'Player'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Start',struct('mode',2,'min',1,'val',1,'max',Menus.reader.NumberOfFrames,'step',Menus.reader.NumberOfFrames,'val2txt','','tip','Start'),...
                'Pause',struct('mode',2,'min',1,'val',1,'max',Menus.reader.NumberOfFrames,'step',Menus.reader.NumberOfFrames,'val2txt','','tip','Pause')...
                ),pointedIndex);return;end;
            %%%
            freeShow(handles);
            switch Menus.Parameters
                case 'Start'
                    if Pause;ii=Pause;Pause=0;else return;end;
                    for i=ii:Menus.reader.NumberOfFrames
                        Records.raw=read(Menus.reader,i);
                        figShow(handles,'hold off',Records.raw);
                        %
                        set(handles.Changes,'Value',i);
                        set(handles.Values,'String',i);
                        pause(0.5*1/Menus.reader.FrameRate);
                        if Pause;Pause=i;Parameters.Pause.val=i;break;end;
                    end
                    if ~Pause;Pause=1;end;
                case 'Pause'
                    if Pause
                        index=Parameters.Pause.val;
                        Records.raw=read(Menus.reader,index);
                        figShow(handles,'hold off',Records.raw);
                        Pause=index;
                    else
                        Pause=true;
                        return;
                    end
            end
      otherwise
           return; 
    end
%-------------
function Identify_fit(handles,selection,pointedIndex)
    global Menus Parameters Records;
    switch Menus.Menus
        case 'Center'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Set',struct('mode',99,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Set the center of the view'),...
                'Points',struct('mode',99,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Automatically, identifying the center of point-coordinates, if no coordinate, switch to ''Set'''),...
                'Centroid',struct('mode',99,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Automatically, identifying the centeroid of shape-coordinates, if no coordinate, switch to ''Set'''),...
                'Get',struct('mode',99,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Get the current center-coordinate')...
                ),pointedIndex);return;end;
            %%%
            figCenter(handles,lower(Menus.Parameters));
        case 'Point'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show >>> count: pixels + regions + points(all regionarea) + points(required regionarea) + points(required region);Record >>> areas: regions(required);'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Connectivity',struct('mode',2,'min',1,'val',4,'max',8,'step',4,'val2txt','','tip','Connectivity(Pixels): peripheral point number(1/4/6/8) for connecting'),...
                'MinDiameter',struct('mode',3,'min',1,'val',1.5,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Pixels: the min value of the point diameter'),...
                'MaxDiameter',struct('mode',3,'min',1,'val',min(100,max(size(Records.raw))),'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Pixels: the max value of the point diameter'),...
                'KNNRadius',struct('mode',2,'min',1,'val',min(40,max(size(Records.raw))),'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Pixels: the max value of the nearest neighbors area radius'),...
                'KNNOutliersRatio',struct('mode',1,'min',0,'val',1.5,'max',3,'step',30,'val2txt','','tip','LowerLimit=Q1-R*(Q3-Q1);UpperLimit=Q3+R*(Q3-Q1);')...
                ),pointedIndex);return;end;
            %%%
            if ~ismember([1,4,6,8],Parameters.Connectivity.val);msgShow(handles,2,Parameters.Connectivity.tip);return;end;
            if numel(find(Records.raw>0 & Records.raw<1));msgShow(handles,2,'A> please [Image/Gray1]');return;end;
            cc=bwconncomp(Records.raw,Parameters.Connectivity.val);
            stats = regionprops('table',cc,'Centroid','MajorAxisLength','MinorAxisLength','Area');
            Record_Pixels=length(find(Records.raw>0));
            Record_Regions=size(stats.Centroid,1);
            %
            centroidAndindex=[];
            for i=1:Record_Regions
                if stats.MinorAxisLength(i)>=Parameters.MinDiameter.val && stats.MajorAxisLength(i)<=Parameters.MaxDiameter.val
                    centroidAndindex=[centroidAndindex;stats.Centroid(i,:), i];
                end
            end
            Record_ALLRegionpoints=0;
            KNNr=Parameters.KNNRadius.val;
            PTarea=Parameters.MinDiameter.val^2;
            [r,c]=size(Records.raw);
            cnt=zeros(r,c);
            for i=1:size(centroidAndindex,1)
                x=floor(centroidAndindex(i,1));
                y=floor(centroidAndindex(i,2));
                xs=max(1,x-KNNr):min(c,x+KNNr);
                ys=max(1,y-KNNr):min(r,y+KNNr);
                %
                index=centroidAndindex(i,3);
                PTnum=round(stats.Area(index)/PTarea);
                cnt(ys,xs)=cnt(ys,xs)+PTnum;
                Record_ALLRegionpoints=Record_ALLRegionpoints+PTnum;
            end
            %
            Record_ReqRegionpoints=0;
            KNNok=[];
            if ~isempty(centroidAndindex)
                    XYIND=floor(centroidAndindex(:,1:2));
                    Xs=XYIND(:,1);
                    Ys=XYIND(:,2);
                    CNT=cnt(sub2ind(size(cnt),Ys,Xs));
                    KNNratio=Parameters.KNNOutliersRatio.val;
                    Q=prctile(CNT,[25,75]);
                    Q1=Q(1);Q3=Q(2);
                    KNNlower=Q1-KNNratio*(Q3-Q1);
                    KNNupper=Q3+KNNratio*(Q3-Q1);
                    for i=1:size(centroidAndindex,1)
                        x=floor(centroidAndindex(i,1));
                        y=floor(centroidAndindex(i,2));
                        %
                        cntNum=cnt(y,x);
                        if cntNum>=KNNlower && cntNum<=KNNupper;
                            KNNok=[KNNok;centroidAndindex(i,:)];
                        index=centroidAndindex(i,3);
                        PTnum=round(stats.Area(index)/PTarea);
                        Record_ReqRegionpoints=Record_ReqRegionpoints+PTnum;
                        end;
                    end
            end
            %
            Record_ReqRegions=size(KNNok,1);
            %---
            axes(handles.Figures);
            figShow(handles,'hold off',Records.raw);
            if isempty(KNNok)
                xys=[];
            else
                xys=KNNok(:,1:2);
                hold on;
                pltShow(xys(:,1),xys(:,2),'r.'); 
                hold off;
            end
            %---
            if ~D3R_loop_switch()
                switch Menus.Parameters
                    case 'MinDiameter'
                        midV=Parameters.MinDiameter.val;
                        tmpShow(handles,struct('Tag','bw','XData',mean([stats.MajorAxisLength,stats.MinorAxisLength]'),'Data',[midV]),'Visible',{'on','off'},8);
                    case 'MaxDiameter'
                        midV=Parameters.MaxDiameter.val;
                        tmpShow(handles,struct('Tag','bw','XData',mean([stats.MajorAxisLength,stats.MinorAxisLength]'),'Data',[midV]),'Visible',{'on','off'},8);
                    case 'KNNRadius'
                        midV=Parameters.KNNRadius.val;
                        tmpShow(handles,struct('Tag','ppd','Data',[midV]),'Visible',{'on','off'},5);
                    otherwise
                        set(handles.Windows,'Visible','off');
                end
            end
            %---
            Records.xys=xys;
            if isempty(KNNok);Records.record=[];else;Records.record=stats.Area(KNNok(:,3));end;
            D3R_record(handles,[num2str(Record_Pixels),9,num2str(Record_Regions),9,num2str(Record_ALLRegionpoints),9,num2str(Record_ReqRegionpoints),9,num2str(Record_ReqRegions)]);
        case 'Line'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Level',struct('mode',2,'min',0,'val',2,'max',100,'step',100,'val2txt','','tip','Level: the level for the contour to split'),...
                'MaxPPD',struct('mode',2,'min',0,'val',min(10,max(size(Records.raw))),'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Pixel Pixel Distance: the max distance between lastpoint to nextpoint;'),...
                'MinLength',struct('mode',2,'min',0,'val',min(15,max(size(Records.raw))),'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Pixels: the min length of the line')...
                ),pointedIndex);return;end;
            %%%
            XYs=contourc(Records.raw,Parameters.Level.val);%contour contains bw
            XYs=XYs';
            lines=Ana_line(XYs,Parameters.MaxPPD.val,Parameters.MinLength.val);
            axes(handles.Figures);
            figShow(handles,'hold off',Records.raw);
            hold on;
            num=size(lines,1);
            cols=hsv(num);
            maxi=1;maxLength=0;
            for i=1:num
                starti=lines(i,1);
                endi=lines(i,2);
                maxLen=lines(i,3);
                if maxLen>=maxLength;maxLength=maxLen;maxi=i;end;
                xys=XYs(starti:endi,:);
                xs=xys(:,1);ys=xys(:,2);
                pltShow(xs,ys,'Color',cols(i,:));
                text(mean(xs),mean(ys),num2str(i),'Color','c');
            end
                i=maxi;
                starti=lines(i,1);
                endi=lines(i,2);
                xys=XYs(starti:endi,:);
                pltShow(xys(:,1),xys(:,2),'r*');
                hold off
            Records.xys=xys;
                            if ~D3R_loop_switch() && strcmp(Menus.Parameters,'MaxPPD')
                                tmpShow(handles,struct('Tag','ppd','Data',[Parameters.MaxPPD.val/2]),'Visible',{'on','off'},5);
                            elseif ~D3R_loop_switch() && strcmp(Menus.Parameters,'MinLength')
                                tmpShow(handles,struct('Tag','ppd','Data',[Parameters.MinLength.val/2]),'Visible',{'on','off'},5);
                            end 
        case 'Region'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show >>> count: pixels + regions(all) + regions(dia);Record >>> areas: regions;'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Connectivity',struct('mode',2,'min',1,'val',4,'max',8,'step',4,'val2txt','','tip','Connectivity(Pixels): peripheral point number(1/4/6/8) for connecting'),...
                'MinDiameter',struct('mode',3,'min',1,'val',min(15,max(size(Records.raw))),'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Pixels: the min value of the region diameter'),...
                'MaxDiameter',struct('mode',3,'min',1,'val',min(150,max(size(Records.raw))),'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Pixels: the max value of the region diameter'),...
                'Tracking',struct('mode',2,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Tracking: 0:off; 1:on;')...
                ),pointedIndex);return;end;
            %%%
            if ~ismember([1,4,6,8],Parameters.Connectivity.val);msgShow(handles,2,Parameters.Connectivity.tip);return;end;
            if numel(find(Records.raw>0 & Records.raw<1));msgShow(handles,2,'A> please [Image/Gray1]');return;end;
            cc=bwconncomp(Records.raw,Parameters.Connectivity.val);
            stats = regionprops('table',cc,'Centroid','MajorAxisLength','MinorAxisLength','Area','ConvexHull');
            Record_Pixels=length(find(Records.raw>0));
            Record_Regions=size(stats.Centroid,1);
            %
            centroidAndindex=[];
            for i=1:Record_Regions
                if stats.MinorAxisLength(i)>=Parameters.MinDiameter.val && stats.MajorAxisLength(i)<=Parameters.MaxDiameter.val
                    centroidAndindex=[centroidAndindex;stats.Centroid(i,:), i];
                end
            end
            KNNok=centroidAndindex;
            Record_Points=size(KNNok,1);
            %---
            axes(handles.Figures);
            figShow(handles,'hold off',Records.raw);
            if isempty(KNNok)
                xys=[];
            else
                xys=KNNok(:,1:2);%centroid
                hold on;
                for i=1:size(KNNok,1)
                    index=KNNok(i,3);
                    vxy=stats.ConvexHull{index};%convexhull
                    pltShow(vxy(:,1),vxy(:,2),'r');
                    cxy=xys(i,:);
                    text(cxy(1),cxy(2),num2str(i),'Color','c');
                    if Parameters.Tracking.val
                        info=[];
                        nume=numel(Menus.container.tracking);
                        for j=1:nume
                            cts=Menus.container.tracking(j).centroid;
                            lst=Menus.container.tracking(j).convexhull;
                            if isempty(lst);continue;end;
                            xs=polyxpoly(vxy(:,1),vxy(:,2),lst(:,1),lst(:,2));
                            if ~isempty(xs)
                                ct=cts(end,:);
                                dis=sum((cxy-ct).^2)^0.5;
                                info=[info; dis cxy j];
                            end
                        end
                        if isempty(info)
                            if isempty(Menus.container.tracking(nume).centroid)
                                nume=nume;
                            else
                                nume=nume+1;
                            end
                            Menus.container.tracking(nume).centroid=cxy;
                            Menus.container.tracking(nume).convexhull=vxy;
                        else
                            [val,ind]=min(info(:,1));
                            ct=info(ind,2:3);
                            j=info(ind,4);
                            Menus.container.tracking(j).centroid=[Menus.container.tracking(j).centroid;ct];
                            Menus.container.tracking(j).convexhull=vxy;
                        end
                    end
                end
                if Parameters.Tracking.val
                    for j=1:numel(Menus.container.tracking)
                        cts=Menus.container.tracking(j).centroid;
                        if isempty(cts);continue;end;
                        pltShow(cts(:,1),cts(:,2),'m');
                        %arrowPlot(cts(:,1),cts(:,2),'number',1,'color','m');
                    end
                end
                hold off;
            end
            %---
            if ~D3R_loop_switch()
                switch Menus.Parameters
                    case 'MinDiameter'
                        midV=Parameters.MinDiameter.val;
                        tmpShow(handles,struct('Tag','bw','XData',mean([stats.MajorAxisLength,stats.MinorAxisLength]'),'Data',[midV]),'Visible',{'on','off'},8);
                    case 'MaxDiameter'
                        midV=Parameters.MaxDiameter.val;
                        tmpShow(handles,struct('Tag','bw','XData',mean([stats.MajorAxisLength,stats.MinorAxisLength]'),'Data',[midV]),'Visible',{'on','off'},8);
                    otherwise
                        set(handles.Windows,'Visible','off');
                end
            end
            %---
            Records.xys=xys;
            if isempty(KNNok);Records.record=[];else;Records.record=stats.Area(KNNok(:,3));end;
            D3R_record(handles,[num2str(Record_Pixels),9,num2str(Record_Regions),9,num2str(Record_Points)]);
        case 'Edge'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Level',struct('mode',2,'min',0,'val',2,'max',100,'step',100,'val2txt','','tip','Level: the level for the contour to split'),...
                'MaxPPD',struct('mode',2,'min',0,'val',min(10,max(size(Records.raw))),'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Pixel Pixel Distance: the max distance between lastpoint to nextpoint;'),...
                'MinRadius',struct('mode',2,'min',0,'val',min(15,max(size(Records.raw))),'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Pixels:the min radius of the ConvexHull created by the line')...
                ),pointedIndex);return;end;
            %%%
            XYs=contourc(Records.raw,Parameters.Level.val);%contour contains bw
            XYs=XYs';
            center=figCenter(handles,'.');
            xys=Ana_area(XYs,center,Parameters.MaxPPD.val,Parameters.MinRadius.val);
            %%%
            axes(handles.Figures);
            figShow(handles,'hold off',Records.raw);
            hold on;
            if ~isempty(xys);pltShow(xys(:,1),xys(:,2),'r');end;
            hold off;
            Records.xys=xys;
                            if ~D3R_loop_switch() && strcmp(Menus.Parameters,'MaxPPD')
                                tmpShow(handles,struct('Tag','ppd','Data',[Parameters.MaxPPD.val/2]),'Visible',{'on','off'},5);
                            elseif ~D3R_loop_switch() && strcmp(Menus.Parameters,'MinRadius')
                                tmpShow(handles,struct('Tag','ppd','Data',[Parameters.MinRadius.val]),'Visible',{'on','off'},5);
                            end 

        case 'Color'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Level',struct('mode',2,'min',0,'val',3,'max',100,'step',100,'val2txt','','tip','Level: the level for the contour to split')...
                ),pointedIndex);return;end;
            %%%
            [xys,contour]=imcontour(Records.raw,Parameters.Level.val);
            mesh(contour.XData,contour.YData,contour.ZData,'parent',handles.Windows);
        case 'Pointss'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Area',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'BoundingBox',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'Centroid',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'Basic',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'FilledArea',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'FilledImage',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'Image',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'PixelList',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'PixelIdxList',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'SubarrayIdx',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'All',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'ConvexArea',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'ConvexHull',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'ConvexImage',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'Eccentricity',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'EquivDiameter',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'EulerNumber',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'Extent',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'Extrema',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'MajorAxisLength',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'MinorAxisLength',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'Orientation',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'Perimeter',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip',''),...
                'Solidity',struct('mode',2,'min',4,'val',4,'max',8,'step',1,'val2txt','','tip','')...
                ),pointedIndex);return;end;
            name=Menus.Parameters;
            paras=getfield(Parameters,name);
            connectivity=paras.val;
            %[L,N]=bwlabel(Commands.raw,connectivity);
            stats = regionprops(bw,name);
        otherwise
    end
function lines=Ana_line(outlineDat,maxDis,minLen)
    noiseCircum=minLen;
    %%%
    circum=0;lasti=1;
    xold=outlineDat(1,1);yold=outlineDat(1,2);
    lines=[];
    for i=1:size(outlineDat,1)
        x=outlineDat(i,1);y=outlineDat(i,2);
        xdis=abs(x-xold);ydis=abs(y-yold);
        if xdis<=maxDis && ydis<=maxDis
            circum=circum+(xdis^2+ydis^2)^0.5;
        else
            if circum<noiseCircum
                outlineDat(lasti:i-1,:)=nan;
            else
                lines=[lines;lasti i-1 circum];
            end
            circum=0;
            lasti=i;
        end
        xold=x;yold=y;
    end
    %%%
        if xdis<=maxDis && ydis<=maxDis
            i=i+1;
            if circum<noiseCircum
                outlineDat(lasti:i-1,:)=nan;
            else
                lines=[lines;lasti i-1 circum];
            end
        end
function xys=Ana_area(outlineDat,center,maxDis,minR)
    noiseArea = pi*minR^2;
    noiseCircum=2*pi*minR;
    %%%
    centers=[];xys=[];
    circum=0;lasti=1;
    if isempty(outlineDat);return;end;
    xold=outlineDat(1,1);yold=outlineDat(1,2);
    for i=1:size(outlineDat,1)
        x=outlineDat(i,1);y=outlineDat(i,2);
        xdis=abs(x-xold);ydis=abs(y-yold);
        if xdis<=maxDis && ydis<=maxDis
            circum=circum+sum([xdis,ydis].^2)^0.5;
        else
            area=polyarea(outlineDat(lasti:i-1,1),outlineDat(lasti:i-1,2));
            if circum<noiseCircum || area<noiseArea
                outlineDat(lasti:i-1,:)=nan;
            else
                xyc=outlineDat(lasti:i-1,:);
                if size(xyc,1)>1;xyc=median(xyc);end;
                rdis=sum((xyc-center(1:2)).^2).^0.5;
                centers=[centers;rdis area xyc lasti i-1];
            end
            circum=0;
            area=0;
            lasti=i;
        end
        xold=x;yold=y;
    end
    %%%
        if xdis<=maxDis && ydis<=maxDis
            i=i+1;
            area=polyarea(outlineDat(lasti:i-1,1),outlineDat(lasti:i-1,2));
            if circum<noiseCircum || area<noiseArea
                outlineDat(lasti:i-1,:)=nan;
            else
                xyc=mean(outlineDat(lasti:i-1,:));
                if size(xyc,1)>1;xyc=median(xyc);end;
                rdis=sum((xyc-center(1:2)).^2).^0.5;
                centers=[centers;rdis area xyc lasti i-1];
            end
        end
    %%%
        if isempty(centers);return;end;
        [val,ind]=min(centers(:,1));
        vals=centers(ind,:);
        centernew=vals(3:4);%single
        area=vals(2);
        xys=outlineDat(vals(5):vals(6),:);
%-------------
function D3_fit(handles,selection,pointedIndex)
    global Menus Parameters Records;
    switch Menus.Menus
        case 'Viewer'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Normalize',struct('mode',2,'min',0,'val',1,'max',1,'step',2,'val2txt','','tip','Normalize:0:Off; 1:On;'),...
                'Xaxis',struct('mode',2,'min',1,'val',1,'max',1,'step',1,'val2txt','','tip','Start index of series axis'),...
                'Yaxis',struct('mode',2,'min',1,'val',1,'max',1,'step',1,'val2txt','','tip','Start index of Time axis'),...
                'Zaxis',struct('mode',4,'min',0,'val',Records.D3.viewer.index,'max',max([size(Records.D3.xyzs,1),1]),'step',max([size(Records.D3.xyzs,1),1]),'val2txt','','tip','Start index of Z axis'),...
                'Loop',struct('mode',2,'min',0,'val',0,'max',2,'step',3,'val2txt','','tip','0:Off; 1:Start; 2:End; >>> do with the process in loop')...
                ),pointedIndex);return;end;
            %-----------------------------
            Dir_File_read(handles,[Records.file.filePath,'.d3r'],Parameters,false,false);
        case 'Scanner'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'XYorZ',struct('mode',2,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','The direction to scan'),...
                'MaxPPD',struct('mode',2,'min',0,'val',60,'max',max(size(Records.raw)),'step',max(size(Records.raw)),'val2txt','','tip','Pixel Pixel Distance: the max distance between lastpoint to nextpoint;'),...
                'OutliersRatio',struct('mode',1,'min',0,'val',1.5,'max',3,'step',30,'val2txt','','tip','LowerLimit=Q1-R*(Q3-Q1);UpperLimit=Q3+R*(Q3-Q1);'),...
                'SmoothMethod',struct('mode',2,'min',1,'val',1,'max',4,'step',4,'val2txt','','tip','1:lowess; 2:rlowess; 3:loess; 4:rlesss;'),...
                'SmoothRatio',struct('mode',1,'min',0,'val',0.1,'max',1,'step',20,'val2txt','','tip','The value to smooth the linked curve'),...
                'RepeatSmoothMethod',struct('mode',2,'min',1,'val',1,'max',4,'step',4,'val2txt','','tip','1:lowess; 2:rlowess; 3:loess; 4:rlesss;'),...
                'RepeatSmoothRatio',struct('mode',1,'min',0,'val',0.99,'max',1,'step',20,'val2txt','','tip','When collect repeatly monolayer data(first collection must fit with first original raw), the value to smooth linear regression for choosing best one group data')...
                ),pointedIndex);return;end;
            switch Parameters.SmoothMethod.val
                case 1
                    SmoothMethod='lowess';
                case 2
                    SmoothMethod='rlowess';
                case 3
                    SmoothMethod='loess';
                case 4
                    SmoothMethod='rloess';
            end
            %%%, when collect repeatly, you should follow the rule(such as, Level=2 for the first member of first group and Level=3 for the last member of last group)
            switch Parameters.RepeatSmoothMethod.val
                case 1
                    RepeatSmoothMethod='lowess';
                case 2
                    RepeatSmoothMethod='rlowess';
                case 3
                    RepeatSmoothMethod='loess';
                case 4
                    RepeatSmoothMethod='rloess';
            end
            Menus.RepeatSmoothMethod=RepeatSmoothMethod;
            Menus.RepeatSmoothRatio=Parameters.RepeatSmoothRatio.val;
            switch Parameters.XYorZ.val
                case 0%----------------------------
                    if D3R_loop_switch('D3R','D3R')%self>>>done>>>can't change fileSource
                    else
                        center=figCenter(handles,'.');
                        if ~strcmp(Records.D3.source.file,Records.file.filePath)|| ~isequal(Records.D3.shape.center,center)
                            halflen=max(center(1),center(2));
                            %polarnum=ceil(2^0.5*2*pi*halflen);
                            polarnum=ceil(pi*halflen);
                            switch Records.file.fileType
                                case 'Microscopy'
                                    omeMeta = Menus.reader.getMetadataStore();
                                    %
                                    voxelSizeXValue = omeMeta.getPixelsPhysicalSizeX(0).value().doubleValue();
                                    voxelSizeXUnit = char(omeMeta.getPixelsPhysicalSizeX(0).unit().getSymbol()); 
                                    voxelSizeYValue = omeMeta.getPixelsPhysicalSizeY(0).value().doubleValue();
                                    voxelSizeYUnit = char(omeMeta.getPixelsPhysicalSizeY(0).unit().getSymbol());
                                    voxelSizeZValue = omeMeta.getPixelsPhysicalSizeZ(0).value().doubleValue();
                                    voxelSizeZUnit = char(omeMeta.getPixelsPhysicalSizeZ(0).unit().getSymbol());
                                otherwise%Image/Video/...
                                    voxelSizeXValue = 1;
                                    voxelSizeXUnit = 'pixel';
                                    voxelSizeYValue = 1;
                                    voxelSizeYUnit = 'pixel';
                                    voxelSizeZValue = 1;
                                    voxelSizeZUnit = 'pixel';
                            end
                            thickness=voxelSizeZValue/(voxelSizeXValue*voxelSizeYValue)^0.5;
                            XYZValue=[voxelSizeXValue,voxelSizeYValue,voxelSizeZValue];
                            XYZUnit=[voxelSizeXUnit,9,voxelSizeYUnit,9,voxelSizeZUnit];
                            %%%
                            Records.D3.shape.polarnum=polarnum;
                            Records.D3.shape.center=center;
                            Records.D3.shape.width=size(Records.raw,2);
                            Records.D3.shape.height=size(Records.raw,1);
                            Records.D3.shape.thickness=thickness;
                            Records.D3.shape.ppu=XYZValue;
                            Records.D3.shape.unit=XYZUnit;
                            %%%file
                            Records.D3.source.file=Records.file.filePath;
                        end
                    end
                            %polar
                            if isempty(Records.xys)
                                if ~D3R_loop_switch();msgShow(handles,2,'M> ''Scanner'' or  go to ''Identify''');return;end;
                            else
                                polar=D3_XYScanner(Records.xys,Parameters.MaxPPD.val,Parameters.OutliersRatio.val,SmoothMethod,Parameters.SmoothRatio.val);
                                xys=D3_XYViewer(handles,polar);
                                Records.xys=xys;
                            end
                            %loop
                            if ~D3R_loop_switch()
                                if strcmp(Menus.Parameters,'MaxPPD')%XYScanner->ppd
                                    xys(any(isnan(xys)'),:)=[];
                                    %
                                    ppds=sum(diff(xys).^2').^0.5;
                                    tmpShow(handles,struct('Tag','ppd','XData',ppds,'Data',[Parameters.MaxPPD.val/2]),'Visible',{'on','off'},8);
                                end
                                return;
                            end 
                            if isempty(Records.xys)
                                if isempty(Menus.container.polars)
                                    polar=nan(1,Records.D3.shape.polarnum);
                                else
                                    polar=Menus.container.polars(end,:);
                                end
                                msgShow(handles,1,'M> the last data to fill');
                            end
                            %container
                            Menus.container.polars=[Menus.container.polars;polar];
                case 1%----------------------------
                    if isempty(Records.D3.polars);msgShow(handles,2,'M> go to ''D3R/Scanner''');return;end; 
                    %%%XY-->(Z)
                    D3R_loop_switch(1,'tmp');
                    %-
                    polars=D3_ZScanner(handles,Records.D3.polars,Parameters.MaxPPD.val,Parameters.OutliersRatio.val,SmoothMethod,Parameters.SmoothRatio.val);
                    D3_Polar2XYZViewer(handles,polars);
                    D3_Polar2Zoom();
                    %-
                    D3R_loop_switch(2,'tmp');
            end
        case 'Source'
            if isfield(Records.D3.source.paras,'Loop');Records.D3.source.paras=rmfield(Records.D3.source.paras,'Loop');end;
            if Functions_gui(handles,selection,Records.D3.source.paras...
                ,pointedIndex);return;end;
            if exist(Records.D3.source.file)~=2
                    rtn=questdlg({'SourceFile doesn''t exist:',['>>> ',Records.D3.source.file],'','Would you point the sourcefile ?'},'Attention:','Yes','No','Yes');
                    if strcmp(rtn,'No');return;end;
                    [pathstr, name, fi] = fileparts(Records.D3.source.file);
                    suffix=lower(fi(2:length(fi)));
                    [file,dir]=uigetfile(['*.',suffix],'Input File ...');
                    if ~file;return;end;
                    path=strcat(dir,file);
                    Records.D3.source.file=path;
            end
            Records.D3.source.paras=Parameters;
            %-----------------------------
            Dir_File_read(handles,Records.D3.source.file,Parameters,true,false);
        case 'Transform'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Style',struct('mode',2,'min',0,'val',Records.D3.show.Style.val,'max',4,'step',5,'val2txt','','tip','Style>0:Off; 1:Mesh; 2:Suface; 3:Line; 4:Point;'),...
                'Side',struct('mode',2,'min',0,'val',Records.D3.show.Side.val,'max',4,'step',5,'val2txt','','tip','Side>0:Off; 1:Upper; 2:Lower; 3:Both; 4:Ceiling (polyfit3 to fill);'),...
                'Zoom',struct('mode',3,'min',0,'val',Records.D3.show.Zoom.val,'max',2,'step',3,'val2txt','','tip','The ratio to zoom the D3R Model')...
                ),pointedIndex);return;end;
            %%%
            Records.D3.show=Parameters;
            D3R_show(handles,Menus.Parameters);
        case 'Perspective'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Mode',struct('mode',2,'min',0,'val',0,'max',2,'step',3,'val2txt','','tip','0:Image; 1:Clip; 2:Perspective;'),...
                'Gray',struct('mode',1,'min',0,'val',0,'max',1,'step',100,'val2txt','','tip','The gray ratio is only for ''2:Perspective'''),...
                'Index',struct('mode',2,'min',1,'val',Records.D3.viewer.index,'max',max([size(Records.D3.xyzs,1),1]),'step',max([size(Records.D3.xyzs,1),1]),'val2txt','','tip','Index for perspective')...
                ),pointedIndex);return;end;
            if Parameters.Mode.val==2
                Parameters.Gray.mode=1;
            else
                Parameters.Gray.mode=99;
            end
            if strcmp(Menus.Parameters,'Gray') && Parameters.Gray.mode==99;set(handles.Changes,'enable','off');end;
            %%%
            if exist(Records.D3.source.file)~=2
                    rtn=questdlg({'SourceFile doesn''t exist:',['>>> ',Records.D3.source.file],'','Would you point the sourcefile ?'},'Attention:','Yes','No','Yes');
                    if strcmp(rtn,'No');return;end;
                    [pathstr, name, fi] = fileparts(Records.D3.source.file);
                    suffix=lower(fi(2:length(fi)));
                    [file,dir]=uigetfile(['*.',suffix],'Input File ...');
                    if ~file;return;end;
                    path=strcat(dir,file);
                    Records.D3.source.file=path;
            end
            %-----------------------------
                persistent layer;
                delete(layer);
            %-----------------------------
                if ~D3R_loop_switch()
                    Zaxis=Parameters.Index.val;
                    Records.D3.viewer.index=Zaxis;
                else
                    Zaxis=Records.D3.viewer.index;
                end
                %%%Viewer
                [Records.xys,valid]=D3_XYZViewer(handles,Zaxis);
                %%%img
                paras=Records.D3.source.paras;
                paras.index=Zaxis;
                Dir_File_read(handles,Records.D3.source.file,paras,false,false);
                img=Records.raw;
                switch Parameters.Mode.val
                    case 0
                        [r,c,cc]=size(img);
                        [x,y]=meshgrid(1:c,1:r);
                        z=ones(r,c)*(Zaxis-1)*Records.D3.shape.thickness;
                            if max(img(:))<=1;imgcol=255*img;else imgcol=img;end;
                        hold on;
                        layer=surf(x,y,z,imgcol,'linestyle','none','CDataMapping','direct','Tag','OME-D3R');
                        hold off;
                    case 1
                        [row,col,chn]=size(img);
                        [x,y]=meshgrid(1:col,1:row);
                        z=ones(row,col)*(Zaxis-1)*Records.D3.shape.thickness;
                            roi=D3R_roi(row,col,Records.xys);
                            rois=find(roi==0);
                            z(rois)=nan;
                            for chni=1:size(img,3)
                                im=img(:,:,chni);
                                im(rois)=0;
                                img(:,:,chni)=im;
                            end
                            if max(img(:))<=1;imgcol=255*img;else imgcol=img;end;
                        hold on;
                        layer=surf(x,y,z,imgcol,'linestyle','none','CDataMapping','direct','Tag','OME-D3R');
                        hold off;
                        %%%
                        Records.img=img;
                    case 2
                        %%%perspective
                        D3_psp(handles,Parameters.Gray.val,Zaxis,valid);
                end
        otherwise
    end
function polar=D3_XYScanner(xys,maxDis,outliersRatio,smoothMethod,smoothRatio)
    global Records;
    xc=Records.D3.shape.center(1);yc=Records.D3.shape.center(2);
    polarnum=Records.D3.shape.polarnum;
    %scan radius
    THI=1;
    PI=pi;
    PI12=0.5*pi;
    PI2=2*pi;
    piSplitedNum=polarnum/(2*pi);
    XYs=cell(1,polarnum);
    for i=1:size(xys,1)
        x=xys(i,1);y=xys(i,2);
        if isnan(x)||isnan(y)
            continue;
        elseif x==xc
            if y>yc
                thi=PI12;
            else
                thi=PI+PI12;
            end
        else
            thi=atan((y-yc)/(x-xc));
            if y>yc
                if x>xc
                else
                    thi=PI+thi;
                end
            else
                if x>xc
                    thi=PI2+thi;
                else
                    thi=PI+thi;
                end
            end
        end
        thi=min(ceil(thi*piSplitedNum)+THI,polarnum);
        XYs{thi}=[XYs{thi};[x y]];
    end
    %outliers
    rs=[];
    for i=1:polarnum
        XY=XYs{i};
        if isempty(XY)
            rs=[rs nan];
        else
            xy=[mean(XY(:,1)),mean(XY(:,2))];
            r=sum((xy-[xc yc]).^2)^0.5;
            rs=[rs r];
        end
    end
    inRs=D3_outliers(rs,outliersRatio);
    %radius-filled
    rs=[];lasti=1;starti=[];lastr=0;
    lastxy=0;
    for i=1:polarnum
        r=inRs(i);
        XY=XYs{i};
        if isnan(r)
            rs=[rs nan];
        else
            rs=[rs r];
            xy=[mean(XY(:,1)),mean(XY(:,2))];
            if i>lasti+1
                dis=sum((xy-lastxy).^2)^0.5;
                if dis<maxDis
                    rs(lasti:i)=linspace(lastr,r,i-lasti+1);
                end
            end
            lasti=i;
            lastr=r;
            if isempty(starti);starti=i;end;
            lastxy=xy;
        end
    end
    %start-end
        XY=XYs{starti};
            xy=[mean(XY(:,1)),mean(XY(:,2))];
            r=sum((xy-[xc yc]).^2)^0.5;
            num=polarnum-lasti+starti;
            if num>1
                dis=sum((xy-lastxy).^2)^0.5;
                if dis<maxDis
                    vals=linspace(lastr,r,num+1);
                    rs(lasti:end)=vals(1:end-starti);
                    rs(1:starti)=vals(end-starti+1:end);
                end
            end
    %radius-smooth
    polar=D3_smooth(rs,smoothMethod,smoothRatio);
function D3polar=D3_ZScanner(handles,polars,maxDis,outliersRatio,smoothMethod,smoothRatio)
        global Records;
        %%%
        zinum=size(polars,1);
        polarnum=size(polars,2);
        thickness=Records.D3.shape.thickness;
        piSplitedNum=round(Records.D3.shape.polarnum/(2*pi));
        %%%
        D3polar=polars;
        for thi=1:polarnum
            rs=[];lasti=1;starti=[];lastr=0;
            for i=1:zinum
                r=polars(i,thi);
                if isnan(r)
                    rs=[rs nan];
                else
                    rs=[rs r];
                    if i>lasti+1
                        dis=thickness*(i-lasti);
                        if dis<maxDis
                            rs(lasti:i)=linspace(lastr,r,i-lasti+1);
                        end
                    end
                    lasti=i;
                    lastr=r;
                    if isempty(starti);starti=i;end;
                end
            end
            %start-end
            i=length(rs);
            r=lastr;
            if i>lasti
                        dis=thickness*(i-lasti);
                        if dis<maxDis
                            rs(lasti:i)=linspace(lastr,r,i-lasti+1);
                        end
            end
            i=starti;lasti=1;
            r=rs(starti);lastr=r;
            if i>lasti
                        dis=thickness*(i-lasti);
                        if dis<maxDis
                            rs(lasti:i)=linspace(lastr,r,i-lasti+1);
                        end
            end
            %radius-smooth
            ps=D3_smooth(rs,smoothMethod,smoothRatio);
            D3polar(:,thi)=ps;
            pithi=(thi-1)/piSplitedNum;
            xyzs=D3_ZViewer(handles,ps,pithi);
            Records.xyzs=xyzs;
            %---
            hold(handles.Figures,'on');
            plot3(handles.Figures,xyzs(:,1),xyzs(:,2),xyzs(:,3),'b.');axis ij;
            hold(handles.Figures,'off');
            %---
            if ~D3R_loop_switch([],'pause');break;end;
        end
function Rs=D3_outliers(rs,outliersRatio)
        Q=prctile(rs,[25,75]);
        Q1=Q(1);Q3=Q(2);
        lower=Q1-outliersRatio*(Q3-Q1);
        upper=Q3+outliersRatio*(Q3-Q1);
        Rs=rs;
        Rs(rs<lower|rs>upper)=nan;
function Rs=D3_smooth(rs,smoothMethod,smoothRatio)
    len=length(rs);
    if smoothRatio>0
        if abs(rs(end)-rs(1))>max(rs(end),rs(1))*smoothRatio
            Rs=smooth(1:len,rs,smoothRatio,smoothMethod);
        else
            addNum=floor(len*smoothRatio);
            newrs=[rs(end-addNum+1:end) rs rs(1:addNum)];
            newss=smooth(1:length(newrs),newrs,smoothRatio,smoothMethod);
            Rs=newss(addNum+1:end-addNum);
        end
        Rs=Rs';
        Rs(isnan(rs))=nan;
    else
        Rs=rs;
    end
function xys=D3_XYViewer(handles,polar)
    global Records;
    xys=[];
    xc=Records.D3.shape.center(1);yc=Records.D3.shape.center(2);
    piSplitedNum=round(Records.D3.shape.polarnum/(2*pi));
    for i=1:numel(polar)
        thi=(i-1)/piSplitedNum;
        r=polar(i);

        x=xc+r*cos(thi);
        y=yc+r*sin(thi);
        xys=[xys;x y];
    end
    hold(handles.Figures,'on');
    scanner=Records.scanner;
    if isobject(scanner)&&isvalid(scanner);delete(scanner);end;
    Records.scanner=pltShow(handles.Figures,xys(:,1),xys(:,2),'c.');axis ij;
    hold(handles.Figures,'off');
function xyzs=D3_ZViewer(handles,polar,thi)
    global Records;
    xyzs=[];
    zinum=numel(polar);
    xc=Records.D3.shape.center(1);yc=Records.D3.shape.center(2);
    thickness=Records.D3.shape.thickness;
    %%%
    xs=xc+polar*cos(thi);
    ys=yc+polar*sin(thi);
    zs=thickness*(1:zinum);
    xyzs=[xs',ys',zs'];
    %%%
    hold(handles.Figures,'on');
    scanner=Records.scanner;
    if isobject(scanner)&&isvalid(scanner);delete(scanner);end;
    Records.scanner=plot3(handles.Figures,xyzs(:,1),xyzs(:,2),xyzs(:,3),'c.');axis ij;
    pause(0.001);
    hold(handles.Figures,'off');
function Ps=D3_mulPolars(polars,Nnum,Znum,smoothMethod,smoothRatio)
    ns=polars;
    ns(~isnan(ns))=1;
    ns(isnan(ns))=0;
    ns=sum(ns,2)';
    ps=polars;
    ps(isnan(ps))=0;
    rs=sum(ps,2)';
    rs=rs./ns;
    mulNum=Nnum/Znum;
    is=1:Znum;
    Is=repmat(is,mulNum,1);
    Is=Is(:)';
    %---
    lastv=rs(1);
    for i=1:Znum
        si=(i-1)*mulNum+1;
        ei=i*mulNum;
        vs=rs(si:ei);
        vb=abs(vs-lastv);
        [vx,ix]=max(vb);
        [vn,in]=min(vb);
        if vx/vn<2;break;end;
        v=rs(si+in-1);
        rs(si:ei)=v;
        lastv=v;
    end
    %---
    Rs=smooth(Is,rs,smoothRatio,smoothMethod);
    Rs=Rs';
    Ps=[];
    mulNum=Nnum/Znum;
    for i=1:Znum
        si=(i-1)*mulNum+1;
        ei=i*mulNum;
        r=rs(si:ei);
        R=Rs(si:ei);
        [val,ind]=min(abs(r-mean(R)));
        Ps=[Ps; polars(si+ind-1,:)];
    end
function xyzs=D3_Polar2XYZ(polars)
    global Records;
    %---
    zinum=size(polars,1);
    polarnum=size(polars,2);
    thickness=Records.D3.shape.thickness;
    i2r=(polarnum-1)/(2*pi);
    PI2=2*pi;
    %---
    xyzs=nan(zinum,polarnum,3);
    for zi=1:zinum
        for pii=1:polarnum
            thi=(pii-1)/i2r;
            if thi>PI2;thi=PI2;end;
            R=polars(zi,pii);
            Z=zi-1;
            Z=thickness*Z;
            Y=Records.D3.shape.center(2)+R*sin(thi);
            X=Records.D3.shape.center(1)+R*cos(thi);
            if X<1
                X=1;
            elseif X>Records.D3.shape.width
                X=Records.D3.shape.width;
            end
            if Y<1
                Y=1;
            elseif Y>Records.D3.shape.height
                Y=Records.D3.shape.height;
            end
            xyzs(zi,pii,1)=X;
            xyzs(zi,pii,2)=Y;
            xyzs(zi,pii,3)=Z;
        end
    end
function D3_Polar2XYZViewer(handles,polars)
    global Records;
    %---
    xyzs=D3_Polar2XYZ(polars);
    %-----------------------
    Records.xyzs=xyzs;
    Records.D3.xyzs=xyzs;
    Records.D3.polars=polars;
    [Records.xys,valid]=D3_XYZViewer(handles,1,true);
function D3_Polar2Zoom()
    global Records;
    %---
    if Records.D3.show.Zoom.val~=1
        rtn=questdlg({['Current ZoomRatio:',num2str(Records.D3.show.Zoom.val)],'','Are you sure to replace (irrevocable) origianl data ?' },'Attention:','Yes','No','Cancel','No');
        if ~strcmp(rtn,'Yes');return;end;
    elseif ~D3R_loop_switch()
        rtn=questdlg({'1.(Yes)> Transform permanently,irrevocable','2.(No)> Transform temporarily, [Zoom] recovery','3.(Cancel)> cancel the current action','','Please choose the way in which you want to transform ?' },'Attention:','Yes','No','Cancel','No');
        if ~strcmp(rtn,'Yes');return;end;
    end
    Records.D3.show.Zoom.val=1;
    Records.D3.zoom=struct('ratio',1,'polars',Records.D3.polars);
function [xys,valid]=D3_XYZViewer(handles,Zaxis,refresh)
    global Records;
    %---
    scanner=Records.scanner;
    if isobject(scanner)&&isvalid(scanner);delete(scanner);end;
    %---
    xs=Records.D3.xyzs(:,:,1);
    ys=Records.D3.xyzs(:,:,2);
    zs=Records.D3.xyzs(:,:,3);
    x=xs(Zaxis,:);y=ys(Zaxis,:);z=zs(Zaxis,:);
    xi=find(~isnan(x));
    xys=[x' y'];
    if nargin<3 && all(isobject(Records.D3.object.main)) && all(isvalid(Records.D3.object.main)) && isequal(Records.D3.object.main.Parent,handles.Figures)
        valid=true;
        delete(Records.D3.object.patch);
    else
        valid=false;
        Records.D3.object.main=mesh(xs,ys,zs);
    end
    hold on;
    %Records.D3.object.patch=fill3(x(xi),y(xi),z(xi),'c');
    Records.D3.object.patch=plot3(x(xi),y(xi),z(xi),'c');
    hold off;
    %---
    names=fieldnames(Records.D3.show);
    for i=1:numel(names)
        style=names{i};
        if strcmp(style,'Parameters')||strcmp(style,'Zoom');continue;end;
        D3R_show(handles,style);
    end
function D3_psp(handles,pVal,Zaxis,valid)
    persistent psp;global Menus Records;
    if isempty(psp);psp=struct('Zaxis',1,'pVal',-1,'source',struct(),'surf',[]);end;
    %---
    if ~pVal
        delete(psp.surf);
        psp.pVal=-1;
        return;
    end
    %---
        axes(handles.Figures);
        if pVal==psp.pVal && valid && isequal(psp.source,Records.D3.source)
            if psp.Zaxis==Zaxis;return;end;
            %%%
            sf=psp.surf(psp.Zaxis);
            set(sf,'Marker','none','MarkerEdgeColor','none');
            sf=psp.surf(Zaxis);
            set(sf,'Marker','.','MarkerEdgeColor','m');
            %%%
            psp.Zaxis=Zaxis;
       else
            delete(psp.surf);
            %%%
            psp.surf=[];Z=[];
            sourcei=Records.D3.source.start;
            hold on;
            for i=Records.D3.viewer.start:Records.D3.viewer.end
                paras=Records.D3.source.paras;
                paras.index=sourcei;
                Dir_File_read(handles,Records.D3.source.file,paras,false,false);
                img=Records.raw;
                %%%
                if isempty(Z)
                    [row,col,chn]=size(img);
                    [x,y]=meshgrid(1:col,1:row);
                    Z=ones(row,col);
                end
                z=(i-1)*Records.D3.shape.thickness*Z;
                            roi=D3R_roi(row,col,Records.xys);
                            rois=find(roi==0);
                            z(rois)=nan;
                            for chni=1:size(img,3)
                                im=img(:,:,chni);
                                im(rois)=0;
                                img(:,:,chni)=im;
                            end
                            if max(img(:))<=1;imgcol=255*img;else imgcol=img;end;
                %%%
                [gry,rng]=D3R_gray(handles,img,[],false);
                z(find(gry<pVal*rng))=nan;
                %%%
                if i==Zaxis
                    sf=surf(x,y,z,imgcol,'linestyle','none','CDataMapping','direct','Tag','OME-D3R','Marker','.','MarkerEdgeColor','m');
                else
                    sf=surf(x,y,z,imgcol,'linestyle','none','CDataMapping','direct','Tag','OME-D3R');
                end
                psp.surf=[psp.surf,sf];
                sourcei=sourcei+1;
                %%%
                pause(0.001);
            end
            hold off;
            if ~D3R_loop_switch() && strcmp(Menus.Parameters,'Gray')
                tmpShow(handles,struct('Tag','bw','XData',gry,'Data',[pVal]),'Visible',{'on','off'},10);
            end
            %%%
            psp.Zaxis=Zaxis;
            psp.pVal=pVal;
            psp.source=Records.D3.source;
        end
%-------------
function Analyse_fit(handles,selection,pointedIndex)
    global Menus Parameters Records;
    switch Menus.Menus
        case '1D'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',1,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Length',struct('mode',99,'min',1,'val',1,'max',2,'step',1,'val2txt','','tip','Line length')...
                ),pointedIndex);return;end;
            %%%
            switch Menus.Parameters
                case 'Length'
                    [xs,ys,bs]=ginput(2);
                    xy1=[xs(1),ys(1)];
                    xy2=[xs(2),ys(2)];
                    len=sum((xy1-xy2).^2)^0.5;
                    str=[num2str(len)];
            end
        case '2D'
            maxV=numel(find(~isnan(Records.xys(:,1))));
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',1,'max',1,'step',1,'val2txt','','tip','[Record] >>> relative parameters'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Centroid',struct('mode',99,'min',1,'val',1,'max',2,'step',2,'val2txt','','tip','Centroid'),...
                'Circumference',struct('mode',99,'min',1,'val',1,'max',2,'step',2,'val2txt','','tip','Circumference'),...
                'Area',struct('mode',99,'min',1,'val',1,'max',2,'step',2,'val2txt','','tip','Area'),...
                'SliceLine',struct('mode',2,'min',1,'val',2,'max',maxV,'step',maxV,'val2txt','','tip','The maxNumber of the sliceLine')...
                ),pointedIndex);return;end;
            %%%
            xys=Records.xys;
            xys(any(isnan(xys)'),:)=[];
            xs=xys(:,1);ys=xys(:,2);
            switch Menus.Parameters
                case 'Centroid'
                    [xg,yg,xsum,ysum,xysum]=Com_poly(xys);
                    G=[xg,yg];
                    str=['[',num2str(G,'%0.3e\t'),']'];
                    %%%
                    hold on;
                    pltShow(xg,yg,'m*');
                    hold off;
                case 'Circumference'
                    C=Com_circumference(xys);
                    str=[num2str(C,'%0.3e')];
                    %%%
                    hold on;
                    pltShow(xs,ys,'m*');axis ij;
                    hold off;
                case 'Area'
                    A=Com_area(xys);
                    str=[num2str(A,'%0.3e')];
                    %%%
                    hold on;
                    pltShow(xs,ys,'m*');axis ij;
                    hold off;
                case 'SliceLine'
                    lenOrarea=Com_slice(xys,Parameters.SliceLine.val);
                    str=['[',num2str(lenOrarea,'%0.3e\t'),']'];
                    %%%
                    
            end
        case '3D'
            maxV=numel(find(~isnan(Records.D3.xyzs(:,:,1))));
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',1,'max',1,'step',1,'val2txt','','tip','[Record] >>> relative parameters'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Centroid',struct('mode',99,'min',1,'val',1,'max',2,'step',2,'val2txt','','tip','Centroid'),...
                'Surface',struct('mode',99,'min',1,'val',1,'max',2,'step',2,'val2txt','','tip','Surface'),...
                'Volume',struct('mode',99,'min',1,'val',1,'max',2,'step',2,'val2txt','','tip','Volume'),...
                'SliceArea',struct('mode',2,'min',1,'val',4,'max',maxV,'step',maxV,'val2txt','','tip','The maxNumber of the sliceeSection')...
                ),pointedIndex);return;end;
            %%%
            xyzs=Records.D3.xyzs;
            switch Menus.Parameters
                case 'Centroid'
                    G=Com_centroid(xyzs);
                    str=['[',num2str(G,'%0.3e\t'),']'];
                    %%%
                    hold on;
                    plot3(G(1),G(2),G(3),'m*');
                    hold off;
                case 'Surface'
                    S=Com_surface(xyzs);
                    str=['[',num2str(S,'%0.3e\t'),']'];
                case 'Volume'
                    V=Com_volume(xyzs);
                    str=[num2str(V,'%0.3e')];
                case 'SliceArea'
                    lenOrarea=Com_slice(Records.D3.xyzs,Parameters.SliceArea.val);
                    str=['[',num2str(lenOrarea,'%0.3e\t'),']'];
            end
        otherwise
           return; 
    end
    D3R_record(handles,str)
function G=Com_centroid(xyzs)
    G=[0,0,0];
    if isempty(xyzs);return;end;
    %%%
    z=xyzs(:,:,3);lastZ=z(1,1);
    V=0;
    for i=1:size(xyzs,1);
        nowZ=z(i,1);
        disZ=nowZ-lastZ;
        %
        xys=reshape(xyzs(i,:,1:2),size(xyzs,2),2);
        [xg,yg,xsum,ysum,area]=Com_poly(xys);
        V=V+area*disZ;
        %
        G=G+[xsum,ysum,area*(nowZ+lastZ)/2]*disZ;
        %
        lastZ=nowZ;
    end
    G=G/V;
function S=Com_surface(xyzs)
    S=[0,0,0];
    if isempty(xyzs);return;end;
    %%%
    z=xyzs(:,:,3);
    S=0;num=size(xyzs,1);
        i=1;
        xys=reshape(xyzs(i,:,1:2),size(xyzs,2),2);
        lstxys=xys;
        xys(any(isnan(xys)'),:)=[];
        C=Com_circumference(xys);
        A1=Com_area(xys);
        lstC=C;lstZ=z(i,1);
    for i=2:num
        xys=reshape(xyzs(i,:,1:2),size(xyzs,2),2);
        disD=sum(((xys-lstxys).^2)').^0.5;
        disD(isnan(disD))=[];
        disD=mean(disD);
        lstxys=xys;
        %
        nowZ=z(i,1);
        disZ=nowZ-lstZ;
        %
        xys(any(isnan(xys)'),:)=[];
        C=Com_circumference(xys);
        c=(C+lstC)/2;
        disz=(disZ^2+disD^2)^0.5;
        S=S+c*disz;
        %
        lstC=C;lstZ=nowZ;
    end
        A2=Com_area(xys);
    S=[A1,S,A2];
function V=Com_volume(xyzs)
    V=0;
    if isempty(xyzs);return;end;
    %%%
    z=xyzs(:,:,3);lastZ=z(1,1);
    for i=1:size(xyzs,1);
        nowZ=z(i,1);
        disZ=nowZ-lastZ;
        %
        xys=reshape(xyzs(i,:,1:2),size(xyzs,2),2);
        xys(any(isnan(xys)'),:)=[];
        A=Com_area(xys);
        V=V+A*disZ;
        %
        lastZ=nowZ;
    end
function C=Com_circumference(xys)
    C=0;
    if isempty(xys);return;end;
    lastXY=xys(1,:);
    for j=1:size(xys,1)
        XY=xys(j,:);
        C=C+sum((XY-lastXY).^2)^0.5;
        lastXY=XY;
    end
        XY=xys(1,:);
        C=C+sum((XY-lastXY).^2)^0.5;
function A=Com_area(xys)
    A=0;
    if isempty(xys);return;end;
    A=polyarea(xys(:,1),xys(:,2));
function C=Com_join(A,B,flag)
    if nargin>2 && strcmp(flag,'rows')
        in=intersect(A,B,flag);
        if isempty(in)
            C=[];
            return;
        else
            if isequal(in,B(1:size(in,1),:))
                C=A;
            elseif isequal(in,A(1:size(in,1),:))
                C=B;
                B=A;
            else
                C=[];
                return;
            end
            for i=1:size(B,1)
                b=B(i,:);
                if ~any(ismember(C,b,flag))
                    C=[C;b];
                end
            end
        end
    else
        in=intersect(A,B);
        if isempty(in)
            C=[];
            return;
        else
            if isequal(in,B(1:numel(in)))
                C=A;
            elseif isequal(in,A(1:numel(in)))
                C=B;
                B=A;
            else
                C=[];
                return;
            end
            for i=1:length(B)
                b=B(1:i);
                if ~any(ismember(C,b))
                    C=[C b];
                end
            end
        end
    end
function [lensOrareas,lines]=Com_slice(xysOrxyzs,sliceMaxNum,loop)
    lensOrareas=[0];lines=struct();
    if ndims(xysOrxyzs)==3%xyz
        areas=[];update={};
        areasIndex=[];
        xyzs=xysOrxyzs;
        ssize=size(xyzs);
        lastZone=xyzs(1,1,3);
        %---
        HOLE=[];
        for zi=1:ssize(1)
            xys=xyzs(zi,:,1:2);
            xys=reshape(xys,ssize(2),2);
            %---
            nowZone=xyzs(zi,1,3);
            disZone=abs(nowZone-lastZone);
            lastZone=nowZone;
            %---
            [ls,lines]=Com_slice(xys,sliceMaxNum,true);
            for i=1:numel(lines)
                line=lines(i);
                find=false;
                for j=1:numel(HOLE)
                    hole=HOLE(j);
                    if ~hole.open;continue;end;
                    lns=hole.line{end};
                    for k=1:numel(lns)
                        ln=lns(k);
                        if ~isempty(intersect(ln.polar,line.polar))
                            HOLE(j).open=true;
                            if HOLE(j).index(end)==zi
                                lastline=HOLE(j).line{end}(end);
                                if ~isequal(lastline,line)
                                    HOLE(j).line{end}=[HOLE(j).line{end} line];
                                end
                            else
                                find=true;
                                HOLE(j).index=[HOLE(j).index zi];
                                HOLE(j).dis=[HOLE(j).dis disZone];
                                HOLE(j).line=[HOLE(j).line line];
                            end
                        end
                    end
                end
                if ~find
                    newi=numel(HOLE)+1;
                    HOLE(newi).open=true;
                    HOLE(newi).index=[zi];
                    HOLE(newi).dis=[disZone];
                    HOLE(newi).line={[line]};
                end
            end
            for j=1:numel(HOLE)
                hole=HOLE(j);
                if hole.index(end)<zi
                    HOLE(j).open=false;
                end
            end
        end
        %---
        Areas=[];
        index=0;
        hold on;
        for j=1:numel(HOLE)
            hole=HOLE(j);
            lines=hole.line;
            area=0;
            for k=1:numel(lines)
                lns=lines{k};
                zi=hole.index(k);
                dis=hole.dis(k);
                z=xyzs(zi,1,3);
                for l=1:numel(lns)
                    ln=lns(l);
                    area=area+dis*ln.len;
                end
            end
            if area<mean(hole.dis)^2;continue;end;
            xs=[];ys=[];zs=[];
            for k=1:numel(lines)
                lns=lines{k};
                zi=hole.index(k);
                dis=hole.dis(k);
                z=xyzs(zi,1,3);
                zs=[zs z];
                for l=1:numel(lns)
                    ln=lns(l);
                    xy=ln.xy;
                    xy1=xy(1,:);
                    xy2=xy(end,:);
                    xs=[xs xy1(1) xy2(1)];
                    ys=[ys xy1(2) xy2(2)];
                    plot3([xy1(1),xy2(1)],[xy1(2),xy2(2)],[z,z],'b*-')
                end
            end
            Areas=[Areas area];
            index=index+1;
            text(mean(xs),mean(ys),mean(zs),['(',num2str(index),')'],'Color','c');
        end
        hold off;
        lensOrareas=Areas;
        %---
        return;
                                %-
                                %---
                                %--
                                %{
            for i=1:numel(lines)
                nowlst=lspii{i}(2:end);
                nowlen=lspii{i}(1);
                nowlng=length(nowlst);
                have=false;
                for j=1:size(update,1)
                    oldlst=update{j}(2:end);
                    oldlen=update{j}(1);
                    oldlng=length(oldlst);
                    unnlst=union(nowlst,oldlst);
                    if length(unnlst)<nowlng+oldlng
                        starti=nowlst(1);
                        startxyz=xyzs(zi,starti,:);
                        endi=nowlst(end);
                        endxyz=xyzs(zi,endi,:);
                        areas=[areas;startxyz;endxyz;];
                        %
                        update{j}=[oldlen+nowlen*disZone nowlst];
                        have=true;
                    end
                end
                if ~have
                    starti=nowlst(1);
                    startxyz=xyzs(zi,starti,:);
                    endi=nowlst(end);
                    endxyz=xyzs(zi,endi,:);
                    areas=[areas;startxyz;endxyz;];
                    areasIndex=[areasIndex size(areas,1)/2];
                    %
                    update=[update;[nowlen*disZone nowlst]];
                end
            end
                                %}
        %---
        %{
        hold on;
        num=size(areas,1);
        index=0;Index=0;
        for i=1:num/2
            as=areas(2*i-1:2*i,:);
            plot3(as(:,1),as(:,2),as(:,3),'-*b');axis ij;
            if i>Index
                index=index+1;
                if index>length(areasIndex);continue;end;
                Index=areasIndex(index);
                text(mean(as(:,1)),mean(as(:,2)),2*mean(as(:,3)),['(',num2str(index),')'],'Color','g');axis ij;
            end
        end
        hold off;
        Areas=[];
        for i=1:size(update,1)
                Area=update{i}(1);                
                Areas=[Areas Area];
        end
        %}
    end
    %xy
        xys=xysOrxyzs;
        %---
        lineIndex=1;
        startxy=[];endxy=[];endi=0;
        for i=1:size(xys,1)
            xy=xys(i,:);
            if any(isnan(xy));continue;end;
            if isempty(startxy);startxy=xy;endxy=xy;endi=i;end;
            lines(lineIndex).len=sum((xy-endxy).^2)^0.5;
            lines(lineIndex).polar=[endi:i];
            lines(lineIndex).xy=[endxy;xy];
            endxy=xy;
            endi=i;
            %
            lineIndex=lineIndex+1;
        end
        if isempty(startxy)||isempty(endxy)
            return;
        end
        lines(1).len=sum((startxy-endxy).^2)^0.5;
        lines(1).polar=[endi:size(xys,1) 1:lines(1).polar(1)];
        lines(1).xy=[endxy;lines(1).xy(1,:)];
        %---
        PER=mean(cell2mat({lines(:).len}));
        MERGE=2*PER;
        while true
            [LV,LI]=sort(cell2mat({lines(:).len}),'descend');
            jump=false;
            lastline=lines(1);lastli=LI(1);
            for VI=2:numel(LV)
                lv=LV(VI);
                li=LI(VI);
                line=lines(li);
                if line.len<MERGE
                    VI=VI-1;
                    jump=true;
                    break;
                end
                lastline=lines(lastli);
                int=intersect(line.polar,lastline.polar);
                if ~isempty(int)
                    if line.polar(1)>=lastline.polar(end)
                        up=[lastline.polar line.polar];
                        ux=[lastline.xy;line.xy];
                    elseif lastline.polar(1)>=line.polar(end)
                        up=[line.polar lastline.polar];
                        ux=[line.xy;lastline.xy];
                    else
                        %disp('E> slice.polar');
                        %disp({'int>',int(:),'line',line.polar(1),line.polar(end),'last',lastline.polar(1),lastline.polar(end)})
                        %return;
                        lines(li).len=0;
                        break;
                    end
                    lines(lastli).len=line.len+lastline.len;
                    lines(lastli).polar=up;
                    lines(lastli).xy=ux;
                    lines(li).len=0;
                    break;
                elseif VI>=sliceMaxNum
                    jump=true;
                    break;
                end
                %%%
                lastli=li;
            end
            if jump;break;end;
        end
        lensOrareas=LV(1:min(sliceMaxNum,VI));
        lines=lines(LI(1:min(sliceMaxNum,VI)));
        %----------
        if nargin<3;
            hold on;
            pltShow(xys(:,1),xys(:,2),'c');axis ij;
            for i=1:min(sliceMaxNum,VI)
                lv=LV(i);
                li=LI(i);
                line=lines(li);
                xy=mean(line.xy);
                pltShow(line.xy(:,1),line.xy(:,2),'-*b');
                text(xy(1),xy(2),['(',num2str(i),')'],'Color','g');
            end
            hold off;
        end
function [xg,yg,xsum,ysum,xysum]=Com_poly(xys)
    xg=0;yg=0;xsum=0;ysum=0;xysum=0;
    if isempty(xys);return;end;
    %
    xys(any(isnan(xys)'),:)=[];
    %
    xs=xys(:,1);ys=xys(:,2);
    minX=floor(min(xs));maxX=ceil(max(xs));
    minY=floor(min(ys));maxY=ceil(max(ys));
    %
    imgx=minX:maxX;imgx=imgx';
    imgy=[minY;maxY]*ones(1,maxX+1-minX);
    imgy=imgy(:);imgy=imgy(1:numel(imgx));
    [xx,yy]=polyxpoly(imgx,imgy,xs,ys);
    [val,ind]=sort(xx);
    %
    id1=ind(1);
    lastx=xx(id1);
    lasty=yy(id1);
    for i=2:numel(xx)
        id=ind(i);
        x=xx(id);
        y=yy(id);
        len=((x-lastx)^2+(y-lasty)^2)^0.5;
        xsum=xsum+len*(x+lastx)/2;
        ysum=ysum+len*(y+lasty)/2;
        xysum=xysum+len;
        lastx=x;
        lasty=y;
    end
    xg=xsum/xysum;
    yg=ysum/xysum;
function [xg,yg,xsum,ysum,xysum]=Com_poly0(xys)
    xg=0;yg=0;xsum=0;ysum=0;xysum=0;
    if isempty(xys);return;end;
    %
    xys(any(isnan(xys)'),:)=[];
    %
    xs=xys(:,1);ys=xys(:,2);
    minX=floor(min(xs));maxX=ceil(max(xs));
    minY=floor(min(ys));maxY=ceil(max(ys));
    %
    for x=minX:maxX
        [xx,yy]=polyxpoly([x;x],[minY;maxY],xs,ys);
        if isempty(yy);continue;end;
        minv=min(yy);maxv=max(yy);disv=maxv-minv;
        xysum=xysum+disv;
        ysum=ysum+disv*(minv+maxv)/2;
        xsum=xsum+disv*x;
    end
    xg=xsum/xysum;
    yg=ysum/xysum;
function [xg,yg,xsum,ysum,xysum]=Com_polyCentroid(x,y,voxelSizeXnano,voxelSizeYnano)
    % x,y are two vectors,which are the coordinates of the boundary of
    % the polygon. [coord(1),coord(2)] is the the coordinate of barycenter.
    ymax=max(y);ymin=min(y);
    xmax=max(x);xmin=min(x);
    xsum=0;ysum=0;xysum=0;
    Ny=ceil((ymax-ymin)/voxelSizeYnano);
    for i=1:Ny+1
      xcmin=xmax;
      xcmax=xmin;
      for j=1:length(x)
        if(round((y(j)-ymin)/voxelSizeYnano)==(i-1))
            if xcmin>x(j)
                xcmin=x(j);
            end
            if xcmax<x(j)
                xcmax=x(j);
            end
        end
      end
      Nx=(xcmax-xcmin)/voxelSizeXnano+1;
      xysum=xysum+Nx;
      xsum=xsum+(xcmin+xcmax)*Nx/2;
      ysum=ysum+(ymin+voxelSizeYnano*(i-1))*Nx;
    end
    xg=xsum/xysum;
    yg=ysum/xysum;
    xsum=xsum*voxelSizeXnano^2;
    ysum=ysum*voxelSizeYnano^2;
%-------------
function Format_fit(handles,selection,pointedIndex)
    global Menus Records;
    dirname=createPath(Menus.Menus);
    createDir(handles,dirname);
    switch Menus.Menus
        case 'Project'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',1,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);%{1}can't move;{2}selection=2>>>val=0(normal);val=1(must one);
                'OMEd3r',struct('mode',99,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','mp4 format')...
                ),pointedIndex);return;end;
            suff=Menus.Parameters;
            filePath=createPath(dirname,suff);
            %%%
            D3R_export(handles,filePath);
        case 'D3R'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',1,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);%{1}can't move;{2}selection=2>>>val=0(normal);val=1(must one);
                'd3r',struct('mode',99,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','mp4 format')...
                ),pointedIndex);return;end;
            suff=Menus.Parameters;
            filePath=createPath(dirname,suff);
            %%%
            Records.D3.colormap=colormap();
            D3=Records.D3;
            save(filePath,'D3','-mat');
            clear D3;
        case {'Form','Frame','Figure','Raw'}
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',1,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);%{1}can't move;{2}selection=2>>>val=0(normal);val=1(must one);
                'tif',struct('mode',99,'min',1,'val',1,'max',1,'step',1,'val2txt','','tip','tif format'),...
                'png',struct('mode',99,'min',1,'val',1,'max',1,'step',1,'val2txt','','tip','png format'),...
                'jpg',struct('mode',99,'min',1,'val',1,'max',1,'step',1,'val2txt','','tip','jpg format'),...
                'bmp',struct('mode',99,'min',1,'val',1,'max',1,'step',1,'val2txt','','tip','bmp format'),...
                'eps',struct('mode',99,'min',1,'val',1,'max',1,'step',1,'val2txt','','tip','eps format')...
                ),pointedIndex);return;end;
            suff=Menus.Parameters;
            filePath=createPath(dirname,suff);
            %%%
            switch Menus.Menus
                case 'Form'
                    figExport(handles,handles.Form,filePath,suff);
                case 'Frame'
                    figExport(handles,nan,filePath,suff);
                case 'Figure'
                    figExport(handles,handles.Figures,filePath,suff);
                case 'Raw'
                    figExport(handles,[],filePath,suff);
                otherwise
                    msgShow(handles,2,'E> not supported');
                    return;
            end
        case 'Video'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',1,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);%{1}can't move;{2}selection=2>>>val=0(normal);val=1(must one);
                'avi',struct('mode',2,'min',1,'val',1,'max',360,'step',360,'val2txt','','tip','avi format'),...
                'mj2',struct('mode',2,'min',1,'val',1,'max',360,'step',360,'val2txt','','tip','mj2 format'),...
                'mp4',struct('mode',2,'min',1,'val',1,'max',360,'step',360,'val2txt','','tip','mp4 format')...
                ),pointedIndex);return;end;
            suff=Menus.Parameters;
            filePath=createPath(dirname,suff);
            %%%
            switch suff
                case 'avi'
                    Records.writer= VideoWriter(filePath,'Uncompressed AVI');
                case 'mj2'
                    Records.writer = VideoWriter(filePath,'Motion JPEG 2000');
                case 'mp4'
                    Records.writer = VideoWriter(filePath,'MPEG-4');
                otherwise
                    msgShow(handles,2,'E> not supported');
                    return;
            end
            %%%
            open(Records.writer);
            Figures_Menus_Switch_Animation_Callback(handles.Form, nan, handles);
            close(Records.writer);
        case 'Output'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',1,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);%{1}can't move;{2}selection=2>>>val=0(normal);val=1(must one);
                'xls',struct('mode',99,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Export the ''Output'' to xls')...
                ),pointedIndex);return;end;
            suff=Menus.Parameters;
            filePath=createPath(dirname,suff);
            %%%
            switch suff
                case 'xls'
                    lstExport([],handles.Records,handles);
                otherwise
                    return;
            end
        otherwise
            return;
    end
    msgShow(handles,2,strcat('OK> ',filePath));
%-------------
function Command_fit(handles,selection,pointedIndex)
    global Menus Parameters Records;
    switch Menus.Menus
        case 'Action'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',1,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);%{1}can't move;{2}selection=2>>>val=0(normal);val=1(must one);
                'Switch',struct('mode',2,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Switch windows>>>0:Main; 1:Sub;'),...
                'Pause',struct('mode',99,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Pause'),...
                'Wait',struct('mode',2,'min',0,'val',0,'max',365*24*3600,'step',365*24*3600,'val2txt','','tip','The time for sleep')...
                ),pointedIndex);return;end;
            switch Menus.Parameters
                case 'Switch'
                    D3R_switch(handles,Parameters.Switch.val);
                case 'Pause'
                    Switch_Callback(handles.Switch,[],handles);
                case 'Wait'
                    pause(Parameters.Wait.val);
                otherwise
                    return;
            end
        case 'Draw'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',1,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);%{1}can't move;{2}selection=2>>>val=0(normal);val=1(must one);
                'Clear',struct('mode',99,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Clear the drawing plane'),...
                'XYs',struct('mode',99,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Draw coordinates of XY plane'),...
                'HoldOn',struct('mode',99,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Hold on the drawing plane'),...
                'HoldOff',struct('mode',99,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Hold off the drawing plane'),...
                'Box',struct('mode',2,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Box>0:off; 1:on;'),...
                'Axis',struct('mode',2,'min',0,'val',0,'max',7,'step',8,'val2txt','','tip','Axis>0:Off; 1:On; 2:Auto; 3:Normal; 4:Manual; 5:Equal; 6:Ij; 7:Xy;'),...
                'Tick',struct('mode',2,'min',0,'val',2,'max',100,'step',100,'val2txt','','tip','The xyz axis tick(10^x)'),...
                'Background',struct('mode',2,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Backgound>0:white; 1:colormap;'),...
                'Color',struct('mode',1,'min',0,'val',1,'max',1,'step',size(colormap(),1),'val2txt','','tip','The color from colorbar'),...
                'Hidden',struct('mode',2,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Hidden>0:off; 1:on;'),...
                'Alpha',struct('mode',1,'min',0,'val',0.5,'max',1,'step',10,'val2txt','','tip','The alpha color')...
                ),pointedIndex);return;end;
            switch Menus.Parameters
                case 'Clear'
                    cla;
                case 'XYs'
                    pltShow(Records.xys(:,1),Records.xys(:,2),'.b');axis ij;                  
                case 'HoldOn'
                    hold on;
                case 'HoldOff'
                    hold off;
                case 'Box'
                    switch Parameters.Box.val
                        case 0
                            box off;
                        case 1
                            box on;
                    end
                case 'Axis'
                    switch Parameters.Axis.val
                        case 0
                            axis off;
                        case 1
                            axis on;
                        case 2
                            axis auto;
                        case 3
                            axis normal;
                        case 4
                            axis manual;
                        case 5
                            axis equal;
                        case 6
                            axis ij;
                        case 7
                            axis xy;
                    end
                case 'Tick'
                    tik=10^Parameters.Tick.val;
                    ax=gca;
                    objs=allchild(ax);
                    objs=objs(isprop(objs,'XData'));
                    Xs=get(objs,'XData');Ys=get(objs,'YData');Zs=get(objs,'ZData');
                    xs=Xs{:};xs=xs(:);ys=Ys{:};ys=ys(:);zs=Zs{:};zs=zs(:);
                    xmin=min(xs);xmax=max(xs);ymin=min(ys);ymax=max(ys);zmin=min(zs);zmax=max(zs);
                    txn=floor(xmin/tik)*tik;txx=ceil(xmax/tik)*tik;
                    tyn=floor(ymin/tik)*tik;tyx=ceil(ymax/tik)*tik;
                    tzn=floor(zmin/tik)*tik;tzx=ceil(zmax/tik)*tik;
                    axis([txn txx tyn tyx tzn tzx]);
                    set(gca,'xtick',ceil(txn:tik:txx),'ytick',ceil(tyn:tik:tyx),'ztick',ceil(tzn:tik:tzx));
                case 'Background'
                    switch Parameters.Background.val
                        case 0
                            set(gca,'Color','w');
                        case 1
                            cols=colormap();
                            set(gca,'Color',cols(1,end));
                    end
               case 'Color'
                    cols=colormap();
                    if isempty(cols);return;end;
                    coli=max(1,round(Parameters.Color.val*size(cols,1)));
                    col=cols(coli,:);
                    tmpShow(handles,'colorbar','Visible',{'on','off'},3);
                    %
                    objs=allchild(gca);
                    for i=1:numel(objs)
                        obj=objs(i);
                        if isprop(obj,'Tag') && strcmp(obj.Tag,'OME-D3R')
                            continue;
                        elseif isprop(obj,'FaceColor')
                            set(obj,'FaceColor',col);
                        elseif isprop(obj,'Color')
                            set(obj,'Color',col);
                        end
                    end
                case 'Hidden'
                    switch Parameters.Hidden.val
                        case 0
                            hidden off;
                        case 1
                            hidden on;
                    end
                case 'Alpha'
                    alpha=Parameters.Alpha.val;
                    %
                    objs=allchild(gca);
                    for i=1:numel(objs)
                        obj=objs(i);
                        if isprop(obj,'Tag') && strcmp(obj.Tag,'OME-D3R')
                            continue;
                        elseif isprop(obj,'FaceAlpha')
                            set(obj,'FaceAlpha',alpha);
                        elseif isprop(obj,'Alpha')
                            set(obj,'Alpha',alpha);
                        end
                    end
                otherwise
                    return;
            end
        case 'Colormap'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);
                'Gray',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Bone',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Copper',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Pink',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Hot',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Cool',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Spring',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Summer',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Autumn',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Winter',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Parula',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Jet',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Hsv',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Lines',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...	
                'Colorcube',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Prism',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'Flag',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping'),...
                'White',struct('mode',2,'min',1,'val',10,'max',1000,'step',100,'val2txt','','tip','The color for mapping')...
                ),pointedIndex);return;end;
            para=getfield(Parameters,Menus.Parameters);
            color=lower(Menus.Parameters);
            evalstr=[color,'(',num2str(para.val),')'];
            colors=eval(evalstr);
            %---
            Records.D3.colormap=colors;
            colormap(colors);
            %---
            tmpShow(handles,'colorbar','Visible',{'on','off'},3);
        case 'Output'
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',1,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);%{1}can't move;{2}selection=2>>>val=0(normal);val=1(must one);
                'Clear',struct('mode',99,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Clear the ''Output'''),...
                'Info',struct('mode',99,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Project information for exporting'),...
                'XYs',struct('mode',99,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Coordinates marked in XY-plane'),...
                'XYZs',struct('mode',99,'min',0,'val',0,'max',1,'step',2,'val2txt','','tip','Coordinates marked in XYZ-model'),...
                'Record',struct('mode',99,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','Record processing information for exporting')...
                ),pointedIndex);return;end;
            switch Menus.Parameters
                case 'Clear'
                    lstEmpty(handles.Records);
                    return;
                case 'Info'
                    info=Info_show(handles,false);
                case 'XYs'
                    info=num2str(round(Records.xys),'%d\t');
                case 'XYZs'
                    info=num2str(round(Records.xyzs),'%d\t');
                case 'Record'
                    info=Records.record;
                otherwise
                    return;
            end
            D3R_record(handles,info,false);
            D3R_record(handles,datestr(now));
       otherwise
            return;
    end
%-------------
function Plugin_fit(handles,selection,pointedIndex)
    global Menus Parameters Records;
    if strcmp(Menus.Menus,'Package')
            if Functions_gui(handles,selection,struct(...
                'Parameters',struct('mode',0,'min',0,'val',1,'max',1,'step',1,'val2txt','','tip','Show or input the corresponding parameter'),...%{1}enable=0;{2}selection=2>>>check>>>val=0(normal);val=1(must select one);%{1}can't move;{2}selection=2>>>val=0(normal);val=1(must one);
                'Install',struct('mode',99,'min',0,'val',0,'max',1,'step',1,'val2txt','','tip','mp4 format')...
                ),pointedIndex);return;end;
            [file,dir]=uigetfile('*.jar;*.m;*.p;*.py;*.py3;*.r;*.R','Input File ...');
            if ~file;return;end;
            path=strcat(dir,file);
            %
            [d,f,s]=fileparts(path);
            suffix=lower(s);
            switch suffix
                case {'.jar'}
                    dir='Java';
                case {'.m','.p'}
                    dir='Matlab';
                case {'.py3','.py'}
                    dir='Python';
                case {'.r'}
                    dir='R';
            end
            try
                targetpath=fullfile(D3R_project(handles,'path'),dir);
                if ~isdir(targetpath);createDir(handles,targetpath);end;
                targetfile=fullfile(targetpath,file);
                copyfile(path,targetfile);
                msgShow(handles,2,'OK> installed');
            catch
                msgShow(handles,2,['E> ',lasterr]);
            end
            return;
    end
    %-------
    msgShow(handles,2,'A> @Reservation [Functions]');
    return;
    %-------
    targetpath=fullfile(D3R_project(handles,'path'),Menus.Menus);
    if ~isdir(targetpath);createDir(handles,targetpath);end;
    fs=subDFs(targetpath,'f');
    fs=['Parameters',fs];
    set(handles.Parameters,'String',fs,'Value',1);
    %-------
    try
        switch Menus.Menus            
            case 'Java'
                javaaddpath(targetpath);
                OME=java.lang.Integer(2);
                obj=javaObject('D3R.ZNL7.taqingbilu',OME);
                obj.run();
            case 'Matlab'
            case 'Python'
            case 'R'
            otherwise
                return;
        end
    catch
        msgShow(handles,2,['E> ',lasterr]);
    end
%****************************************
function Timer(time)
    T=timer('TimerFcn',@(~,~)disp(''),'StartDelay',time);
    start(T);
    wait(T);
function busyShow(handles,reverse)
    global Menus;
    names={'Functions','Menus','Parameters','Values','Changes',...
           %'AllCmds','AllFiles','AllDirs'...
           %'Dirs','Files','Commands','Records',...
           %'Switch','Figures'
          };
    for i=1:numel(names)
        name=names{i};
        obj=getfield(handles,name);
        if nargin>1
            set(obj,'Enable','on');
            continue;
        end
        val=getfield(obj,'Enable');
        Menus.busy=setfield(Menus.busy,name,val);
        set(obj,'Enable','off');
    end
    %%%
    if nargin>1
        set(handles.Form,'pointer','arrow');
        Menus.busy=[];
    else
        set(handles.Form,'pointer','watch');
    end
function freeShow(handles)
    global Menus;
    if isempty(Menus.busy);return;end;
    names=fieldnames(Menus.busy);
    for i=1:numel(names)
        name=names{i};
        obj=getfield(handles,name);
        val=getfield(Menus.busy,name);
        if ~strcmp(obj.Enable,'on')
            set(obj,'Enable',val);
        end
    end
    Menus.busy=[];
    set(handles.Form,'pointer','arrow');
function msgShow(handles,waitTime,str)
    global Handles;
    if nargin<3;str=waitTime;waitTime=handles;handles=Handles;end;
    %---
    if isempty(str);return;end;
    set(handles.Message,'Visible','on','String',str);
    if length(str)>2
        col=str(1:2);
        switch col
            case 'A>'
                set(handles.Message,'ForegroundColor','c');
            case 'L>'
                set(handles.Message,'ForegroundColor','g');
            case 'E>'
                set(handles.Message,'ForegroundColor','r');
            otherwise
                set(handles.Message,'ForegroundColor','k');
        end
    end
    %time
    if isnumeric(waitTime) && waitTime>0;pause(waitTime);set(handles.Message,'Visible','off','String','');end;
function sldShow(handles,str)
    global Records;
    %---
    len=length(str);
    can=10;
    for i=1:len-can
        set(handles.Message,'Name',str(i:i+can));
        pause(0.3);
    end
    msgShow(handles,1,Records.file.projectTitle);
function tmpShow(handles,objectTag,propName,propVal,time,self)%for switch>>> 1.axes(handles.Figures);2.tmpshow;
    persistent stat;global Menus;
    if isempty(stat);stat=struct();end;
    objectData=struct();
    %%%
    if isstruct(objectTag)
        objectData=objectTag;
        objectTag=objectData.Tag;
    elseif isobject(objectTag)
        object=objectTag;
        objectTag=object.Tag;
    end
    %%%
    if ~isfield(stat,objectTag)
        Tag=struct();
        axes(handles.Windows);
        switch objectTag
            case 'colorbar'
                handles.Windows.Visible='off';
                %###
                hObj=colorbar(handles.Windows,'southoutside');
                hObj.Position=handles.Windows.Position;
                hObj.Position(4)=0.03;
                %%%
                object=hObj;
            case {'gray','bw'}
                handles.Windows.Position(4)=0.2;
                handles.Windows.Visible='on';
                %###
                [f,x]=ksdensity(objectData.XData(:),'width',0.01);
                pltShow(handles.Windows,x,f,'b');
                hold(handles.Windows,'on');
                %---
                maxY=max(f);
                if length(objectData.Data)>1
                    minV=objectData.Data(1);
                    midV=objectData.Data(2);
                    maxV=objectData.Data(3);
                    Tag.plots(1)=pltShow(handles.Windows,[minV,minV],[0,maxY],'g-.');
                    Tag.plots(2)=pltShow(handles.Windows,[midV,midV],[0,maxY],'r--');
                    Tag.plots(3)=pltShow(handles.Windows,[maxV,maxV],[0,maxY],'g-.');
                else
                    midV=objectData.Data;
                    Tag.plots=pltShow(handles.Windows,[midV,midV],[0,maxY],'r--');
                end
                handles.Windows.XLim(1)=0;
                axis(handles.Windows,'on');
                %---
                hold(handles.Windows,'off');
                %%%
                object=handles.Windows;
            case 'info'
                handles.Windows.Visible='off';
                %###
                D3R_switch(handles,false);
                pltShow(0,0);
                obj=text(-0.4,0.8,objectData.Data);
                box(handles.Windows,'off');
                axis(handles.Windows,'off');
                %%%
                object=obj;
            case 'rotate3d'
                %###
                %%%
                object=rotate3d;
            case 'img'
                handles.Windows.Position(2)=0;
                handles.Windows.Position(4)=0.2;
                handles.Windows.Visible='on';
                axis(handles.Windows,'off');
                object=imshow(objectData.Data,'parent',handles.Windows);
            case 'ppd'
                R=objectData.Data;
                center=figCenter(handles,'.');
                xc=center(1);yc=center(2);zc=center(3);
                %%%
                hold(handles.Figures,'on');
                [x,y,z]=sphere(100);
                x=x*R+xc;
                y=y*R+yc;
                z=z*R+zc;
                object=mesh(x,y,z,'Parent',handles.Figures,'FaceColor','b','FaceAlpha',0.5);
                hold(handles.Figures,'off');
                if isfield(objectData,'XData')
                    handles.Windows.Position(4)=0.2;
                    handles.Windows.Visible='on';
                    %###
                    [f,x]=ksdensity(objectData.XData(:),'width',0.01);
                    pltShow(handles.Windows,x,f,'b');
                    hold(handles.Windows,'on');
                    %---
                    maxY=max(f);
                    midV=objectData.Data;
                    Tag.plots=pltShow(handles.Windows,[midV,midV],[0,maxY],'r--');
                    %---
                    %---
                    handles.Windows.XLim(1)=0;
                    axis xy;
                    axis(handles.Windows,'on');
                    %---
                    hold(handles.Windows,'off');
                end
            case 'other'
        end
        pause(0.1);axes(handles.Figures);
        Tag.object=setfield(object,propName,propVal{1});
        Tag.timer=timer('BusyMode','drop',...
            'StartDelay',time,...
            'TimerFcn',@(~,~)tmpShow(handles,objectTag,propName,propVal,time,true)...
            );
        Tag.data=objectData;
        stat=setfield(stat,objectTag,Tag);
    else
        Tag=getfield(stat,objectTag);
        if nargin>5%self->off
            Tag.object=setfield(Tag.object,propName,propVal{2});
            if isequal(Tag.object,handles.Windows)
                    objs=allchild(handles.Windows);
                    objs=objs(isprop(objs,'Visible'));
                    set(objs,'Visible','off');
            end
            stop(Tag.timer);
            delete(Tag.timer);
            stat=rmfield(stat,objectTag);
            %---------------associated variables;
            switch objectTag
                case 'colorbar'
                    delete(Tag.object);
                case 'img'
                    delete(Tag.object);
                case 'ppd'
                    delete(Tag.object);
                    objs=allchild(handles.Windows);
                    objs=objs(isprop(objs,'Visible'));
                    set(objs,'Visible','off');
                    %
                    set(handles.Windows,'Visible','off');
                case 'rotate3d'
                    delete(Tag.object);
                    set(handles.Form,'pointer','arrow');
                    D3R_button('');
                case {'gray','bw'}
                case 'info'
                    delete(Tag.object);
                    D3R_switch(handles,true);
                case 'other'
            end
            return;
        else
            axes(handles.Windows);
            switch objectTag
                case {'gray','bw'}
                    handles.Windows.Visible='on';
                    hold(handles.Windows,'on');
                    %---
                        maxY=max(cell2mat({Tag.plots.YData}));
                        delete(Tag.plots);
                        if length(objectData.Data)>1
                            minV=objectData.Data(1);
                            midV=objectData.Data(2);
                            maxV=objectData.Data(3);
                            Tag.plots(1)=pltShow(handles.Windows,[minV,minV],[0,maxY],'g-.');
                            Tag.plots(2)=pltShow(handles.Windows,[midV,midV],[0,maxY],'r--');
                            Tag.plots(3)=pltShow(handles.Windows,[maxV,maxV],[0,maxY],'g-.');
                        else
                            midV=objectData.Data;
                            Tag.plots=pltShow(handles.Windows,[midV,midV],[0,maxY],'r--');
                        end
                    handles.Windows.XLim(1)=0;
                    axis xy;
                    axis(handles.Windows,'on');
                    %---
                    hold(handles.Windows,'off');
                case 'img'
                    handles.Windows.Position(2)=0;
                    handles.Windows.Position(4)=0.2;
                    handles.Windows.Visible='on';
                    delete(Tag.object);
                    Tag.object=imshow(objectData.Data,'parent',handles.Windows);
                    axis(handles.Windows,'off');
                case 'ppd'
                    R=objectData.Data;
                    center=figCenter(handles,'.');
                    xc=center(1);yc=center(2);zc=center(3);
                    %%%
                    delete(Tag.object);
                    hold(handles.Figures,'on')
                    [x,y,z]=sphere(100);
                    x=x*R+xc;
                    y=y*R+yc;
                    z=z*R+zc;
                    Tag.object=mesh(x,y,z,'Parent',handles.Figures,'FaceColor','b','FaceAlpha',0.5);
                    hold(handles.Figures,'off')
                    if isfield(objectData,'XData')
                        if isfield(Tag,'plots') && all(isvalid(Tag.plots))
                            delete(Tag.plots);
                        end
                            handles.Windows.Position(4)=0.2;
                            handles.Windows.Visible='on';
                            %###
                            [f,x]=ksdensity(objectData.XData(:),'width',0.01);
                            pltShow(handles.Windows,x,f,'b');
                            hold(handles.Windows,'on');
                            %---
                            %---
                            maxY=max(f);
                            midV=objectData.Data;
                            Tag.plots=pltShow(handles.Windows,[midV,midV],[0,maxY],'r--');
                            %---
                            %---
                            handles.Windows.XLim(1)=0;
                            axis xy;
                            axis(handles.Windows,'on');
                            %---
                            hold(handles.Windows,'off');
                    end
                case 'other'
            end
            pause(0.1);axes(handles.Figures);
        %-------------
            try
                Tag.object=setfield(Tag.object,propName,propVal{1});
                stat=setfield(stat,objectTag,Tag);
                stop(Tag.timer);
            catch
                try
                stat=rmfield(stat,objectTag);
                catch
                end
                tmpShow(handles,objectTag,propName,propVal,time);
            end
        end
    end
    %time=0>>>no close;
    if time && isobject(Tag.timer) && isvalid(Tag.timer);start(Tag.timer);elseif isfield(stat,objectTag);stat=rmfield(stat,objectTag);end;
%-------------
function lstShow(hObject,handles)
    try
        contents=get(hObject,'String');
        if isempty(contents);msgShow(handles,2,'M> no ''Data''');return;end;
        contents=cellstr(contents);

        index=get(hObject,'Value');
        content=contents{index(1)};
        msgShow(handles,2,content);
    catch
        return;
    end
function index=lstAdd(hObject,handles,item,index)
    try
        old=cellstr(get(hObject,'String'));
        if isequal(old,{''});old={};end;
        if nargin>3
            set(hObject,'String',[old(1:index);item;old(index+1:end)],'Value',index+1);
        else
            set(hObject,'String',[old,item],'Value',numel(old)+1);
        end
        index=index+1;
    catch
        msgShow(handles,2,'E> record');
        index=0;
        return;
    end
function index=lstRemove(hObject,handles)
    try
        contents=get(hObject,'String');
        if isempty(contents);index=1;return;end;
        contents=cellstr(contents);
        index=get(hObject,'Value');
        is=1:numel(contents);
        is(index)=0;
        contents=contents(is>0);
        set(hObject,'String',contents,'Value',max(1,index(1)-1));
    catch
        msgShow(handles,2,'E> remove');
        index=0;
        return;
    end
function index=lstRemoveDowns(hObject,handles)
    try
        contents=get(hObject,'String');
        if isempty(contents);index=1;return;end;
        contents=cellstr(contents);
        index=get(hObject,'Value');
        index=index(1);
        set(hObject,'String',contents(1:index-1),'Value',max(1,index-1));
    catch
        msgShow(handles,2,'E> lstRemoveDowns');
        index=0;
        return;
    end
function lstEmpty(hObject)
    set(hObject,'String','','Value',1);        
function [index,number]=lstUpDown(hObject,handles,upDown)
    try
        contents=get(hObject,'String');
        contents=cellstr(contents);
        index=get(hObject,'Value');
        number=numel(contents);
        IS=1:number;
        if upDown
            if any(ismember(index,1))
                msgShow(handles,2,'M> top');
                index=0;
                return;
            else
                is=IS;
                is(index)=0;
                objs=contents(is==0);
                oths=contents(is>0);
                
                is=IS;
                is(index-1)=0;
                contents(is==0)=objs;
                contents(is>0)=oths;
                newIndex=index-1;
            end
        else
            if any(ismember(index,numel(contents)))
                msgShow(handles,2,'M> bottom');
                index=0;
                return;
            else
                is=IS;
                is(index)=0;
                objs=contents(is==0);
                oths=contents(is>0);
                
                is=IS;
                is(index+1)=0;
                contents(is==0)=objs;
                contents(is>0)=oths;
                newIndex=index+1;
            end
        end
        set(hObject,'String',contents,'Value',newIndex);
    catch
        msgShow(handles,2,'E> lstUpDown');
        index=0;
        return;
    end
function number=lstImport(suffix,hObject,handles)
    try
        [file,dir]=uigetfile(strcat('*.',suffix),'Input File ...');
        if ~file;number=0;return;end;
        path=strcat(dir,file);
        Cel=importdat(path);
        %{
        Cel={};
        dat=importdata(path,'\n');
        for i=1:numel(dat)
            line=dat{i};
            if ~isempty(line);Cel=[Cel line];end;
        end
        %}
        set(hObject,'String',Cel,'Value',1);
        number=numel(Cel);
    catch
        Commands_Menus_Clear_All_Callback(hObject, [], handles);
        number=0;
    end
function lstExport(suffix,hObject,handles)
    try
        contents=get(hObject,'String');
        if isempty(contents);
            msgShow(handles,2,'M> no ''Data''');
            return;
        end;
        contents=cellstr(contents);
    catch
        msgShow(handles,2,strcat('E> ',lasterr));
        return;
    end

    if isempty(suffix)
        global Menus;
        path=createPath(Menus.Menus);
        createDir(handles,path);
        path=createPath(path,'xls');
    else
        [file,dir]=uiputfile(strcat('*.',suffix),'Ouput File ...');
        if ~file;return;end;
        path=strcat(dir,file);
    end

    fw=fopen(path,'w');
    for i=1:length(contents)
        fwrite(fw,[contents{i},13]);
    end
    fclose(fw);
    msgShow(handles,2,strcat('OK> ',path));
%-------------
function rtn=pltShow(varargin)
    global Handles;
    %---------
    rtn=[];
    if D3R_loop_switch()
        if get(Handles.Show,'value');
            rtn=plot(varargin{1:end});
        end
    else
        rtn=plot(varargin{1:end});
    end
function figShow(handles,cmd,dat)
    global Records;
    switch cmd;
        case 'hold off'
            hold(handles.Figures,'off');
        case 'hold on';
            hold(handles.Figures,'on');
        otherwise
    end;
    if size(dat,3)>3
        dat=dat(:,:,1:3);
    end
    %---------
    if D3R_loop_switch()
        if get(handles.Show,'value');
            imshow(dat,'Parent',handles.Figures);
        end
    else
        imshow(dat,'Parent',handles.Figures);
    end
    Records.img=dat;
function fig=figSwitch(par1sub2)
    global Records;
    %---
    figs=get(0,'children');
    find=0;
    for i=1:length(figs)
        if strcmp(get(figs(i),'Tag'),'OME:3DR')
            sub=figs(i);
            find=find+1;
            if find>1;break;end;
        elseif strcmp(get(figs(i),'Tag'),'Form')
            par=figs(i);
            find=find+1;
            if find>1;break;end;
        end
    end
    if find<2
        sub=figure('NumberTitle', 'off','Name',Records.file.projectTitle,'Tag','OME:3DR');%,'WindowButtonDownFcn',@(hObject, eventdata, handles){clf(par);copyobj(get(hObject,'children'),par);});
        %set(par,'WindowButtonDownFcn',@(hObject, eventdata, handles){clf(handles.Figures);copyobj(get(sub,'children'),handles.Figures);})
    end;
    %%%
    switch par1sub2
        case 1
            fig=par;
        case 2
            fig=sub;
    end
    figure(fig);
function figImport(handles,suffix)
    global Records;
    %%%
    [file,dir]=uigetfile(suffix,'Input File ...');
    if ~file;return;end;
    filePath=strcat(dir,file);
    %------------------------------------------------
    Records.file.readerPath='';%>>>for Menus.reader
    [dirstr,fileName,suffix]=fileparts(filePath);
    Records.file.fileName=[fileName,suffix];
    Records.file.filePath=filePath;
    Records.file.fileSuffix=lower(suffix(2:end));

    imgORerr=Dir_File_read(handles,filePath,[],true,true);
    %------------------------------------------------
    if ischar(imgORerr)
        msgShow(handles,2,['E> (import)> ',imgORerr]);
        return;
    end
    msgShow(handles,2,['OK> (import)>',fileName,suffix]);
function img=figExport(handles,hObject,filePath,suffix)
    attention=false;
    if strcmp(filePath,'.')
        [file,dir]=uiputfile(suffix,'Figure File ...');
        if ~file;return;end;
        filePath=strcat(dir,file);
        [pathStr, name, suf] = fileparts(filePath);
        suffix=suf(2:end);
        attention=true;
    end
    %------------------------------------------------
    %------------------------------------------------
    try
        if strcmp(suffix,'eps')%eps
            D3R_figEPS(handles,hObject,filePath);
        elseif isempty(hObject)%raw
            global Records;
            img=Records.img;
            imwrite(img,filePath,suffix);
        else
            if isobject(hObject)%form/figure
                if strcmp(hObject.Type,'figure')%form
                    frame=getframe(hObject);
                else%figure
                    frame=D3R_figEPS(handles,hObject,[]);
                end
            elseif isnan(hObject)%frame
                handles.Main.Units='pixels';
                pos=handles.Main.Position;
                pos(1)=ceil(pos(1));pos(2)=ceil(pos(2));
                pos(3)=floor(pos(3));pos(4)=floor(pos(4));
                mrg=2*handles.Main.BorderWidth;
                handles.Main.Units = 'normalized';
                pos=[pos(1)+mrg,pos(2)+mrg,pos(3)-2*mrg,pos(4)-2*mrg];
                frame=getframe(handles.Form,pos); 
            else
            end
            %%%
            [im,map]=frame2im(frame);
            if isempty(map)            %Truecolor system
              img = im;
            else                       %Indexed system
              img = ind2rgb(im,map);   %Convert image data
            end
            if isempty(filePath);return;end;
            imwrite(img,filePath,suffix);
        end
    catch
        msgShow(handles,2,['E> (export)> ',lasterr]);
        img=[];
        return;
    end
    if attention
        [pathStr, name, suf] = fileparts(filePath);
        msgShow(handles,2,['OK> (export)>',name,suf]);
    end
function ct=figCenter(handles,cmd)
    global Records;persistent center;
    %---
    switch cmd
        case '.'
            if isempty(center)||any(isnan(center))
                pos=[ceil(size(Records.img,2)/2),ceil(size(Records.img,1)/2),0];
                center=pos;
            end  
        case 'get'
                D3R_record(handles,['[',num2str(center,['%0.3f, ',9]),']']);
                %%%
                if isempty(center)||any(isnan(center))
                    msgShow(handles,2,'M> no set ''Center''');
                else
                    hold on;
                    plot3(center(1),center(2),center(3),'*m');axis ij;
                    hold off;
                end;
        case 'set'
            msgShow(handles,0,'M> wait for center pointing ...');
            imshow(Records.img);
            pos=gtext('*','FontSize',18,'Color','y');
            center=pos.Position;
            msgShow(handles,0,'M> busy ...');
        case 'points'
            if isempty(Records.xys)
                center=figCenter(handles,'set');
            else
                xys=Records.xys;
                xys(any(isnan(xys)'),:)=[];
                xy=mean(xys);
                xg=xy(1);yg=xy(2);
                cnt=[xg,yg,0];
                %%%
                if any(isnan(cnt));
                    msgShow(handles,2,'M> can''t find the center');
                else
                    center=cnt;
                    hold on;
                    plot3(center(1),center(2),center(3),'*m');axis ij;
                    hold off;
                end;
            end
        case 'centroid'
            if isempty(Records.xys)
                center=figCenter(handles,'set');
            else
                [xg,yg,xsum,ysum,xysum]=Com_poly(Records.xys);
                cnt=[xg,yg,0];
                %%%
                if any(isnan(cnt));
                    msgShow(handles,2,'M> can''t find the center');
                else
                    center=cnt;
                    hold on;
                    plot3(center(1),center(2),center(3),'*m');axis ij;
                    hold off;
                end;
            end
        case ''
            center=[0,0,0];
    end
    ct=center;
%-------------
function dfs=subDFs(path,df)
    E=0;
    if upper(df)=='D'
        e=7;
    elseif upper(df)=='F'
        e=2;
    elseif upper(df)=='P'
        e=2;
        E=1;
    else
        return;
    end
    %%%
    dfs={};
    ds=dir(path);
    for i=1:length(ds)
        d=ds(i).name;
        if d(1)=='.'
            continue;
        end
        f=strcat(path,filesep,d);
        if exist(f)==e
            if E
                d=fullfile(path,d);
            end
            dfs=[dfs;d];
        end
    end
function err=createDir(handles,dirname)
    err=0;
    if ~isdir(dirname)
        err=mkdir(dirname);
        if ~err
            msgShow(handles,2,'A> cann''t create [Direcory]');
            return;
        end
        if ~isdir(dirname)
            msgShow(handles,2,strcat('E> duplicated ''',dirname,''''));
            err=1;
            return;
        else
            msgShow(handles,2,strcat('M> created ''',dirname,''''));
        end
    end
function path=createPath(dirname,suffix)
    global Records;
    if nargin==1
        path=fullfile(Records.file.rootPath,dirname);
    else
        path=fullfile(dirname,[Records.file.fileName,'(',strrep(datestr(now),':','-'),').',suffix]);
    end
function cells=importdat(path)
    cells={};
    
    fr=fopen(path,'r');
    line=fgetl(fr);
    while ischar(line)
    if ~isempty(line);cells=[cells;line];end;
    line=fgetl(fr);
    end;
    fclose(fr);
function [ok,val]=txt2val(txt)
    try
        val=eval(txt);
        ok=true;
    catch
        val=nan;
        ok=false;
    end
function [ok,num]=txt2num(txt)
    try
        num=str2double(txt);
        ok=true;
    catch
        num=nan;
        ok=false;
    end
%{
function xR=xDirection(x,y,dat,oldR)
        mStep=0;
        loop=true;
        sz=size(dat);
        while loop
            nowX=x+mStep;
            if nowX>sz(1)
                break;
            elseif ~dat(nowX,y)
                jump=true;
                for i=1:oldR
                    tstX=nowX+i;
                    if tstX>sz(1)
                        break;
                    elseif dat(tstX,y)
                        jump=false;
                        break;
                    end
                end
                if jump
                   loop=false;
                else
                    mStep=mStep+i;
                end
            end
            mStep=mStep+1;
        end
        xR=mStep-1;
function [xR,yR]=yDirection(x,y,dat,oldR,sign)
        yStep=0;
        nowR=0;
        sz=size(dat);
        xR=0;
        while true
            nowY=y+yStep*sign;
            nowR=xDirection(x,nowY,dat,oldR);
            if ~nowR
                break;
            elseif nowY<1||nowY>sz(2)
                xR=nowR;
                break;
            elseif nowR>oldR
                xR=nowR;
            end
            yStep=yStep+1;
        end
        yR=yStep;
function [xyRadius,xyLoc]=xySearch(x,y,dat,oldR)
    xR=xDirection(x,y,dat,oldR);
    maxR=max(xR,oldR);
    
    [xR,yRp]=yDirection(x,y,dat,maxR,1);
    maxR=max(maxR,max(xR,yRp));
    [xR,yRm]=yDirection(x,y,dat,maxR,-1);
    maxR=max(maxR,max(xR,yRm));

    xmid=round(x+maxR/2);
    ymid=round(max(y,y+(yRp-yRm)/2));
    xyLoc=[xmid,ymid];   
    %###
    xyN=0;
    for i=x:x+maxR
        for j=max(0,y-yRm):y+yRp
            if dat(i,j)
                dat(i,j)=0;
                xyN=xyN+1;
            end
        end
    end
    xyRadius=sqrt(2*xyN)/2;     
function [dotRadius,pixelXYs]=dotGrayFigures(dat)
    [xs,ys]=size(dat);
    dotRadius=1;
    dotRadiuses=[];
    pixelXYs=[];
    for x=1:xs
        lstNum=length(dotRadiuses);
        for y=1:ys
            if dat(x,y)
                [xyR,xyL]=xySearch(x,y,dat,dotRadius);
                disp(xyR);
                disp(xyL);
                disp('???');
                dotRadiuses=[dotRadiuses,xyR];
                pixelXYs=[pixelXYs;xyL];
            end
            disp('X');disp(x);
            disp('Y');disp(y);
        end
        nowNum=length(dotRadiuses);
        %###
        if lstNum>33
            preNum=round((nowNum-lstNum)/2);
            sufNum=nowNum-lstNum-preNum;
            sortList=sort(dotRadiuses);
            dotRadius=mean(sortList(1+preNum:nowNum-sufNum));
            disp('!!!');disp(dotRadius);disp('...');
        end
    end
%}
%****************************************
function H = arrowPlot(X, Y, varargin)
%ARROWPLOT Plot with arrow on the curve.
%   ARROWPLOT(X, Y) plots X, Y vectors with 2 arrows directing the trend of data.
%
%   You can use some options to edit the properties of arrow or curve.
%   The options that you can change are as follow:
%       number:		The number of arrows, default number is 2;
%       color:		The color of arrows and curve, default color is [0, 0.447, 0.741];
%       LineWidth:	The line width of curve, default LineWidth is 0.5;
%       scale:		To scale the size of arrows, default scale is 1;
%       limit:		The range to plot, default limit is determined by X, Y data;
%       ratio:		The ratio of X-axis and Y-axis, default ratio is determined by X, Y data;
%             		You can use 'equal' for 'ratio', that means 'ratio' value is [1, 1, 1].
%
%   Example 1:
%   ---------
%      t = [0:0.01:20];
%      x = t.*cos(t);
%      y = t.*sin(t);
%      arrowPlot(x, y, 'number', 3)
%
%   Example 2:
%   ---------
%      t = [0:0.01:20];
%      x = t.*cos(t);
%      y = t.*sin(t);
%      arrowPlot(x, y, 'number', 5, 'color', 'r', 'LineWidth', 1, 'scale', 0.8, 'ratio', 'equal')

%   Copyright 2017 TimeCoder.

    h = plot(X, Y);
    hold on;
    if nargout == 1
        H = h;
    end

    ratio = get(gca, 'DataAspectRatio');
    limit = axis;
    d = max(limit(2)-limit(1), limit(4)-limit(3));
    
    default_options.number = 2;
    default_options.color = [0 0.447 0.741];
    default_options.LineWidth = 0.5;
    default_options.size = d;
    default_options.scale = 1;
    default_options.limit = axis;
    default_options.ratio = ratio;
    Options = creat_options(varargin, default_options);
    
    useroptions = creat_useroptions(varargin);
    if ~isfield(useroptions, 'size')
        Options.size = max(Options.limit(2)-Options.limit(1), Options.limit(4)-Options.limit(3));
    end
    if ~isfield(useroptions, 'ratio')
        axis(Options.limit);
        Options.ratio = get(gca, 'DataAspectRatio');
    end
    set(h, 'color', Options.color);
    set(h, 'LineWidth', Options.LineWidth);
    if isa(Options.ratio, 'char') && strcmp(Options.ratio, 'equal')
        r = 1;
    else
        r = Options.ratio(2) / Options.ratio(1);
    end
    
    n_X = length(X);
    journey = 0;
    for i = 1 : n_X-1
        journey = journey + sqrt( (X(i+1)-X(i))^2 + (Y(i+1)-Y(i))^2 );
    end
    journey_part = journey / Options.number;

    if 10*journey<Options.size
        Options.size = 10*journey;
    end
    
    
    [X_arrow, Y_arrow] = arrow_shape(50, 25);
    [X_arrow1, Y_arrow1] = arrow_Scale(X_arrow, Y_arrow, 0.015*Options.scale*Options.size);

    k=0.5;
    journey_now = 0;

    for i = 1 : n_X-1
        journey_step = sqrt( (X(i+1)-X(i))^2 + (Y(i+1)-Y(i))^2 );
        journey_next = journey_now + journey_step;
        if journey_now<=k*journey_part && journey_next>k*journey_part
            s = (k*journey_part - journey_now) / journey_step;
            x0 = X(i) + s * (X(i+1)-X(i));
            y0 = Y(i) + s * (Y(i+1)-Y(i));
            [X_arrow2, Y_arrow2] = arrow_Rotate(X_arrow1, Y_arrow1, arrow_arg(X(i+1)-X(i), (Y(i+1)-Y(i))/r) );
            [X_arrow3, Y_arrow3] = arrow_Translation(X_arrow2, r*Y_arrow2, [x0, y0]);
            g = fill(X_arrow3, Y_arrow3, Options.color);
            set(g, 'EdgeColor', Options.color);
            k=k+1;
        end
        journey_now = journey_next;
    end
    axis(Options.limit);
    if isequal(Options.ratio, 'equal')
        axis equal;
    end
    hold off;
function Options = creat_options(user_choice, default_choice_struct)
    n = length(user_choice);
    if ~arrow_ispair(n)
        error('varargin is not an options''s struct.');
    end
    
    Options = default_choice_struct;
    i = 1;
    while i <= n
        if isfield(default_choice_struct, user_choice{i})
            Options = setfield(Options, user_choice{i}, user_choice{i+1});
        end
        i = i + 2;
    end
function Options = creat_useroptions(VARARGIN)
    if ~isa(VARARGIN, 'cell')
        error('VARARGIN is not of class cell!');
    end
    n = length(VARARGIN);
    if ~arrow_ispair(n)
        error('length of VARARGIN is not pair!');
    end
    i = 1;
    Options = struct();
    while i < n
        Options = setfield(Options, VARARGIN{i}, VARARGIN{i+1});
        i = i+2;
    end
function check = arrow_ispair(x)
    check = ( arrow_isint(x) && arrow_isint( 1.0*x / 2.0 ) );
function check = arrow_isint(x)
    check = ( floor(x) == x );
function theta = arrow_arg(x, y)
    if nargin == 2
        [m, n] = size(x);
        theta = zeros(m, n);
        for i = 1 : m
            for j = 1 : n
                if x(i, j) > 0 || y(i, j) ~= 0
                    theta(i, j) = 2 * atan( y(i, j) ./ ( x(i, j) + sqrt(x(i, j).^2+y(i, j).^2) ) );
                elseif x(i, j) < 0 && y(i, j) == 0
                    theta(i, j) = pi;
                elseif x(i, j) == 0 && y(i, j) == 0
                    theta(i, j) = 0;
                end
            end
        end
    elseif nargin==1
        theta = arrow_arg(real(x), imag(x));
    end
function [X, Y] = arrow_shape(theta1, theta2)
    theta1 = theta1/180*pi;
    theta2 = theta2/180*pi;
    x0 = tan(theta2) / ( tan(theta2) - tan(theta1) );
    y0 = tan(theta1) * tan(theta2) / ( tan(theta2) - tan(theta1) );
    X = [0, x0, 1, x0, 0];
    Y = [0, y0, 0, -y0, 0];
function [X_new, Y_new] = arrow_Rotate( X, Y, varargin )
    if length(varargin)==1
        center = [0, 0];
        theta = varargin{1};
    elseif length(varargin)==2
        center = varargin{1};
        theta = varargin{2};
    end

    [m1, n1] = size(X);
    [m2, n2] = size(Y);
    
    if min(m1, n1) ~= 1
        error('The size of X is wrong!');
    end
    
    if min(m2, n2) ~= 1
        error('The size of Y is wrong!');
    end
    
    if n1 == 1
        X = X';
    end
    
    if n2 == 1
        Y = Y';
    end
    
    if length(X) ~= length(Y)
        error('length(X) and length(Y) must be equal!');
    end
    XY_new = [cos(theta), -sin(theta); sin(theta), cos(theta)] * [X-center(1); Y-center(2)];
    X_new = XY_new(1, :)+center(1);
    Y_new = XY_new(2, :)+center(2);
function [X_new, Y_new] = arrow_Scale( X, Y, varargin )
    if length(varargin)==1
        center = [0, 0];
        s = varargin{1};
    elseif length(varargin)==2
        center = varargin{1};
        s = varargin{2};
    end
    
    X_new = s * ( X - center(1) ) + center(1);
    Y_new = s * ( Y - center(2) ) + center(2);
function [X_new, Y_new] = arrow_Translation( X, Y, increasement )
    X_new = X + increasement(1);
    Y_new = Y + increasement(2);
%****************************************

