function OffsetValueChangedCallback(src, evt)
% OFFSETTILTVALUECHANGEDCALLBACK updates the correction_type property
% according to the the offset_radio_btn value
    
    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    offset_tilt = handles.curveprops.(curvename).Results.Baseline.gui_elements.setting_offset_tilt_radio_btn;
    
    %% toggle like behavior of radio buttons
    if src.Value == 0
        offset_tilt.Value = 1;
        handles.curveprops.(curvename).Results.Baseline.correction_type = 2;
    else
        offset_tilt.Value = 0;
        handles.curveprops.(curvename).Results.Baseline.correction_type = 1;
    end
    
    %% update handles-struct
    guidata(handles.figure1, handles);
end

