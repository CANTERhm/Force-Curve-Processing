function main(varargin)
%MAIN initialize activated editfunction
%
%   main-function initializes the whole infrastrukture of the respectively
%   activated editfunction. This Function can also be used as an Callback;
%   source-data and event-data parameters are not used

    %% input parsing
    p = inputParser;
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
    
    %% preparation of variables
    
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'VerticalTipPosition');
    
    % obtain data from curvename, to use it as default values if neccessary
    table = handles.guiprops.Features.edit_curve_table;
    if ~isempty(table.Data)
        curvename = table.UserData.CurrentCurveName;
        if isprop(handles.curveprops.(curvename).Results, 'VerticalTipPosition')
            data = handles.curveprops.(curvename).Results.VerticalTipPosition;
        else
            data = [];
        end
    else
        data = [];
    end
    
    if isempty(results)
        results = Results();
        results.addproperty('userdata');
        results.addproperty('Sensitivity');
        results.addproperty('SpringConstant');
        results.addproperty('calculated_data');
        results.addproperty('settings_xchannel_popup_value');
        results.addproperty('settings_ychannel_popup_value');
        results.addproperty('settings_springconstant_checkbox_value');
        results.addproperty('settings_sensitivity_checkbox_value');
        results.addproperty('calculation_status');
        results.addproperty('singleton');
        if isempty(data)
            loaded_input = handles.procedure.VerticalTipPosition;
            results.userdata = loaded_input.userdata;
            results.Sensitivity = handles.curveprops.CalibrationValues.Sensitivity;
            results.SpringConstant = handles.curveprops.CalibrationValues.SpringConstant;
            results.calculated_data = loaded_input.calculated_data;
            results.calculation_status = loaded_input.calculation_status;
            results.singleton = loaded_input.singleton;
        else
            % use values from data as default
            % the singleton property has to be resettet to false in every
            % execution of main in order to load property listeners for results
            % properly
            results.Status = data.Status;
            results.userdata = data.userdata;
            results.Sensitivity = data.Sensitivity;
            results.SpringConstant = data.SpringConstant;
            results.calculated_data = data.calculated_data;
            results.calculation_status = data.calculation_status;
            results.singleton = false;
            results.settings_xchannel_popup_value = data.settings_xchannel_popup_value;
            results.settings_ychannel_popup_value = data.settings_ychannel_popup_value;
            results.settings_springconstant_checkbox_value = data.settings_springconstant_checkbox_value;
            results.settings_sensitivity_checkbox_value = data.settings_sensitivity_checkbox_value;
        end

        % update appdata if new results-object for Baseline has been created
        setappdata(handles.figure1, 'VerticalTipPosition', results);
    end
    
    container = handles.guiprops.Panels.results_panel;
    button_handle = findobj(allchild(handles.guiprops.Panels.processing_panel),...
        'Type', 'UIControl', 'Tag', 'VerticalTipPosition');
    
    %% determine calculation status
    table = handles.guiprops.Features.edit_curve_table;
    
    % if no curves are loaded
    if isempty(table.Data)
        results.calculation_status = 2;
    end
    
    % curves are not calibrated
    if ~handles.curveprops.Calibrated && ~isempty(table.Data)
        results.calculation_status = 3;
    end
    
    % no baseline correction applied prior to vertical tip position
    % calculation
    edit_functions = allchild(handles.guiprops.Panels.processing_panel);
    to_test = false(length(edit_functions), 1);
    for i = 1:length(to_test)
        if strcmp(edit_functions(i).Tag, 'Baseline')
            to_test(i) = true;
        end
    end
    if ~any(to_test)
        results.calculation_status = 4;
    end
    
    %% operations on Figure and Axes 
    UtilityFcn.RefreshGraph('RefreshAll', false);
    UtilityFcn.ResetMainFigureCallbacks();

    %% gui on/off behavior
    GuiStatus = button_handle.UserData.on_gui.Status;
    switch GuiStatus
        case true
            UtilityFcn.RefreshGraph();
            if ~isprop(results, 'input_elements') && ~isprop(results, 'output_elements')
                SetupGraphicalElements(container);
            end
            if ~results.singleton
                SetupListeners();
                results.singleton = true;
            end
        case false
            if ~results.singleton
                SetupListeners();
                results.singleton = true;
            end
    end
    
    %% show corrected data
    
    % Refresh results
    results = getappdata(handles.figure1, 'VerticalTipPosition');    

    % apply vertical tip position on data
    EditFunctions.VerticalTipPosition.AuxillaryFcn.UserDefined.ApplyVerticalTipPosition();
    
    % refresh graph
    UtilityFcn.RefreshGraph([], [],...
        results.settings_xchannel_popup_value,...
        results.settings_ychannel_popup_value,...
        'EditFunction', 'VerticalTipPosition',...
        'RefreshAll', true);
    
    %% trigger UpdateResultsToMain to update handles.curveprops.curvename.Results.Baseline
    setappdata(handles.figure1, 'VerticalTipPosition', results);
    guidata(handles.figure1, handles);
    results.FireEvent('UpdateObject');
    
    % delete results object if edit function is not active, after all tasks
    % are done 
    if ~GuiStatus
        UtiltiyFcn.DeleteListener('EditFunction', 'VerticalTipPosition');
    end
end % main

function SetupGraphicalElements(container)

    % clear results panel 
    delete(allchild(container));
    
    % main panels
    main_scrolling_panel = uix.ScrollingPanel('Parent', container,...
        'Tag', 'vtp_main_scrolling_panel');
    main_vbox = uix.VBox('Parent', main_scrolling_panel,...
        'Padding', 5,...
        'Tag', 'vtp_main_vbox',...
        'Visible', 'off');
    
    % Settings 
    EditFunctions.VerticalTipPosition.AuxillaryFcn.SetInputElements(main_vbox)
    
    % Results
    EditFunctions.VerticalTipPosition.AuxillaryFcn.SetOutputElements(main_vbox)
    
    % make graphical elements visible
    main_vbox.Visible = 'on';
    
    % panelposition adjustment
    main_vbox.Heights = [-1 -0.6];
    main_scrolling_panel.Heights = 400;
    main_scrolling_panel.Widths = 345;

end % SetupGraphicalElements

function SetupListeners()
    EditFunctions.VerticalTipPosition.AuxillaryFcn.SetPropertyEventListener();
    EditFunctions.VerticalTipPosition.AuxillaryFcn.SetExternalEventListener();
end % SetupListeners