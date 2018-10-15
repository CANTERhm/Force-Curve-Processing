function capture_last_value(src, evt)
%CAPTURE_LAST_VALUE captures the last value of sensitivity_edit or
%springconstant_edit, befor changing it

last = ProcessInput(src.String);
src.UserData.LastValue = last;

%% helper functions

    function processed = ProcessInput(in)
        % if input is of size nx1 we only want the first line (1x1)
        line = in(1, 1:end);
        if strcmp(line, 'NaN')
            processed = NaN;
        end
        num = str2double(line);
        if isnan(num)
            processed = NaN;
        else 
            processed = line;
        end
    end % process_input

end % capture_last_value

