function Baseline(handles, varargin)
%BASELINE Calculates Baseline correction for an current active force-curve

    %% preparation of variables
    table = handles.guiprops.Features.edit_curve_table;
    if ~isempty(table.Data)
        curvename = table.UserData.CurrentCurveName;
        if isprop(handles.curveprops.(curvename).Results, 'Baseline')
            baseline = handles.curveprops.(curvename).Results.Baseline;
            if ~isempty(baseline)
                results = baseline;
                results.singleton = true;
            else
                results = [];
            end
        else
            results = [];
        end
    else
        results = [];
    end

if isempty(results)
    results = Results();
    results.addproperty('correction_type');
    results.addproperty('units');
    results.addproperty('selection_borders');
    results.addproperty('slope');
    results.addproperty('offset');
    results.addproperty('calculated_data');
    results.addproperty('singleton');
    results.addproperty('input_features');
    results.addproperty('results_features');

    results.Status = [];
    results.singleton = false;
    results.correction_type = 1;
    results.units = 'relative';
    results.selection_borders = [0.99 1];
end

    setappdata(handles.figure1, 'Baseline', results);
    
    lh = PropListener();

    panel = handles.guiprops.Panels.results_panel;
    
    %% clear FCP Graph Window from previouse editing artefacts
    UtilityFcn.RefreshGraph();
    
    %% set WindowButton and KeyPress Callbacks
    handles.guiprops.MainFigure.WindowButtonDownFcn = @wbdcb;

    %% layout input parameters and results
    % clear results panel 
    delete(allchild(panel));

    % setup main_vbox for resutls an input parameters for Baseline
    main_vbox = uix.VBox('Parent', panel,...
        'Padding', 5,...
        'Visible', 'off');

    % layout input parameters
    input_features = EditFunctions.Baseline.HelperFcn.layout_input(main_vbox);
    results_features = EditFunctions.Baseline.HelperFcn.layout_results(main_vbox);

    % adjust height of main_vbox
    main_vbox.Heights = [100 40];

    % make layout visible
    main_vbox.Visible = 'on';
    
    % update results object
    results.input_features = input_features;
    results.results_features = results_features;
    setappdata(handles.figure1, 'Baseline', results);
    

    %% callbacks for input_layout elements
    tilt = input_features.tilt;
    tilt_offset = input_features.tilt_offset;
    relative_units = input_features.relative_units;
    absolute_units = input_features.absolute_units;
    left_border = input_features.left_border;
    right_border = input_features.right_border;
    
    tilt.Callback = {@EditFunctions.Baseline.Callbacks.TiltCallback, [tilt; tilt_offset]};
    tilt_offset.Callback = {@EditFunctions.Baseline.Callbacks.TiltOffsetCallback, [tilt; tilt_offset]};
    relative_units.Callback = {@EditFunctions.Baseline.Callbacks.RelativeUnitsCallback, [relative_units; absolute_units]};
    absolute_units.Callback = {@EditFunctions.Baseline.Callbacks.AbsoluteUnitsCallback, [relative_units; absolute_units]};
    left_border.Callback = @EditFunctions.Baseline.Callbacks.LeftBorderCallback;
    right_border.Callback = @EditFunctions.Baseline.Callbacks.RightBorderCallback;

    %% property listener for results-object
    
    if results.singleton == false % only add property listener once
        % correction_type-property
        lh.addListener(results, 'correction_type', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.test);

        % units-property
        lh.addListener(results, 'units', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.UpdateElementsAccordingToUnitsCallback);    

        % selection_borders-property
        lh.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.UpdateBorderEditsCallback);
        lh.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.HelperFcn.MarkupData);
        
        % event listener to update handles.curveprops.curvename.Results.Baseline
        % This step is important, because it update the handles-struct; it is
        % kind of an output from Baseline
        lh.addListener(results, 'UpdateObject',...
        {@EditFunctions.Baseline.Callbacks.UpdateResultsToMain, handles, results});
    end

    %% WindowButtonDownFcn and initial Markup
    EditFunctions.Baseline.HelperFcn.MarkupData();

    %% trigger UpdateResultsToMain to update handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');
    
    %% WindowCallbacks
    
    function wbdcb(src, evt)
    % WBDCB window button down callback
        cp = handles.guiprops.MainAxes.CurrentPoint;
        results.selection_borders(1) = cp(1, 1);
        src.WindowButtonMotionFcn = @wbmcb;
        src.WindowButtonUpFcn = @wbucb;
    end % wbdcb

    function wbmcb(src, evt)
    % WBMCB window button move callback
        table = handles.guiprops.Features.edit_curve_table;
        xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
        ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
        curvename = table.UserData.CurrentCurveName;
        RawData = handles.curveprops.(curvename).RawData;
        editfunctions = allchild(handles.guiprops.Panels.processing_panel);
        baseline = findobj(editfunctions, 'Tag', 'Baseline');
        last_editfunction_index = find(editfunctions == baseline) + 1;
        last_editfunction = editfunctions(last_editfunction_index).Tag;
        
        cp = handles.guiprops.MainAxes.CurrentPoint;
        user_defined_borders = [results.selection_borders(1) cp(1, 1)];
        
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
        
        switch results.units
            case 'relative'
                new_borders = EditFunctions.Baseline.HelperFcn.BorderTransformation(linedata,...
                    'absolute-relative',...
                    'user_defined_borders', user_defined_borders);
            case 'absolute'
                new_borders = user_defined_borders;
        end
        
        results.selection_borders = new_borders;
        drawnow;
    end % wbmcb

    function wbucb(src, evt)
    % WBUCB window button up callback
      src.WindowButtonMotionFcn = '';
      src.WindowButtonUpFcn = '';
    end % wbucb

end % Baseline