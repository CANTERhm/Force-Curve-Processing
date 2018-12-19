function SwitchToggleState(src, varargin)
%SWITCHTOGLESSTATE applies the desired behavior of edit procedure
%toggelbuttons
%
% input:
%   - src: object, which toggle state should be switched
%   - obj_list: optional property, a cell-array, containing a list of
%   switchable gui elements, which shall be switched off if src is set true

%% input parsing
p = inputParser;

ExpectedStyles = {'togglebutton', 'checkbox'};
ValidStyles = @(x)assert(any(validatestring(x, ExpectedStyles)), 'SwitchToggleState:wrongStyle',...
    'input was not an expected style for toggle-element.');

addRequired(p, 'src');
addOptional(p, 'obj_list', []);
addParameter(p, 'style', 'togglebutton', ValidStyles)

parse(p, src, varargin{:});

src = p.Results.src;
obj_list = p.Results.obj_list;
style = p.Results.style;

%% function procedure

switch style
    case 'togglebutton' % make sure, only switching another togglebutton can deactivate src
        if src.Value == 0
            src.Value = 1;
        end
    case 'checkbox' % every other checkbox gets unchecked
        if src.Value == 0
            src.Value = 1;
        else
            src.Value = 0;
        end
end

% if src.Value == 1, set every other toggleelemt.Value == 0
if isempty(obj_list)
    list = allchild(src.Parent);
else
    list = obj_list;
end
mask = list ~= src;
list = list(mask);
for i = 1:length(list)
    if ~isa(list, 'cell')
        list(i).Value = 0;
    else
        list{i}.Value = 0;
    end
end 


