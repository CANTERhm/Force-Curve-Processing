function FcnBtnCallback(src, evt, panel)
%EDITBUTTONCALLBACK Callback for Edit Function Buttons; not the buttons on
% edit_procedure_panel

% set up the edit procedure buttons
parfig = findobj('Tag', 'figure1');
handles = guidata(parfig);
list = handles.guiprops.procedure;
funcs = handles.guiprops.procedure_functions;
name = src.String;

% becaus name can contain whitespaces, one has to remove them to create
% valid struct names --> Str2Name can do this
struct_name = UtilityFcn.Str2Name(name, ' ');
    
proc_btn = uicontrol('Parent', panel,...
    'Style', 'togglebutton',...
    'String', name,...
    'Callback', @Callbacks.EditProcBtnCallback);
panel.Widths = 120*ones(1,length(panel.Children));

% create property name for new edit procedure btn
list = [list; struct_name];
mask = ismember(list, struct_name);
redundant = list(mask);
PropertyName = [struct_name num2str(length(redundant))];

proc_btn.Tag = 'proc_btn';
proc_btn.UserData.PropertyName = PropertyName;
proc_btn.UserData.FunctionName = struct_name;
funcs = [funcs; PropertyName];
handles.guiprops.addproperty(['proc_btn_' PropertyName], 'prophandle', proc_btn);
handles.guiprops.procedure = list;
handles.guiprops.procedure_functions = funcs;
guidata(parfig, handles);

% add a context menu for deletion
cm = uicontextmenu(parfig);
cm.UserData.proc_btn = proc_btn;
proc_btn.UIContextMenu = cm;
uimenu(cm, 'Label', 'delete', 'Callback', {@DeleteBtnCallback, proc_btn});

% Delete Callback for edit procedure buttons
    function DeleteBtnCallback(src, evt, proc_btn)
        c = allchild(groot);
        p = c(1);
        h = guidata(p);
        keep_proc_mask = ~ismember(h.guiprops.procedure_functions, proc_btn.UserData.PropertyName);
        
        % update guipropsd
        h.guiprops.delproperty([proc_btn.Tag '_' proc_btn.UserData.PropertyName]);
        h.guiprops.procedure_functions = h.guiprops.procedure_functions(keep_proc_mask);
        
        % update curveprops
        curvelist = fieldnames(h.curveprops.DynamicProps);
        for i = 1:length(curvelist)
            h.curveprops.(curvelist{i}).Results.delproperty(proc_btn.UserData.PropertyName);
        end
        
        % delete button
        delete(proc_btn);
        
        % update handles-stucture
        guidata(p, h);
    end
end