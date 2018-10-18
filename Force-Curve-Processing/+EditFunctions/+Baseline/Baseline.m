function Baseline(src, handles)
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
    ax = findobj(handles.guiprops.MainFigure, 'Type', 'Axes');
    cla(ax);
    handles = UtilityFcn.SetupMainFigure(handles);
    
    % plot afm-graph again
    table = handles.guiprops.Features.edit_curve_table;
    xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
    ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
    curvename = table.UserData.CurrentCurveName;
    RawData = handles.curveprops.(curvename).RawData;
    
    if ~isempty(results.calculated_data)
        curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel);
    else
        curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel,...
            'edit_button', 'procedure_root_btn');
    end
    handles = IOData.PlotData(curvedata, handles);
    
    %% set WindowButton and KeyPress Callbacks
    

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
    
        lh.addListener(findobj(handles.guiprops.MainFigure, 'Type', 'Axes'),...
            'Children', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.test);
        
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
    
%     %% nested functions
%     
%     function dataimport(handles)
%         t = handles.guiprops.Features.edit_curve_table;
%         if ~ismpty(t.Data)
%             cn = t.UserData.CurrentCurveName;
%         end
%         xch_idx = handles.guiprops.Features.curve_xchannel_popup.Value;
%         ych_idx = handles.guiprops.Features.curve_ychannel_popup.Value;
%     end % dataimport

end % Baseline