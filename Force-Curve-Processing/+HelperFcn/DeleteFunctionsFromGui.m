function handles = DeleteFunctionsFromGui(handles)
%DELETEFUNCTIONSFROMGUI Delete All Edit-Function-Buttons from gui

edit_buttons = handles.guiprops.Features.edit_buttons;
if ~isempty(edit_buttons)
    names = fieldnames(edit_buttons);
else
    names = [];
end

if ~isempty(names)
    for i = 1:length(names)
        delete(edit_buttons.(names{i}));
        handles.procedure.delproperty(names{i});
    end
end

handles.procedure.DynamicProps = [];
handles.guiprops.Features.edit_buttons = [];
handles.guiprops.Features.proc_root_btn.Value = 1;
guidata(handles.figure1, handles);

