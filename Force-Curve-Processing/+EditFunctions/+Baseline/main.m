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
    results = handles.curveprops.(curvename).Results.Baseline;
    if isempty(results)
        results = Results();
        results.addproperty('OnGui');
        results.addproperty('AlreadyDisplayed');
        results.addproperty('calculated_data');
        results.addproperty('property_listener');
        results.addproperty('gui_elements');
        results.addproperty('correction_type');
        results.addproperty('units');
        results.addproperty('selection_borders');
        results.addproperty('slope');
        results.addproperty('offset');
        results.addproperty('userdata');
        
        results.OnGui = handles.procedure.Baseline.OnGui;
        results.AlreadyDisplayed = handles.procedure.Baseline.AlreadyDisplayed;
        results.calculated_data = [];
        results.property_listener = [];
        results.gui_elements = [];
        results.correction_type = handles.procedure.Baseline.correction_type;
        results.units = handles.procedure.Baseline.units;
        results.selection_borders = handles.procedure.Baseline.selection_borders;
        results.slope = handles.procedure.Baseline.slope;
        results.offset = handles.procedure.Baseline.offset;
        results.userdata = handles.procedure.Baseline.userdata;
    end
    
    %% check if baseline gui should be on screen
    if edit_button_handle.Value == edit_button_handle.Max
        results.OnGui = true;
    else
        results.OnGui = false;
    end
    
    if results.OnGui
        if results.AlreadyDisplayed
%             handles = EditFunctions.Baseline.AuxillaryFcn.CalculateData();
        else
            results.AlreadyDisplayed = true;
            delete(allchild(results_panel));
            UtilityFcn.ResetMainFigureCallbacks();
            handles = EditFunctions.Baseline.AuxillaryFcn.CreateGuiElements(handles);
%             handles = EditFunctions.BaselineAuxillaryFcn.SetWindowButtonCallbacks(handles);
%             EditFunctions.Baseline.AuxillaryFcn.SetPropertyListener();
%             EditFunctions.Baseline.AuxillaryFcn.InitiateGraphicalRepresentation();
%             handles = EditFunctions.Baseline.AuxillaryFcn.CalculateData();
        end
    else
        results.AlreadyDisplayed = false;
        if ~isempty(results.property_listener)
            for i = 1:length(results.property_listener)
                delete(results.property_listener(i))
            end
        end
        results.property_listener = [];
    end
    
    %% write results to handles
    handles.curveprops.(curvename).Results.Baseline = results;
    guidata(handles.figure1, handles);
end

