function comment_style_edit_callback(src, evt)
% COMMENT_STYLE_EDIT_CALLBACL process the input to comment_style_edit

% obtain mainHandle-struct
main = findobj(groot, 'Type', 'Figure', 'Name', 'Import Settings');
mainHandles = guidata(main);

comment_style = ProcessInput(src.String);
if ~isempty(comment_style{:})
    mainHandles.settings.comment_style_edit = comment_style;
else
    names = fieldnames(mainHandles.settings);
    if any(ismember(names, 'comment_style_edit'))
        mainHandles.settings = rmfield(mainHandles.settings, 'comment_style_edit');
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

end % comment_style_edit_callback

