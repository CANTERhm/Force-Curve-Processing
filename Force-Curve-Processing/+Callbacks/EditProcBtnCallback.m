function EditProcBtnCallback(src, evt, handles)
%EDITPROCBTNCALLBACK Callback for buttons on edit procedure list

% behavior for Togglebuttons
HelperFcn.SwitchToggleState(src);

%% execute edit function
name = src.Tag;
EditFunctions.(name).(name)(handles);

%% plot data for explicit edit button

% [LineData, handles] = UtilityFcn.ExtractPlotData(, handles);

% update handles-sturct
guidata(handles.figure1, handles);