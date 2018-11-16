function EditProcBtnCallback(src, evt, handles)
%EDITPROCBTNCALLBACK Callback for buttons on edit procedure list

% behavior for Togglebuttons
HelperFcn.SwitchToggleState(src);

%% execute edit function
name = src.Tag;
EditFunctions.(name).(name)();
