function handles = CreateGuiElements(handles)
% CREATEGUIELEMENTS create all elements for the user interface used for the
% Editfunction: Contact Point

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if table is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    panel = handles.guiprops.Panels.results_panel;
    
    % clear results_panel
    delete(allchild(panel));
    
    %% setup main_vbox for input and results parameters for Baseline
    scrolling_panel = uix.ScrollingPanel('Parent', panel);
    main_vbox = uix.VBox('Parent', scrolling_panel,...
        'Padding', 5,...
        'Visible', 'off');
    
    %% settings elements: parent
    
    results_vbox = uix.VBox('Parent', main_vbox,...
        'Spacing', 5,...
        'Tag', 'tss_results_vbox');
    results_panel = uix.Panel('Parent', results_vbox,...
        'Title', 'Settings',...
        'Padding', 5,...
        'Tag', 'results_panel');

    %% calibration values elements: sensitivity + springconstant
    
    cp_offset = handles.curveprops.(curvename).Results.ContactPoint.offset;
    
    results_grid = uix.Grid('Parent', results_panel,...
        'Spacing', 5);
    
    offset_label = uicontrol('Parent', results_grid,...
        'Style', 'text',...
        'String', 'Offset:',...
        'HorizontalAlignment', 'right',...
        'Tag', 'cp_offset_label');
    
    offset_value = uicontrol('Parent', results_grid,...
        'Style', 'edit',...
        'Value', cp_offset,...
        'String', num2str(cp_offset),...
        'Tag', 'cp_offset_value',...
        'Callback', @EditFunctions.ContactPoint.Callbacks.OffsetValueCallback);
    
    offset_unit = uicontrol('Parent', results_grid,...
        'Style', 'text',...
        'String', 'm',...
        'HorizontalAlignment', 'left',...
        'Tag', 'cp_offset_unit');
    
    results_grid.Heights = -1;
    results_grid.Widths = [-1 -1 -1];
    
    handles.procedure.ContactPoint.function_properties.gui_elements.offset_label = offset_label;
    handles.procedure.ContactPoint.function_properties.gui_elements.offset_value = offset_value;
    handles.procedure.ContactPoint.function_properties.gui_elements.offset_unit = offset_unit;
    
    %% positional settigs for panels
    
    results_vbox.Heights = 45;
    main_vbox.Heights = -1;
    scrolling_panel.Heights = 100;

    % make layout visible
    main_vbox.Visible = 'on';

end

