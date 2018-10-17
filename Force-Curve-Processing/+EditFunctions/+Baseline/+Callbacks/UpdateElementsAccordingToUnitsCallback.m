function UpdateElementsAccordingToUnitsCallback(src, evt)
%UPDATEELEMENTSACCORDINGTOUNITSCALLBACK Porpertylistener callback to update
%left/right border edit according to results.units-property

    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');

<<<<<<< HEAD
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
                linedata = ConvertToVector(curvedata);
            else
                % get data from active editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel);
                linedata = ConvertToVector(curvedata);
            end
        end
        new_borders = BorderTransformation(linedata, 'absolute-relative');
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
                linedata = ConvertToVector(curvedata);
            else
                % get data from active editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel);
                linedata = ConvertToVector(curvedata);
            end
        end
        new_borders = BorderTransformation(linedata, 'relative-absolute');
    end % ExpressAsAbsolute

%% UtilityFcn
    function new_borders = BorderTransformation(linedata, direction)
        % calculation of new borders according to transformation direction
        %
        % input: 
        %   - linedata: vecotrized curvedata (means nx2-vector of force-curve)
        %   - direction: transformation direction
        %       *absolute-relative: transformation from absolute values to
        %       relative vaules
        %       * relative-absolute: transformation from relative-values to
        %       absolute-values
        %
        % output:
        %   - new_borders: transformed selection_borders-values
        
        old_borders = results.selection_borders;
        switch direction
            case 'absolute-relative'
                xdata = linedata(:,1);
                x = length(xdata);
                a_left = old_borders(1);
                a_right = old_borders(2);
                aind_left = knnsearch(xdata, a_left);
                aind_right = knnsearch(xdata, a_right);
                
                % left border
                r_left = aind_left/x;
                
                % right border
                r_right = aind_right/x;
                
                new_borders = [r_left r_right];
            case 'relative-absolute'
                x = linedata(:,1);
                
                % left border
                a_left_index = round(length(x)*old_borders(1));
                a_left = x(a_left_index);
                
                % right border
                a_right_index = round(length(x)*old_borders(2));
                a_right = x(a_right_index);
                
                new_borders = [a_left a_right];
        end
                
    end % BorderTransformation

    function vector_data = ConvertToVector(data)
        % flattens the data input to an nx2-double vector for calculation
        % purposes
        %
        % input:
        %   - data: extracted curvedata obtained via ExtractPlotData
        %
        % output:
        %   - vector_data: vectorized curvedata as nx2 double-vector;
        %                   :,1 --> x-data
        %                   :,2 --> y-data
        
        trace_x = [];
        trace_y = [];
        retrace_x = [];
        retrace_y = [];
        
        % prepare data
        if ~isempty(data.Trace)
            segment = fieldnames(data.Trace);
            for i = 1:length(segment)
                if ~isempty(data.Trace.(segment{i}).XData) && ...
                        ~isempty(data.Trace.(segment{i}).YData)
                    trace_x = [trace_x; data.Trace.(segment{i}).XData];
                    trace_y = [trace_y; data.Trace.(segment{i}).YData];
                else
                    trace_x = [];
                    trace_y = [];
                end
            end
        end

        if ~isempty(data.Retrace)
            segment = fieldnames(data.Retrace);
            for i = 1:length(segment)
                if ~isempty(data.Retrace.(segment{i}).XData) && ...
                        ~isempty(data.Retrace.(segment{i}).YData)
                    retrace_x = [retrace_x; data.Retrace.(segment{i}).XData];
                    retrace_y = [retrace_y; data.Retrace.(segment{i}).YData];
                else
                    retrace_x = [];
                    retrace_y = [];
                end
            end
        end

        % convert trace from cell to mat if necessary
        if isa(trace_x, 'cell') 
            trace_x = cell2mat(trace_x);
        end
        if isa(trace_y, 'cell')
            trace_y = cell2mat(trace_y);
        end

        % convert retrace from cell to mat if necessary
        if isa(retrace_x, 'cell')
            retrace_x = cell2mat(retrace_x);
        end
        if isa(retrace_y, 'cell')
            retrace_y = cell2mat(retrace_y);
        end
        
        % output
        curve_x = [trace_x; retrace_x];
        curve_y = [trace_y; retrace_y];
        vector_data = [curve_x, curve_y];
        
    end % ConvertToVector

=======
switch results.units
    case 'relative'
        new_borders = ExpressAsRelative(handles, results);
    case 'absolute'
        new_borders = ExpressAsAbsolute(handles, results);
end

>>>>>>> master
end % UpdateElementsAccordingToUnitsCallback

