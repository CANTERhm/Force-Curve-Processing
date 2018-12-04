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
        results.addproperty('results_news');
        if isempty(data)
            loaded_input = handles.procedure.VerticalTipPosition;
            results.userdata = loaded_input.userdata;
            results.Sensitivity = loaded_input.Sensitivity;
            results.SpringConstant = loaded_input.SpringConstant;
            results.calculated_data = loaded_input.calculated_data;
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
            results.settings_xchannel_popup_value = data.settings_xchannel_popup_value;
            results.settings_ychannel_popup_value = data.settings_ychannel_popup_value;
        end
        
        if handles.curveprops.Calibrated
            results.results_news = 'good';
        else
            results.results_new = 'bad';
        end

        % update appdata if new results-object for Baseline has been created
        setappdata(handles.figure1, 'VerticalTipPosition', results);
    end
    
    container = handles.guiprops.Panels.results_panel;
    button_handle = findobj(allchild(handles.guiprops.Panels.processing_panel),...
        'Type', 'UIControl', 'Tag', 'VerticalTipPosition');
    
    
    %% operations on Figure and Axes 
    UtilityFcn.RefreshGraph();
    UtilityFcn.ResetMainFigureCallbacks();

    %% Setup Graphical Elements

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

    %% trigger UpdateResultsToMain to update handles.curveprops.curvename.Results.Baseline
    guidata(handles.figure1, handles);
    results.FireEvent('UpdateObject');
end % main