function handles = DeleteFunctionsFromAppdata(handles)
%DELETEFUNCTIONSFROMAPPDATA Cleanup AppData after Editfunctions are deleted
%from edit_functions_panel on FCP-App

edit_buttons = handles.guiprops.Features.edit_buttons;
appdata = fieldnames(getappdata(handles.figure1));
if ~isempty(edit_buttons)
    functionnames = fieldnames(edit_buttons);
else
    return
end

for i = 1:length(functionnames)
    if any(ismember(appdata, functionnames{i}))
        rmappdata(handles.figure1, functionnames{i});
    end
end

guidata(handles.figure1, handles);