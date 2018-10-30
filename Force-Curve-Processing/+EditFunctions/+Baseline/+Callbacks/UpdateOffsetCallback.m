function UpdateOffsetCallback(src, evt)
%UPDATEOFFSETCALLBACK Update offset_value_label and offset_unit_label
%according to results-object

    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');
    
    % get label references
    off_value = results.results_features.offset_value_label;
    off_unit = results.results_features.offset_unit_label;
    
    % update value labels
    off_value.String = num2str(results.offset);
    
    % update unit labels
    table = handles.guiprops.Features.edit_curve_table;
    curvename = table.UserData.CurrentCurveName;
    SpecialInformation = handles.curveprops.(curvename).RawData.SpecialInformation;
    if ~isempty(SpecialInformation)
        units = SpecialInformation.Segment1.units;
    else
        units = [];
    end
    if ~isempty(units)
        ych = handles.guiprops.Features.curve_ychannel_popup.Value;
        off_unit.String = units{ych};
    end

    % refresh results object and handles
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');

end % UpdateOffsetCallback

