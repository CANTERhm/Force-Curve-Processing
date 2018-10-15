function CompleteProcessingBtnCallback(src, evt, handles)
% COMPLETEPROCESSINGBTNCALLBACK Executes if Complete Processing Butonn on
% FCProcessing has been pressed

if isempty(handles.guiprops.Features.edit_curve_table.Data)
    return
end

if isempty(handles.guiprops.SavePathObject.path)
    answer = questdlg('Specify a Savepath now?', 'No Savepath has been specified',...
        'Yes', 'No',...
        'Yes');
    switch answer
        case 'Yes'
            handles = UtilityFcn.UISetSavepath(handles);
            guidata(handles.figure1, handles);
        case 'No'
            return
    end
end

% obtain handles for specific gui elements
table = handles.guiprops.Features.edit_curve_table;


% obtain specific elementinformation
table_stat = table.Data(:,2);
curves = fieldnames(handles.curveprops.DynamicProps);
loadpath = handles.guiprops.FilePathObject.path;
savepath = handles.guiprops.SavePathObject.path;
oldpath = pwd;

% determine curve status
processed_mask = ismember(table_stat, 'processed');
unprocessed_mask = ismember(table_stat, 'unprocessed');
discarded_mask = ismember(table_stat, 'discarded');

% obtain curves
cd(loadpath);
list = dir();

isdir = false(length(list), 1);
for i = 1:length(list)
    if list(i).isdir
        isdir(i) = true;
    end
end
list = list(~isdir);

processed = list(processed_mask);
unprocessed = list(unprocessed_mask);
discarded = list(discarded_mask);

% create new directories for processed, unprocessed and discarded curves
cd(savepath);

% overwrite existing results folder
if exist('results', 'dir')
    rmdir('results', 's');
end

mkdir results
cd('results')

mkdir processed
mkdir unprocessed
mkdir discarded

% copy processed
cd('processed');
processed_path = pwd;
for i = 1:length(processed)
    file = fullfile(processed(i).folder, processed(i).name);
    copyfile(file, processed_path);
end
cd('..');

% copy unprocessed
cd('unprocessed');
unprocessed_path = pwd;
for i = 1:length(unprocessed)
    file = fullfile(unprocessed(i).folder, unprocessed(i).name);
    copyfile(file, unprocessed_path);
end
cd('..');

% copy discarded
cd('discarded');
discarded_path = pwd;
for i = 1:length(discarded)
    file = fullfile(discarded(i).folder, discarded(i).name);
    copyfile(file, discarded_path);
end
cd('..');

cd(oldpath);

note = sprintf('results saved to: \n%s', savepath);
HelperFcn.ShowNotification(note)

% update handles-structure
handles.curveprops.Saved = true;
guidata(handles.figure1, handles)
