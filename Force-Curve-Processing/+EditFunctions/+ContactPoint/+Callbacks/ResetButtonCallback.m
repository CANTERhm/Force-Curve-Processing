function ResetButtonCallback(src, evt)
% RESETBUTTONCALLBACK reset elements of EditFunction: ContactPoint
%   
%   reset means: 
%       - offfset = 0
%       - calculated_data = baseline.calculated_data (the previous EditFunction)

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    cp_results = handles.curveprops.(curvename).Results.ContactPoint;
    bl_results = handles.curveprops.(curvename).Results.Baseline;
    offset_value_handle = handles.procedure.ContactPoint.function_properties.gui_elements.offset_value;
    
    %% reset elements
    cp_results.offset = 0;
    cp_results.calculated_data = bl_results.calculated_data;
    offset_value_handle.String = '0';
    offset_value_handle.Value = 0;
    
    %% update graphical representation
    EditFunctions.ContactPoint.Callbacks.UpdateGraphicalRepresentation([], []);
    
    %% update handles-struct
    handles.curveprops.(curvename).Results.ContactPoint = cp_results;
    guidata(handles.figure1, handles);
end

