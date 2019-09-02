function handles = CreateGuiElements(handles)
% CREATEGUIELEMENTS create all elements for the user interface used for the
% Editfunction: Tip Sample Seperation

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if table is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    panel = handles.guiprops.Panels.results_panel;
    curvename = table.UserData.CurrentCurveName;
    
    % clear results_panel
    delete(allchild(panel));
    
    %% setup main_vbox for input and results parameters for Baseline
    scrolling_panel = uix.ScrollingPanel('Parent', panel);
    main_vbox = uix.VBox('Parent', scrolling_panel,...
        'Padding', 5,...
        'Visible', 'off');
    
    %% calibration values elements: parent
    
    results_vbox = uix.VBox('Parent', main_vbox,...
        'Spacing', 5,...
        'Tag', 'tss_results_vbox');
    results_panel = uix.Panel('Parent', results_vbox,...
        'Title', 'Calibration Values',...
        'Padding', 5,...
        'Tag', 'tss_results_panel');
    results_panel_2 = uix.Panel('Parent', results_vbox,...
        'Title', 'Calculation Status',...
        'Padding', 5,...
        'Tag', 'tss_results_panel_2');
    
    results_panel_3 = uix.Panel('Parent', results_vbox,...
        'Title', 'Comment',...
        'Padding', 5,...
        'Tag', 'tss_results_panel_2');
    
    %% calibration values elements: sensitivity + springconstant
    
    sensitivity = handles.curveprops.CalibrationValues.Sensitivity;
    spring_constant = handles.curveprops.CalibrationValues.SpringConstant;
    
    results_grid = uix.Grid('Parent', results_panel,...
        'Spacing', 5);
    
    sensitivity_label = uicontrol('Parent', results_grid,...
        'Style', 'text',...
        'String', 'Sensitivity:',...
        'HorizontalAlignment', 'right',...
        'Tag', 'tss_sensitivity_label'); 
    
    spring_constant_label = uicontrol('Parent', results_grid,...
        'Style', 'text',...
        'String', 'Spring Constant:',...
        'HorizontalAlignment', 'right',...
        'Tag', 'tss_spring_constant_label');
    
    sensitivity_value = uicontrol('Parent', results_grid,...
        'Style', 'text',...
        'String', num2str(sensitivity),...
        'HorizontalAlignment', 'center',...
        'Tag', 'tss_sensitivity_value');
    
    spring_constant_value = uicontrol('Parent', results_grid,...
        'Style', 'text',...
        'String', num2str(spring_constant),...
        'HorizontalAlignment', 'center',...
        'Tag', 'tss_spring_constant_value');
    
    sensitivity_unit = uicontrol('Parent', results_grid,...
        'Style', 'text',...
        'String', 'N/V',...
        'HorizontalAlignment', 'left',...
        'Tag', 'tss_sensitivity_unit');
    
    spring_constant_unit = uicontrol('Parent', results_grid,...
        'Style', 'text',...
        'String', 'N/m',...
        'HorizontalAlignment', 'left',...
        'Tag', 'tss_spring_constant_unit');
    
    results_grid.Heights = [-1 -1];
    results_grid.Widths = [-1 -1 -1];
    
    handles.procedure.TipSampleSeperation.function_properties.gui_elements.sensitivity_label = sensitivity_label;
    handles.procedure.TipSampleSeperation.function_properties.gui_elements.spring_constant_label = spring_constant_label;
    handles.procedure.TipSampleSeperation.function_properties.gui_elements.sensitivity_value = sensitivity_value;
    handles.procedure.TipSampleSeperation.function_properties.gui_elements.spring_constant_value = spring_constant_value;
    handles.procedure.TipSampleSeperation.function_properties.gui_elements.sensitivity_unit = sensitivity_unit;
    handles.procedure.TipSampleSeperation.function_properties.gui_elements.spring_constant_unit = spring_constant_unit;
    
    %% calibration values elements: calibration status
    results_grid_2 = uix.Grid('Parent', results_panel_2,...
        'Padding', 5);
    
    status_label = uicontrol('Parent', results_grid_2,...
        'Style', 'text',...
        'String', 'Tip Sample Seperation calculated:',...
        'HorizontalAlignment', 'left',...
        'Tag', 'tss_status_label');
    
    calculation_status = uicontrol('Parent', results_grid_2,...
        'Style', 'text',...
        'String', '',...
        'BackgroundColor', 'red',...
        'HorizontalAlignment', 'left',...
        'Tag', 'tss_calculation_status');
    
    results_grid_2.Heights = 20;
    results_grid_2.Widths = [-1 20];
    
    handles.procedure.TipSampleSeperation.function_properties.gui_elements.status_label = status_label;
    handles.procedure.TipSampleSeperation.function_properties.gui_elements.calculation_status = calculation_status;
    
    %% Notifications
    results_grid_3 = uix.Grid('Parent', results_panel_3,...
        'Padding', 5);
    
    notification = uicontrol('Parent', results_grid_3,...
        'Style', 'text',...
        'String', '',...
        'HorizontalAlignment', 'left',...
        'Tag', 'tss_notification');
    
    results_grid_3.Heights = -1;
    results_grid_3.Widths = -1;
    
    handles.procedure.TipSampleSeperation.function_properties.gui_elements.notification = notification;
    
    %% positional settigs for panels
    
    results_vbox.Heights = [-2 -1 -1];
    main_vbox.Heights = -1;
    scrolling_panel.Heights = 300;

    % make layout visible
    main_vbox.Visible = 'on';

end

