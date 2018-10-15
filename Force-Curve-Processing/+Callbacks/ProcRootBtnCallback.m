function ProcRootBtnCallback(src, evt)
%PROCROOTBTNCALLBACK Callback for proc_root_btn

% behavior for Togglebuttons
HelperFcn.SwitchToggleState(src);

% get a reference to handles struct
figure1 = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
handles = guidata(figure1);

% clear results panel 
delete(allchild(handles.guiprops.Panels.results_panel))

% update handles-struct
guidata(handles.figure1, handles);