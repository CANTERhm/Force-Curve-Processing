function main(varargin)
%MAIN initialize activated editfunction
%   main-function initializes the whole infrastrukture of the respectively
%   activated editfunction

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
    results.addproperty('singleton');
    results.addproperty('calculated_data');
    results.addproperty('userdata');
    
    if isempty(data)
        loaded_input = handles.procedure.Baseline;
        results.Status = loaded_input.Status;
        results.correction_type = loaded_input.correction_type;
        results.units = loaded_input.units;
        results.selection_borders = loaded_input.selection_borders;
        results.slope = loaded_input.slope;
        results.offset = loaded_input.offset;
        results.singleton = loaded_input.singleton;
        results.calculated_data = loaded_input.calculated_data;
        results.userdata = loaded_input.userdata;
    else
        % use values from data as default
        results.Status = data.Status;
        results.correction_type = data.correction_type;
        results.units = data.units;
        results.selection_borders = data.selection_borders;
        results.slope = data.slope;
        results.offset = data.offset;
        results.singleton = data.singleton;
        results.calculated_data = data.calculated_data;
        results.userdata = data.userdata;
    end
    
    % update appdata if new results-object for Baseline has been created
    setappdata(handles.figure1, 'Baseline', results);
end

    
    panel = handles.guiprops.Panels.results_panel;
    button_handle = findobj(allchild(handles.guiprops.Panels.processing_panel),...
        'Type', 'UIControl', 'Tag', 'Baseline');
    
    %% operations on Figure and Axes 
    UtilityFcn.RefreshGraph();
    UtilityFcn.ResetMainFigureCallbacks();
    handles.guiprops.MainFigure.WindowButtonDownFcn = @EditFunctions.Baseline.Callbacks.WindowButtonDownCallback;
    
    %% Baseline procedure
    switch button_handle.UserData.on_gui.Status
        case true
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
                main_vbox.Heights = [100 80];

                % make layout visible
                main_vbox.Visible = 'on';

                scrolling_panel.Widths = 345;
                scrolling_panel.Heights = 200;

                tilt = results.input_elements.tilt;
                tilt_offset = results.input_elements.tilt_offset;
                left_border = results.input_elements.left_border;
                right_border = results.input_elements.right_border;

                tilt.Callback = {@EditFunctions.Baseline.Callbacks.ElementCallbacks.TiltCallback, [tilt; tilt_offset]};
                tilt_offset.Callback = {@EditFunctions.Baseline.Callbacks.ElementCallbacks.TiltOffsetCallback, [tilt; tilt_offset]};
                left_border.Callback = @EditFunctions.Baseline.Callbacks.ElementCallbacks.LeftBorderCallback;
                right_border.Callback = @EditFunctions.Baseline.Callbacks.ElementCallbacks.RightBorderCallback;
            end

            % Set Event Listeners
            EditFunctions.Baseline.AuxillaryFcn.SetPropertyEventListener();
            EditFunctions.Baseline.AuxillaryFcn.SetExternalEventListener();
            
        % Data Markup
        EditFunctions.Baseline.AuxillaryFcn.UserDefined.MarkupData();

        % Data Correction
        EditFunctions.Baseline.AuxillaryFcn.UserDefined.CalculateCorrection();

        % Apply Data Correction
        EditFunctions.Baseline.AuxillaryFcn.UserDefined.ApplyCorrection();
    end % switch
    
%     %% Calculation Procedure
% 
%     % decide what to do if Baseline is on screen or not
%     switch button_handle.UserData.on_gui.Status
%         case true
%             % Data Markup
%             EditFunctions.Baseline.AuxillaryFcn.UserDefined.MarkupData();
% 
%             % Data Correction
%             EditFunctions.Baseline.AuxillaryFcn.UserDefined.CalculateCorrection();
% 
%             % Apply Data Correction
%             EditFunctions.Baseline.AuxillaryFcn.UserDefined.ApplyCorrection();
%         case false
%             % Data Correction
%             EditFunctions.Baseline.AuxillaryFcn.UserDefined.CalculateCorrection();
% 
%             % Apply Data Correction
%             EditFunctions.Baseline.AuxillaryFcn.UserDefined.ApplyCorrection();
%     end
    
    %% trigger UpdateResultsToMain to update handles.curveprops.curvename.Results.Baseline
    guidata(handles.figure1, handles);
    results.FireEvent('UpdateObject');

end % main