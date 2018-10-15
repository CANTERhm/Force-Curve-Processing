function handles = CreateProcedureFunctions(handles)
%CREATEPROCEDUREFUNCTIONS Creates a FCProcedure-object form procedurefile

%% input parsing
p = inputParser;

addRequired(p, 'handles');

parse(p, handles);

handles = p.Results.handles;

%% method procedure

% Read Procedures from procedure-file
filename = handles.guiprops.ProcedureFilePathObject.files;
if isa(filename, 'cell')
    filename = filename{:};
end
path = handles.guiprops.ProcedureFilePathObject.path;
file = [path '\' filename];
% if ~isa(filename, 'cell') && filename ~= 0
%     file = handles.guiprops.ProcedureFilePathObject.path;
% end
object = handles.procedure;
object = object.ReadProcedureFile(file);

% update handles-struct
handles.procedure = object;
guidata(handles.figure1, handles);


