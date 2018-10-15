function AddTableDataCallback(src, evt, handles, varargin)
% ADDTABLEDATACALLBACK Add all loaded curves to curve_list_table and Update
% uitable-Data

% input parsing
p = inputParser;
addRequired(p, 'src');
addRequired(p, 'evt');
addRequired(p, 'handles');
parse(p, src, evt, handles, varargin{:});

src = p.Results.src;
evt = p.Results.evt;
handles = p.Results.handles;

% function procedure
table = handles.guiprops.Features.edit_curve_table;

if isa(handles.curveprops.DynamicProps, 'struct')
    curvenames = fieldnames(handles.curveprops.DynamicProps);
else
    curvenames = [];
end
data = cell(length(curvenames), 2);
for i = 1:length(curvenames)
    data{i,1} = curvenames{i};
    data{i,2} = 'unprocessed';
end

table.Data = data;

if ~isempty(table.Data)
    table.UserData.CurrentCurveName = data{1, 1};
    table.UserData.CurrentRowIndex = 1;
    table.UserData.CurrentRowSpan = [1; 1];
end


handles.guiprops.Features.edit_curve_table = table;
guidata(handles.figure1, handles);
