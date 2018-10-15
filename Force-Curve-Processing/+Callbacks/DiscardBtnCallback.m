function DiscardBtnCallback(src, evt, handles)
%DISCARDBTNCALLBACK Callback for Discard-Button on FCProssesing-Gui

table = handles.guiprops.Features.edit_curve_table;
sz = size(table.Data);
table_length = sz(1);

% return if curve_edit_table is empty
if isempty(table.Data)
    return
end

% get current row and current curve name from edit_curve_table
row = table.UserData.CurrentRowIndex;
curvename = table.Data{row, 1};

% update Status
handles.curveprops.(curvename).Results.Status = 'discarded';

% set the next row to current row and update CurrentCurveName
row = row + 1;
if row <= table_length
    curvename = table.Data{row, 1};
    table.UserData.CurrentCurveName = curvename;
    table.UserData.CurrentRowIndex = row;
end

% update handles-struct
handles.guiprops.Features.edit_curve_table = table;
guidata(handles.figure1, handles);