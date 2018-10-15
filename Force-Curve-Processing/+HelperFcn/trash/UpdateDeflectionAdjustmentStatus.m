function handles = UpdateDeflectionAdjustmentStatus(handles)
%UPDATEDEFLECTIONADJUSTMENTSTATUS checks if imported afm-curves are adjusted for Cantilever Deflection and
% updates the curveprops.DelfectoinAdjusted-property accordingly

if isempty(handles.curveprops.DynamicProps)
    return
else
    elements = fieldnames(handles.curveprops.DynamicProps);
end

deflection_corrected = false(length(elements), 1);
% curvename = handles.guiprops.Features.edit_curve_table.UserData.CurrentCurveName;
for i = 1:length(elements) % go through everey curves
    segments = fieldnames(handles.curveprops.(elements{i}).RawData.SpecialInformation);
    segment_deflection_corrected = false(length(segments), 1);
    for n = 1:length(segments) % go through every segment
        info = handles.curveprops.(elements{i}).RawData.SpecialInformation.(segments{i});
        if any(ismember('N', info.units))
            corrected = true;
        else
            corrected = false;
        end
        segment_deflection_corrected(n) = corrected;
    end
    deflection_corrected(i) = any(segment_deflection_corrected);
end

% test if an afm-curve has all its segments calibrated
if any(~deflection_corrected)
    handles.curveprops.DeflectionAdjusted = false;
else
    handles.curveprops.DeflectionAdjusted = true;
end
guidata(handles.figure1, handles);