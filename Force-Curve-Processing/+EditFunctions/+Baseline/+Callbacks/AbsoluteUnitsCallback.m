function AbsoluteUnitsCallback(src, evt, obj_list)
%RELATIVEUNITSCALLBACK updates the relative- and absolute-units checkboxes
%on FCP-Apps results panel

    % refresh results object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');
    
    EditFunctions.Baseline.HelperFcn.SwitchCheckboxes(src, obj_list);
    if src.Value == 1
        results.units = 'absolute';
    else
        results.units = 'relative';
    end
        
    % update results object
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');

end % AbsoluteUnitsCallback