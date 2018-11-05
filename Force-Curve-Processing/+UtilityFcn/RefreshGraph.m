function RefreshGraph()
%REFRESHGRAPH brings a refreshed version of the afm-curve to the screen

    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
%     results = getappdata(handles.figure1, 'Baseline');
    update_appdata = true;

    table = handles.guiprops.Features.edit_curve_table;
    curvename = table.UserData.CurrentCurveName;
    editfunctions = allchild(handles.guiprops.Panels.processing_panel);
    editfunctions(end) = [];
    active_fun_mask = false(length(editfunctions), 1);
    for i = 1:length(editfunctions)
        if editfunctions(i).Value == 1
            active_fun_mask(i) = 1;
        end
    end
    active_fun = editfunctions(active_fun_mask);
    
    if ~isempty(active_fun)
        results = handles.curveprops.(curvename).Results.(active_fun.Tag);
    else
        results = [];
    end
    
    % return if table's UserData-property is empty
    if isempty(table.UserData)
        return
    end
    
    xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
    ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
    curvename = table.UserData.CurrentCurveName;
    RawData = handles.curveprops.(curvename).RawData;
    
    % if no data has been loaded, there is no graph to update
    if isempty(curvename)
        return
    end
    
    % function call outside of an editfunction
    if isempty(results)
%         results.calculated_data = [];
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
%         setappdata(handles.figure1, 'Baseline', results);
        handles.curveprops.(curvename).Results.(active_fun.Tag) = results;
        
        % trigger update to handles.curveprops.curvename.Results.Baseline
        results.FireEvent('UpdateObject');
    end
    guidata(handles.figure1, handles);
    
end % RefreshGraph

