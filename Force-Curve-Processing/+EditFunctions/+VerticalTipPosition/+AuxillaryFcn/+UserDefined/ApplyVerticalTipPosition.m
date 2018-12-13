function ApplyVerticalTipPosition(varargin)
%APPLYVERTICALTIPPOSITION Calculate VTP to AFM-Data
%
% Vertical Tip Position is defined as follows: length of molecule attached 
% between substrate and AFM-tip or the actual distance between the substate
% and the AFM-tip (lm).
% Consider the measured heihgt at the piezo to be lg, the overall length. 
% If you proceed to retract the priezo from an substrate with an
% attached molecule between it and the AFM-tip, one can strecht the
% molecule until a certain cantilever-deflection. lg then consits of lm and
% the additional length through cantiliever deflection lk. The vertical tip
% position is now given as:
% (1)  lm = lg - lk; where all lengths are in m
%
% lg is given as it is the measured height from the cantilever. One has to
% calculate the length lk. 
% The force applied via an spring, deflected a certain length is given as:
%   F = k*x; where F is the Force in N, k the springconstant in N/m and x
%   the Cantileverdeflection in m. 
% Normally x is the detector signal at the photodiode of an AFM. 
% To obtain x in meter, one has to determine the Cantilevers Sensitivity in
% m/V. The force now looks like:
% (2)  F = k*x*S = k*lk => lk = x*S = F/k
% 
% Combining (1) with (2) leads to the disired vertical tip position:
%   lm = lg - lk
%   - if vertical deflection is given in Volt 
%     (as it is the detector signal directly)
%       * (3a) lm = lg - x*S
%   - if vertical deflection is given in Newton 
%     (e.g. the experiments were calibrated prio to measurements with the 
%      Nanowizard I)
%       * (3b) lm = lg - F/k

    %% input parsing
    p = inputParser;
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);

    %% variables
    
    % handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'VerticalTipPosition');
    
    % from results-object
    sensitivity = results.Sensitivity;
    springconstant = results.SpringConstant;
    sensitivity_checkbox_value = results.settings_sensitivity_checkbox_value;
    springconstant_checkbox_value = results.settings_springconstant_checkbox_value;
    xchannel_idx = results.settings_xchannel_popup_value;
    ychannel_idx = results.settings_ychannel_popup_value;
    calculation_status = results.calculation_status;
    
    % obtain last editfunction
    editfunctions = allchild(handles.guiprops.Panels.processing_panel);
    edit_function = findobj(editfunctions, 'Tag', 'VerticalTipPosition');
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
    
    % something went wrong with loading the curves or obtaining sensitivity
    % and springconstant
    if calculation_status ~= 1
        return
    end
    
    % no curves have been loaded
    if isempty(table.Data)
        return
    end
    
    %% fetch data
    data = [];
    
    if ~strcmp(last_edit_function, 'procedure_root_btn')
        res = handles.curveprops.(curvename).Results.(last_edit_function);
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
    
    %% calculate vertical tip position
    if springconstant_checkbox_value == 1
        corrected_data = CalculateViaSpringConstant(data,...
            springconstant,...
            xchannel_idx,...
            ychannel_idx);
    elseif sensitivity_checkbox_value == 1
        corrected_data = CalculateViaSensitivity(data,...
            sensitivity,...
            xchannel_idx,...
            ychannel_idx);
    end
    
    %% update all Results
    results.calculated_data = corrected_data;
    
    % update results object and handles-struct
    setappdata(handles.figure1, 'VerticalTipPosition', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.EditFunction
    results.FireEvent('UpdateObject');

end % ApplyVerticalTipPosition

function out_data = CalculateViaSensitivity(data, sensitivity, xchannel, ychannel)

    % work off data
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
                xdata = xdata - abs(ydata).*sensitivity;
                data.(segment).(channels{xchannel}) = xdata;
            end
        end
    else     
        xdata = data(:, xchannel);
        ydata = data(:, ychannel);
        xdata = xdata - abs(ydata).*sensitivity;
        data(:, xchannel) = xdata;
    end
    
    out_data = data;
    
end % CalculateViaSensitivity

function out_data = CalculateViaSpringConstant(data, springconstant, xchannel, ychannel)

    % work off data
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
                xdata = xdata - abs(ydata)./springconstant;
                data.(segment).(channels{xchannel}) = xdata;
            end
        end
    else     
        xdata = data(:, xchannel);
        ydata = data(:, ychannel);
        xdata = xdata - abs(ydata)./springconstant;
        data(:, xchannel) = xdata;
    end
    
    out_data = data;
    
end % CalculateViaSpringConstant
