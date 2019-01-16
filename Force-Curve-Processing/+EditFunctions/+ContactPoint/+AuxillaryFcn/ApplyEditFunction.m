function ApplyEditFunction(varargin)
%APPLYCONTACTPOINT  shifts a force-curve along the x-axis to zero

    %% input parsing
    p = inputParser;
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
    
    %% variables
    
    % handles and results-object
    [~, handles, results] = EditFunctions.ContactPoint.GetCommonVariables('ContactPoint');
    
    % from results-object
    try
        offset = results.offset;
        part_index = results.part_index;
        segment_index = results.segment_index;
    catch ME
        switch ME.identifier
            case 'MATLAB:structRefFromNonStruct'
                % occurance: struct operation on non struct-object
                % reason: results is empty or not correctly loaded
                offset = [];
                part_index = [];
                segment_index = [];
        end
    end
    xchannel_index = handles.guiprops.Features.curve_xchannel_popup.Value;
    ychannel_index = handles.guiprops.Features.curve_ychannel_popup.Value;
    
    % obtain last editfunction
    editfunctions = allchild(handles.guiprops.Panels.processing_panel);
    edit_function = findobj(editfunctions, 'Tag', 'ContactPoint');
    last_editfunction_index = find(editfunctions == edit_function) + 1;
    if ~isempty(last_editfunction_index)
        last_edit_function = editfunctions(last_editfunction_index).Tag;
    else
        last_edit_function = 'procedure_root_btn';
    end
    
    % other 
    table = handles.guiprops.Features.edit_curve_table;
    try
        curvename = table.UserData.CurrentCurveName;
    catch ME
        switch ME.identifier
            case 'MATLAB:structRefFromNonStruct'
                % occurance: struct operation on non-struct object
                % reason: table.UserData is empty because there are no
                % curves loaded
                curvename = [];
        end
    end
    
    %% return conditions
    
    % no curves have been loaded
    if isempty(table.Data) || isempty(curvename)
        return
    end
    
    %% fetch data
    data = [];
    
    if ~strcmp(last_edit_function, 'procedure_root_btn')
        res = handles.curveprops.(curvename).Results.(last_edit_function);
        if isa(res, 'struct')
            props = fieldnames(res);
            if any(ismember(props, 'calculated_data'))
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
    
    %% find contact point
    corrected_data = CalculateCorrectOffsetedData('data', data,...
        'offset', offset,...
        'part_index', part_index,...
        'segment_index', segment_index,...
        'xchannel_index', xchannel_index,...
        'ychannel_index', ychannel_index);
    
    %% update all Results
    results.calculated_data = corrected_data;
    
    % update results object and handles-struct
    PublishResults('ContactPoint', handles, results,...
        'FireEvent', true);
    
end % ApplyContactPoint
