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
    
    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    results_panel = handles.guiprops.Panels.results_panel;
    edit_button_handle = findobj(allchild(handles.guiprops.Panels.processing_panel),...
        'Type', 'UIControl', 'Tag', 'Baseline');
    
    % test if Baseline-results-object exists
    baseline_results = handles.curveprops.(curvename).Results.Baseline;
    baseline_properties = handles.procedure.Baseline.function_properties;
    if isempty(baseline_results) && isempty(baseline_properties)
        
        baseline_results = Results();
        baseline_results.addproperty('calculated_data');
        baseline_results.addproperty('curve_parts_index');
        baseline_results.addproperty('curve_segments_index');
        baseline_results.addproperty('xchannel_index');
        baseline_results.addproperty('ychannel_index');
        baseline_results.addproperty('correction_type');
        baseline_results.addproperty('units');
        baseline_results.addproperty('selection_borders');
        baseline_results.addproperty('slope');
        baseline_results.addproperty('offset');
        baseline_results.addproperty('userdata');
        baseline_results.calculated_data = [];
        baseline_results.curve_parts_index = handles.procedure.Baseline.curve_parts_index;
        baseline_results.curve_segments_index = handles.procedure.Baseline.curve_segments_index;
        baseline_results.xchannel_index = handles.procedure.Baseline.xchannel_index;
        baseline_results.ychannel_index = handles.procedure.Baseline.ychannel_index;
        baseline_results.correction_type = handles.procedure.Baseline.correction_type;
        baseline_results.units = handles.procedure.Baseline.units;
        baseline_results.selection_borders = handles.procedure.Baseline.selection_borders;
        baseline_results.slope = handles.procedure.Baseline.slope;
        baseline_results.offset = handles.procedure.Baseline.offset;
        baseline_results.userdata = handles.procedure.Baseline.userdata;
        
        baseline_properties = Results();
        baseline_properties.addproperty('gui_elements');
        baseline_properties.addproperty('property_listener');
        baseline_properties.gui_elements = [];
        baseline_properties.property_listener = PropListener();
        
        % update handles-struct in function workspace
        handles.curveprops.(curvename).Results.Baseline = baseline_results;
        handles.procedure.Baseline.function_properties = baseline_properties;
    end
    
    %% check if baseline gui should be on screen
    if edit_button_handle.Value == edit_button_handle.Max
        handles.procedure.Baseline.OnGui = true;
    else
        handles.procedure.Baseline.OnGui = false;
    end
    
    if handles.procedure.Baseline.OnGui
        if handles.procedure.Baseline.AlreadyDisplayed
%             handles = EditFunctions.Baseline.AuxillaryFcn.CalculateData();
        else
            handles.procedure.Baseline.AlreadyDisplayed = true;
            delete(allchild(results_panel));
            UtilityFcn.ResetMainFigureCallbacks();
            handles = EditFunctions.Baseline.AuxillaryFcn.CreateGuiElements(handles);
            handles = EditFunctions.Baseline.AuxillaryFcn.SetPropertyListener(handles);
            handles = EditFunctions.Baseline.AuxillaryFcn.SetWindowButtonCallbacks(handles);
%             EditFunctions.Baseline.AuxillaryFcn.InitiateGraphicalRepresentation();
%             handles = EditFunctions.Baseline.AuxillaryFcn.CalculateData();
        end
    else
        handles.procedure.Baseline.AlreadyDisplayed = false;
        UtilityFcn.ResetMainFigureCallbacks();
        if ~isempty(baseline_properties.property_listener)
            for i = 1:length(baseline_properties.property_listener)
                delete(baseline_properties.property_listener(i))
            end
        end
        baseline_properties.property_listener = [];
    end
    
    %% update handles-struct for app
    guidata(handles.figure1, handles);
end

