function UpdateBorderElementsCallback(src, evt)
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
    
    %% update Elements
    baseline_properties.gui_elements.setting_left_border.String = num2str(baseline_results.selection_borders(1));
    baseline_properties.gui_elements.setting_right_border.String = num2str(baseline_results.selection_borders(2));
    baseline_properties.gui_elements.setting_left_border.Value = baseline_results.selection_borders(1);
    baseline_properties.gui_elements.setting_right_border.Value = baseline_results.selection_borders(2);
    
    handles = EditFunctions.Baseline.AuxillaryFcn.UpdateBorderRepresentation(handles);
    
    %% update handles-struct
    handles.procedure.Baseline.function_properties = baseline_properties;
    guidata(handles.figure1, handles);
end

