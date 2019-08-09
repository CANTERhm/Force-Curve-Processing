function varargout = ForceCurveProcessing(varargin)
%==========================================================================
% ForceCurveProcessing 0.2.0
%==========================================================================
%
% New Features:
%   - Baseline Correction
%   - Vertical Tip Position Calculation
%
%
% FORCECURVEPROCESSING MATLAB code for ForceCurveProcessing.fig
%      FORCECURVEPROCESSING, by itself, creates a new FORCECURVEPROCESSING or raises the existing
%      singleton*.
%
%      H = FORCECURVEPROCESSING returns the handle to a new FORCECURVEPROCESSING or the handle to
%      the existing singleton*.
%
%      FORCECURVEPROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORCECURVEPROCESSING.M with the given input arguments.
%
%      FORCECURVEPROCESSING('Property','Value',...) creates a new FORCECURVEPROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ForceCurveProcessing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ForceCurveProcessing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ForceCurveProcessing

% Last Modified by GUIDE v2.5 07-Aug-2019 15:13:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ForceCurveProcessing_OpeningFcn, ...
                   'gui_OutputFcn',  @ForceCurveProcessing_OutputFcn, ...
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


% --- Executes just before ForceCurveProcessing is made visible.
function ForceCurveProcessing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ForceCurveProcessing (see VARARGIN)

guiprops = GUIProperties(); % object holding properties concerning the gui
curveprops = CurveProperties(); % object holding properties concerning afm data
listeners = PropListener(); % object create property event listeners
procedure = FCProcedure(); % object containing all editfunctions
FilePathObject = FilePath(); % Get force curves from
SavePathObject = FilePath('title', 'Choose Folder'); % Save processed curves to
ProcedureFilePathObject = FilePath(); % get procedure file from

% additional propertys for guiprops
guiprops.addproperty('FilePathObject');
guiprops.addproperty('SavePathObject');
guiprops.addproperty('ProcedureFilePathObject');
guiprops.addproperty('MainFigure');
guiprops.addproperty('MainFigureName');
guiprops.addproperty('MainAxes');

% additional properties for curveprops
curveprops.addproperty('CurvePartIndex', 'exclude', true);
curveprops.addproperty('CurrentCurveName', 'exclude', true);
curveprops.addproperty('TraceColor', 'exclude', true);
curveprops.addproperty('RetraceColor', 'exclude', true);
curveprops.addproperty('DeflectionAdjusted', 'exclude', true);
curveprops.addproperty('Calibrated', 'exclude', true);
curveprops.addproperty('Saved', 'exclude', true);
curveprops.addproperty('AllowedFileSpecifiers', 'exclude', true);
curveprops.addproperty('CalibrationValues', 'exclude', true);

% some default values
guiprops.MainFigure = [];
guiprops.MainFigureName = 'FCP Graph Window';
guiprops.FilePathObject = FilePathObject;
guiprops.SavePathObject = SavePathObject;
ProcedureFilePathObject.DefaultPath = 'StandardProcedureFiles\fc_process_curves.txt';
ProcedureFilePathObject.title = 'Select an procedure-file';
guiprops.ProcedureFilePathObject = ProcedureFilePathObject;
curveprops.CurvePartIndex.trace = [1; 2];
curveprops.CurvePartIndex.retrace = [3; 6];
curveprops.TraceColor = [0 0 1];
curveprops.RetraceColor = [0 0.45 0.74];
curveprops.DeflectionAdjusted = false;
curveprops.Calibrated = false;
curveprops.Saved = false; % maybe obsolete; will be removed in future
curveprops.AllowedFileSpecifiers = afm.AllowedFileSpecifiers;
curveprops.CalibrationValues.Sensitivity = [];
curveprops.CalibrationValues.SpringConstant = [];

% update handles structure
handles.guiprops = guiprops;
handles.curveprops = curveprops;
handles.listeners = listeners;
handles.procedure = procedure;
guidata(handles.figure1, handles);

hObject.Name = 'Force-Curve Processing';
hObject.SizeChangedFcn = @Callbacks.WindowResizeCallback;
hObject.CloseRequestFcn = @Callbacks.CloseAppRequestFcnCallback;
handles = CreateAppComponents(handles);

handles = UtilityFcn.SeveralMonitors(handles, hObject, handles.guiprops.MainFigure);

% Choose default command line output for ForceCurveProcessing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ForceCurveProcessing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ForceCurveProcessing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
% Menu callback definition
% --------------------------------------------------------------------

% File Menu Entrys
% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_curves_submenu_Callback(hObject, eventdata, handles)
% hObject    handle to load_curves_submenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = UtilityFcn.UIGetFilepath(handles);
handles = IOData.ImportData(handles);
if ~isempty(handles.curveprops.DynamicProps) 
    handles = HelperFcn.AddFunctionsToCurve(handles);
