function SetExternalEventListener(EditFunction, varargin)
%SETEXTERNALEVENTLISTENER Listener for external Events
%   Sets the property event listener neccessary to keep the graphical input
%   and output elemnts updated. This Listener objects listen to changes of
%   properties in the results-object of each editfunction.

    % handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');

    % if results_listener property has been removed 
    if ~isprop(results, 'external_event_listener')
        results.addproperty('external_event_listener');
        results.external_event_listener = PropListener();
    end

    % curveparts
    results.property_event_listener.addListener(results.input_elements.input_parts_popup, 'Value', 'PostSet',...
        @EditFunctions.Baseline.main);

    % curvesegments
    results.property_event_listener.addListener(results.input_elements.input_segments_popup, 'Value', 'PostSet',...
        @EditFunctions.Baseline.main);

    % xchannel
    results.property_event_listener.addListener(results.input_elements.input_xchannel_popup, 'Value', 'PostSet',...
        @EditFunctions.Baseline.main);

    % ychannel
    results.property_event_listener.addListener(results.input_elements.input_ychannel_popup, 'Value', 'PostSet',...
        @EditFunctions.Baseline.main);
    
    % update handles and results-object
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);


end % SetExternalEventListener

