function CalculateCorrection(varargin)
%CALCULATECORRECTION Calculates Offset and Slope of the given afm-data
%
% input parameter:
%   - if used as an Callback the first two paramteres are source-data and
%     event-data 
%
% Name-Value-Pairs
%   - EditFunction: char-vector or string-scalar, determining from which
%   editfunction the calculated_data property should be taken from;
%   default: the last editfunction (left from the active one on gui)
%
%   - RawData: char-vector or string-scalar, determinting the afm-object
%   containing the RawData if calculated_data form active editfunction or
%   last editfunction is empty
%   default: RawData from currently shown curve

    %% input parser
    p = inputParser;
    
    ValidCharacter = @(x)assert(isa(x, 'char') || isa(x, 'string'),...
        'CalculateCorrection:invalidInput',...
        'Input is not a character-vector or a string-scalar.');
    
    % this input parameter only exits, if this function is used as an
    % Callback
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    
    addParameter(p, 'EditFunction', 'Baseline', ValidCharacter);
    addParameter(p, 'RawData', [], ValidCharacter);
    
    % no futher input parameters so far
    
    parse(p, varargin{:})
    
    src = p.Results.src;
    evt = p.Results.evt;
    EditFunction = p.Results.EditFunction;
    RawData = p.Results.RawData;
    
    %% function procedure
    
    % get latest references to handles and result
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    if ~isempty(main)
        handles = guidata(main);
        results = getappdata(handles.figure1, EditFunction);
    else
        % abort, no open fcp-app
        return
    end
    
    % create frequently used variables
    xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
    ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
    table = handles.guiprops.Features.edit_curve_table;
    if isempty(table.Data)
        return
    end
    curvename = table.UserData.CurrentCurveName;
    
    % obtain last editfunction
    editfunctions = allchild(handles.guiprops.Panels.processing_panel);
    edit_function = findobj(editfunctions, 'Tag', EditFunction);
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
    
    % Check caluclated_data of last_editfunction
    if ~isempty(table.Data)
        % test if there are already calculated data, if not take data
        % for last Editfunction
        if isempty(results.calculated_data)
            % get data from last editfunction
            curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel,...
                'edit_button', last_editfunction);
            linedata = UtilityFcn.ConvertToVector(curvedata);
        else
            % get data from active editfunction
            curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel);
            linedata = UtilityFcn.ConvertToVector(curvedata);
        end
    end
    
    % obtain data for calculate corrections
    calc_data = GetCalcData(results, linedata);
    
    % Calculate Corrections
    [slope, offset] = CalculateFit(calc_data);
    
    % update handles, results and fire event UpdateObject
    results.slope = slope;
    results.offset = offset;
    
    % update results object
    setappdata(handles.figure1, EditFunction, results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.EditFunction
    results.FireEvent('UpdateObject');
    
    %% nested functions
    
    function calc_data = GetCalcData(results, linedata)
    
    % frequently used variables
    xdata = linedata(:,1);
    ydata = linedata(:,2);
    
    % Check units-property
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
        calc_data(:,1) = xdata(idx_left:idx_right);
        calc_data(:,2) = ydata(idx_left:idx_right);
        
    end % GetCalcData

    function [slope, offset] = CalculateFit(calc_data)
        f = Poly1Fit(calc_data(:,1), calc_data(:,2));
        slope = f.p1;
        offset = f.p2;
    end % CalculateFit

end % CalculateCorrection

