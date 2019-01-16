function PublishResults(EditFunction, handles, results, varargin)
%PUBLISHRESULTS publish calculated results to results-object
%   trigger ´UpdateResultsToMain´ to update 
%   ´handles.curveprops.curvename.Results.Editfunction´
%
% Input:
%   - EditFunction: String; determines the name of the Editfunction to
%                   update in handles-struct
%   - handles: FCP-App´s handles-structure
%   - restuls: Editfunction´s results-object
%
% Name/ Value Pair:
%   - 'GuiStatus', Boolean; true if Editfunction is already on FCP-App
%   - 'FireEvent', Boolean; default is false. If True, fires the
%                           ´UpdateObject´ event of results

    %% input parsing
    p = inputParser;
    
    BoolInput = @(x)assert(isa(x, 'logical'),...
        'PublishResults:invalidInput',...
        'Input to GuiStatus was not logical.');
    
    StrInput = @(x)assert(isa(x, 'string') || isa(x, 'char'),...
        'PublishResults:invalidInput',...
        'Input to EditFunction was not a string-scalar or an character-vector.');
    
    StructInput = @(x)assert(isa(x, 'struct'),...
        'PublishResults:invalidInput:',...
        'Input to handles was not a structure.');
    
    ObjectInput = @(x)assert(isobject(x),...
        'PublishResults:invalidInput',...
        'Input to results was not a Matlab-Object.');
    
    addRequired(p, 'EditFunction', StrInput);
    addRequired(p, 'handles', StructInput);
    addRequired(p, 'results', ObjectInput);
    addParameter(p, 'GuiStatus', [], BoolInput);
    addParameter(p, 'FireEvent', false, BoolInput);
    
    parse(p, EditFunction, handles, results, varargin{:});
    
    EditFunction = p.Results.EditFunction;
    handles = p.Results.handles;
    results = p.Results.results;
    GuiStatus = p.Results.GuiStatus;
    FireEvent = p.Results.FireEvent;
    
    %% function procedure
    setappdata(handles.figure1, EditFunction, results);
    guidata(handles.figure1, handles);
    
    if FireEvent
        results.FireEvent('UpdateObject');
    end
    
    % delete results-object if edit function is not active, after all tasks
    % are done
    if ~isempty(GuiStatus)
        if ~GuiStatus
            UtilityFcn.DeleteListener('EditFunction', EditFunction);
        end
    end

end % PublishResults

