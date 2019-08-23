function handles = UpdateGuiElements(handles)
% UPDATEGUIELEMENTS Updates all gui-elements, if they have been created and
% the next curve has been chosen

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    
    %% update settings elements: force vs. distance --> offset + tilt
    correction_type = handles.curveprops.(curvename).Results.Baseline.correction_type;
    offset_tilt_btn = handles.procedure.Baseline.function_properties.gui_elements.setting_offset_tilt_radio_btn;
    offset_btn = handles.procedure.Baseline.function_properties.gui_elements.setting_offset_radio_btn;
    
    switch correction_type
        case 1
            offset_tilt_btn.Value = 1;
            offset_btn.Value = 0;
        case 2
            offset_tilt_btn.Value = 0;
            offset_btn.Value = 1;
    end
    
    %% update settings elements: force vs. distance --> baseline range
    selection_borders = handles.curveprops.(curvename).Results.Baseline.selection_borders;
    left_border = handles.procedure.Baseline.function_properties.gui_elements.setting_left_border;
    right_border = handles.procedure.Baseline.function_properties.gui_elements.setting_right_border;
    
    left_border.Value = selection_borders(1);
    left_border.String = num2str(selection_borders(1));
    right_border.Value = selection_borders(2);
    right_border.String = num2str(selection_borders(2));
    
    %% update settings elements: force vs. distance --> curve settings
    parts_dropdown = handles.procedure.Baseline.function_properties.gui_elements.setting_parts_dropdown;
    segments_dropdown = handles.procedure.Baseline.function_properties.gui_elements.setting_segments_dropdown;
    parts_idx = handles.curveprops.(curvename).Results.Baseline.curve_parts_index;
    segments_idx = handles.curveprops.(curvename).Results.Baseline.curve_segments_index;
    
    parts_dropdown.Value = parts_idx;
    segments_dropdown.Value = segments_idx;
    
    %% update settings elements: force vs. time --> offset + tilt
    correction_type = handles.curveprops.(curvename).Results.Baseline.correction_type_2;
    offset_tilt_btn = handles.procedure.Baseline.function_properties.gui_elements.setting_offset_tilt_radio_btn_2;
    offset_btn = handles.procedure.Baseline.function_properties.gui_elements.setting_offset_radio_btn_2;
    
    switch correction_type
        case 1
            offset_tilt_btn.Value = 1;
            offset_btn.Value = 0;
        case 2
            offset_tilt_btn.Value = 0;
            offset_btn.Value = 1;
    end
    
    %% update settings elements: force vs. time --> baseline range
    selection_borders = handles.curveprops.(curvename).Results.Baseline.selection_borders_2;
    left_border = handles.procedure.Baseline.function_properties.gui_elements.setting_left_border_2;
    right_border = handles.procedure.Baseline.function_properties.gui_elements.setting_right_border_2;
    
    left_border.Value = selection_borders(1);
    left_border.String = num2str(selection_borders(1));
    right_border.Value = selection_borders(2);
    right_border.String = num2str(selection_borders(2));
    
    %% update settings elements: force vs. time --> curve settings
    parts_dropdown = handles.procedure.Baseline.function_properties.gui_elements.setting_parts_dropdown_2;
    segments_dropdown = handles.procedure.Baseline.function_properties.gui_elements.setting_segments_dropdown_2;
    parts_idx = handles.curveprops.(curvename).Results.Baseline.curve_parts_index_2;
    segments_idx = handles.curveprops.(curvename).Results.Baseline.curve_segments_index_2;
    
    parts_dropdown.Value = parts_idx;
    segments_dropdown.Value = segments_idx;
    
    %% update results elements: force vs. distance --> offset + tilt
    offset = handles.procedure.Baseline.function_properties.gui_elements.results_offset_value;
    tilt = handles.procedure.Baseline.function_properties.gui_elements.results_tilt_value;
    offset_value = handles.curveprops.(curvename).Results.Baseline.offset;
    tilt_value = handles.curveprops.(curvename).Results.Baseline.slope;
    
    offset.String = num2str(offset_value);
    tilt.String = num2str(tilt_value);
    
    %% update results elements: force vs. time --> offset + tilt
    offset = handles.procedure.Baseline.function_properties.gui_elements.results_offset_value_2;
    tilt = handles.procedure.Baseline.function_properties.gui_elements.results_tilt_value_2;
    offset_value = handles.curveprops.(curvename).Results.Baseline.offset_2;
    tilt_value = handles.curveprops.(curvename).Results.Baseline.slope_2;
    
    offset.String = num2str(offset_value);
    tilt.String = num2str(tilt_value);
    
end

