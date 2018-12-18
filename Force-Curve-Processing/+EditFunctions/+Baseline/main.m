function main(varargin)
%MAIN initialize activated editfunction
%
%   main-function initializes the whole infrastrukture of the respectively
%   activated editfunction. This Function can also be used as an Callback;
%   source-data and event-data parameters are not used

    %% input parsing
    p = inputParser;
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;

    %% preparation of variables
    
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');
    
    % obtain data from curvename, to use it as default values if neccessary
    table = handles.guiprops.Features.edit_curve_table;
    if ~isempty(table.Data)
        curvename = table.UserData.CurrentCurveName;
        if isprop(handles.curveprops.(curvename).Results, 'Baseline')
            data = handles.curveprops.(curvename).Results.Baseline;
        else
            data = [];
        end
    else
        data = [];
    end

if isempty(results)
    results = Results();
    results.addproperty('correction_type');
    results.addproperty('units');
    results.addproperty('selection_borders');
    results.addproperty('slope');
    results.addproperty('offset');
    results.addproperty('offset_fitted');
    results.addproperty('singleton');
    results.addproperty('calculated_data');
    results.addproperty('xchannel_popup_value');
    results.addproperty('ychannel_popup_value');
    results.addproperty('parts_popup_value');
    results.addproperty('segments_popup_value');
    results.addproperty('userdata');
    
    if isempty(data)
        loaded_input = handles.procedure.Baseline;
        results.Status = loaded_input.Status;
        results.correction_type = loaded_input.correction_type;
        results.units = loaded_input.units;
        results.selection_borders = loaded_input.selection_borders;
        results.slope = loaded_input.slope;
        results.offset = loaded_input.offset;
        results.offset_fitted = loaded_input.offset_fitted;
        results.singleton = loaded_input.singleton;
        results.calculated_data = loaded_input.calculated_data;
        results.userdata = loaded_input.userdata;
    else
        % use values from data as default
        % the singleton property has to be resettet to false in every
        % execution of main in order to load property listeners for results
        % properly
        results.Status = data.Status;
        results.correction_type = data.correction_type;
        results.units = data.units;
        results.selection_borders = data.selection_borders;
        results.slope = data.slope;
        results.offset = data.offset;
        results.offset_fitted = data.offset_fitted;
        results.singleton = false; 
        results.calculated_data = data.calculated_data;
        results.xchannel_popup_value = data.xchannel_popup_value;
        results.ychannel_popup_value = data.ychannel_popup_value;
        results.parts_popup_value = data.parts_popup_value;
        results.segments_popup_value = data.segments_popup_value;
        results.userdata = data.userdata;
    end
    
    % update appdata if new results-object for Baseline has been created
    setappdata(handles.figure1, 'Baseline', results);
