function fixed_column_edit_callback(src, evt)
% FIXED_COLUMN_EDIT_CALLBACK process the input to fixed_column_edit

% obtain mainHandle-struct
main = findobj(groot, 'Type', 'Figure', 'Name', 'Import Settings');
mainHandles = guidata(main);

fixed_column = ProcessInput(src.String);
if ~isempty(fixed_column{:})
    mainHandles.settings.column_specifier_edit = fixed_column;
else
    names = fieldnames(mainHandles.settings);
    if any(ismember(names, 'column_specifier_edit'))
        mainHandles.settings = rmfield(mainHandles.settings, 'column_specifier_edit');
    end
end

% update mianHandles-struct
guidata(mainHandles.mainDialog, mainHandles)

%% helper functions

    function processed = ProcessInput(in)
        sz = size(in);
        input = cell(sz(1), 1);
        for i = 1:sz(1)
            line = in(i, 1:end);
            line = strtrim(line);
            try
                if ~isempty(line)
                    line = eval(line); % if input is numeric convert it to double
                end
            catch ME % if you can
                switch ME.identifier
                    case 'MATLAB:UndefinedFunction'
                        src.String = '';
                        note = 'Fixed Colum must be numeric!';
                        HelperFcn.ShowNotification(note);
                    otherwise
                        rethrow(ME);
                end
            end
            if ~isempty(line)
                input{i} = line; 
            else
                input = [];
            end
        end
        processed = input;
    end % ProcessInput

end % fixed_column_edit_callback

