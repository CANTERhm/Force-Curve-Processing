function SetExternalEventListener(varargin)
%SETEXTERNALEVENTLISTENER Listener for external Events
%   Sets the property event listener neccessary to keep the graphical input
%   and output elemnts updated. This Listener objects listen to changes of
%   properties in the results-object of each editfunction.

    % handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'EditFunction');
    
    % do stuff
    
    % update handles and results-object
    setappdata(handles.figure1, 'EditFunction', results);
    guidata(handles.figure1, handles);

end % SetExternalEventListener

