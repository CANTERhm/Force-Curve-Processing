function main_already_calibrated_checkbox_callback(src, evt)
%MAIN_ALREADY_CALIBRATED_CHECKBOX_CALLBACK Enables/Disables
%settings-panel according to handles.curveprops.Calibrated-property

%% get an actual handle to mainHandles-struct
main = findobj(allchild(groot), 'Type', 'Figure', 'Name', 'Calibrate Curves');
mainHandles = guidata(main);

%% preparation
if isempty(mainHandles.handles.curveprops.DynamicProps)
    return
else
    curvenames = fieldnames(mainHandles.handles.curveprops.DynamicProps);
end

%% function procedure

switch evt.AffectedObject.Value
    case evt.AffectedObject.Max
        status = calibration_status();
        
        % set curve-status-label on processing panel for FCP-App
        % accordingly
        if status 
            mainHandles.handles.curveprops.Calibrated = true;
        else
            mainHandles.handles.curveprops.Calibrated = true;
        end
        
        change_features('off');
        
    case evt.AffectedObject.Min
        status = calibration_status();
        
        % set curve-status-label on processing panel for FCP-App
        % accordingly
        if status 
            mainHandles.handles.curveprops.Calibrated = true;
        else
            mainHandles.handles.curveprops.Calibrated = false;
        end
        
        change_features('on');
        
end

%% update mainHandles.mainDialog with mainHandles
guidata(main, mainHandles);


%% nested functions

    function change_features(enable)
        features = fieldnames(mainHandles.settings);
        if ~isempty(features)
            for i = 1:length(features)
                mainHandles.settings.(features{i}).Enable = enable;
            end
        end
    end % change_features

    function status = calibration_status()
        sensitivity = mainHandles.handles.curveprops.CalibrationValues.Sensitivity;
        springconstant = mainHandles.handles.curveprops.CalibrationValues.SpringConstant;
        if ~isempty(sensitivity) && ~isempty(springconstant)
            if isnumeric(sensitivity) && isnumeric(springconstant)
                status = true;
            else
                status = false;
            end
        else
            status = false;
        end
    end % calibtation_status

%     function status = calibration_status()
%         %calibration_status checks status of calibration for a bunch of
%         %loaded curves.
%         %   
%         %   Output:
%         %       - status: logical value indicating wether loaded curves are
%         %       calibratet or not.
%         %
%         %   status is TRUE if in every segment of every loaded curve exist
%         %   valid values for springconstant and sensitivity and FALSE if
%         %   not.
%         %   Validation of Calibration-status takes two lagical array:
%         %       - Status for every curve (springconstant and sensitivity) 
%         %       - Status for every segment (segment_springconstant and segment_sensitivity)
%         %   First we check if every segment of a curve has values for
%         %   sensitivity and springconstant
%         
%         springconstant = false(length(curvenames), 1);
%         sensitivity = false(length(curvenames), 1);
%         
%         % fist take every loaded curve and iterate over them
%         for i = 1:length(curvenames)
%             try 
%                 segments = fieldnames(mainHandles.handles.curveprops.(curvenames{i}).RawData.SpecialInformation);
%             catch ME % if you can
%                 switch ME.identifier
%                     case 'MATLAB:fieldnames:InvalidInput' % Specialifnormation is empty --> no specialinformation has been found
%                         note = 'there is no Informatio available about calibration status (springconstant and sensitivity).';
%                         HelperFcn.ShowNotification(note);
%                         return
%                     otherwise
%                         rethrow(ME);
%                 end
%             end
%             
%             % second take every segment contained in a curve and iterate
%             % over it
%             segment_springconstant = false(length(segments), 1);
%             segment_sensitivity = false(length(segments), 1);
%             for n = 1:length(segments)
%                 info = mainHandles.handles.curveprops.(curvenames{i}).RawData.SpecialInformation.(segments{i});
%                 if ~isempty(info.springConstant) 
%                     springconst = true;
%                 else
%                     springconst = false;
%                 end
%                 if ~isempty(info.sensitivity)
%                     sensi = true;
%                 else
%                     sensi = false;
%                 end
%                 segment_springconstant(n) = springconst;
%                 segment_sensitivity(n) = sensi;
%             end
%             springconstant(i) = any(segment_springconstant);
%             sensitivity(i) = any(segment_sensitivity);
%         end % for 
%         
%         % test if an afm-curve has all its segments calibrated
%         if any(~springconstant) || any(~sensitivity)
%             status = false;
%         else
%             status = true;
%         end
%         
%     end % calibration_status

end % main_already_calibrated_checkbox

