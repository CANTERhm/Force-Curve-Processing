function Baseline(varargin)
%BASELINE Calculates Baseline correction for an current active force-curve

    %% preparation of variables
    
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    
    table = handles.guiprops.Features.edit_curve_table;
    if ~isempty(table.Data)
        curvename = table.UserData.CurrentCurveName;
        if isprop(handles.curveprops.(curvename).Results, 'Baseline')
            baseline = handles.curveprops.(curvename).Results.Baseline;
            if ~isempty(baseline)
                results = baseline;
%                 if isprop(results, 'results_listener')
%                     % singleton option ensures to load 
%                     % results_listener objects only once
%                     results.singleton = true;
%                 end
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
    results.addproperty('userdata');
    results.addproperty('results_listener');
    
    loaded_input = handles.procedure.Baseline;
    results.Status = loaded_input.Status;
    results.singleton = loaded_input.singleton;
    results.correction_type = loaded_input.correction_type;
    results.units = loaded_input.units;
    results.selection_borders = loaded_input.selection_borders;
    results.slope = loaded_input.slope;
    results.offset = loaded_input.offset;
    results.calculated_data = loaded_input.calculated_data;
    results.input_features = loaded_input.input_features;
    results.results_features = loaded_input.results_features;
    results.userdata = loaded_input.userdata;
    results.results_listener = PropListener();
end

%     setappdata(handles.figure1, 'Baseline', results);
    curvename = table.UserData.CurrentCurveName;
    handles.curveprops.(curvename).Results.Baseline = results;

    panel = handles.guiprops.Panels.results_panel;
    
    %% clear FCP Graph Window from previouse editing artefacts
    UtilityFcn.RefreshGraph();
    
    %% set WindowButton and KeyPress Callbacks
    UtilityFcn.ResetMainFigureCallbacks();
    handles.guiprops.MainFigure.WindowButtonDownFcn = @wbdcb;

    %% layout input parameters and results
    if isempty(results.input_features) || isempty(results.results_features)
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
    %     setappdata(handles.figure1, 'Baseline', results);

        %% callbacks for input_layout elements
        tilt = results.input_features.tilt;
        tilt_offset = results.input_features.tilt_offset;
        relative_units = results.input_features.relative_units;
        absolute_units = results.input_features.absolute_units;
        left_border = results.input_features.left_border;
        right_border = results.input_features.right_border;

        tilt.Callback = {@EditFunctions.Baseline.Callbacks.TiltCallback, [tilt; tilt_offset]};
        tilt_offset.Callback = {@EditFunctions.Baseline.Callbacks.TiltOffsetCallback, [tilt; tilt_offset]};
        relative_units.Callback = {@EditFunctions.Baseline.Callbacks.RelativeUnitsCallback, [relative_units; absolute_units]};
        absolute_units.Callback = {@EditFunctions.Baseline.Callbacks.AbsoluteUnitsCallback, [relative_units; absolute_units]};
        left_border.Callback = @EditFunctions.Baseline.Callbacks.LeftBorderCallback;
        right_border.Callback = @EditFunctions.Baseline.Callbacks.RightBorderCallback;
    end

    %% property listener for results-object
    
    if results.singleton == false % only add property listener once
        
        % if results_listener property has been removed 
        if ~isprop(results, 'results_listener')
            results.addproperty('results_listener');
            results.results_listener = PropListener();
        end
        
        % delete all listeners, if Baseline is not acitve
        editfunctions = handles.guiprops.Features.edit_buttons;
        BaselineFcn = editfunctions.Baseline;
        results.results_listener.addListener(BaselineFcn, 'Value', 'PostSet',...
            {@Callbacks.DeleteListenerCallback, BaselineFcn.Tag});
        
        % correction_type-property
        results.results_listener.addListener(results, 'correction_type', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.test);

        % units-property
        results.results_listener.addListener(results, 'units', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.UpdateElementsAccordingToUnitsCallback);    

        % selection_borders-property
        results.results_listener.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.UpdateBorderEditsCallback);
        results.results_listener.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.HelperFcn.MarkupData);
        results.results_listener.addListener(results, 'selection_borders', 'PostSet',...
            @EditFunctions.Baseline.HelperFcn.CalculateCorrection);
        
        % listener for slope and baseline for results_features
        results.results_listener.addListener(results, 'slope', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.UpdateSlopeCallback);
        results.results_listener.addListener(results, 'offset', 'PostSet',...
            @EditFunctions.Baseline.Callbacks.UpdateOffsetCallback);
        
        % event listener to update handles.curveprops.curvename.Results.Baseline
        % This step is important, because it update the handles-struct; it is
        % kind of an output from Baseline
        results.results_listener.addListener(results, 'UpdateObject',...
        {@EditFunctions.Baseline.Callbacks.UpdateResultsToMain, handles, results});
    
        % propertylistener for fcp-gui-elements
        
        % if results_listener property has been removed 
        if ~isprop(results, 'results_listener')
            results.addproperty('results_listener');
        end

        % curveparts
        results.results_listener.addListener(handles.guiprops.Features.curve_parts_popup, 'Value', 'PostSet',...
            @EditFunctions.Baseline.HelperFcn.MarkupData);

        % curvesegments
        results.results_listener.addListener(handles.guiprops.Features.curve_segments_popup, 'Value', 'PostSet',...
            @EditFunctions.Baseline.HelperFcn.MarkupData);

        % xchannel
        results.results_listener.addListener(handles.guiprops.Features.curve_xchannel_popup, 'Value', 'PostSet',...
            @EditFunctions.Baseline.HelperFcn.MarkupData);
        % ychannel
        results.results_listener.addListener(handles.guiprops.Features.curve_ychannel_popup, 'Value', 'PostSet',...
            @EditFunctions.Baseline.HelperFcn.MarkupData);
        
        results.singleton = true;
        
        % edit_curve_table.UserData.CurrentCurveName
        % execute following callbacks if the selected curve changes
