function column_specifier_edit_callback(src, evt)
%COLUMN_SPECIFIER_EDIT_CALLBACK process the input to column_specifier_edit

% obtain mainHandle-struct
main = findobj(groot, 'Type', 'Figure', 'Name', 'Import Settings');
mainHandles = guidata(main);

column_specifier = ProcessInput(src.String);
if ~isempty(column_specifier{:})
    mainHandles.settings.column_specifier_edit = column_specifier;
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
            if ~isnan(str2double(line))
                src.String = '';
                note = 'Delimiter must be character-vector or string-scalar!';
                HelperFcn.ShowNotification(note);
            end
            if ~isempty(line)
                input{i} = line; 
            else
                input = [];
            end
        end
        processed = input;
    end % ProcessInput

end % column_specifier_edit_callback

