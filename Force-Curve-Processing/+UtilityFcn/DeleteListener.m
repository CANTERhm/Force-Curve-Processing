function DeleteListener(varargin)
%DELETELISTENER Deletes all results_listener object for editfunctions which
%are not active

    %% input parser
    p = inputParser;
    
    ValidCharacter = @(x)assert(isa(x, 'char') || isa(x, 'string'),...
        'CalculateCorrection:invalidInput',...
        'Input is not a character-vector or a string-scalar.');
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    addParameter(p, 'EditFunction', [], ValidCharacter);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
    EditFunction = p.Results.EditFunction;
    
    %% function procedure
    
    % if there is no eidtfunction input, abort function
    if isempty(EditFunction)
        return
    end
    
    % get latest references to handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    if ~isempty(main)
        handles = guidata(main);
        results = getappdata(handles.figure1, EditFunction);
    end
    
    if ~isempty(results)
        if isprop(results, 'property_event_listener')
            listeners = results.property_event_listener;
            listener_handles = listeners.ListenerObjects;
            for i = 1:length(listener_handles)
                listeners.deleteListener(listener_handles(i));
            end
        end
        if isprop(results, 'external_event_listener')
            listeners = results.external_event_listener;
            listener_handles = listeners.ListenerObjects;
            for i = 1:length(listener_handles)
                listeners.deleteListener(listener_handles(i));
            end
        end
        % finally delete results-object
        delete(results);
    end
    
    % remove Editfunction from appdata and update handles
    try
        rmappdata(handles.figure1, EditFunction);
    catch ME
        switch ME.identifier
            case 'MATLAB:HandleGraphics:Appdata:InvalidPropertyName'
                % 'Invalid user property: EditFunction.'
                % reason: try to remove an not existing field from appdata
                % move on
            otherwise
                rethrow(ME);
        end
    end
    guidata(handles.figure1, handles);

end % DeleteListener

