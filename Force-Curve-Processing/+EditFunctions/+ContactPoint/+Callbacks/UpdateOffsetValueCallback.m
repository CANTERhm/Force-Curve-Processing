function UpdateOffsetValueCallback(src, evt)
% UPDATEOFFSETVALUECALLBACK Update the offset_value of the EditFunction: Contact Point

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    offset_value = handles.curveprops.(curvename).Results.ContactPoint.offset;
    offset_value_handle = handles.procedure.ContactPoint.function_properties.gui_elements.offset_value;
    
    %% update Elements
    offset_value_handle.String = num2str(offset_value);
    offset_value_handle.Value = offset_value;
    
    %% recalculate data
    handles = EditFunctions.ContactPoint.AuxillaryFcn.CalculateData(handles);
    EditFunctions.ContactPoint.Callbacks.UpdateGraphicalRepresentation([], []);
    
    %% update handles-struct
    guidata(handles.figure1, handles);
    
end

