function UpdateElementsAccordingToUnitsCallback(src, evt)
%UPDATEELEMENTSACCORDINGTOUNITSCALLBACK Porpertylistener callback to update
%left/right border edit according to results.units-property

    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');

    % preparation of frequently used variables
    table = handles.guiprops.Features.edit_curve_table;
    xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
    ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
    curvename = table.UserData.CurrentCurveName;
    RawData = handles.curveprops.(curvename).RawData;
    editfunctions = allchild(handles.guiprops.Panels.processing_panel);
    baseline = findobj(editfunctions, 'Tag', 'Baseline');
    last_editfunction_index = find(editfunctions == baseline) + 1;
    last_editfunction = editfunctions(last_editfunction_index).Tag;

    switch results.units
        case 'relative'
            new_borders = ExpressAsRelative();
        case 'absolute'
            new_borders = ExpressAsAbsolute();
    end
    
    results.selection_borders = new_borders;
    
    % refresh results object and handles
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');

%% nested functions

    function new_borders = ExpressAsRelative()
        % transforms absolute selection_borders to relative ones
        
        % abort transformation because no curvedata is available
        if isempty(table.Data)
            new_borders = [];
            return
        else
            % test if there are already calculated data, if not take data
            % for last Editfunction
            if isempty(results.calculated_data)
                % get data from last editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel,...
                    'edit_button', last_editfunction);
                linedata = EditFunctions.Baseline.HelperFcn.ConvertToVector(curvedata);
            else
                % get data from active editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel);
                linedata = EditFunctions.Baseline.HelperFcn.ConvertToVector(curvedata);
            end
        end
        new_borders = sort(EditFunctions.Baseline.HelperFcn.BorderTransformation(linedata, 'absolute-relative'));
    end % ExpressAsRelative

    function new_borders = ExpressAsAbsolute()
        % transforms relative selection_borders to aboslute ones
        
        % abort transformation because no curvedata is available
        if isempty(table.Data)
            new_borders = [];
            return
        else
            % test if there are already calculated data, if not take data
            % for last Editfunction   
            if isempty(results.calculated_data)
                % get data from last editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel,...
                    'edit_button', last_editfunction);
                linedata = EditFunctions.Baseline.HelperFcn.ConvertToVector(curvedata);
            else
                % get data from active editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel);
                linedata = EditFunctions.Baseline.HelperFcn.ConvertToVector(curvedata);
            end
        end
        new_borders = sort(EditFunctions.Baseline.HelperFcn.BorderTransformation(linedata, 'relative-absolute'));
    end % ExpressAsAbsolute

end % UpdateElementsAccordingToUnitsCallback