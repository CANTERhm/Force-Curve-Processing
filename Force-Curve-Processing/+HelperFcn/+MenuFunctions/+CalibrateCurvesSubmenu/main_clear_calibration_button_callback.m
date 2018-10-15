function main_clear_calibration_button_callback(src, evt)
%MAIN_CLEAR_CALIBRATION_BUTTON processes the Clear Calibration-button press
%on FCP-App main-function.

main = findobj(allchild(groot), 'Type', 'Figure', 'Name', 'Calibrate Curves');
mainHandles = guidata(main);

mainHandles.handles.curveprops.Calibrated = false;
mainHandles.handles.curveprops.CalibrationValues.Sensitivity = [];
mainHandles.handles.curveprops.CalibrationValues.SpringConstant = [];
mainHandles.Features.already_calibrated_checkbox.Enable = 'on';
mainHandles.Features.already_calibrated_checkbox.Value = mainHandles.Features.already_calibrated_checkbox.Min;

if isa(mainHandles.settings, 'struct')
    names = fieldnames(mainHandles.settings);
    for i = 1:length(names)
        edit = mainHandles.settings.(names{i});
        edit.String = 'NaN';
    end
end

guidata(main, mainHandles);

end % main_clear_calibration_button

