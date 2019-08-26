function OffsetValueChangedCallback(src, evt, other_btn, property)
% OFFSETTILTVALUECHANGEDCALLBACK updates the correction_type property
% according to the the offset_radio_btn values (offset_btn 1 and 2)
    
    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    
    %% toggle behavior
    HelperFcn.SwitchToggleState(src, other_btn);
    
    %% change property value according to button value
    if src.Value == 0
%         other_btn.Value = 1;
        handles.curveprops.(curvename).Results.Baseline.(property) = 1;
    else
%         other_btn.Value = 0;
        handles.curveprops.(curvename).Results.Baseline.(property) = 2;
    end
    
    %% update handles-struct
    guidata(handles.figure1, handles);
end

