function UpdateProcessingCurveStatusCallback(src, evt, handles)
%UPDATEPROCESSINGCURVESTATUSCALLBACK changes the curve status in table data
%according to the status of handles.curveprops.curvename.Results.Status-property

% get handles to specific gui elements
table = handles.guiprops.Features.edit_curve_table;

% obtain element specific data
curvename = table.UserData.CurrentCurveName;
row = table.UserData.CurrentRowIndex;
stat = handles.curveprops.(curvename).Results.Status;

% update curve status in curve_edit_table
table.Data{row, 2} = stat;

% update processing information labels
handles = HelperFcn.UpdateProcInformationLabels(handles);

% update handle-structure
handles.guiprops.Features.edit_curve_table = table;
guidata(handles.figure1, handles);
