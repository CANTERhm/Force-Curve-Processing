function EditProcBtnCallback(src, evt, handles)
%EDITPROCBTNCALLBACK Callback for buttons on edit procedure list

% behavior for Togglebuttons
HelperFcn.SwitchToggleState(src);

%% execute edit function
name = src.Tag;
UtilityFcn.ResetMainFigureCallbacks();
EditFunctions.(name).main();
