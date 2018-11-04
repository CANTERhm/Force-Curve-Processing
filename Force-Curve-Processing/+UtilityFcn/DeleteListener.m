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
            
            %----------------------------------------------------------
            disp(EditFunction);
            %----------------------------------------------------------

            delete(handles.curveprops.(curvename).Results.(EditFunction).results_listener);
            struct = handles.curveprops.(curvename).Results.(EditFunction);
            struct = struct.delproperty('results_listener');
            handles.curveprops.(curvename).Results.(EditFunction) = struct;
            handles.curveprops.(curvename).Results.(EditFunction).singleton = false;
        catch
            continue
        end
    end
    
%     editfunctions = allchild(handles.guiprops.Panels.processing_panel);
%     editfunctions(end) = [];
%     edit_function = findobj(editfunctions, 'Tag', EditFunction);
%     not_active = editfunctions ~= edit_function;
%     editfunctions = editfunctions(not_active);
%     
%     curves = fieldnames(handles.curveprops.DynamicProps);
%     for i = 1:length(curves)
%         curvename = curves{i};
%         for n = 1:length(editfunctions)
%             try
%                 func = editfunctions(n).Tag;
%                 
%                 %----------------------------------------------------------
%                 disp(func);
%                 %----------------------------------------------------------
%                 
%                 delete(handles.curveprops.(curvename).Results.(func).results_listener);
%                 struct = handles.curveprops.(curvename).Results.(func);
%                 struct = struct.delproperty('results_listener');
%                 handles.curveprops.(curvename).Results.(func) = struct;
%                 handles.curveprops.(curvename).Results.(func).singleton = false;
%             catch
%                 continue
%             end
%         end
%     end
    
    guidata(handles.figure1, handles);

end % DeleteListener

