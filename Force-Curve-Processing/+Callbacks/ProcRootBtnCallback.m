function ProcRootBtnCallback(src, evt)
%PROCROOTBTNCALLBACK Callback for proc_root_btn

% behavior for Togglebuttons
HelperFcn.SwitchToggleState(src);

% get a reference to handles struct
figure1 = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
handles = guidata(figure1);

% clear results panel 
delete(allchild(handles.guiprops.Panels.results_panel))

% clear FCP Graph Window from previouse editing artefacts
ax = findobj(handles.guiprops.MainFigure, 'Type', 'Axes');
cla(ax);
handles = UtilityFcn.SetupMainFigure(handles);
    
% plot afm-graph again
table = handles.guiprops.Features.edit_curve_table;
xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
curvename = table.UserData.CurrentCurveName;
RawData = handles.curveprops.(curvename).RawData;

curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel,...
    'edit_button', 'procedure_root_btn');

handles = IOData.PlotData(curvedata, handles);

% update handles-struct
guidata(handles.figure1, handles);