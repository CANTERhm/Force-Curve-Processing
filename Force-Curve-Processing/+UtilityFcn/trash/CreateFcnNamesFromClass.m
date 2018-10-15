function funclist = CreateFcnNamesFromClass(class, varargin)
%CREATEFUNCTIONFROMLIST Create a list of functions, which shall be applied
%to the afm data, from a list of methods from EditFunctions-class

%% input parsing
p = inputParser;

addRequired(p, 'class');
addParameter(p, 'Qualifier', []);

parse(p, class, varargin{:});

class = p.Results.class;
Qualifier = p.Results.Qualifier;

%% function procedure
list = methods(class, '-full');
list = split(list, ' ');

switch Qualifier
    case 'static'
        mask = ismember(list, 'Static');
        list = list(mask, :);
        funclist = list(:, 2);
    case []
        funclist = list;
end