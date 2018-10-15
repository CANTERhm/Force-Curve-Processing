function delimiter_edit_callback(src, evt)
% DELIMITER_EDIT_CALLBACK process the input to delimiter_edit

% obtain mainHandle-struct
main = findobj(groot, 'Type', 'Figure', 'Name', 'Import Settings');
mainHandles = guidata(main);

segment_header = ProcessInput(src.String);
if ~isempty(segment_header{:})
    mainHandles.settings.delimiter_edit = segment_header;
else
    names = fieldnames(mainHandles.settings);
    if any(ismember(names, 'delimiter_edit'))
        mainHandles.settings = rmfield(mainHandles.settings, 'delimiter_edit');
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
            t = regexp(line,  '^.(\s).|^(\s)', 'tokens');
            if ~isempty(t)
                line = t{1}{:};
            else
                line = strtrim(line);
            end
            if ~isnan(str2double(line))
                src.String = '';
                note = 'Delimiter must be character-vektor or string-scalar!';
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

end % delimiter_edit_callback