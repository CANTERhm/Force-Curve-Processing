function CalculateCorrection(varargin)
%CALCULATECORRECTION Calculates Offset and Slope of the given afm-data
%
%   Purpos of CalculateCorrection is to be used within the Basline
%   Eidtfunction of FCP-App. It Calculates Slope and Offset for Baseline
%   Correction and subsequently updates the Results-Object of the
%   Editfunction. 
%   -   The Slope gets calculated by an linear fit through the selected data
%       range
%   -   The Offset is the mean-value of the ydata of the selected data
%       range
%
% Input:
%   - if used as an Callback the first two paramteres are source-data and
%     event-data
%   - xchannel_idx: Value of an xchannel_popup (default: fcp-app curve_xchannel_popup.Value)
%   - ychannel_idx: Value of an ychannel_popup (default: fcp-app curve_ychannel_popup.Value)
%   - curve_part_idx: Value of an curve_parts_popup (default: fcp-app curve_parts_popup.Value)
%   - curve_segment_idx: Value of an curve_segments_popup (default: fcp-app curve_segments_popup.Value)
%
% Optional Name-Value-Pairs:
%   - EditFunction: char-vector or string-scalar, determining from which
%   editfunction the calculated_data property should be taken from;
%   default: the last editfunction (left from the active one on gui)
%
%   - RawData: char-vector or string-scalar, determinting the afm-object
%   containing the RawData if calculated_data form active editfunction or
%   last editfunction is empty
%   default: RawData from currently shown curve
%
% Note:
%   If this function is used as an Callback the default Values for
%   xchannel_idx, ychannel_idx, curve_part_idx and curve_segment_idx
%   are changing as follows:
%   - xchannel_idx: results.input_elements.input_xchannel_popup.Value
%   - ychannel_idx: results.input_elements.input_ychannel_popuo.Value
%   - curve_part_idx: results.input_elements.input_parts_popup.Value
%   - curve_segments_idx: results.input_elements.input_segments_popup.Value

    %% input parser
    p = inputParser;
    
    ValidCharacter = @(x)assert(isa(x, 'char') || isa(x, 'string'),...
        'CalculateCorrection:invalidInput',...
        'Input is not a character-vector or a string-scalar.');
    
    ValidNumber = @(x)assert(isnumeric(x),...
        'CalculateCorrection:invalidInput',...
        'Input was not numeric for one of the following Inputparameters:\n%s\n%s\n%s\n%s\n',...
        'xchannel_idx', 'ychannel_idx', 'curve_part_idx', 'curve_segment_idx');
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    addOptional(p, 'xchannel_idx', [], ValidNumber);
    addOptional(p, 'ychannel_idx', [], ValidNumber);
    addOptional(p, 'curve_part_idx', [], ValidNumber);
    addOptional(p, 'curve_segment_idx', [], ValidNumber);
    addParameter(p, 'RawData', [], ValidCharacter);
    
    parse(p, varargin{:})
    
    src = p.Results.src;
    evt = p.Results.evt;
    xchannel_idx = p.Results.xchannel_idx;
    ychannel_idx = p.Results.ychannel_idx;
    curve_part_idx = p.Results.curve_part_idx;
    curve_segment_idx = p.Results.curve_segment_idx;
    RawData = p.Results.RawData;
    
    %% function procedure
    
    % get latest references to handles and result
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    if ~isempty(main)
        handles = guidata(main);
        results = getappdata(handles.figure1, 'Baseline');
    else
        % abort, no open fcp-app
        return
    end
    
    table = handles.guiprops.Features.edit_curve_table;
    
    if isempty(results)
        % no editfunctions are loaded
        return
    end
    
    if isempty(table.Data)
        % no loaded curves
        return
    else
        curvename = table.UserData.CurrentCurveName;
    end
    
    % create frequently used variables
    if isempty(src) && isempty(evt)
        InCallback = false;
    else
        InCallback = true;
    end
    
    if isempty(xchannel_idx) && isempty(ychannel_idx)
        if ~InCallback
            xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
            ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
        else
            xchannel = results.input_elements.input_xchannel_popup.Value;
            ychannel = results.input_elements.input_ychannel_popup.Value;
        end
    else
        xchannel = xchannel_idx;
        ychannel = ychannel_idx;
    end
    
    if isempty(curve_part_idx)
        if ~InCallback
            part = handles.guiprops.Features.curve_parts_popup.Value;
        else
            part = results.input_elements.input_parts_popup.Value;
        end
    else
        part = curve_part_idx;
    end
    
    if isempty(curve_segment_idx)
        if ~InCallback
            segment = handles.guiprops.Features.curve_segments_popup.Value;
        else
            segment = results.input_elements.input_segments_popup.Value;
        end
    else
        segment = curve_segment_idx;
    end
    
    if isempty(table.Data)
        return
    end
    
    % obtain last editfunction
    editfunctions = allchild(handles.guiprops.Panels.processing_panel);
    edit_function = findobj(editfunctions, 'Tag', 'Baseline');
    last_editfunction_index = find(editfunctions == edit_function) + 1;
    if ~isempty(last_editfunction_index)
        last_editfunction = editfunctions(last_editfunction_index).Tag;
    else
        last_editfunction = 'procedure_root_btn';
    end
    
    % Check inputparameter RawData
    if isempty(RawData)
        RawData = handles.curveprops.(curvename).RawData;
    end
    
    % obtain curve-data either from last editfunction if availalbe or from
    % procedure_root_btn if not
    if ~strcmp(last_editfunction, 'procedure_root_btn')
        % get data from last editfunction
        curvedata = UtilityFcn.ExtractPlotData(RawData,...
            handles,...
            xchannel,...
            ychannel,...
            part,...
            segment,...
            'edit_button', last_editfunction);
        linedata = UtilityFcn.ConvertToVector(curvedata);
    else
        % get data from active editfunction
        curvedata = UtilityFcn.ExtractPlotData(RawData,...
            handles,...
            xchannel,...
            ychannel,...
            part,...
            segment,...
            'edit_button', 'procedure_root_btn');
        linedata = UtilityFcn.ConvertToVector(curvedata);
    end
    
    % cut out selected data from linedata
    calc_data = GetCalcData(results, linedata);
    
    % Calculate Corrections
    if ~isempty(calc_data)
        [slope, offset, offset_fitted] = CalculateFit(calc_data);
    else
        slope = [];
        offset = [];
        offset_fitted = [];
    end
    
    % update handles, results and fire event UpdateObject
    results.slope = slope;
    results.offset = offset;
    results.offset_fitted = offset_fitted;
    
    % update results object
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.EditFunction
    results.FireEvent('UpdateObject');
    
    %% nested functions
    
    function calc_data = GetCalcData(results, linedata)
        
        % work off results
        if isempty(results)
            calc_data = [];
            return
        end
        
        % work off linedata
        if isempty(linedata)
            calc_data = [];
            return
        end
        
        % frequently used variables
        xdata = linedata(:,1);
        ydata = linedata(:,2);
    
        % Check units-property
        % the switch might be obsolete, because only relative units are
        % used 
            switch results.units
                case 'absolute'
                    old_borders = results.selection_borders;
                    x = length(xdata);
                    a_left = old_borders(1);
                    a_right = old_borders(2);
                    aind_left = knnsearch(xdata, a_left);
                    aind_right = knnsearch(xdata, a_right);

                    % left border
                    r_left = aind_left/x;

                    % right border
                    r_right = aind_right/x;

                    borders = [r_left r_right];
                case 'relative'
                    borders = results.selection_borders;
            end

            % data extraction
            idx_left = round(length(linedata(:,1))*borders(1));
            idx_right = round(length(linedata(:,2))*borders(2));
            
            % matlab start counting at 1, not zero
            if idx_left == 0
                idx_left = 1;
            end
            if idx_right == 0
                idx_right = 1;
            end
            
            try
                calc_data(:,1) = xdata(idx_left:idx_right);
                calc_data(:,2) = ydata(idx_left:idx_right);
            catch ME
                switch ME.identifier
                    case 'MATLAB:badsubscript'
                        % 'Array indices must be positive integers or logical values.'
                        % reason: idx_left and/or idx_right are zero
                        calc_data = [];
                    otherwise
                        rethrow(ME);
                end
            end

    end % GetCalcData

    function [slope, offset, offset_fitted] = CalculateFit(calc_data)
        offset = mean(calc_data(:,2));
        if length(calc_data) <= 3
            % not enough data for fitting 
            slope = 'not enough data';
            offset_fitted = [];
            return
        end
        calc_data = smoothdata(calc_data, 1, 'gaussian', 100);
        f = fit(calc_data(:,1), calc_data(:,2), 'poly1');
        slope = f.p1;
        offset_fitted = f.p2;
    end % CalculateFit

end % CalculateCorrection

