function UpdateAxesCallback(src, evt, handles)
% UPDATEAXESCALLBACK Updates handles.guiprops.MainAxes, if any popup-value
% from general_settings_panel changes.
% connected: uicontrol CallbackFcn

% update MainAxes
curvename = handles.guiprops.Features.edit_curve_table.UserData.CurrentCurveName;
xch_idx = handles.guiprops.Features.curve_xchannel_popup.Value;
ych_idx = handles.guiprops.Features.curve_ychannel_popup.Value;

[LineData, handles] = UtilityFcn.ExtractPlotData(handles.curveprops.(curvename).RawData,...
    handles,...
    xch_idx,...
    ych_idx);

handles = IOData.PlotData(LineData, handles);

% update EditFunctions
editBtns = allchild(handles.guiprops.Panels.processing_panel);
mask = false(length(editBtns),1);
for i = 1:length(mask)
    if editBtns(i).Value == 1
        mask(i) = 1;
    end
end
editBtn = editBtns(mask);
if ~isempty(editBtn)
    active_edit_button = editBtn.Tag;
else
    active_edit_button = DefaultValues.active_edit_button;
    handles.guiprops.Features.proc_root_btn.Value = 1;
end
if ~strcmp(active_edit_button, 'procedure_root_btn')
    EditFunctions.(active_edit_button).(active_edit_button)(handles);
end

guidata(handles.figure1, handles);