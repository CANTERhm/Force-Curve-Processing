function ExecuteAllEditFcn(varargin)
%EXECUTEALLEDITFCN executes all loaded editfunctions in case a new curve
%has been selected or for every other case the editfunctions have to be
%reinvoked

% this function can also be used as an callback. In this case the first two
% input paramters are source-object and event-data

    %% input parser
    p = inputParser;
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    
    parse(p, varargin{:})
    
    src = p.Results.src;
    evt = p.Results.evt;
    
    %% function procedure

    % get latest references to handles and result
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    if ~isempty(main)
        handles = guidata(main);
    else
        % abort, no open fcp-app
        return
    end
    
    if ~isempty(handles.guiprops.Features.edit_buttons)
        editfunctions = fieldnames(handles.guiprops.Features.edit_buttons);
    else
        % no loaded editfunction which has to be invoked
        return
    end
    
    % execute editfunctions
    for i = 1:length(editfunctions)
        try
            EditFunctions.(editfunctions{i}).main();
        catch ME
            switch ME.identifier
                case 'MATLAB:undefinedVarOrClass'
                    % 'Undefined variable "EditFunctions" or class "EditFunctions.functionname.main".'
                    % reason: main does not exists
                    % move on
                case 'MATLAB:badsubscript'
                    % 'Index exceeds array bounds.'
                    % reason: A channel does not have as much choises as in in the
                    % channels-popup-menus are available
                    % move on
                otherwise
                    rethrow(ME);
            end
        end
    end
    
    guidata(handles.figure1, handles);
    
end % ExecuteAllEditFcn

