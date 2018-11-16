function UpdateBorderEditsCallback(src, evt)
% Callback to react on changes of selection_borders-property

% refresh results object
main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
handles = guidata(main);
table = handles.guiprops.Features.edit_curve_table;
curvename = table.UserData.CurrentCurveName;
if isprop(handles.curveprops.(curvename).Results, 'Baseline')
    results = handles.curveprops.(curvename).Results.Baseline;
end
% results = getappdata(handles.figure1, 'Baseline');

left_border = results.input_features.left_border;
right_border = results.input_features.right_border;
left_border.String = num2str(results.selection_borders(1));
right_border.String = num2str(results.selection_borders(2));

% refresh results object and handles
% setappdata(handles.figure1, 'Baseline', results);
handles.curveprops.(curvename).Results.Baseline = results;
guidata(handles.figure1, handles);

% trigger update to handles.curveprops.curvename.Results.Baseline
results.FireEvent('UpdateObject');

