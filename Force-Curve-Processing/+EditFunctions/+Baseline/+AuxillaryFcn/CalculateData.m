function handles = CalculateData(handles)
% CALCULATEDATA calculate data of the EditFunction: Baseline
%
%   calculate the offset and slope of the force-curve and
%   correct the curve-data. Either only the offset or offset and slope can be
%   corrected, depending of the userinput to restuls.correction_type.
%
%   offset: mean value of y-values within the force-curve
%   slope: the fitted slope of the specified range in the
%          selcection_border-property of results-object
%
%   Input:
%       - handles: an actual reference to the handles-struct
%
%    Output: 
%       - updated handles-struct

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    raw_data = handles.curveprops.(curvename).RawData;
    results = handles.curveprops.(curvename).Results;
    selection_borders_1 = handles.curveprops.(curvename).Results.Baseline.selection_borders;
    selection_borders_2 = handles.curveprops.(curvename).Results.Baseline.selection_borders_2; 
    correction_type = handles.curveprops.(curvename).Results.Baseline.correction_type;
    correction_type_2 = handles.curveprops.(curvename).Results.Baseline.correction_type_2;
    part_idx_1 = results.Baseline.curve_parts_index;
    part_idx_2 = results.Baseline.curve_parts_index_2;
    segment_idx_1 = results.Baseline.curve_segments_index;
    segment_idx_2 = results.Baseline.curve_segments_index_2;
    
    %% aquire data of full curve
    
    % force vs. distance
    [LineData, handles] = UtilityFcn.ExtractPlotData(raw_data, handles,...
        'xchannel_idx', 'measuredHeight',...
        'ychannel_idx', 'vDeflection',...
        'curve_part_idx', part_idx_1,...
        'curve_segment_idx', segment_idx_1,...
        'edit_button', 'procedure_root_btn');
    data_vector_1 = UtilityFcn.ConvertToVector(LineData);
    
    % force vs. time
    [LineData, handles] = UtilityFcn.ExtractPlotData(raw_data, handles,...
        'xchannel_idx', 'seriesTime',...
        'ychannel_idx', 'vDeflection',...
        'curve_part_idx', part_idx_2,...
        'curve_segment_idx', segment_idx_2,...
        'edit_button', 'procedure_root_btn');
    data_vector_2 = UtilityFcn.ConvertToVector(LineData);

    %% slice data for culculation
    
    % force vs. distance
    idx_1 = round(length(data_vector_1)*selection_borders_1(1));
    idx_2 = round(length(data_vector_1)*selection_borders_1(2));
    sliced_data_1 = data_vector_1(idx_1:idx_2,:);
    
    % force vs. time
    idx_1 = round(length(data_vector_2)*selection_borders_2(1));
    idx_2 = round(length(data_vector_2)*selection_borders_2(2));
    sliced_data_2 = data_vector_2(idx_1:idx_2,:);

    %% calculation of the corrections
    
    % force vs. distance
%     offset_1 = mean(sliced_data_1(:,2));
    
    f = fit(sliced_data_1(:,1), sliced_data_1(:,2), 'poly1');
    tilt_1 = f.p1;
    
    switch correction_type
        case 1
            offset_1 = f.p2;
        case 2
            offset_1 = mean(sliced_data_1(:,2));
    end
    
    % force vs. time
%     offset_2 = mean(sliced_data_2(:,2));
    
    f = fit(sliced_data_2(:,1), sliced_data_2(:,2), 'poly1');
    tilt_2 = f.p1;
    
    switch correction_type_2
        case 1
            offset_2 = f.p2;
        case 2
            offset_2 = mean(sliced_data_2(:,2));
    end
    
    
    results.Baseline.offset = offset_1;
    results.Baseline.offset_2 = offset_2;
    results.Baseline.slope = tilt_1;
    results.Baseline.slope_2 = tilt_2;
    handles.curveprops.(curvename).Results = results;
    
    %% apply corrections
    segments = fieldnames(raw_data.CurveData);
    corrected_data = raw_data;
    corrected_data_2 = raw_data;
    switch correction_type
        case 1
            for i = 1:length(segments)
                % force vs. distance
                if isfield(raw_data.CurveData.(segments{i}), 'measuredHeight') ...
                    && isfield(raw_data.CurveData.(segments{i}), 'vDeflection')
                
                   xdata = raw_data.CurveData.(segments{i}).measuredHeight;
                   ydata = raw_data.CurveData.(segments{i}).vDeflection;
                   
                   % tilt
                   new_ydata = ydata - xdata*tilt_1;

                   % offset
                   offset_vector = ones(length(ydata),1)*offset_1;
                   new_ydata = new_ydata - offset_vector;
                   
                   % update raw_data
                   corrected_data.CurveData.(segments{i}).vDeflection = new_ydata;
                end
            end
            
        case 2
            for i = 1:length(segments)
                % force vs. distance
                if isfield(raw_data.CurveData.(segments{i}), 'measuredHeight') ...
                    && isfield(raw_data.CurveData.(segments{i}), 'vDeflection')
                
                   ydata = raw_data.CurveData.(segments{i}).vDeflection;
                   
                   % offset
                   offset_vector = ones(length(ydata),1)*offset_1;
                   new_ydata = ydata - offset_vector;
                   
                   % update raw_data
                   corrected_data.CurveData.(segments{i}).vDeflection = new_ydata;
                end
            end
    end
    
    switch correction_type_2
        case 1
            for i = 1:length(segments)
                % force vs. time
                if isfield(raw_data.CurveData.(segments{i}), 'seriesTime') ...
                    && isfield(raw_data.CurveData.(segments{i}), 'vDeflection')
                
                   xdata = raw_data.CurveData.(segments{i}).seriesTime;
                   ydata = raw_data.CurveData.(segments{i}).vDeflection;
                   
                   % offset
                   offset_vector = ones(length(ydata),1)*offset_2;
                   new_ydata = ydata - offset_vector;
                   
                   % tilt
                   new_ydata = new_ydata - xdata*tilt_2;
                   
                   % update raw_data
                   corrected_data_2.CurveData.(segments{i}).vDeflection = new_ydata;
                end
            end
        case 2
            for i = 1:length(segments)
                % force vs. time
                if isfiled(raw_data.CurveData.(segments{i}), 'seriesTime') ...
                    && isfield(raw_data.CurveData.(segments{i}), 'vDeflection')

                   ydata = raw_data.CurveData.(segments{i}).vDeflection;
                   
                   % offset
                   offset_vector = ones(length(ydata),1)*offset_2;
                   new_ydata = ydata - offset_vector;
                   
                   % update raw_data
                   corrected_data_2.CurveData.(segments{i}).vDeflection = new_ydata;
                end
            end
    end
    
    %% update handles-struct
    
    actual_xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
    actual_xchannel_string = handles.guiprops.Features.curve_xchannel_popup.String;
    mHeight_idx = find(ismember(actual_xchannel_string, 'measuredHeight'));
    sTime_idx = find(ismember(actual_xchannel_string, 'seriesTime'));
    
    if actual_xchannel == mHeight_idx
        handles.curveprops.(curvename).Results.Baseline.calculated_data = corrected_data.CurveData;
    elseif actual_xchannel == sTime_idx
        handles.curveprops.(curvename).Results.Baseline.calculated_data = corrected_data_2.CurveData;
    else
        handles.curveprops.(curvename).Results.Baseline.calculated_data = raw_data.CurveData;
    end
    
end

