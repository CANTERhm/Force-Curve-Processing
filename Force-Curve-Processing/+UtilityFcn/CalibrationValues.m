function [sensitivity, springconstant, handles] = CalibrationValues(handles)

    if isempty(handles.curveprops.DynamicProps)
        sensitivity = [];
        springconstant = [];
        return
    else
        curvenames = fieldnames(handles.curveprops.DynamicProps);
    end

    springconstant = cell(length(curvenames), 1);
    sensitivity = cell(length(curvenames), 1);

    % fist: take every loaded curve and iterate over them
    for i = 1:length(curvenames)
        try 
            segments = fieldnames(handles.curveprops.(curvenames{i}).RawData.SpecialInformation);
        catch ME % if you can
            switch ME.identifier
                case 'MATLAB:fieldnames:InvalidInput' % Specialifnormation is empty --> no specialinformation has been found
                    sensitivity = [];
                    springconstant = [];
                    return
                otherwise
                    rethrow(ME);
            end
        end

        % second: take every segment contained in a curve and iterate
        % over it
        segment_springconstant = ones(length(segments), 1);
        segment_sensitivity = ones(length(segments), 1);
        for n = 1:length(segments)
            
            try
                info = handles.curveprops.(curvenames{i}).RawData.SpecialInformation.(segments{i});
            catch ME % if you can
                switch ME.identifier
                    case 'MATLAB:nonExistentField' % only if something went wrong with segmentnames
                        warning(ME.identifier,'%s', ME.message);
                    otherwise
                        rethrow(ME);
                end
            end
            
            if ~isempty(info.springConstant) 
                if isa(info.springConstant{:}, 'char') || isa(info.springConstant{:}, 'string')
                    springconst = str2double(info.springConstant{:});
                else
                    springconst = info.springConstant{:};
                end
            else
                springconst = [];
            end
            if ~isempty(info.sensitivity)
                if isa(info.sensitivity{:}, 'char') || isa(info.sensitivity{:}, 'string')
                    sensi = str2double(info.sensitivity{:});
                else
                    sensi = info.sensitivity{:};
                end
            else
                sensi = [];
            end
            segment_springconstant(n) = springconst;
            segment_sensitivity(n) = sensi;
        end
        springconstant{i} = segment_springconstant;
        sensitivity{i} = segment_sensitivity;
    end % for 

    sensitivity = median(cell2mat(sensitivity));
    springconstant = median(cell2mat(springconstant));

end % CalibrationValues

