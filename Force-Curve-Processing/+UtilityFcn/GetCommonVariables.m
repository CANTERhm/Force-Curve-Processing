function [varargout] = GetCommonVariables(EditFunction)
%GETCOMMONVARIABLES get the most commonly used variables within EditFunction
%
% most commonly used varaibles are:
%   - main: MainFigure of FCP-App
%   - handles: handles-struct of FCP-App
%   - results: results-object of EditFunction
%
% Input:
%   - EditFunction: String; name of the Editfunction from which to obtain
%                   results-object
%
% Output:
%   - varargout{1}: main
%   - varargout{2}: handles
%   - varargout{3}: results

    %% input parsing
    p = inputParser;
    
    StrInput = @(x)assert(isa(x, 'String') || isa(x, 'char'),...
        'GetCommonVariables:invalidInput',...
        'Input for EditFunction was not a string-scalar or a character-vector.');
    
    addRequired(p, 'EditFunction', StrInput);
    
    parse(p, EditFunction);
    
    EditFunction = p.Results.EditFunction;

    %% function procedure
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, EditFunction);
    
    %% assign output
    varargout{1} = main;
    varargout{2} = handles;
    varargout{3} = results;
end % GetCommonVariables