end
guidata(handles.figure1, handles);


% --------------------------------------------------------------------
function save_curves_submenu_Callback(hObject, eventdata, handles)
% hObject    handle to save_curves_submenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = HelperFcn.MenuFunctions.SaveCurveSubmenuFcn(handles);

% handles = UtilityFcn.UISetSavepath(handles);
guidata(handles.figure1, handles);



% --------------------------------------------------------------------
function load_procedure_submenu_Callback(hObject, eventdata, handles)
% hObject    handle to load_procedure_submenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.guiprops.Features.proc_root_btn.Enable = 'off';
handles = UtilityFcn.UIGetFilepath(handles, 'ProcedureFilePathObject', 'mSelect', 'off');
handles = HelperFcn.LoadEditFunctions(handles);

% to load all listeners to editbuttons propertly and to set on_gui.Status 
% of every edit button properly: set the on_gui.Status property of
% proc_root_btn == true
src = handles.guiprops.Features.proc_root_btn;
HelperFcn.SwitchToggleState(src);
src.UserData.on_gui.Status = true;

% Enable all editbuttons
buttons = allchild(handles.guiprops.Panels.processing_panel);
for i = 1:length(buttons)
    buttons(i).Enable = 'on';
end

guidata(handles.figure1, handles);



% --------------------------------------------------------------------
function delete_procedure_submenu_Callback(hObject, eventdata, handles)
% hObject    handle to delete_procedure_submenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % this might be obsolete, because the results of editfunctions get stored
% % within die curveporps.(curvneame).Results-object anyways
% % Delete edit_functions from appdata
% handles = HelperFcn.DeleteFunctionsFromAppdata(handles);

% Delete edit_functions from curveprops.curvename.Results-Object
handles = HelperFcn.DeleteFunctionsFromCurve(handles);

% Delete edit_buttons from Gui
handles = HelperFcn.DeleteFunctionsFromGui(handles);

% Reset MainFigure Callbacks
UtilityFcn.ResetMainFigureCallbacks();

% clear Results-panel
panel = handles.guiprops.Panels.results_panel;
delete(allchild(panel));

% refresh shown graph
UtilityFcn.RefreshGraph();

% Reset SwitchToggleState to make sure its propert behavior if a new
% procedure gets loaded
clear SwitchToggleState

guidata(handles.figure1, handles)

% Edit Menu Entrys
% --------------------------------------------------------------------
function edit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to edit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function calibrate_curves_submenu_Callback(hObject, eventdata, handles)
% hObject    handle to calibrate_curves_submenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = HelperFcn.MenuFunctions.CalibrateCurvesSubmenu.main(handles);


% --------------------------------------------------------------------
function import_settings_submenu_Callback(hObject, eventdata, handles)
% hObject    handle to import_settings_submenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = HelperFcn.MenuFunctions.ImportSettingSubmenu.main(handles);


% --------------------------------------------------------------------
function curve_settings_submenu_Callback(hObject, eventdata, handles)
% hObject    handle to curve_settings_submenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Window Menu Entrys
% --------------------------------------------------------------------
function window_menu_Callback(hObject, eventdata, handles)
% hObject    handle to window_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function main_graph_submenu_Callback(hObject, eventdata, handles)
% hObject    handle to main_graph_submenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = UtilityFcn.SetupMainFigure(handles);
plottools();




% --------------------------------------------------------------------
function delete_curves_submenu_Callback(hObject, eventdata, handles)
% hObject    handle to delete_curves_submenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% delete curves from curveprops
try
    names = fieldnames(handles.curveprops.DynamicProps);
catch
    return
end
handles.curveprops.settings.FileSpecifier = [];
if ~isempty(names)
    for i = 1:length(names)
        handles.curveprops = handles.curveprops.delproperty(names{i});
    end
end


% clean the handles.guiprops.Features.edit_curve_table
handles.guiprops.Features.edit_curve_table.Data = [];
handles.guiprops.Features.edit_curve_table.UserData = [];

% reset handles.curveprops.Calibrated and switch the color of
% handles.guiprops.Features.calibration_status back to red
handles.curveprops.Calibrated = false;

% refreshing the handles.guiprops.Features.curve_parts_popup property
handles.guiprops.FireEvent('UpdateObject');

% update processing information labels
% handles = guidata(handles.figure1);
handles = HelperFcn.UpdateProcInformationLabels(handles);

% update calibration-statuslabels if curves are calibrated 
handles = HelperFcn.UpdateCalibrationStatus(handles);

% update CalibrationValues-property of curveprops if available
[sensitivity, springconstant, handles] = UtilityFcn.CalibrationValues(handles);
handles.curveprops.CalibrationValues.Sensitivity = sensitivity;
handles.curveprops.CalibrationValues.SpringConstant = springconstant;

% clear main axes
cla(handles.guiprops.MainAxes);

guidata(handles.figure1, handles);
