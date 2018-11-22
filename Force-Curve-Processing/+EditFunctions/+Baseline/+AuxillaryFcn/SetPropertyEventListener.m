function SetPropertyEventListener(varargin)
%SETPROPERTYEVENTLISTENER PropertyEventListener for results-object
%   Sets the property event listener neccessary to keep the graphical input
%   and output elemnts updated. This Listener objects listen to changes of
%   properties in the results-object of each editfunction.

    % handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');
    
    %% property listener for results-object
    
    if results.singleton == false % only add property listener once
        
        % if results_listener property has been removed 
        if ~isprop(results, 'property_event_listener')
            results.addproperty('property_event_listener');
            results.property_event_listener = PropListener();
        end
        
        % delete all listeners, if Baseline is not acitve
        editfunctions = handles.guiprops.Features.edit_buttons;
        BaselineFcn = editfunctions.Baseline;
        results.property_event_listener.addListener(BaselineFcn.UserData.on_gui, 'Status', 'PostSet',...
            {@Callbacks.DeleteListenerCallback, BaselineFcn});   
        
        % correction_type-property
        results.property_event_listener.addListener(results, 'correction_type', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.PropertyEventListener.test); 

        % selection_borders-property
        results.property_event_listener.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.PropertyEventListener.UpdateBorderEditsCallback);
        results.property_event_listener.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.AuxillaryFcn.UserDefined.MarkupData);
        results.property_event_listener.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.AuxillaryFcn.UserDefined.CalculateCorrection);
        results.property_event_listener.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.AuxillaryFcn.UserDefined.ApplyCorrection);
        
        % listener for slope and baseline for results_features
        results.property_event_listener.addListener(results, 'slope', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.PropertyEventListener.UpdateSlopeCallback);
        results.property_event_listener.addListener(results, 'offset', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.PropertyEventListener.UpdateOffsetCallback);
        
        % event listener to update handles.curveprops.curvename.Results.Baseline
        % This step is important, because it update the handles-struct; it is
        % kind of an output from Baseline
        results.property_event_listener.addListener(results, 'UpdateObject',...
        @EditFunctions.Baseline.Callbacks.UpdateResultsToMain);
    
        results.singleton = true;
    end
    
    % update handles and results-object
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

end % SetPropertyEventListener

