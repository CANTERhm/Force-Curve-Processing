function search_query_edit_callback(src, evt)
% SEARCH_QUERY_EDIT_CALLBACK process the input to search_query_edit

% obtain mainHandle-struct
main = findobj(groot, 'Type', 'Figure', 'Name', 'Import Settings');
mainHandles = guidata(main);

search_query = ProcessInput(src.String);
if ~isempty(search_query)
    mainHandles.settings.search_query_edit = search_query;
else
    names = fieldnames(mainHandles.settings);
    if any(ismember(names, 'search_query_edit'))
        mainHandles = rmfield(mainHandles.settings, 'search_query_edit');
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

end % search_query_edit_callback