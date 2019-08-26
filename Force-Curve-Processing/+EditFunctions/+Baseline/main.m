function main(varargin)
%MAIN initialize activated editfunction "Baseline"
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

    curvenames = fieldnames(handles.curveprops.DynamicProps);
    results_panel = handles.guiprops.Panels.results_panel;
    edit_button_handle = findobj(allchild(handles.guiprops.Panels.processing_panel),...
        'Type', 'UIControl', 'Tag', 'Baseline');
    
    for i = 1:length(curvenames)
        % test if Baseline-results-object exists
        curvename = curvenames{i};
        baseline_results = handles.curveprops.(curvename).Results.Baseline;
        baseline_properties = handles.procedure.Baseline.function_properties;
        if isempty(baseline_results)

            baseline_results = Results();
            baseline_results.addproperty('calculated_data');
            baseline_results.addproperty('curve_parts_index');
            baseline_results.addproperty('curve_parts_index_2');
            baseline_results.addproperty('curve_segments_index');
            baseline_results.addproperty('curve_segments_index_2');
            baseline_results.addproperty('correction_type');
            baseline_results.addproperty('correction_type_2');
            baseline_results.addproperty('selection_borders');
            baseline_results.addproperty('selection_borders_2');
            baseline_results.addproperty('slope');
            baseline_results.addproperty('slope_2');
            baseline_results.addproperty('offset');
            baseline_results.addproperty('offset_2');
            baseline_results.addproperty('userdata');
            baseline_results.addproperty('property_listener');
            baseline_results.calculated_data = [];
            baseline_results.property_listener = [];
            baseline_results.curve_parts_index = handles.procedure.Baseline.curve_parts_index;
            baseline_results.curve_parts_index_2 = handles.procedure.Baseline.curve_parts_index_2;
            baseline_results.curve_segments_index = handles.procedure.Baseline.curve_segments_index;
            baseline_results.curve_segments_index_2 = handles.procedure.Baseline.curve_segments_index_2;
            baseline_results.correction_type = handles.procedure.Baseline.correction_type;
            baseline_results.correction_type_2 = handles.procedure.Baseline.correction_type_2;
            baseline_results.selection_borders = handles.procedure.Baseline.selection_borders;
            baseline_results.selection_borders_2 = handles.procedure.Baseline.selection_borders_2;
            baseline_results.slope = handles.procedure.Baseline.slope;
            baseline_results.slope_2 = handles.procedure.Baseline.slope_2;
            baseline_results.offset = handles.procedure.Baseline.offset;
            baseline_results.offset_2 = handles.procedure.Baseline.offset_2;
            baseline_results.userdata = handles.procedure.Baseline.userdata;

            % update handles-struct in function workspace
            handles.curveprops.(curvename).Results.Baseline = baseline_results;


        end

        if isempty(baseline_properties)

            baseline_properties = Results();
            baseline_properties.addproperty('gui_elements');
            baseline_properties.gui_elements = [];

            % update handles-struct in function workspace
            handles.procedure.Baseline.function_properties = baseline_properties;

        end
    end
    
    
    %% check if baseline gui should be on screen
    if edit_button_handle.Value == edit_button_handle.Max
        handles.procedure.Baseline.OnGui = true;
    else
        handles.procedure.Baseline.OnGui = false;
    end
    
    if handles.procedure.Baseline.OnGui
        if handles.procedure.Baseline.AlreadyDisplayed
            handles = EditFunctions.Baseline.AuxillaryFcn.UpdateGuiElements(handles);
            handles = EditFunctions.Baseline.AuxillaryFcn.CalculateData(handles);
        else
            handles.procedure.Baseline.AlreadyDisplayed = true;
            delete(allchild(results_panel));
            UtilityFcn.ResetMainFigureCallbacks();
            handles = EditFunctions.Baseline.AuxillaryFcn.CreateGuiElements(handles);
            handles = EditFunctions.Baseline.AuxillaryFcn.SetPropertyListener(handles);
            handles = EditFunctions.Baseline.AuxillaryFcn.CalculateData(handles);
        end
    else
        handles.procedure.Baseline.AlreadyDisplayed = false;
        UtilityFcn.ResetMainFigureCallbacks();
        for i = 1:length(curvenames)
            curvename = curvenames{i};
            baseline_results = handles.curveprops.(curvename).Results.Baseline;
            if ~isempty(baseline_results.property_listener)
                for n = 1:length(baseline_results.property_listener.ListenerObjects)
                    delete(baseline_results.property_listener.ListenerObjects(n))
                end
            end
            delete(baseline_results.property_listener);
            baseline_results.property_listener = [];
            handles.curveprops.(curvename).Results.Baseline = baseline_results;
        end
    end
    
    %% update handles-struct for app
    guidata(handles.figure1, handles);
end

