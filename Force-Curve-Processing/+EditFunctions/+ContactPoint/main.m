function main(varargin)
% MAIN initialize activated editfunction "ContactPoint"
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
        'Type', 'UIControl', 'Tag', 'ContactPoint');

    %% abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        note = 'Error invoking Contact Point: No Force-Curves have been loaded!';
        HelperFcn.ShowNotification(note);
        return
    end
    
    %% main procedure
    for i = 1:length(curvenames)
        % test if Baseline-results-object exists
        curvename = curvenames{i};
        cp_results = handles.curveprops.(curvename).Results.ContactPoint;
        cp_properties = handles.procedure.ContactPoint.function_properties;
        if isempty(cp_results)

            cp_results = Results();
            cp_results.addproperty('calculated_data');
            cp_results.addproperty('part_index');
            cp_results.addproperty('segment_index');
            cp_results.addproperty('offset');
            cp_results.addproperty('userdata');
            cp_results.addproperty('property_listener');
            cp_results.calculated_data = [];
            cp_results.property_listener = [];
            cp_results.part_index = 1;
            cp_results.segment_index = 1;
            cp_results.offset = 0;
            cp_results.userdata = handles.procedure.ContactPoint.userdata;

            % update handles-struct in function workspace
            handles.curveprops.(curvename).Results.ContactPoint = cp_results;


        end

        if isempty(cp_properties)

            cp_properties = Results();
            cp_properties.addproperty('gui_elements');
            cp_properties.gui_elements = [];

            % update handles-struct in function workspace
            handles.procedure.ContactPoint.function_properties = cp_properties;

        end
    end
    
    %% check if baseline gui should be on screen
    if edit_button_handle.Value == edit_button_handle.Max
        handles.procedure.ContactPoint.OnGui = true;
        handles = HelperFcn.SwitchDisplayStatus(handles);
    else
        handles.procedure.ContactPoint.OnGui = false;
    end
    
    if handles.procedure.ContactPoint.OnGui
        if handles.procedure.ContactPoint.AlreadyDisplayed
            handles = EditFunctions.ContactPoint.AuxillaryFcn.CalculateData(handles);
%             handles = EditFunctions.ContactPoint.AuxillaryFcn.UpdateGuiElements(handles);
            EditFunctions.ContactPoint.Callbacks.UpdateGraph([], []);
            EditFunctions.ContactPoint.Callbacks.UpdateGraphicalRepresentation([], []);
        else
            handles.procedure.ContactPoint.AlreadyDisplayed = true;
            delete(allchild(results_panel));
            UtilityFcn.ResetMainFigureCallbacks();
            handles = EditFunctions.ContactPoint.AuxillaryFcn.CreateGuiElements(handles);
            handles = EditFunctions.ContactPoint.AuxillaryFcn.InitiateGraphicalRepresentation(handles);
            handles = EditFunctions.ContactPoint.AuxillaryFcn.SetWindowButtonCallbacks(handles);
            handles = EditFunctions.ContactPoint.AuxillaryFcn.SetPropertyListeners(handles);
            handles = EditFunctions.ContactPoint.AuxillaryFcn.CalculateData(handles);
            EditFunctions.ContactPoint.Callbacks.UpdateGraph([], []);
        end
    else
        handles.procedure.ContactPoint.AlreadyDisplayed = false;
        handles = EditFunctions.ContactPoint.AuxillaryFcn.CalculateData(handles);
        UtilityFcn.ResetMainFigureCallbacks();
        for i = 1:length(curvenames)
            curvename = curvenames{i};
            cp_results = handles.curveprops.(curvename).Results.ContactPoint;
            if ~isempty(cp_results.property_listener)
                for n = length(cp_results.property_listener.ListenerObjects):-1:1
                    cp_results.property_listener = cp_results.property_listener.deleteListener(cp_results.property_listener.ListenerObjects(n));
                end
            end
            delete(cp_results.property_listener);
            cp_results.property_listener = [];
            handles.curveprops.(curvename).Results.ContactPoint = cp_results;
        end
    end
    
    %% update handles-struct
    guidata(handles.figure1, handles);
end

