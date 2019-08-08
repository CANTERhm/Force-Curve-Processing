function ApplyCorrection(varargin)
%APPLYCORRECTION applys calculated correction to afm-data
%
%
%
% Syntax:
%   - ApplyCorrection()
%   - ApplyCorrection(xchannel_idx, ychannel_idx)
%   - ApplyCorrection(___, RawData, 'afm-object')
%
% Input:
%   - if used as an Callback the first two paramteres are source-data and
%     event-data 
%   - xchannel_idx: Value of an xchannel_popup (default: fcp-app curve_xchannel_popup.Value)
%   - ychannel_idx: Value of an ychannel_popup (default: fcp-app curve_ychannel_popup.Value)
%
% Name-Value-Pairs
%   - RawData: afm-object containing the RawData if calculated_data 
%              form active editfunction or last 
%              editfunction is empty
%              default: RawData from currently shown curve

    %% input parser
    p = inputParser;
    
    ValidNumber = @(x)assert(isnumeric(x),...
        'ApplyCorrection:invalidInput',...
        'Input was not numeric for one of the following inuptparameters:\n%s\n%s\n%s\n%s\n',...
        'xchannel_idx', 'ychannel_idx', 'curve_part_idx', 'curve_segment_idx');
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    addOptional(p, 'xchannel_idx', [], ValidNumber);
    addOptional(p, 'ychannel_idx', [], ValidNumber);
    addOptional(p, 'curve_part_idx', [], ValidNumber);
    addOptional(p, 'curve_segment_idx', [], ValidNumber);
    addParameter(p, 'RawData', []);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
    xchannel_idx = p.Results.xchannel_idx;
    ychannel_idx = p.Results.ychannel_idx;
    RawData = p.Results.RawData;
    
    %% get latest references to handles and result
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    if ~isempty(main)
        handles = guidata(main);
        results = getappdata(handles.figure1, 'Baseline');
    else
        % abort, no open fcp-app
        return
    end
    
    if isempty(src) && isempty(evt)
        InCallback = false;
    else
        InCallback = true;
    end

    %% function procedure
    
    % obtain last editfunction
    editfunctions = allchild(handles.guiprops.Panels.processing_panel);
    edit_function = findobj(editfunctions, 'Tag', 'Baseline');
    last_editfunction_index = find(editfunctions == edit_function) + 1;
    if ~isempty(last_editfunction_index)
        last_editfunction = editfunctions(last_editfunction_index).Tag;
    else
        last_editfunction = 'procedure_root_btn';
    end
    
    % obtain current curve name
    table = handles.guiprops.Features.edit_curve_table;
    if isempty(table.Data)
        return
    end
    curvename = table.UserData.CurrentCurveName;

    % setup data
    data = [];
    
    % take RawData, if input is not empty
    if ~isempty(RawData)
        data = RawData.CurveData;
    end
    
    % try to fetch data for correction from last editfunction
    if isempty(data) && ~strcmp(last_editfunction, 'procedure_root_btn')
        res = handles.curveprops.(curvename).Results.(last_editfunction);
        if isa(res, 'sturct')
            props = fieldnames(res);
            if ismember(props, 'calculated_data')
                calculated_data = res.calculated_data;
                if ~isempty(calculated_data)
                    data = calculated_data;
                end
            end
        end
    end
    
    % if data from last editfunction is not avaliable, take
    % RawData.CurveData from active editfunction
    if isempty(data)
        data = handles.curveprops.(curvename).RawData.CurveData;
    end
    
    % apply the correction
    main_slope = results.slope;
    main_offset = results.offset;
    main_offset_mean = results.offset_mean;
    
    switch results.correction_type
        case 1
            corrected_data = apply(data,...
                handles,...
                results,...
                xchannel_idx,...
                ychannel_idx,...
                InCallback,...
                'OffsetMean', main_offset_mean);
        case 2
            corrected_data = apply(data,...
                handles,...
                results,...
                xchannel_idx,...
                ychannel_idx,...
                InCallback,...
                'Slope', main_slope,...
                'Offset', main_offset);
    end
    
    %% update all Results
    results.calculated_data = corrected_data;
    
    % update results object and handles-struct
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.EditFunction
    results.FireEvent('UpdateObject');
    
    %% nested functions
    
    function corrected_data = apply(data, handles, results, varargin)
    %APPLY applys corrections in varargin to data
    %
    % data: input with data to be corrected
    % vararing: list with corrections to be applied on data
    
    % inputpaser
    p_apply = inputParser;
    
    ValidNumber_apply = @(x)assert(isnumeric(x),...
        'ApplyCorrection:apply:invalidInput',...
        'Input was not numeric for one of the following Inputparameters:\n%s\n%s\n%s\n%s\n',...
        'xchannel_idx', 'ychannel_idx', 'Offset', 'Slope');
    
        addRequired(p_apply, 'data');
        addRequired(p_apply, 'handles');
        addRequired(p_apply, 'results');
        addOptional(p_apply, 'xchannel_idx', [], ValidNumber_apply);
        addOptional(p_apply, 'ychannel_idx', [], ValidNumber_apply);
        addOptional(p_apply, 'InCallback', false);
        addParameter(p_apply, 'Slope', [], ValidNumber_apply);
        addParameter(p_apply, 'Offset', [], ValidNumber_apply);
        addParameter(p_apply, 'OffsetMean', [], ValidNumber_apply);

        parse(p_apply, data, handles, results, varargin{:});

        data = p_apply.Results.data;
        handles = p_apply.Results.handles;
        results = p_apply.Results.results;
        xchannel_idx_apply = p_apply.Results.xchannel_idx;
        ychannel_idx_apply = p_apply.Results.ychannel_idx;
        InCallback_apply = p_apply.Results.InCallback;
        slope = p_apply.Results.Slope;
        offset = p_apply.Results.Offset;
        offset_mean = p_apply.Results.OffsetMean;
        
        % function procedure
        
        % work off xchannel_idx and ychannel_idx parameter
        if isempty(xchannel_idx_apply) && isempty(ychannel_idx_apply)
            if ~InCallback_apply
                xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
                ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
            else
                xchannel = results.input_elements.input_xchannel_popup.Value;
                ychannel = results.input_elements.input_ychannel_popup.Value;
            end
        else
            xchannel = xchannel_idx_apply;
            ychannel = ychannel_idx_apply;
        end
        

        % work off slope parameter
        if ~isempty(slope)
            % test if data is segmented. In special cases, like true
            % easyimport, data is only a nxm-numeric matrix
            if isa(data, 'struct')
                segmented = true;
            else
                segmented = false;
            end

            if segmented
                segments = fieldnames(data);
                for i = 1:length(segments)
                    segment = segments{i};
                    channels = fieldnames(data.(segment));
                    try
                        xdata = data.(segment).(channels{xchannel});
                        ydata = data.(segment).(channels{ychannel});
                    catch ME
                        switch ME.identifier
                            case 'MATLAB:badsubscript'
                                % 'Index exceeds array bounds.'
                                % reason: A channel does not have as much choises as in in the
                                % channels-popup-menus are available
                                xdata = [];
                                ydata = [];
                            otherwise
                                rethrow(ME);
                        end
                    end
                    if ~isempty(xdata) && ~isempty(ydata)
                        ydata = ydata - xdata.*slope;
                        data.(segment).(channels{ychannel}) = ydata;
                    end
                end
            else     
                xdata = data(:, xchannel);
                ydata = data(:, ychannel);
                ydata = ydata - xdata.*slope;
                data(:, ychannel) = ydata;
            end
        end
        
        % work off offset parameter
        if ~isempty(offset) && isempty(offset_mean)
            % test if data is segmented. In special cases, like true
            % easyimport, data is only a nxm-numeric matrix
            if isa(data, 'struct')
                segmented = true;
            else
                segmented = false;
            end
            
            if segmented
                segments = fieldnames(data);
                for i = 1:length(segments)
                    segment = segments{i};
                    channels = fieldnames(data.(segment));
                    try
                        ydata = data.(segment).(channels{ychannel});
                    catch ME
                        switch ME.identifier
                            case 'MATLAB:badsubscript'
                                % 'Index exceeds array bounds.'
                                % reason: A channel does not have as much choises as in in the
                                % channels-popup-menus are available
                                ydata = [];
                            otherwise
                                rethrow(ME);
                        end
                    end
                    if ~isempty(ydata)
                        ydata = ydata - offset;
                        data.(segment).(channels{ychannel}) = ydata;
                    end
                end
            else
                ydata = data(:, ychannel);
                ydata = ydata - offset;
                data(:, ychannel) = ydata;
            end
        end
        
        % work off offset_mean parameter
        if ~isempty(offset_mean) && isempty(offset)
            % test if data is segmented. In special cases, like true
            % easyimport, data is only a nxm-numeric matrix
            if isa(data, 'struct')
                segmented = true;
            else
                segmented = false;
            end
            
            if segmented
                segments = fieldnames(data);
                for i = 1:length(segments)
                    segment = segments{i};
                    channels = fieldnames(data.(segment));
                    try
                        ydata = data.(segment).(channels{ychannel});
                    catch ME
                        switch ME.identifier
                            case 'MATLAB:badsubscript'
                                % 'Index exceeds array bounds.'
                                % reason: A channel does not have as much choises as in in the
                                % channels-popup-menus are available
                                ydata = [];
                            otherwise
                                rethrow(ME);
                        end
                    end
                    if ~isempty(ydata)
                        ydata = ydata - offset_mean;
                        data.(segment).(channels{ychannel}) = ydata;
                    end
                end
            else
                ydata = data(:, ychannel);
                ydata = ydata - offset_mean;
                data(:, ychannel) = ydata;
            end
        end
        
        % assign data output
        if isempty(slope) && isempty(offset) && isempty(offset_mean)
            corrected_data = [];
        else
            corrected_data = data;
        end

    end % apply

end % ApplyCorrection

