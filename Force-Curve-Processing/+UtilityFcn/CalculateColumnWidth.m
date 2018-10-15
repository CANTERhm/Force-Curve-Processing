function varargout = CalculateColumnWidth(uitable, col_fractions)
%CALCULATECOLUMNWIDTH calculate columnwidht of uitable to fit into
%tablewindow
%
%   uitable: uitable-object to calculate the widths
%   col_fractions: row-vector of relative column widths; length of this
%   vector must match the real columnnumber in the uitable
%
%   output:
%       varargout{1}: row vector of column widths

% input parsing
p = inputParser;

addRequired(p, 'uitable');
addRequired(p, 'col_fractions');

parse(p, uitable, col_fractions);

uitable = p.Results.uitable;
col_fractions = p.Results.col_fractions;

% function procedure

% set uitable column width to a detemined width
col_width = 10*ones(1, length(col_fractions));
col_width = num2cell(col_width);
uitable.ColumnWidth = col_width;

% capture some is-values from cuurent table state
table_window_width = uitable.Position(3);
table_content_width = uitable.Extent(3);

% calculate optimal columnwidht based on col_fractions
blank_space = table_window_width - table_content_width;
if blank_space < 0
    blank_space = -1*blank_space;
end

rowname_col_width = table_window_width - blank_space;
for i = 1:length(col_width)
    rowname_col_width = rowname_col_width - col_width{i};
end

col_data_width = table_window_width - rowname_col_width;

for i = 1:length(col_width)
    col_width{i} = col_data_width*col_fractions(i);
end

uitable.ColumnWidth = col_width;

% determine output
varargout{1} = col_width;


