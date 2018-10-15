function varargout = main(varargin)
%MAIN provides the main frame of the Calibrate Curve Submenu
%
%   Input:
%       - varargin{1}: handles-struct from FCP-App
%
%   Output:
%       - varargout{1}: updated handles-struct to FCP-App
%
%   mainHandles-struct: basic structure to share between callbacks and
%   functions. 
%   Fields:
%       - handles: handles-struct from FCP-App
%       - mainDialog: handles to Menu-gui
%       - Features: struct with importand gui-features (static)
%       - settings: struct with important gui-features (dynamic)
%       - general_grid: handle to General Grid
%       - settings_grid: handle to Settings Grid
%
%   functions:
%       - main
%       - JPK_NW_I_FC
%       - AR_MFP_3D_FC
%
%   callbacks:
%       - main_ok_button_callback
%       - main_cancel_button_callback
%       - main_clear_calibration_button_callback
%       - main_EasyImport_callback
%       - main_already_calibrated_checkbox_callback
%       - JPK_NW_I_FC
%           * sensitivity_edit_callback
%           * springconstant_edit_callback
%
%       - AR_MFP_3D_FC
%           * sensitivity_edit_callback
%           * springconstant_edit_callback

%% input parsing
p = inputParser;

ValidInput = @(x)assert(isa(x, 'struct'),...
    'CalibrateCurveSubmenu:main:InvalidInput',...
    'Input is not type: struct.');

addOptional(p, 'handles', [], ValidInput);

parse(p,varargin{:});

handles = p.Results.handles;

%% preparation

% return if one instance of calibrate curves submenu is open
singleton = findobj(groot, 'Type', 'Figure', 'Name', 'Calibrate Curves');
if ~isempty(singleton)
    return
end

% if there is no loaded data, cancel Calibrate Curves Submenu
if ~isempty(handles)
    if isempty(handles.guiprops.Features.edit_curve_table.Data)
        note = 'No loaded curves';
        HelperFcn.ShowNotification(note);
        
        % assign requested output
        if ~isempty(handles)
            varargout{1} = handles;
        end
        
        return
    end
end

mainHandles.handles = handles;

mainDialog = dialog('Name', 'Calibrate Curves',...
    'Units', 'normalized',...
    'Position', [0.3 0.3 0.2 0.19]); % to mainHandles

% create main_vbox an hide it, to prevent flickering during creation
mainVbox = uix.VBox('Parent', mainDialog,...
    'Padding', 5,...
    'Visible', 'off'); % to mainHandles

%% General Panel
general_panel = uix.Panel('Parent', mainVbox,...
    'Padding', 5,...
    'Title', 'General');
general_grid = uix.Grid('Parent', general_panel,...
    'Spacing', 5); % to mainHandles

TextLabel('Parent', general_grid,...
    'String', 'Easy Import:');
TextLabel('Parent', general_grid,...
    'String', 'File Specifier:');
TextLabel('Parent', general_grid,...
    'String', 'Already Calibrated:');
easyimport_label = TextLabel('Parent', general_grid,...
    'String', '',...
    'CreateFcn', {@HelperFcn.MenuFunctions.CalibrateCurvesSubmenu.main_EasyImport_callback, mainHandles}); % to mainHandles
filespecifier_label = TextLabel('Parent', general_grid,...
    'String', '',...
    'CreateFcn', {@HelperFcn.MenuFunctions.CalibrateCurvesSubmenu.main_filespecifier_label_callback, mainHandles}); % to mainHandles
already_calibrated_checkbox = uicontrol('Parent', general_grid,...
    'Style', 'checkbox',...
    'CreateFcn', {@test_if_calibrated_callback, mainHandles}); % to mainHandles

general_grid.Heights = [-1 -1 -1];
general_grid.Widths = [-2 -1];

%% Settings Panel
settings_panel = uix.Panel('Parent', mainVbox,...
    'Padding', 5,...
    'Title', 'Settings');
settings_grid = uix.Grid('Parent', settings_panel); % to mainHandles

%% button group
button_group = uix.HButtonBox('Parent', mainVbox,...
    'Padding', 0,...
    'HorizontalAlignment', 'right',...
    'VerticalAlignment', 'middle',...
    'Spacing', 5);

% ok button
uicontrol('Parent', button_group,...
    'Style', 'pushbutton',...
    'String', 'Ok',...
    'Callback', @HelperFcn.MenuFunctions.CalibrateCurvesSubmenu.main_ok_button_callback);

% clear calibration button
uicontrol('Parent', button_group,...
    'Style', 'pushbutton',...
    'String', 'Clear Calibration',...
    'Callback', @HelperFcn.MenuFunctions.CalibrateCurvesSubmenu.main_clear_calibration_button_callback);

% cancel button
uicontrol('Parent', button_group,...
    'Style', 'pushbutton',...
    'String', 'Cancel',...
    'Callback', @HelperFcn.MenuFunctions.CalibrateCurvesSubmenu.main_cancel_button_callback);

button_group.HorizontalAlignment = 'center';
button_group.ButtonSize = [100 20];

%% update mainHandles-struct
mainHandles.mainDialog = mainDialog;
mainHandles.mainVbox = mainVbox;
mainHandles.general_grid = general_grid;
mainHandles.settings_grid = settings_grid;
mainHandles.Features.easyimport_label = easyimport_label;
mainHandles.Features.filespecifier_label = filespecifier_label;
mainHandles.Features.already_calibrated_checkbox = already_calibrated_checkbox;
mainHandles.settings = struct();

% add listeners for every uicontrol which need an updated mainHandles
% struct
lh = PropListener();
lh.addListener(already_calibrated_checkbox,...
    'Value', 'PostSet',...
    @HelperFcn.MenuFunctions.CalibrateCurvesSubmenu.main_already_calibrated_checkbox_callback);

%% write mainHandles to mainDialog
guidata(mainHandles.mainDialog, mainHandles);

%% setup default for menu
mainVbox.Heights = [80 -1 30];
mainVbox.Visible = 'on';

if ~isempty(handles)
    switch mainHandles.handles.curveprops.settings.FileSpecifier
        case '.txt'
           mainHandles =  HelperFcn.MenuFunctions.CalibrateCurvesSubmenu.JPK_NW_I_FC(mainHandles);
        case '.ibw'
           mainHandles = HelperFcn.MenuFunctions.CalibrateCurvesSubmenu.AR_MFP_3D_FC(mainHandles);
    end
end

%% determine output
if ~isempty(handles)
    varargout{1} = mainHandles.handles;
end

%% callbacks

    function test_if_calibrated_callback(src, evt, mainHandles)
        if mainHandles.handles.curveprops.Calibrated
            src.Value = src.Max;
            % if sensitivity and springconstant is nan, treat curves as
            % not calibrated
            if ~isnan(mainHandles.handles.curveprops.CalibrationValues.Sensitivity) & ... 
                    ~isnan(mainHandles.handles.curveprops.CalibrationValues.SpringConstant)
                src.Enable = 'off';
            else
                src.Enable = 'on';
                src.Value = src.Min;
            end
        else
            src.Enable = 'on';
            src.Value = src.Min;
        end
    end % test_if_calibrated_callback

end % main

