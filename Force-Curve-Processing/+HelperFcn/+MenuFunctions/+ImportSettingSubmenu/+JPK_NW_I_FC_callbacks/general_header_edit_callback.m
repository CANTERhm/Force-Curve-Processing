function general_header_edit_callback(src, evt)
% GENERAL_HEADER_CALLBACK process the input to general_header_edit

% obtain mainHandle-struct
main = findobj(groot, 'Type', 'Figure', 'Name', 'Import Settings');
mainHandles = guidata(main);

general_header = ProcessInput(src.String);
if ~isempty(general_header)
    mainHandles.settings.general_header_edit = general_header;
else
    names = fieldnames(mainHandles.settings);
    if any(ismember(names, 'general_header_edit'))
        mainHandles.settings = rmfield(mainHandles.settings, 'general_header_edit');
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
                        note = 'General Header must be numeric!';
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

end % general_header_callback

