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
    other_toggle_btn = handles.procedure.Baseline.function_properties.gui_elements.settings_select_range_btn;
    
    %% toggle state behavior
    HelperFcn.SwitchToggleState(src, other_toggle_btn)
end

