function ClearAllCurvesBtnCallback(src, evt, handles)
%CLEARALLCURVESCALLBACK Delete all loaded Curves

% if any curve havn't been saved yet, ask to do so
if ~handles.curveprops.Saved
    answer = questdlg('Save Results Before?', 'Results not saved',...
        'Yes', 'No',...
        'Yes');
    switch answer
        case 'Yes'
            % if yes save curves an change curveprops.Saved property back
            % to false
            Callbacks.CompleteProcessingBtnCallback(src, evt, handles)
        case 'No'
            % do nothing
    end
end

if ~isempty(handles.curveprops.DynamicProps)
    list = fieldnames(handles.curveprops.DynamicProps);
    for i = 1:length(list)
        handles.curveprops.delproperty(list{i});
    end
end

% reset MainFigure
close(handles.guiprops.MainFigure);
handles.guiprops.MainFigure = [];
handles.guiprops.MainAxes = [];
handles = UtilityFcn.SetupMainFigure(handles);

% empty popup-menu UserData.HasDefaultValue-property, to reset it if a new
% bunch of curves get loaded
handles.guiprops.Features.curve_xchannel_popup.UserData.HasDefaultValue = 0;
handles.guiprops.Features.curve_ychannel_popup.UserData.HasDefaultValue = 0;

% update calibration status
handles.curveprops.Calibrated = false;

% update curveprops.Saved property
handles.curveprops.Saved = false;

% update Deflection Adjustment status
handles.curveprops.DeflectionAdjusted = false;

% update prcessing information labels
handles = HelperFcn.UpdateProcInformationLabels(handles);

% update handles-structure
handles.guiprops.Features.curve_segments_popup.String = 'no segments...';
handles.guiprops.Features.curve_segments_popup.Value = 1;
handles.guiprops.Features.curve_xchannel_popup.String = 'no xchannels...';
handles.guiprops.Features.curve_xchannel_popup.Value = 1;
handles.guiprops.Features.curve_ychannel_popup.String = 'no ychannels...';
handles.guiprops.Features.curve_ychannel_popup.Value = 1;
handles.guiprops.Features.edit_curve_table.UserData = [];
handles.guiprops.FilePathObject.files = [];
handles.curveprops.DynamicProps = [];
handles.curveprops.CalibrationValues.SpringConstant = [];
handles.curveprops.CalibrationValues.Sensitivity = [];
guidata(handles.figure1, handles);
