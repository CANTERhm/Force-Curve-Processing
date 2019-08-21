function UpdateCalculatedOffsetValueCallback(src, evt, offset_value_handle, offset_property)
% UPDATECALCULATEDOFFSETVALUE update the results offset value of the
% baseline editfunction

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    value_label = handles.procedure.Baseline.function_properties.gui_elements.(offset_value_handle);
    value = handles.curveprops.(curvename).Results.Baseline.(offset_property);
    
    %% update label
    value_label.String = num2str(value);
    
    %% update handles-struct
    handles.procedure.Baseline.function_properties.gui_elements.(offset_value_handles) = value_label;
    guidata(handles.figure1, handles);

end

