function handles = AddFunctionsToGui(handles)
% ADDFUNCTIONSTOGUI Add procedure functions to the FCProcessing gui

% procedurelist = fieldnames(handles.procedure.DynamicProps);
panel = handles.guiprops.Panels.processing_panel;
edit_buttons = struct();

if ~isempty(handles.procedure.DynamicProps)
    procedurelist = fieldnames(handles.procedure.DynamicProps);
else
    procedurelist = [];
end

for i = 1:length(procedurelist)
    btn_name = UtilityFcn.Str2Name(procedurelist{i}, '', ' ', 'ExpressionSpecifier', 'CamelCase');
    funcName = procedurelist{i};
    btn = uicontrol('Parent', panel,...
        'Style', 'togglebutton',...
        'Enable', 'off',...
        'String', btn_name,...
        'Tag', funcName,...
        'Interruptible', 'off',...
        'Callback', {@Callbacks.EditProcBtnCallback, handles});
    edit_buttons.(funcName) = btn;
end

elementNumber = length(procedurelist) + 1; % + 1 because of already existing procedure_root_btn
panel.Widths = 120*ones(1, elementNumber);

% update handles-structure
handles.guiprops.Features.edit_buttons = edit_buttons;
handles.guiprops.Panels.processing_panel = panel;
guidata(handles.figure1, handles);