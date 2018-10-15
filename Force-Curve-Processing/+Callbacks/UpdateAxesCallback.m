function UpdateAxesCallback(src, evt, handles)
% UPDATEAXESCALLBACK Updates handles.guiprops.MainAxes, if any popup-value
% from general_settings_panel changes.
% connected: uicontrol CallbackFcn

curvename = handles.guiprops.Features.edit_curve_table.UserData.CurrentCurveName;
xch_idx = handles.guiprops.Features.curve_xchannel_popup.Value;
ych_idx = handles.guiprops.Features.curve_ychannel_popup.Value;

[LineData, handles] = UtilityFcn.ExtractPlotData(handles.curveprops.(curvename).RawData,...
    handles,...
    xch_idx,...
    ych_idx);

handles = IOData.PlotData(LineData, handles);

guidata(handles.figure1, handles);