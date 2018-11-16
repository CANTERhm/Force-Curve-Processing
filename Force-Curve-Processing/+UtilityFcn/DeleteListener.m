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
    
    % get latest references to handles
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    if ~isempty(main)
        handles = guidata(main);
    end
    
    % if there is no eidtfunction input, abort function
    if isempty(EditFunction)
        return
    end
    
    curves = fieldnames(handles.curveprops.DynamicProps);
    for i = 1:length(curves)
        curvename = curves{i};
        try
            listener = handles.curveprops.(curvename).Results.(EditFunction).results_listener;
            listener_handles = listener.ListenerObjects;
            for n = 1:length(listener_handles)
                listener.deleteListener(listener_handles(n));
            end
            struct = handles.curveprops.(curvename).Results.(EditFunction);
            struct = struct.delproperty('results_listener');
            handles.curveprops.(curvename).Results.(EditFunction) = struct;
        catch
            % if an error occurs, skip this loop
            continue
        end
        handles.curveprops.(curvename).Results.(EditFunction).singleton = false;
    end
    
    guidata(handles.figure1, handles);

end % DeleteListener

