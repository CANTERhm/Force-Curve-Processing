function handles = SetPropertyListener(handles)
% SETPROPERTYLISTENER set the property listener for the functionality
% of the baseline-editfunction

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    baseline = handles.procedure.Baseline.function_properties;
    baseline_results = handles.curveprops.(curvename).Results.Baseline;
    
    %% create listener
    baseline.property_listener = PropListener();
    
    % Curve Settings: update dropdown menus
    baseline.property_listener.addListener(baseline_results, 'curve_parts_index', 'PostSet',...
        @EditFunctions.Baseline.Callbacks.BLUpdateDropdownMenuCallback);
    
    %% update handles-struct
    handles.procedure.Baseline.function_properties = baseline;
end

