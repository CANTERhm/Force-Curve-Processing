function handles = SetPropertyListener(handles)
% SETPROPERTYLISTENER set the property listener for the functionality
% of the baseline-editfunction

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvenames = fieldnames(handles.curveprops.DynamicProps);
    current_curvename = table.UserData.CurrentCurveName;
    current_baseline = handles.curveprops.(current_curvename).Results.Baseline;
    
    %% create listener
    for i = 1:length(curvenames)
        curvename = curvenames{i};
        baseline = handles.curveprops.(curvename).Results.Baseline;
        baseline.property_listener = PropListener();

        % Baseline Range: update border-edit-controls
        baseline.property_listener.addListener(baseline, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.UpdateBorderElementsCallback);

        % Curve Settings: update dropdown menus
        baseline.property_listener.addListener(baseline, 'curve_parts_index', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.BLUpdateDropdownMenuCallback);
    end
    
    %% update handles-struct
    handles.curveprops.(current_curvename).Results.Baseline = baseline;
end

