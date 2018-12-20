function main(varargin)
%MAIN initialize activated editfunction
%
%   main-function initializes the whole infrastrukture of the respectively
%   activated editfunction. This Function can also be used as an Callback;
%   source-data and event-data parameters are not used
%
%   ToDo: replace all EditFunction occurances with 
%   activated-editfunction-tags

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
    results = getappdata(handles.figure1, 'ContactPoint');
    
    % obtain data from curvename, to use it as default values if neccessary
    table = handles.guiprops.Features.edit_curve_table;
    if ~isempty(table.Data)
        curvename = table.UserData.CurrentCurveName;
        if isprop(handles.curveprops.(curvename).Results, 'ContactPoint')
            data = handles.curveprops.(curvename).Results.ContactPoint;
        else
            data = [];
        end
    else
        data = [];
    end
    
    if isempty(results)
        results = Results();
        results.addproperty('userdata');
        results.addproperty('singleton');
        results.addproperty('offset');
        results.addproperty('part_index');
        results.addproperty('segment_index');
        if isempty(data)
            loaded_input = handles.procedure.ContactPoint;
            results.userdata = loaded_input.userdata;
            results.singleton = loaded_input.singleton;
            results.offset = loaded_input.offset;
            results.part_index = loaded_input.part_index;
            results.segment_index = loaded_input.segment_index;
        else
            % use values from data as default
            % the singleton property has to be resettet to false in every
            % execution of main in order to load property listeners for results
            % properly
            results.Status = data.Status;
            results.userdata = data.userdata;
            results.singleton = false;
            results.offset = data.offset;
            results.part_index = data.part_index;
            results.segment_index = data.segment_index;
        end

        % update appdata if new results-object for Baseline has been created
        setappdata(handles.figure1, 'ContactPoint', results);
    end
    
    container = handles.guiprops.Panels.results_panel;
    button_handle = findobj(allchild(handles.guiprops.Panels.processing_panel),...
        'Type', 'UIControl', 'Tag', 'ContactPoint');
    
    %% operations on Figure and Axes 
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
    
    %% trigger UpdateResultsToMain to update handles.curveprops.curvename.Results.Baseline
    setappdata(handles.figure1, 'ContactPoint', results);
    guidata(handles.figure1, handles);
    results.FireEvent('UpdateObject');
    
    % delete results object if edit function is not active, after all tasks
    % are done 
    if ~GuiStatus
        UtilityFcn.DeleteListener('EditFunction', 'ContactPoint');
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
    EditFunctions.ContactPoint.AuxillaryFcn.SetInputElements(main_vbox)
    
    % Results
    EditFunctions.ContactPoint.AuxillaryFcn.SetOutputElements(main_vbox)
    
    % make graphical elements visible
    main_vbox.Visible = 'on';
    
    % panelposition adjustment
    main_vbox.Heights = [-1 -0.6];
    main_scrolling_panel.Heights = 400;
    main_scrolling_panel.Widths = 345;

end % SetupGraphicalElements

function SetupListeners()
    EditFunctions.ContactPoint.AuxillaryFcn.SetPropertyEventListener();
    EditFunctions.ContactPoint.AuxillaryFcn.SetExternalEventListener();
end % SetupListeners