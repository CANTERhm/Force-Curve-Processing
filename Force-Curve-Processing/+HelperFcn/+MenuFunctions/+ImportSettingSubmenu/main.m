function varargout = main(varargin)
% MAIN provides the main frame of the Import Settings Submenu
%
% Input:
%   - varargin{1}: handles-struct from gui
%
% Output:
%   - varargout{1}: updated handles-struct

%% main dialog
d = dialog('Name', 'Import Settings',...
    'Units', 'normalized',...
    'Position', [0.3 0.3 0.2 0.5]);

% create main_vbox an hide it, to prevent flickering during creation
main_vbox = uix.VBox('Parent', d,...
    'Padding', 5,...
    'Visible', 'off');

% setup mainHandles-stuct
mainHandles = struct();

%% general Settings panel
general_settings_panel = uix.Panel('Parent', main_vbox,...
    'Padding', 5,...
    'Title', 'General Settings');
general_settings_grid = uix.Grid('Parent', general_settings_panel); 

TextLabel('Parent', general_settings_grid,...
    'String', 'Force Curve Type:');
TextLabel('Parent', general_settings_grid,...
    'String', 'Easy Import:');
popup_string = {'JPK NW-I Force Curves'; 'AR MFP-3D Forces Curves'};
main_popup = uicontrol('Parent', general_settings_grid,...
    'Style', 'popup',...
    'String', popup_string,...
    'Callback', @callback);

h = guidata(findobj(groot, 'Type', 'Figure', 'Tag', 'figure1'));
val = h.curveprops.settings.EasyImport;
uicontrol('Parent', general_settings_grid,...
    'Style', 'checkbox',...
    'Value', val,...
    'Callback', @checkbox_callback);

general_settings_grid.Heights = [-1 -1];
general_settings_grid.Widths = [-1 -1];

%% custom settings panel
custom_settings_panel = uix.Panel('Parent', main_vbox,...
    'Padding', 5,...
    'Title', 'Specific Settings');
custom_settings_vbox = uix.VBox('Parent', custom_settings_panel);

%% button group
button_group = uix.HButtonBox('Parent', main_vbox,...
    'Padding', 0,...
    'HorizontalAlignment', 'right',...
    'VerticalAlignment', 'middle',...
    'Spacing', 5);

% ok button
uicontrol('Parent', button_group,...
    'Style', 'pushbutton',...
    'String', 'Ok',...
    'Callback', @HelperFcn.MenuFunctions.ImportSettingSubmenu.main_ok_button_callback);

% cancel button
uicontrol('Parent', button_group,...
    'Style', 'pushbutton',...
    'String', 'Cancel',...
    'Callback', @HelperFcn.MenuFunctions.ImportSettingSubmenu.main_cancel_button_callback);

%% main_vbox height distribution
main_vbox.Heights = [75 -1 30];

%% update mainHandles-struct

% activate if ready
if ~isempty(varargin)
    mainHandles.handles = varargin{1}; % handles-struct from gui
end

mainHandles.mainDialog = d;
mainHandles.main_vbox = main_vbox;
mainHandles.general_settings_grid = general_settings_grid;
mainHandles.custom_settings_vbox = custom_settings_vbox;

%% determining output
% activate if ready
if ~isempty(varargin)
    varargout{1} = mainHandles.handles; % adjusted handles-struct to gui
end

% finally show main_vbox
main_vbox.Visible = 'on';

%% update mainHandles-struct to mainDialog
guidata(mainHandles.mainDialog, mainHandles);

% setting up a default style
InformationStyle = mainHandles.handles.curveprops.settings.InformationStyle;
if strcmp(InformationStyle, 'jpk-nanowizard-I')
    style = 1;
end
if strcmp(InformationStyle, 'mfp-3d-bio')
    style = 2;
end

switch style
    case 1
        main_popup.Value = 1;
        mainHandles = HelperFcn.MenuFunctions.ImportSettingSubmenu.JPK_NW_I_FC(mainHandles);
    case 2
        main_popup.Value = 2;
        mainHandles = HelperFcn.MenuFunctions.ImportSettingSubmenu.AR_MFP_3D_FC(mainHandles);
end

%% nested functions

    function callback(src, evt)
        switch src.Value
            case 1
                mainHandles = HelperFcn.MenuFunctions.ImportSettingSubmenu.JPK_NW_I_FC(mainHandles);
            case 2
                mainHandles = HelperFcn.MenuFunctions.ImportSettingSubmenu.AR_MFP_3D_FC(mainHandles);
        end
    end % callback

    function checkbox_callback(src, evt)
        switch src.Value
            case src.Max
                mainHandles.settings.EasyImport = true;
            case src.Min
                mainHandles.settings.EasyImport = false;
        end
        guidata(mainHandles.mainDialog, mainHandles);
    end % checkbox_callback

end % main