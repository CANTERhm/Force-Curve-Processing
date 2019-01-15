function ApplyContactPoint(varargin)
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
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'ContactPoint');
    
    % from results-object
    offset = results.offset;
    part_index = results.part_index;
    segment_index = results.segment_index;
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
    curvename = table.UserData.CurrentCurveName;
    
    %% return conditions
    
    % no curves have been loaded
    if isempty(table.Data)
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
    corrected_data = CalculateCorrectOffsetedData(data,...
        part_index,...
        segment_index,...
        xchannel_index,...
        ychannel_index);
    
    %% update all Results
    results.calculated_data = corrected_data;
    
    % update results object and handles-struct
    setappdata(handles.figure1, 'ContactPoint', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.ContactPoint
    results.FireEvent('UpdateObject');
end % ApplyContactPoint

function corrected_data = CalculateCorrectOffsetedData(data, part_index, segment_index, xchannel_index, ychannel_index)
    corrected_data = [];
end % CalcluateCorrectOffsetedData