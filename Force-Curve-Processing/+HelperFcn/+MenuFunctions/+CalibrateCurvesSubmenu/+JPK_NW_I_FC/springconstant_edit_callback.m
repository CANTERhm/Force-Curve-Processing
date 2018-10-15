function springconstant_edit_callback(src, evt, mainHandles)
%SPRINGCONSTANT_EDIT_CALLBACK process input to springconstant_edit on
%calibrate-curves submenu

% get an actual reference to mainHandles
main = findobj(groot, 'Type', 'Figure', 'Name', 'Calibrate Curves');
mainHandles = guidata(main);

springconstant = ProcessInput(src.String);
if ~isempty(springconstant)
    mainHandles.settings.values.springconstant = springconstant;
    src.UserData = springconstant;
% else
%     mainHandles.settings.values.springconstant = src.UserData;
%     names = fieldnames(mainHandles.settings.values);
%     if any(ismember(names, 'springconstant'))
%         mainHandles.settings.values = rmfield(mainHandles.settings.values, 'springconstant');
%     end
end

% update mianHandles-struct
setappdata(mainHandles.mainDialog, 'mainHandles', mainHandles);

%% helper functions

    function processed = ProcessInput(in)
        line = in(1, 1:end);
        line = strtrim(line);
        try
            if ~isempty(line)
                % if input is numeric convert it to double 
                line = eval(line); 
                % unfortunately, eval also works on ' ' and " " so we
                % have to filter those values
                if ~isnumeric(line)
                    msgID = 'MATLAB:UndefinedFunction';
                    msg = 'no input is not a valid input';
                    exception = MException(msgID, msg);
                    throw(exception);
                end
            else
                % empty input is also valid for eval(); we have to
                % filter empty input
                msgID = 'MATLAB:UndefinedFunction';
                msg = 'no input is not a valid input';
                exception = MException(msgID, msg);
                throw(exception);
            end
        catch ME % if you can
            % the switch filters all invalid input to eval()
            switch ME.identifier
                case 'MATLAB:UndefinedFunction' % random series of nonnumerical characters or nothing
                    src.String = src.UserData;
                    line = src.UserData;
                    note = 'Sensitivity must be numeric!';
                    HelperFcn.ShowNotification(note);
                case 'MATLAB:string:MustBeStringScalarOrCharacterVector' % wrong datatype, e.g. cell-array
                    src.String = src.UserData;
                    line = src.UserData;
                    note = 'Sensitivity must be numeric!';
                    HelperFcn.ShowNotification(note);
                case 'MATLAB:m_missing_operator' % mixed input whith nonnumerical and numerical characters
                    src.String = src.UserData;
                    line = src.UserData;
                    note = 'Sensitivity must be numeric!';
                    HelperFcn.ShowNotification(note);
                case 'MATLAB:m_illegal_character' % unsupported symbols, invisible characters or non-ASCII-characters
                    src.String = src.UserData;
                    line = src.UserData;
                    note = 'Sensitivity must be numeric!';
                    HelperFcn.ShowNotification(note);
                case 'MATLAB:m_incomplete_statement' % incomplete Statements (+ or -)
                    src.String = src.UserData;
                    line = src.UserData;
                    note = 'Sensitivity must be numeric!';
                    HelperFcn.ShowNotification(note);
                case 'MATLAB:m_invalid_lhs_of_assignment' % use of =
                    src.String = src.UserData;
                    line = src.UserData;
                    note = 'Sensitivity must be numeric!';
                    HelperFcn.ShowNotification(note);
                case 'MATLAB:m_missing_variable_or_function' % use of an operator like ==, >, : etc.
                    src.String = src.UserData;
                    line = src.UserData;
                    note = 'Sensitivity must be numeric!';
                    HelperFcn.ShowNotification(note);
                otherwise
                    rethrow(ME);
            end
        end
        processed = line;
    end % ProcessInput

end % sensitivity_edit_callback

