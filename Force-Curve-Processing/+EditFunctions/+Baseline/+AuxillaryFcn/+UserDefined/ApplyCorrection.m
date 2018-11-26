function ApplyCorrection(varargin)
%APPLYCORRECTION applys calculated correction to afm-data
%
% input parameter:
%   - if used as an Callback the first two paramteres are source-data and
%     event-data 
%
% Name-Value-Pairs
%   - EditFunction: char-vector or string-scalar, determining from which
%                   editfunction the calculated_data property should be 
%                   taken from;
%                   default: the last editfunction 
%                            (left from the active one on gui)
%
%   - RawData: afm-object containing the RawData if calculated_data 
%              form active editfunction or last 
%              editfunction is empty
%              default: RawData from currently shown curve

    %% input parser
    p = inputParser;
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    addParameter(p, 'RawData', []);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
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
    
    switch results.correction_type
        case 1
            corrected_data = apply(data, handles,...
                main_slope);
        case 2
            corrected_data = apply(data, handles,...
                main_slope,...
                main_offset);
    end
    
    %% update all Results
    results.calculated_data = corrected_data;
    
    % update results object and handles-struct
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.EditFunction
    results.FireEvent('UpdateObject');
    
    %% nested functions
    
    function corrected_data = apply(data, handles, varargin)
    %APPLY applys corrections in varargin to data
    %
    % data: input with data to be corrected
    % vararing: list with corrections to be applied on data
        
        xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
        ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
        
        slope = varargin{1};
        % abort, if no slope for data adjustment is available
        if isempty(slope) || ~isnumeric(slope)
            corrected_data = [];
            return
        end
        
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
                xdata = data.(segment).(channels{xchannel});
                ydata = data.(segment).(channels{ychannel});
                ydata = ydata - xdata.*slope;
                data.(segment).(channels{ychannel}) = ydata;
            end
        else     
            xdata = data(:, xchannel);
            ydata = data(:, ychannel);
            ydata = ydata - xdata.*slope;
            data(:, ychannel) = ydata;
        end
        if length(varargin) > 1
            offset = varargin{2};
            if isempty(offset) || ~isnumeric(slope)
                return
            end
            if segmented
                for i = 1:length(segments)
                    segment = segments{i};
                    channels = fieldnames(data.(segment));
                    ydata = data.(segment).(channels{ychannel});
                    ydata = ydata - offset;
                    data.(segment).(channels{ychannel}) = ydata;
                end
            else
                ydata = data(:, ychannel);
                ydata = ydata - offset;
                data(:, ychannel) = ydata;
            end
        end
        
        corrected_data = data;

    end % apply

end % ApplyCorrection

