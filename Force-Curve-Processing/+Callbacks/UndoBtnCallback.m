function UndoBtnCallback(src, evt, handles)
%UNDOBTNCALLBACK Callback to Undo-Button on FCP-Gui

table = handles.guiprops.Features.edit_curve_table;

% return if curve_edit_table is empty
if isempty(table.Data)
    return
end

% get current row and current curve name from edit_curve_table
row = handles.guiprops.Features.edit_curve_table.UserData.CurrentRowIndex;
curvename = handles.guiprops.Features.edit_curve_table.Data{row, 1};

% update Status
handles.curveprops.(curvename).Results.Status = 'unprocessed';

% set the next row to current row and update CurrentCurveName
row = row - 1;
if row >= 1
    curvename = table.Data{row, 1};
    table.UserData.CurrentCurveName = curvename;
    table.UserData.CurrentRowIndex = row;
end
handles.guiprops.Features.edit_curve_table = table;

% update handles-struct
guidata(handles.figure1, handles);
