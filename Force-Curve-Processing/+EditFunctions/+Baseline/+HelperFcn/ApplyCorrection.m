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
        results = getappdata(handles.figure1, EditFunction);
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
        last_editfunction = [];
    end
    
    % obtain current curve name
    table = handles.guiprops.Features.edit_curve_table;
    if isempty(table.Data)
        return
    end
    curvename = table.UserData.CurrentCurveName;
    
    % take RawData, if input is not empty
    if ~isempty(RawData)
        data = RawData.CurveData;
    end
    
    % try to fetch data for correction from last editfunction
    if ~isempty(last_editfunction)
        calculated_data = handles.curveprops.(curvename).Results.(last_editfunction);
    end
    
    % if data from last editfunction is not avaliable, take
    % RawData.CurveData from acitve editfunction
    
    
    % apply the correction
    switch results.correction_type
        case 1
            corrected_data = apply(data, results.slope);
        case 2
            corrected_data = apply(data, results.slope,...
                                         results.offset);
    end
    
    %% update all Results
    results.calculated_data = corrected_data;
    
    % update results object and handles-struct
    setappdata(handles.figure1, EditFunction, results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.EditFunction
    results.FireEvent('UpdateObject');
    
    %% nested functions
    
    function corrected_data = apply(data, varargin)
    %APPLY applys corrections in varargin to data
    %
    % data: input with data to be corrected
    % vararing: list with corrections to be applied on data
    
        
    
    end % apply

end % ApplyCorrection

