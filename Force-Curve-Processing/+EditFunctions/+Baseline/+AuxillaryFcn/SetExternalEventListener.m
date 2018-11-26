function SetExternalEventListener(EditFunction, varargin)
%SETEXTERNALEVENTLISTENER Listener for external Events
%   Sets the property event listener neccessary to keep the graphical input
%   and output elemnts updated. This Listener objects listen to changes of
%   properties in the results-object of each editfunction.

    % handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');
    
    if results.singleton == false % only add property listener once
        
        % if results_listener property has been removed 
        if ~isprop(results, 'external_event_listener')
            results.addproperty('external_event_listener');
            results.external_event_listener = PropListener();
        end

        % curveparts
        results.external_event_listener.addListener(handles.guiprops.Features.curve_parts_popup, 'Value', 'PostSet',...
            @EditFunctions.Baseline.HelperFcn.MarkupData);

        % curvesegments
        results.external_event_listener.addListener(handles.guiprops.Features.curve_segments_popup, 'Value', 'PostSet',...
            @EditFunctions.Baseline.HelperFcn.MarkupData);

        % xchannel
        results.external_event_listener.addListener(handles.guiprops.Features.curve_xchannel_popup, 'Value', 'PostSet',...
            @EditFunctions.Baseline.HelperFcn.MarkupData);
        % ychannel
        results.external_event_listener.addListener(handles.guiprops.Features.curve_ychannel_popup, 'Value', 'PostSet',...
            @EditFunctions.Baseline.HelperFcn.MarkupData);
        
        results.singleton = true;

    end
    
    % update handles and results-object
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);


end % SetExternalEventListener

