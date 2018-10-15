function handles = UpdateProcInformationLabels(handles)
% UPDATEPROCINFORMATIONLABELS Update processing informatioin labels

% obtain handles for specific gui elements
table = handles.guiprops.Features.edit_curve_table;
processed_label = handles.guiprops.Features.count_processed_num;
unprocessed_label = handles.guiprops.Features.count_unprocessed_num;
discarded_label = handles.guiprops.Features.count_discarded_num;

% obtain specific elementinformation
table_stat = table.Data(:,2);

% update labels in processing_information_panel
if isempty(table.Data)
    p_text = '...';
    up_text = '...';
    d_text = '...';
else
    p = table_stat(ismember(table_stat, 'processed'));
    up = table_stat(ismember(table_stat, 'unprocessed'));
    d = table_stat(ismember(table_stat, 'discarded'));
    p_text = num2str(length(p));
    up_text = num2str(length(up));
    d_text = num2str(length(d));
end

processed_label.String = p_text;
unprocessed_label.String = up_text;
discarded_label.String = d_text;

% update handles-structure
handles.guiprops.Features.count_processed_num = processed_label;
handles.guiprops.Features.count_unprocessed_num = unprocessed_label;
handles.guiprops.Features.count_discarded_num = discarded_label;
handles.guiprops.Features.edit_curve_table = table;

guidata(handles.figure1, handles);

