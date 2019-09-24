function handles = CalculateData(handles)
% CALCULATEDATA calculate data for the EditFunction: Tip Sample Seperation
%
%   calculate the tip sample seperation for the
%   "measuredHeight" channel. 
%
%   The Tip Sample Seperation gets calculated using following formula:
%   TSS = measuredHeight + (vDeflection/Springconstant)
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
    cp_data = handles.curveprops.(curvename).Results.ContactPoint;
    tss_data = handles.curveprops.(curvename).Results.TipSampleSeperation;
    raw_data = handles.curveprops.(curvename).RawData;
    notification = handles.procedure.TipSampleSeperation.function_properties.gui_elements.notification;
    try
        if isempty(tss_data.calculated_data)
            curve_data = tss_data.calculated_data;
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
                if handles.procedure.TipSampleSeperation.OnGui
                    note = 'Calculation of Tip Sample Seperation has been failed!';
                    notification.String = note;
                end
                return
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
                    note = 'Calculate Tip Sample Seperation without Baseline Correction!';
                    notification.String = note;
                end
            otherwise
                rethrow(ME);
        end
    end
    sensitivity = handles.curveprops.CalibrationValues.Sensitivity;
    spring_constant = handles.curveprops.CalibrationValues.SpringConstant;
    
    %% calculate data
    for i = 1:length(segments)
        mHeight = curve_data.(segments{i}).measuredHeight;
        vDef = curve_data.(segments{i}).vDeflection;
        spring_constant = handles.curveprops.CalibrationValues.SpringConstant;
        if ~isempty(mHeight) && ~isempty(vDef)
            mHeight = mHeight + (vDef./spring_constant);
        end
        curve_data.(segments{i}).measuredHeight = mHeight;
        curve_data.(segments{i}).vDeflection = vDef;
    end
    
    %% notification of success
    if handles.procedure.TipSampleSeperation.OnGui
        note = 'Tip Sample Seperation has been calculated without errors!';
        notification.String = note;
    end
    
    %% update handles-struct
    
    % load data to tip sample seperation
    handles.curveprops.(curvename).Results.TipSampleSeperation.calculated_data = curve_data;
    
    % load data to step_finder
    
    % write the calibration values to curveprops also
    handles.curveprops.(curvename).Results.TipSampleSeperation.sensitivity = sensitivity;
    handles.curveprops.(curvename).Results.TipSampleSeperation.spring_constant = spring_constant;
    
    % and update the calculation_status
    handles.curveprops.(curvename).Results.TipSampleSeperation.calculation_status = true;

end
