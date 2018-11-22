function SetOutputElements(varargin)
%SETOUTPUTELEMENTS Setup Graphical Elements for Outputparameter
%   Set Graphical Elements for the representation of Outputparameters of
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

end % SetOutputElements

