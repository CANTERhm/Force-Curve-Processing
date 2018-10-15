function WindowResizeCallback(src, evt)
%TABLERESIZECALLBACK Executes if FCP-App size changes

handles = guidata(src);

% Resize handles.guiprops.Features.edit_curve_table columns
table = handles.guiprops.Features.edit_curve_table;
UtilityFcn.CalculateColumnWidth(table, [0.75 0.25]);
handles.guiprops.Features.edit_curve_table = table;

% update handles structure
guidata(handles.figure1, handles)


