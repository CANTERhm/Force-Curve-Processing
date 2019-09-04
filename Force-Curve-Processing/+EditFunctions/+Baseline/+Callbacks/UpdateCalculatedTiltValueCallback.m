function UpdateCalculatedTiltValueCallback(src, evt, tilt_value_handle, tilt_property)
% UPDATECALCULATEDTILTVALUE update the results tilt value of the EditFunction: Baseline

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    % abort if gui should not be displayed
    if ~handles.procedure.Baseline.OnGui
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    value_label = handles.procedure.Baseline.function_properties.gui_elements.(tilt_value_handle);
    value = handles.curveprops.(curvename).Results.Baseline.(tilt_property);
    
    %% update label
    value_label.String = num2str(value);
    
    %% update handles-struct
    handles.procedure.Baseline.function_properties.gui_elements.(tilt_value_handle) = value_label;
    guidata(handles.figure1, handles);
end

