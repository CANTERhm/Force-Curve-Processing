function main(varargin)
% MAIN initialize activated editfunction "Tip Sample Seperation"
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

    curvenames = fieldnames(handles.curveprops.DynamicProps);
    results_panel = handles.guiprops.Panels.results_panel;
    edit_button_handle = findobj(allchild(handles.guiprops.Panels.processing_panel),...
        'Type', 'UIControl', 'Tag', 'TipSampleSeperation');

    %% abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        note = 'Error invoking Tip Sample Seperation: No Force-Curves have been loaded!';
        HelperFcn.ShowNotification(note);
        return
    end
    
    %% abort if curves are not calibrated
    if ~handles.curveprops.Calibrated
        note = 'Error invoking Tip Sample Seperation: Force-Curves are not calibrated!';
        HelperFcn.ShowNotification(note);
        return
    end
    
    %% main procedure
    for i = 1:length(curvenames)
        % test if Baseline-results-object exists
        curvename = curvenames{i};
        TSS_results = handles.curveprops.(curvename).Results.TipSampleSeperation;
        TSS_properties = handles.procedure.TipSampleSeperation.function_properties;
        if isempty(TSS_results)

            TSS_results = Results();
            TSS_results.addproperty('calculated_data');
            TSS_results.addproperty('calculation_status');
            TSS_results.addproperty('sensitivity');
            TSS_results.addproperty('spring_constant');
            TSS_results.addproperty('curve_parts_index');
            TSS_results.addproperty('curve_segments_index');
            TSS_results.addproperty('userdata');
            TSS_results.addproperty('property_listener');
            TSS_results.calculated_data = [];
            TSS_results.property_listener = [];
            TSS_results.calculation_status = handles.procedure.TipSampleSeperation.calculation_status;
            TSS_results.sensitivity = handles.procedure.TipSampleSeperation.sensitivity;
            TSS_results.spring_constant = handles.procedure.TipSampleSeperation.spring_constant;
            TSS_results.curve_parts_index = handles.procedure.TipSampleSeperation.curve_parts_index;
            TSS_results.curve_segments_index = handles.procedure.TipSampleSeperation.curve_segments_index;
            TSS_results.curve_parts_index = handles.procedure.TipSampleSeperation.curve_parts_index;
            TSS_results.curve_segments_index = handles.procedure.TipSampleSeperation.curve_segments_index;
            TSS_results.userdata = handles.procedure.TipSampleSeperation.userdata;

            % update handles-struct in function workspace
            handles.curveprops.(curvename).Results.TipSampleSeperation = TSS_results;


        end

        if isempty(TSS_properties)

            TSS_properties = Results();
            TSS_properties.addproperty('gui_elements');
            TSS_properties.gui_elements = [];

            % update handles-struct in function workspace
            handles.procedure.TipSampleSeperation.function_properties = TSS_properties;

        end
    end
    
    %% check if baseline gui should be on screen
    if edit_button_handle.Value == edit_button_handle.Max
        handles.procedure.TipSampleSeperation.OnGui = true;
        handles = HelperFcn.SwitchDisplayStatus(handles);
    else
        handles.procedure.TipSampleSeperation.OnGui = false;
    end
    
    if handles.procedure.TipSampleSeperation.OnGui
        if handles.procedure.TipSampleSeperation.AlreadyDisplayed
            handles = EditFunctions.TipSampleSeperation.AuxillaryFcn.CalculateData(handles);
            handles = EditFunctions.TipSampleSeperation.AuxillaryFcn.UpdateGuiElements(handles);
            EditFunctions.TipSampleSeperation.Callbacks.UpdateGraph([], []);
        else
            handles.procedure.TipSampleSeperation.AlreadyDisplayed = true;
            delete(allchild(results_panel));
            UtilityFcn.ResetMainFigureCallbacks();
            handles = EditFunctions.TipSampleSeperation.AuxillaryFcn.CreateGuiElements(handles);
            handles = EditFunctions.TipSampleSeperation.AuxillaryFcn.UpdateGuiElements(handles);
            handles = EditFunctions.TipSampleSeperation.AuxillaryFcn.CalculateData(handles);
            EditFunctions.TipSampleSeperation.Callbacks.UpdateGraph([], []);
        end
    else
        handles.procedure.TipSampleSeperation.AlreadyDisplayed = false;
        handles = EditFunctions.TipSampleSeperation.AuxillaryFcn.CalculateData(handles);
        UtilityFcn.ResetMainFigureCallbacks();
        for i = 1:length(curvenames)
            curvename = curvenames{i};
            TSS_results = handles.curveprops.(curvename).Results.TipSampleSeperation;
            if ~isempty(TSS_results.property_listener)
                for n = 1:length(TSS_results.property_listener.ListenerObjects)
                    delete(TSS_results.property_listener.ListenerObjects(n))
                end
            end
            delete(TSS_results.property_listener);
            TSS_results.property_listener = [];
            handles.curveprops.(curvename).Results.TipSampleSeperation = TSS_results;
        end
    end
    
    %% update handles-struct
    guidata(handles.figure1, handles);
end