end

    
    panel = handles.guiprops.Panels.results_panel;
    button_handle = findobj(allchild(handles.guiprops.Panels.processing_panel),...
        'Type', 'UIControl', 'Tag', 'Baseline');
    
    %% operations on Figure and Axes 
    UtilityFcn.ResetMainFigureCallbacks();
    
    %% Baseline procedure
    status = button_handle.UserData.on_gui.Status;
    switch status
        case true
            handles.guiprops.MainFigure.WindowButtonDownFcn = @EditFunctions.Baseline.Callbacks.WindowButtonDownCallback;
            try
                input_elements = results.input_elements;
            catch ME
                switch ME.identifier
                    case 'MATLAB:noSuchMethodOrField'
                        input_elements = [];
                    otherwise
                        rethrow(ME);
                end
            end
            try
                output_elements = results.output_elements;
            catch ME
                switch ME.identifier
                    case'MATLAB:noSuchMethodOrField'
                        output_elements = [];
                    otherwise
                        rethrow(ME);
                end
            end

            if isempty(allchild(panel))
                input_elements = [];
                output_elements = [];
            end

            if (isempty(input_elements) || isempty(output_elements))
                % clear results panel 
                delete(allchild(panel));

                % setup main_vbox for resutls an input parameters for Baseline
                scrolling_panel = uix.ScrollingPanel('Parent', panel);
                main_vbox = uix.VBox('Parent', scrolling_panel,...
                    'Padding', 5,...
                    'Visible', 'off');

                % layout input parameters
                EditFunctions.Baseline.AuxillaryFcn.SetInputElements(main_vbox);
                EditFunctions.Baseline.AuxillaryFcn.SetOutputElements(main_vbox);

                % adjust height of main_vbox
                main_vbox.Heights = [230 80];

                % make layout visible
                main_vbox.Visible = 'on';

                scrolling_panel.Widths = 345;
                scrolling_panel.Heights = 330;

                offset = results.input_elements.offset;
                tilt_offset = results.input_elements.tilt_offset;
                left_border = results.input_elements.left_border;
                right_border = results.input_elements.right_border;

                offset.Callback = {@EditFunctions.Baseline.Callbacks.ElementCallbacks.OffsetCallback, [offset; tilt_offset]};
                tilt_offset.Callback = {@EditFunctions.Baseline.Callbacks.ElementCallbacks.TiltOffsetCallback, [offset; tilt_offset]};
                left_border.Callback = @EditFunctions.Baseline.Callbacks.ElementCallbacks.LeftBorderCallback;
                right_border.Callback = @EditFunctions.Baseline.Callbacks.ElementCallbacks.RightBorderCallback;
            end

            % Set Event Listeners
            if ~results.singleton
                EditFunctions.Baseline.AuxillaryFcn.SetPropertyEventListener();
                EditFunctions.Baseline.AuxillaryFcn.SetExternalEventListener();
                results.singleton = true;
            end
            
            % Refresh results
            results = getappdata(handles.figure1, 'Baseline');

            % Data Correction
            EditFunctions.Baseline.AuxillaryFcn.UserDefined.CalculateCorrection([], [],...
                results.input_elements.input_xchannel_popup.Value,...
                results.input_elements.input_ychannel_popup.Value,...
                results.input_elements.input_parts_popup.Value,...
                results.input_elements.input_segments_popup.Value);

            % Apply Data Correction
            EditFunctions.Baseline.AuxillaryFcn.UserDefined.ApplyCorrection([], [],...
                results.input_elements.input_xchannel_popup.Value,...
                results.input_elements.input_ychannel_popup.Value);
            
            % Data Markup
            UtilityFcn.RefreshGraph([], [],...
                results.input_elements.input_xchannel_popup.Value,...
                results.input_elements.input_ychannel_popup.Value,...
                'EditFunction', 'Baseline',...
                'RefreshAll', true);
            
            EditFunctions.Baseline.AuxillaryFcn.UserDefined.MarkupData([], [],...
                results.input_elements.input_xchannel_popup.Value,...
                results.input_elements.input_ychannel_popup.Value,...
                results.input_elements.input_parts_popup.Value,...
                results.input_elements.input_segments_popup.Value);
            
        case false
            
            % Refresh results
            results = getappdata(handles.figure1, 'Baseline');
            
            % Data Correction
            parts_popup_value = results.parts_popup_value;
            segments_popup_value = results.segments_popup_value;
            xchannel_popup_value = results.xchannel_popup_value;
            ychannel_popup_value = results.ychannel_popup_value;
            EditFunctions.Baseline.AuxillaryFcn.UserDefined.CalculateCorrection([], [],...
                xchannel_popup_value,...
                ychannel_popup_value,...
                parts_popup_value,...
                segments_popup_value);

            % Apply Data Correction
            EditFunctions.Baseline.AuxillaryFcn.UserDefined.ApplyCorrection([], [],...
                xchannel_popup_value,...
                ychannel_popup_value);
            
            % Set Event Listeners
            if ~results.singleton
                EditFunctions.Baseline.AuxillaryFcn.SetPropertyEventListener();
                EditFunctions.Baseline.AuxillaryFcn.SetExternalEventListener();
                results.singleton = true;
            end
            
    end % switch
    
    %% trigger UpdateResultsToMain to update handles.curveprops.curvename.Results.Baseline
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);
    results.FireEvent('UpdateObject');
    
    % delete results object if edit function is not active, after all tasks
    % are done 
    if ~status
        UtilityFcn.DeleteListener('EditFunction', 'Baseline');
    end

end % main