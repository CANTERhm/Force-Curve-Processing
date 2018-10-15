function segment_header_edit_callback(src, evt)
% SEGMENT_HEADER_EDIT_CALLBACK process the input to segment_header_edit

% obtain mainHandle-struct
main = findobj(groot, 'Type', 'Figure', 'Name', 'Import Settings');
mainHandles = guidata(main);

segment_header = ProcessInput(src.String);
if ~isempty(segment_header{:})
    mainHandles.settings.segment_header_edit = segment_header;
else
    names = fieldnames(mainHandles.settings);
    if any(ismember(names, 'segment_header_edit'))
        mainHandles.settings = rmfield(mainHandles.settings, 'segment_header_edit');
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
                        note = 'Segment Header must be numeric!';
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

end % segment_header_edit_callback

