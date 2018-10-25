function UpdateSlopeCallback(src, evt)
%UPDATESLOPECALLBACK Update slope_value_label and slope_unit_label
%according to results-object

    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');
    
    % get label references
    sl_value = results.results_features.slope_value_label;
    sl_unit = results.results_features.slope_unit_label;
    
    % update value labels
    sl_value.String = num2str(results.slope);
    
    % update unit labels
    table = handles.guiprops.Features.edit_curve_table;
    curvename = table.UserData.CurrentCurveName;
    units = handles.curveprops.(curvename).RawData.SpecialInformation.Segment1.units;
    if ~isempty(units)
        xch = handles.guiprops.Features.curve_xchannel_popup.Value;
        ych = handles.guiprops.Features.curve_ychannel_popup.Value;
        sl_unit.String = [units{ych} '/' units{xch}];
    end

    % refresh results object and handles
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');

end % UpdateSlopeCallback

