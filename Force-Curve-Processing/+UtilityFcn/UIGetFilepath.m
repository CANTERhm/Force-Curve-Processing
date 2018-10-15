function handles = UIGetFilepath(handles, varargin)
%UIGETFILEPATHCALLBACK Dialog for asking the location of desired force-curves

%% input parsing
p = inputParser;

ValidStr = @(x)assert(isa(x, 'char') | isa(x, 'string'),...
    'FCProcessing:UIGetFilepath:invalidInput',...
    'input of mSelect was not a valid character-vector or a valid string-scalar');

ValidmSelectStr = @(x)assert((isa(x, 'char') | isa(x, 'string')) & any(validatestring(x, {'on', 'off'})),...
    'FCProcessing:UIGetFilepath:invalidInput',...
    'input of mSelect was not "on", "off", a valid character-vector or a valid string-scalar');

addRequired(p, 'handles');
addOptional(p, 'pathObject', 'FilePathObject', ValidStr);
addParameter(p, 'mSelect', 'on', ValidmSelectStr);

parse(p, handles, varargin{:});

handles = p.Results.handles;
pathObject = p.Results.pathObject;
mSelect = p.Results.mSelect;

%% function procedure
if isempty(handles.guiprops.(pathObject))
    filepath = FilePath();
else
    filepath = handles.guiprops.(pathObject);
end

% setup the uigetfile-filter parameter
list = afm.AllowedFileSpecifiers;

format = repmat('%s; ', 1, length(list));
format = strtrim(format);
format(end) = [];
filter_list = sprintf(format, list{:});

format = repmat('%s, ', 1, length(list));
format = strtrim(format);
format(end) = [];
format = sprintf(format, list{:});
filter_description = ['Force-Curve Files (' format ')'];

filepath.filter = {filter_list, filter_description; '*.*', 'All Files (*.*)'};
filepath = filepath.uigetfile('mSelect', mSelect);

handles.guiprops.(pathObject) = filepath;
guidata(handles.figure1, handles)

