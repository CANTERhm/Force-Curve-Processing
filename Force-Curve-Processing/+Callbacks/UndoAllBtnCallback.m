function UndoAllBtnCallback(src, evt, handles)
%UNDOALLBTNCALLBACK  Callback to Undo-all-Button on FCP-Gui

table = handles.guiprops.Features.edit_curve_table;

% return if curve_edit_table is empty
if isempty(table.Data)
    return
end

% keep and apply to all procedure
row_span = table.UserData.CurrentRowSpan;
multi_row_selection = row_span(1)-row_span(2);
sz = size(table.Data);
table_length = sz(1);

% if only one line is selected
if multi_row_selection == 0
    start = table_length;
    stop = 1;
else
    if multi_row_selection < 0
        start = row_span(2);
        stop = row_span(1);
    else
        start = row_span(1);
        stop = row_span(2);
    end
end

for i = start:-1:stop
    curvename = table.Data{i, 1};

    % update Status (prior to updating the Status-property, we have to make
    % sure, that CurrentCurveName and CurrentRowIndex is actual)
    table.UserData.CurrentCurveName = curvename;
    table.UserData.CurrentRowIndex = i;
    handles.curveprops.(curvename).Results.Status = 'unprocessed';
end

% update handles-struct
handles.guiprops.Features.edit_curve_table = table;
guidata(handles.figure1, handles);

