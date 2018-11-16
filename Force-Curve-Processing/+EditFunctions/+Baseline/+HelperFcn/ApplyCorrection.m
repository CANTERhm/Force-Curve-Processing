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
    
    ValidCharacter = @(x)assert(isa(x, 'char') || isa(x, 'string'),...
        'CalculateCorrection:invalidInput',...
        'Input is not a character-vector or a string-scalar.');
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    addParameter(p, 'EditFunction', 'Baseline', ValidCharacter);
    addParameter(p, 'RawData', []);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
    EditFunction = p.Results.EditFunction;
    RawData = p.Results.RawData;
    
    %% get latest references to handles and result
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    if ~isempty(main)
        handles = guidata(main);
%         results = getappdata(handles.figure1, EditFunction);
    else
        % abort, no open fcp-app
        return
    end

    %% function procedure
    
    % obtain last editfunction
    editfunctions = allchild(handles.guiprops.Panels.processing_panel);
    edit_function = findobj(editfunctions, 'Tag', EditFunction);
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
    
    % obtain results-object
    results = handles.curveprops.(curvename).Results.(EditFunction);

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
            props = fieldnames(results);
            if ismember(props, 'calculated_data')
                calculated_data = res.calculated_data;
                if ~isempty(calculated_data)
                    data = calculated_data;
                end
            end
        end
    end
    
    % if data from last editfunction is not avaliable, take
    % RawData.CurveData from acitve editfunction
    if isempty(data)
        data = handles.curveprops.(curvename).RawData.CurveData;
    end
    
    % apply the correction
    switch results.correction_type
        case 1
            corrected_data = apply(data, handles,...
                results.slope);
        case 2
            corrected_data = apply(data, handles,...
                results.slope,...
                results.offset);
    end
    
    %% update all Results
    results.calculated_data = corrected_data;
    
    % update results object and handles-struct
%     setappdata(handles.figure1, EditFunction, results);
    handles.curveprops.(curvename).Results.Baseline = results;
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
        segments = fieldnames(data);
        for i = 1:length(segments)
            segment = segments{i};
            channels = fieldnames(data.(segment));
            xdata = data.(segment).(channels{xchannel});
            ydata = data.(segment).(channels{ychannel});
            ydata = ydata - xdata.*slope;
            data.(segment).(channels{ychannel}) = ydata;
        end
        if length(varargin) > 1
            for i = 1:length(segments)
                segment = segments{i};
                channels = fieldnames(segment);
                ydata = data.(segment).(channels{ychannel});
                ydata = ydata - offset;
                data.(segment).(channels{ychannel}) = ydata;
            end
        end
        
        corrected_data = data;

    end % apply

end % ApplyCorrection

