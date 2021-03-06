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
    if isprop(results, 'correction_type')
        results.property_event_listener.addListener(results, 'correction_type', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.PropertyEventListener.UpdateCorrectionTypeCallback); 
        results.property_event_listener.addListener(results, 'correction_type', 'PostSet',...
            @EditFunctions.Baseline.AuxillaryFcn.UserDefined.ApplyCorrection);
        results.property_event_listener.addListener(results, 'correction_type', 'PostSet',...
            @EditFunctions.Baseline.AuxillaryFcn.UserDefined.CalculateCorrection);
        results.property_event_listener.addListener(results, 'correction_type', 'PostSet',...
            @EditFunctions.Baseline.AuxillaryFcn.UserDefined.MarkupData);
    end

    % selection_borders-property
    if isprop(results, 'selection_borders')
        results.property_event_listener.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.PropertyEventListener.UpdateSelectionBordersCallback);
        results.property_event_listener.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.AuxillaryFcn.UserDefined.ApplyCorrection);
        results.property_event_listener.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.AuxillaryFcn.UserDefined.CalculateCorrection);
        results.property_event_listener.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.AuxillaryFcn.UserDefined.MarkupData);
        results.property_event_listener.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.PropertyEventListener.UpdateBorderEditsCallback);
    end

    % slope and offset properties
    if isprop(results, 'slope')
        results.property_event_listener.addListener(results, 'slope', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.PropertyEventListener.UpdateSlopeCallback);
    end
    if isprop(results, 'offset')
        results.property_event_listener.addListener(results, 'offset', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.PropertyEventListener.UpdateOffsetCallback);
    end

    % event listener to update handles.curveprops.curvename.Results.Baseline
    % This step is important, because it update the handles-struct; it is
    % kind of an output from Baseline
    results.property_event_listener.addListener(results, 'UpdateObject',...
    @EditFunctions.Baseline.Callbacks.UpdateResultsToMain);
    
    % update handles and results-object
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

end % SetPropertyEventListener