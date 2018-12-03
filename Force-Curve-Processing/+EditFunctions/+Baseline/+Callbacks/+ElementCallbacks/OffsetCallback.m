function OffsetCallback(src, evt, obj_list)
%TILTCALLBACK callback for tilt-checkbox in Baseline-Editfunction

% refresh results object
main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
handles = guidata(main);
results = getappdata(handles.figure1, 'Baseline');

EditFunctions.Baseline.AuxillaryFcn.UserDefined.SwitchCheckboxes(src, obj_list);
if src.Value == 1
    results.correction_type = 1;
else
    results.correction_type = 2;
end

% update results object
setappdata(handles.figure1, 'Baseline', results);
guidata(handles.figure1, handles);

% trigger update to handles.curveprops.curvename.Results.Baseline
results.FireEvent('UpdateObject');

end % TiltCallback

