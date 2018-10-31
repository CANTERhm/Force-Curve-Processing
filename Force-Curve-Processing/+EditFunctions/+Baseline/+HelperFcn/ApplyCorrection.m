function ApplyCorrection(varargin)
%APPLYCORRECTION applys calculated correction to afm-data
%
% input parameter:
%   - if used as an Callback the first two paramteres are source-data and
%     event-data 
%
% Name-Value-Pairs
%   - EditFunction: char-vector or string-scalar, determining from which
%   editfunction the calculated_data property should be taken from;
%   default: the last editfunction (left from the active one on gui)
%
%   - RawData: char-vector or string-scalar, determinting the afm-object
%   containing the RawData if calculated_data form active editfunction or
%   last editfunction is empty
%   default: RawData from currently shown curve

    %% input parser
    p = inputParser;
    
    ValidCharacter = @(x)assert(isa(x, 'char') || isa(x, 'string'),...
        'CalculateCorrection:invalidInput',...
        'Input is not a character-vector or a string-scalar.');
    
    addOptional(p, 'src');
    addOptional(p, 'evt');
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
    addParameter(p, 'EditFunction', 'Baseline', ValidCharacter);
    addParameter(p, 'RawData', [], ValidCharacter);
    
    %% function procedure
    
    % get latest references to handles and result
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    if ~isempty(main)
        handles = guidata(main);
        results = getappdata(handles.figure1, EditFunction);
    else
        % abort, no open fcp-app
        return
    end
    

end % ApplyCorrection

