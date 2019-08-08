function RelativeUnitsCallback(src, evt, obj_list)
%RELATIVEUNITSCALLBACK Summary of this function goes here
%   Detailed explanation goes here

    % refresh results object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    curvename = table.UserData.CurrentCurveName;
    if isprop(handles.curveprops.(curvename).Results, 'Baseline')
        results = handles.curveprops.(curvename).Results.Baseline;
    end
%     results = getappdata(handles.figure1, 'Baseline');
    
    EditFunctions.Baseline.HelperFcn.SwitchCheckboxes(src, obj_list);
    if src.Value == 1
        results.units = 'relative';
    else
        results.units = 'absolute';
    end
        
    % update results object
%     setappdata(handles.figure1, 'Baseline', results);
    handles.curveprops.(curvename).Results.Baseline = results;
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');

end % RelativeUnitsCallback

