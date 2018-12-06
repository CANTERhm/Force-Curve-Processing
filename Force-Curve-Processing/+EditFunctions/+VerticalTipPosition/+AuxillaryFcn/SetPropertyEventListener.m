function SetPropertyEventListener(varargin)
%SETPROPERTYEVENTLISTENER PropertyEventListener for results-object
%   Sets the property event listener neccessary to keep the graphical input
%   and output elemnts updated. This Listener objects listen to changes of
%   properties in the results-object of each editfunction.

    % handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, EditFunction);
    
    % if results_listener property has been removed 
    if ~isprop(results, 'property_event_listener')
        results.addproperty('property_event_listener');
        results.property_event_listener = PropListener();
    end

    % delete all listeners, if Baseline is not acitve
    editfunctions = handles.guiprops.Features.edit_buttons;
    VerticalTipPositionFcn = editfunctions.VerticalTipPosition;
    results.property_event_listener.addListener(VerticalTipPositionFcn.UserData.on_gui, 'Status', 'PostSet',...
        {@Callbacks.DeleteListenerCallback, VerticalTipPositionFcn}); 
    
    % update handles and results-object
    setappdata(handles.figure1, EditFunction, results);
    handles.curveprops.(curvename).Results.EditFunction = results;
    guidata(handles.figure1, handles);

end % SetPropertyEventListener

