function name = Str2Name(str, varargin)
%STR2NAME Creates names for buttons etc. from a formatted str
%   
% 'str' has to be splitted with 'delimiter' and gets 'space' insertet as 
% new delimiter. If delimiter is a withespace (' ') then the new string gets
% concatenated without any withespaces between subsequent parts.
%
% usage: 
%   *nStr = Str2Name(str, delimiter, spacing, ExpressionSpecifier)
%
%   *nStr = Str2Name(str);
%   --> split str according to the matched delimiters which are in str.
%       for Str2Name, delimiters are equal to following 
%       regular expression: \W|_ (any character which is not alphabetic
%       or numeric or the underscore character)
%       
% input:
%   - str: String or char vector, which gets adjusted
%   - delimiter: character, which splits str into parts
%   - spacing: character which gets inserted instead of delimiter
%   - ExpressionSpecifier: Typical word form like CamelCase-style words
%       * split str according to its style. For Example: Consider the word
%       CamelCase. This words get splitted into the parts Camel and Case.
%       spacing will be inserted in between these two parts
%       * available styles are: CamelCase
%
% The ExpressionSpecifier determinds the general type of str. 
% Example: HalloWelt --> ExpressionSpecifier: CamelCase
%
% Dafault delimiter: '_'
% Default spacing: ' '
% Default ExpressionSpecifier: []
% Examples:
%
%   nstr = Str2Name('sdf*sdf*sdf', '*');
%   --> nstr = 'sdf sdf sdf'
%
%   nstr = Str2Name('sdf sdf sdf', ' ');
%   --> nstr = 'sdfsdfsdf'
%
%   nstr = Str2Name('sdf=sdf=sdf', '=', '-');
%   --> nstr = 'sdf-sdf-sdf'
%
%   nstr = Str2Name('HalloWelt', '', '*', 'ExpressionSpecifier', 'CamelCase');
%   --> nstr = 'Hallo*Welt'
%
%   nstr = Str2Name('Johanna+ist^die_Beste');
%   --> nstr is a struct with fields:
%       wordparts: Johanna, ist, die, Beste,
%       delimiter: +, ^, _' []S
%
% notice: nstr remains untouched, if delimiter doesn't occure in str

% input parser
if nargin <= 1
    p = inputParser;
    
    ValidStr = @(s)assert(isa(s, 'char') || isa(s,  'string'),...
        'Str2Name:ValidStr:invalidInput',...
        'Input is not a character vector');
    
    addRequired(p, 'str', ValidStr);
    
    parse(p, str, varargin{:});
    
    str = p.Results.str;
    
else
    p = inputParser;

    ValidStr = @(s)assert(isa(s, 'char') || isa(s,  'string'),...
        'Str2Name:ValidStr:invalidInput',...
        'Input is not a character vector');

    addRequired(p, 'str', ValidStr);
    addOptional(p, 'delimiter', '_', ValidStr);
    addOptional(p, 'spacing', ' ', ValidStr);
    addParameter(p, 'ExpressionSpecifier', '')

    parse(p, str, varargin{:});

    str = p.Results.str;
    delimiter = p.Results.delimiter;
    ExpressionSpecifier = p.Results.ExpressionSpecifier;
    
if strcmp(delimiter, ' ')
    spacing = '';
else
    spacing = p.Results.spacing;
end

end % nargin

% str processing
name = [];
if nargin > 1
    switch ExpressionSpecifier
        case 'CamelCase'
            expression = '([A-Z][a-z]*)';
            matches = regexp(str, expression, 'tokens');
            for i = 1:length(matches)
                name = [name cell2mat(matches{i}) spacing];
            end
        case ''
            str = split(str, delimiter);
            for i = 1:length(str)
                name = [name str{i} spacing];
            end
    end
    if strcmp(name(end), spacing)
        name(end) = [];
    end

    name = strtrim(name);
else
    expression = '[a-zA-Z0-9הצü]*(\W|_)|[a-zA-Z0-9הצü]*';

    [delimiter, match] = regexp(str, expression, 'tokens', 'match');

    names = cell(length(delimiter), 1);
    for i = 1:length(names)
        nStr = split(match{i}, delimiter{i});
        names{i} = nStr{1};
    end
    
    sz = size(delimiter);
    delimiter = reshape(delimiter, sz(2), sz(1));
    
    name.wordparts = names;
    name.delimiter = delimiter;
end
