function main_ok_button_callback(src, evt)
%MAIN_OK_BUTTON_CALLBACK processes the ok_button-event on main

% obtain mainHandle-struct
main = findobj(groot, 'Type', 'Figure', 'Name', 'Import Settings');
mainHandles = guidata(main);

% write all customized properties to curveprops.settings all 
handles = mainHandles.handles;
names = fieldnames(mainHandles.settings);

% % update curve_type_status and easy_import_status on 
% % FCP-App processing information panel
% curve_type_status = handles.guiprops.Features.curve_type_status;
% curve_type_status.String = mainHandles.settings.InformationStyle;
% easy_import_status = handles.guiprops.Features.easy_import_status;
% string = mat2str(mainHandles.settings.EasyImport);
% string(1) = upper(string(1));
% easy_import_status.String = string;

if any(ismember(names, 'general_header_edit'))
    handles.curveprops.settings.GeneralHeaderLength = mainHandles.settings.general_header_edit{:};
end
if any(ismember(names, 'segment_header_edit'))
    handles.curveprops.settings.SegmentHeaderLength = mainHandles.settings.segment_header_edit{:};
end
if any(ismember(names, 'delimiter_edit'))
    handles.curveprops.settings.Delimiter = mainHandles.settings.delimiter_edit{:};
end
if any(ismember(names, 'comment_style_edit'))
    handles.curveprops.settings.Comments = mainHandles.settings.comment_style_edit{:};
end
if any(ismember(names, 'column_specifier_edit'))
    handles.curveprops.settings.ColumnSpecifier = mainHandles.settings.column_specifier_edit{:};
end
if any(ismember(names, 'search_query_edit'))
    handles.curveprops.settings.SearchQuery = mainHandles.settings.search_query_edit;
end
if any(ismember(names, 'InformationStyle'))
    handles.curveprops.settings.InformationStyle = mainHandles.settings.InformationStyle;
    
    % update curve_type_status on 
    % FCP-App processing information panel
    curve_type_status = handles.guiprops.Features.curve_type_status;
    curve_type_status.String = mainHandles.settings.InformationStyle;
end
if any(ismember(names, 'EasyImport'))
    handles.curveprops.settings.EasyImport = mainHandles.settings.EasyImport;
    
    % easy_import_status on 
    % FCP-App processing information panel
    easy_import_status = handles.guiprops.Features.easy_import_status;
    string = mat2str(mainHandles.settings.EasyImport);
    string(1) = upper(string(1));
    easy_import_status.String = string;
end
if any(ismember(names, 'CurvePartIdx'))
    handles.curveprops.CurvePartIndex.trace = mainHandles.settings.CurvePartIdx.trace;
    handles.curveprops.CurvePartIndex.retrace = mainHandles.settings.CurvePartIdx.retrace;
end
delete(main)