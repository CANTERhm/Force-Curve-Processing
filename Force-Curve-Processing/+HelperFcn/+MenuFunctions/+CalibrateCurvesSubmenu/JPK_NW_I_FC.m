function mainHandles = JPK_NW_I_FC(mainHandles)
%JPK_NW_I_FC Settings setup for Calibrate Curves Submenu with
%FileSpecifier: .txt

grid = mainHandles.settings_grid;
grid.Visible = 'off';
sensitivity = mainHandles.handles.curveprops.CalibrationValues.Sensitivity;
springconstant = mainHandles.handles.curveprops.CalibrationValues.SpringConstant;

% make sure sensitivity and springconstant are numerical values
if ~isnumeric(sensitivity)
    sensitivity = NaN;
end
if ~isnumeric(springconstant)
    springconstant = NaN;
end

TextLabel('Parent', grid,...
    'String', 'Sensitivity:');
TextLabel('Parent', grid,...
    'String', 'Spring Constant:');
sensitivity_edit = uicontrol('Parent', grid,...
    'Style', 'edit',...
    'String', num2str(sensitivity),...
    'UserData', num2str(sensitivity),...
    'Callback', @HelperFcn.MenuFunctions.CalibrateCurvesSubmenu.JPK_NW_I_FC.sensitivity_edit_callback);
springconstant_edit = uicontrol('Parent', grid,...
    'Style', 'edit',...
    'String', num2str(springconstant),...
    'UserData', num2str(springconstant),...
    'Callback', @HelperFcn.MenuFunctions.CalibrateCurvesSubmenu.JPK_NW_I_FC.springconstant_edit_callback);

grid.Spacing = 5;
grid.Widths = [-2 -1];
grid.Heights = [20 20];
grid.Visible = 'on';

mainHandles.settings.sensitivity_edit = sensitivity_edit;
mainHandles.settings.springconstant_edit = springconstant_edit;

% update mainDialog with mianHandles
guidata(mainHandles.mainDialog, mainHandles);

end % JPK_NW_I_FC