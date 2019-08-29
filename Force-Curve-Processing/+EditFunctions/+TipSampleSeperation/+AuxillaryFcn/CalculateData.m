function handles = CalculateData(handles)
% CALCULATEDATA calculate the tip sample seperation for the
% "measuredHeight" channel. 
%
%   The Tip Sample Seperation gets calculated using following formula:
%   TSS = measuredHeight - (vDeflection/Springconstant)
%
% Input:
%   - handles: an actual reference to the handles-struct
%
% Output: 
%   - updated handles-struct

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    data = handles.curveprops.(curvename).Results.Baseline;
    curve_data = data.calculated_data;
    segments = fieldnames(curve_data);
    sensitivity = handles.curveprops.CalibrationValues.Sensitivity;
    spring_constant = handles.curveprops.CalibrationValues.SpringConstant;
    
    %% calculate data
    for i = 1:length(segments)
        mHeight = curve_data.(segments{i}).measuredHeight;
        vDef = curve_data.(segments{i}).vDeflection;
        spring_constant = handles.curveprops.CalibrationValues.SpringConstant;
        if ~isempty(mHeight) && ~isempty(vDef)
            mHeight = mHeight - (vDef./spring_constant);
        end
        curve_data.(segments{i}).measuredHeight = mHeight;
        curve_data.(segments{i}).vDeflection = vDef;
    end
    
    %% update handles-struct
    handles.curveprops.(curvename).Results.TipSampleSeperation.calculated_data = curve_data;
    
    % write the calibration values to curveprops also
    handles.curveprops.(curvename).Results.TipSampleSeperation.sensitivity = sensitivity;
    handles.curveprops.(curvename).Results.TipSampleSeperation.spring_constant = spring_constant;

end

