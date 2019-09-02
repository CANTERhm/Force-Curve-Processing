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
    
    %% create listener
    for i = 1:length(curvenames)
        curvename = curvenames{i};
        cp = handles.curveprops.(curvename).Results.ContactPoint;
        cp.property_listener = PropListener();

        % Baseline Range: update border-edit-controls
        cp.property_listener.addListener(cp, 'offset', 'PostSet',...
            @EditFunctions.ContactPoint.Callbacks.UpdateOffsetValueCallback);
        
        %% update handles-struct
        handles.curveprops.(curvename).Results.ContactPoint = cp;
    end
    

end

