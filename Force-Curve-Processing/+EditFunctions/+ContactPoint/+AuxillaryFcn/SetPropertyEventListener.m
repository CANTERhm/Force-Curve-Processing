function SetPropertyEventListener(varargin)
%SETPROPERTYEVENTLISTENER PropertyEventListener for results-object
%   Sets the property event listener neccessary to keep the graphical input
%   and output elemnts updated. This Listener objects listen to changes of
%   properties in the results-object of each editfunction.

    %% handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'ContactPoint');
    
    %% general listeners 
    % if results_listener property has been removed 
    if ~isprop(results, 'property_event_listener')
        results.addproperty('property_event_listener');
        results.property_event_listener = PropListener();
    end

    % delete all listeners, if ContactPoint is not acitve
    editfunctions = handles.guiprops.Features.edit_buttons;
    ContactPointFcn = editfunctions.ContactPoint;
    results.property_event_listener.addListener(ContactPointFcn.UserData.on_gui, 'Status', 'PostSet',...
        {@Callbacks.DeleteListenerCallback, ContactPointFcn}); 
    
    % event listener to update handles.curveprops.curvename.Results.Baseline
    % This step is important, because it update the handles-struct; it is
    % kind of an output from Baseline
    results.property_event_listener.addListener(results, 'UpdateObject',...
    @EditFunctions.ContactPoint.Callbacks.UpdateResultsToMain);
    
    %% specific listeners
    % do stuff

    %% update handles and results-object
    setappdata(handles.figure1, 'ContactPoint', results);
    guidata(handles.figure1, handles);

end % SetPropertyEventListener

