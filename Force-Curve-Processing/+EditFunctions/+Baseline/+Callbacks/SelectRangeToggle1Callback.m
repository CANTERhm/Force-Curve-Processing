function SelectRangeToggle1Callback(src, evt)
% SELECTRANGETOGGLE1CALLBACK prepare baseline editfunction to determine
% selection_borders in the "force-vs-distance" mode

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    other_toggle_btn = handles.procedure.Baseline.function_properties.gui_elements.settings_select_range_btn_2;
    xchannel_dropdown = handles.guiprops.Features.curve_xchannel_popup;
    ychannel_dropdown = handles.guiprops.Features.curve_ychannel_popup;
    
    %% toggle state behavior
    HelperFcn.SwitchToggleState(src, other_toggle_btn)
    
    %% Select Range behavior
    
    % abort, if togglebutton has not been pressed
    if src.Value == 0
        return
    end
    
    % update the baseline range representation
    % input: handles, part_index_name, segment_index_name, xchannel_name, ychannel_name, selection_borders_name
    handles = EditFunctions.Baseline.AuxillaryFcn.UpdateBorderRepresentation(handles, 'curve_parts_index',...
        'curve_segments_index', 'measuredHeight', 'vDeflection', 'selection_borders');

    % switch channels to vDeflection vs. measuredHeight
    % and update fcp´s xchannel and ychannel dropdown menus
    x_idx = find(ismember(xchannel_dropdown.String, 'measuredHeight'));
    y_idx = find(ismember(ychannel_dropdown.String, 'vDeflection'));
    xchannel_dropdown.Value = x_idx;
    ychannel_dropdown.Value = y_idx;
    EditFunctions.Baseline.main();
    handles = EditFunctions.Baseline.AuxillaryFcn.UpdateBorderRepresentation(handles,...
        'curve_parts_index',...
        'curve_segments_index',...
        'measuredHeight',...
        'vDeflection',...
        'selection_borders');
    
    % set WindowButtonCallbacks in MainFigure to prepare the
    % MainFigure for the baselinerange selection
    UtilityFcn.ResetMainFigureCallbacks();
    handles = EditFunctions.Baseline.AuxillaryFcn.SetWindowButtonCallbacks(handles,...
        'setting_parts_dropdown',...
        'setting_segments_dropdown',...
        'selection_borders');
    
    %% update handles-struct
    guidata(handles.figure1, handles);
end

