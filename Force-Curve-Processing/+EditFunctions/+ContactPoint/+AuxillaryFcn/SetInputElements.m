function SetInputElements(varargin)
%SETINPUTELEMENTS Setup Graphical Elements for Inputparameter
%   Set Graphical Elements for the aquisition of Inputparameters of
%   the activated Editfunction

    % handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, EditFunction);
    
    % do Stuff
    
    % update handles and results-object
    setappdata(handles.figure1, EditFunction, results);
    handles.curveprops.(curvename).Results.EditFunction = results;
    guidata(handles.figure1, handles);

end % SetInputElements

