function MarkupData()
%MARKUPDATA Marksup data between selection_borders property
%  	Tracks the selection_borders property via
%   propertylistener and marks up the range according to this property
%   on FCP GraphWindow.

    %% refresh handles and results
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(main, 'Baseline');
    
    %% markup datarange
    
    % transform relative units to absolute
    if strcmp(results.units, 'relative')
    else
    end
    
    
    %% update handles, results and fire event UpdateObject
    % update results object
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');
    
    %% nested functions
    
    function absolute = TransformToAbsolute(results, handles)
        
        % do calculations
        
    end % TransformToAbsolute
end % MarkupData

