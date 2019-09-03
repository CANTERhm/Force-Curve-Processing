function handles = SetPropertyListeners(handles)
% SETPROPERTYLISTENER set the property listener for the functionality
% EditFunction: Contact Point

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvenames = fieldnames(handles.curveprops.DynamicProps);
    ax = handles.guiprops.MainAxes;
    
    %% create listener
    for i = 1:length(curvenames)
        curvename = curvenames{i};
        cp = handles.curveprops.(curvename).Results.ContactPoint;
        cp.property_listener = PropListener();

        % offset_value: update offset-property in handles
        cp.property_listener.addListener(cp, 'offset', 'PostSet',...
            @EditFunctions.ContactPoint.Callbacks.UpdateOffsetValueCallback);
        
        % update graph if data have been recalculated
        cp.property_listener.addListener(cp, 'calculated_data', 'PostSet',...
            @EditFunctions.ContactPoint.Callbacks.UpdateGraph);
        
        % offset representation: update line-plot
        cp.property_listener.addListener(ax, 'YLim', 'PostSet',...
            @EditFunctions.ContactPoint.Callbacks.UpdateGraphicalRepresentation);
        
        %% update handles-struct
        handles.curveprops.(curvename).Results.ContactPoint = cp;
    end
    

end

