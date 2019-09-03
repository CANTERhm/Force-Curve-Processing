function handles = UpdateGuiElements(handles)
% UPDATEGUIELEMENTS updates gui-elements of EditFunction: ContactPoint

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    offset_value = handles.curveprops.(curvename).Results.ContactPoint.offset;
    offset_value_handle = handles.procedure.ContactPoint.function_properties.gui_elements.offset_value;
    
    %% update gui element
    offset_value_handle.String = num2str(offset_value);
    offset_value_handle.Value = offset_value;
end

