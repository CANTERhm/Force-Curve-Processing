function ApplyEditFunction(varargin)
%APPLYEDITFUNCTION empty framework for the calculation procedue of EidtFunctions

% Before usage:
%
%   - create an Function that calculates the desired values and applies it
%     to the data in the folder ´AuxillaryFcn.UserDefined´
%
%   - replace ´ApplyDummyCalculation´ with your functionname
%
%   - don´t forget to publish the calculated values to handles and results
%     in your created function
%
%   - don´t forget to subsitute all occurances of ´EditFunction´ with your 
%     editfunction name!!

    %% input parsing
    p = inputParser;
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
    
    %% variables
    
    % handles and results-object
    [~, handles, results] = UtilityFcn.GetCommonVariables('EditFunction');
    
    % from results-object
    % ...
    
    % obtain last editfunction
    editfunctions = allchild(handles.guiprops.Panels.processing_panel);
    edit_function = findobj(editfunctions, 'Tag', 'EditFunction');
    last_editfunction_index = find(editfunctions == edit_function) + 1;
    if ~isempty(last_editfunction_index)
        last_edit_function = editfunctions(last_editfunction_index).Tag;
    else
        last_edit_function = 'procedure_root_btn';
    end

    % other
    table = handles.guiprops.Features.edit_curve_table;
    curvename = table.UserData.CurrentCurveName;
    
    %% returning conditions
    
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
    
    %% calculation procedure
    
    % create a function for data calculation in AuxillaryFcn.UserDefined
     corrected_data = AuxillaryFcn.UserDefined.ApplyDummyCalculation(data);
    
    %% update all Results
    
    % uncomment this, if corrected_data exists
    results.calculated_data = corrected_data;
    
    % update results object and handles-struct    
    UtilityFcn.PublishResults('EditFunction', handles, results,...
        'FireEvent', true);

end % ApplyDummy

