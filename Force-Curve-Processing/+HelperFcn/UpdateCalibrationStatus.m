function handles = UpdateCalibrationStatus(handles)
% UPDATECALIBRATIONSTATUS checks if imported afm-curves es calibrated and
% updates the curveprops.Calibrated-property accordingly

% Abort if no curves are loaded
if isempty(handles.curveprops.DynamicProps)
    return
else
    elements = fieldnames(handles.curveprops.DynamicProps);
end

springConstant = false(length(elements), 1);
sensitivity = false(length(elements), 1);
% curvename = handles.guiprops.Features.edit_curve_table.UserData.CurrentCurveName;
for i = 1:length(elements) % go through everey curves
    
    try
        segments = fieldnames(handles.curveprops.(elements{i}).RawData.SpecialInformation);
    catch ME % if you can
        switch ME.identifier
            case 'MATLAB:fieldnames:InvalidInput' % Specialifnormation is empty --> no specialinformation has been found
                return
            otherwise
                rethrow(ME);
        end
    end
    
    segment_springConstant = false(length(segments), 1);
    segment_sensitivity = false(length(segments), 1);
    for n = 1:length(segments) % go through every segment
        info = handles.curveprops.(elements{i}).RawData.SpecialInformation.(segments{n});
        if ~isempty(info.springConstant) %&& any(ismember(info.units, 'N'))
            springconst = true;
        else
            springconst = false;
        end
        if ~isempty(info.sensitivity) %&& any(ismember(info.units, 'N'))
            sensi = true;
        else
            sensi = false;
        end
        segment_springConstant(n) = springconst;
        segment_sensitivity(n) = sensi;
    end
    springConstant(i) = any(segment_springConstant);
    sensitivity(i) = any(segment_sensitivity);
end

% test if an afm-curve has all its segments calibrated
if any(~springConstant) || any(~sensitivity)
    handles.curveprops.Calibrated = false;
else
    handles.curveprops.Calibrated = true;
end
guidata(handles.figure1, handles);
