function UpdateBorderElementsCallback(src, evt, part_index_name, segment_index_name, xchannel_name, ychannel_name, selection_borders_name)
% UPDATEBORDERELEMENTSCALLBACK update all border-elements based on the
% results-object-property: selection_borders

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    baseline_results = handles.curveprops.(curvename).Results.Baseline;
    baseline_properties = handles.procedure.Baseline.function_properties;
    selection_borders = baseline_results.(selection_borders_name);
    switch selection_borders_name
        case 'selection_borders'
            left_border = baseline_properties.gui_elements.setting_left_border;
            right_border = baseline_properties.gui_elements.setting_right_border;
        case 'selection_borders_2'
            left_border = baseline_properties.gui_elements.setting_left_border_2;
            right_border = baseline_properties.gui_elements.setting_right_border_2;
    end
    
    %% update Elements
    left_border.String = num2str(selection_borders(1));
    right_border.String = num2str(selection_borders(2));
    left_border.Value = selection_borders(1);
    right_border.Value = selection_borders(2);
    
    handles = EditFunctions.Baseline.AuxillaryFcn.UpdateBorderRepresentation(handles, part_index_name, segment_index_name, xchannel_name, ychannel_name, selection_borders_name);
    
    %% update handles-struct
    handles.procedure.Baseline.function_properties = baseline_properties;
    guidata(handles.figure1, handles);
end

