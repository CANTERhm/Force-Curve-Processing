function RefreshGraph()
%REFRESHGRAPH brings a refreshed version of the afm-curve to the screen

    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');
    update_appdata = true;

    table = handles.guiprops.Features.edit_curve_table;
    if isempty(table.Data)
        % no loaded curves, abort function
        return
    end
    
    xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
    ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
    curvename = table.UserData.CurrentCurveName;
    RawData = handles.curveprops.(curvename).RawData;
     
    % function call outside of an editfunction
    if isempty(results)
        update_appdata = false;
    end
    
    if isobject(results) && ~isempty(results.calculated_data)
        curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel);
    else
        curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel,...
            'edit_button', 'procedure_root_btn');
    end
    handles = IOData.PlotData(curvedata, handles);

    % refresh results object and handles
    if update_appdata
        setappdata(handles.figure1, 'Baseline', results);
        guidata(handles.figure1, handles);
        
        % trigger update to handles.curveprops.curvename.Results.Baseline
        results.FireEvent('UpdateObject');
    end
    guidata(handles.figure1, handles);
    
end % RefreshGraph

