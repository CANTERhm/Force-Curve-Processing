function SetPropertyEventListener(EditFunction, varargin)
%SETPROPERTYEVENTLISTENER PropertyEventListener for results-object
%   Sets the property event listener neccessary to keep the graphical input
%   and output elemnts updated. This Listener objects listen to changes of
%   properties in the results-object of each editfunction.

    % handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, EditFunction);
    
    if results.singleton == false % only add property listener once
        
        results.singleton = true;
        
    end
    
    % update handles and results-object
    setappdata(handles.figure1, EditFunction, results);
    handles.curveprops.(curvename).Results.EditFunction = results;
    guidata(handles.figure1, handles);

end % SetPropertyEventListener