%         results.results_listener.addListener(handles.curveprops, 'CurrentCurveName', 'PostSet',...
%             @EditFunctions.Baseline.HelperFcn.MarkupData);
%         results.results_listener.addListener(handles.curveprops, 'CurrentCurveName', 'PostSet',...
%             @EditFunctions.Baseline.HelperFcn.CalculateCorrection);

    end
    
    editfunctions = allchild(handles.guiprops.Panels.processing_panel);
    edit_function = findobj(editfunctions, 'Tag', 'Baseline');
    
    if isempty(edit_function)
        % initial Data Correction
        EditFunctions.Baseline.HelperFcn.CalculateCorrection();

        % Apply initial Data Correction
        EditFunctions.Baseline.HelperFcn.ApplyCorrection();
        
    else
        
        % initial Markup
        EditFunctions.Baseline.HelperFcn.MarkupData();

        % initial Data Correction
        EditFunctions.Baseline.HelperFcn.CalculateCorrection();

        % Apply initial Data Correction
        EditFunctions.Baseline.HelperFcn.ApplyCorrection();
        
    end
    
    %% trigger UpdateResultsToMain to update handles.curveprops.curvename.Results.Baseline
    handles.curveprops.(curvename).Results.Baseline = results;
    guidata(main, handles);
    results.FireEvent('UpdateObject');
    
    %% Window Callbacks
    
    function wbdcb(src, evt)
    % WBDCB window button down callback
    
        % get results-object
        main_wbdcb = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
        h_wbdcb = guidata(main_wbdcb);
        r_wbdcb = getappdata(h_wbdcb.figure1, 'Baseline');
    
        cp_wbdcb = h_wbdcb.guiprops.MainAxes.CurrentPoint;
        if strcmp(r_wbdcb.units, 'relative')
            r_wbdcb.Status = 'units_changed';
            r_wbdcb.units = 'absolute';
        end
        r_wbdcb.userdata.new_borders = [cp_wbdcb(1, 1) cp_wbdcb(1, 1)];
        
        % refresh results object and handles
        setappdata(h_wbdcb.figure1, 'Baseline', r_wbdcb);
        guidata(h_wbdcb.figure1, h_wbdcb);
        
        src.WindowButtonMotionFcn = @wbmcb;
        src.WindowButtonUpFcn = @wbucb;
        
        function wbmcb(src, evt)
        % WBMCB window button move callback
        
            % get results-object
            main_wbmcb = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
            h_wbmcb = guidata(main_wbmcb);
            r_wbmcb = getappdata(h_wbmcb.figure1, 'Baseline');
        
            cp_wbmcb = h_wbmcb.guiprops.MainAxes.CurrentPoint;
            new_borders = [r_wbmcb.userdata.new_borders(1) cp_wbmcb(1, 1)];
            r_wbmcb.userdata.new_borders = new_borders;

            % renew an initial markup while moving the mouse
            ax = findobj(h_wbmcb.guiprops.MainFigure, 'Type', 'Axes');
            markup = findobj(allchild(groot), 'Type', 'Patch', 'Tag', 'markup');

            xpoints = [new_borders(1) new_borders(2) new_borders(2) new_borders(1)];
            ypoints = [ax.YLim(1) ax.YLim(1) ax.YLim(2) ax.YLim(2)];
            
            if isempty(markup)
                % setup an new markup
                hold(ax, 'on');
                patch(ax, xpoints, ypoints, 'black',...
                    'FaceColor', 'blue',...
                    'FaceAlpha', 0.1,...
                    'LineStyle', 'none',...
                    'Tag', 'markup',...
                    'DisplayName', 'Data Range');
                hold(ax, 'off');
            else
                % in case there are more markups on screen than there should be
                % delete every markup but the last one
                len = length(markup);
                if len > 1
                    for i = 2:len
                        delete(markup(i))
                    end
                end

                % update markup if theres only one
                markup.XData = xpoints;
                markup.YData = ypoints;
                markup.FaceColor = 'blue';
            end
            
            % refresh results object and handles
            setappdata(h_wbmcb.figure1, 'Baseline', r_wbmcb);
            guidata(h_wbmcb.figure1, h_wbmcb);
            
            drawnow;
        end % wbmcb

        function wbucb(src, evt)
        % WBUCB window button up callback
        
            % get results-object
            main_wbucb = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
            h_wbucb = guidata(main_wbucb);
            r_wbucb = getappdata(h_wbucb.figure1, 'Baseline');  
            r_wbucb.selection_borders = sort(r_wbucb.userdata.new_borders);
            
            if strcmp(r_wbucb.Status, 'units_changed')
                r_wbucb.units = 'relative';
                r_wbucb.Status = [];
            end

            r_wbucb.selection_borders = sort(r_wbucb.selection_borders);
            
            src.WindowButtonMotionFcn = '';
            src.WindowButtonUpFcn = '';
            
            % refresh results object and handles
            setappdata(h_wbucb.figure1, 'Baseline', r_wbucb);
            guidata(h_wbucb.figure1, h_wbucb);
        end % wbucb
        
    end % wbdcb

end % Baseline