function handles = CalculateData(handles)
% CALCULATEDATA calculate data for the EditFunction: Contact Point
%
%   calculate the offset to the contact point for the 
%   "measuredHeight" channel. 
%
%   Input:
%       - handles: an actual reference to the handles-struct
%
%   Output: 
%       - updated handles-struct

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    bl_data = handles.curveprops.(curvename).Results.Baseline;
    cp_data = handles.curveprops.(curvename).Results.ContactPoint;
    raw_data = handles.curveprops.(curvename).RawData;
    try
        if isempty(cp_data.calculated_data)
            curve_data = bl_data.calculated_data;
        else
            curve_data = cp_data.calculated_data;
        end
    catch ME
        switch ME.identifier
            case 'MATLAB:structRefFromNonStruct'
                % message: 'Dot indexing is not supported for variables of this type.'
                % reason: previous EditFunction has no calculated its corrections yet, thus 
                %         "data" is an empty vector
                % solution: abort function
                if handles.procedure.ContactPoint.OnGui
                    note = 'ContactPoint: took data from RawData, because calculated_data of "Baseline" is empty';
                    HelperFcn.ShowNitification(note);
                end
                curve_data = raw_data.CurveData;
            otherwise
                rethrow(ME);
        end
    end
    
    % try to retrive calculated_data from previous EditFunction. If this
    % property is empty, take data from RawData
    try
        segments = fieldnames(curve_data);
    catch ME
        switch ME.identifier
            case 'MATLAB:fieldnames:InvalidInput'
                % message: 'Invalid input argument of type 'double'. Input must be a structure or a Java or COM object.'
                % reason: calculated_data from previous EditFunction has
                %         not been calculated
                % solution: take data from RawData
                curve_data = raw_data.CurveData;
                segments = fieldnames(curve_data);
                if handles.procedure.TipSampleSeperation.OnGui
                    note = 'ContactPoint: Took data from RawData, because calculated_data of "Baseline" is not segmented';
                    HelperFcn.ShowNotification(note);
                end
            otherwise
                rethrow(ME);
        end
    end
    
    %% calculate data
    for i = 1:length(segments)
        mHeight = curve_data.(segments{i}).measuredHeight;
        offset = cp_data.offset;
        if ~isempty(mHeight) && ~isempty(offset)
            mHeight = mHeight - offset;
        end
        curve_data.(segments{i}).measuredHeight = mHeight;
    end
    
    %% update handles-struct
    handles.curveprops.(curvename).Results.ContactPoint.calculated_data = curve_data;

end

