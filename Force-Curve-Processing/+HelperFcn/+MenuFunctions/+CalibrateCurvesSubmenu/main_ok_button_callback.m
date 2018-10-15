function main_ok_button_callback(src, evt)
%MAIN_OK_BUTTON_CALLBACK processes the ok_button-event on
%calibrate-curves-submenu

% obtain mainHandle-struct
main = findobj(allchild(groot), 'Type', 'Figure', 'Name', 'Calibrate Curves');
mainHandles = guidata(main);

% write all customized properties to curveprops.settings
handles = mainHandles.handles;
if isfield(mainHandles.settings, 'values')
    names = fieldnames(mainHandles.settings.values);
else
    names = [];
end

if any(ismember(names, 'sensitivity'))
    handles.curveprops.CalibrationValues.Sensitivity = mainHandles.settings.values.sensitivity;
end
if any(ismember(names, 'springconstant'))
    handles.curveprops.CalibrationValues.SpringConstant = mainHandles.settings.values.springconstant;
end

delete(main)