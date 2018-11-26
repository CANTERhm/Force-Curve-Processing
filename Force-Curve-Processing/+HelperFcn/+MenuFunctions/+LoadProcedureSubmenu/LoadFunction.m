function handles = LoadFunction(handles)
%LOADFUNCTION load procedure subfunction
%   this implementation allows to use uiwait, to ensure the hole edit
%   procedure has been loaded properly

handles = HelperFcn.LoadEditFunctions(handles);


% to load all listeners to editbuttons propertly and to set on_gui.Status 
% of every edit button properly: set the on_gui.Status property of
% proc_root_btn == true
src = handles.guiprops.Features.proc_root_btn;
HelperFcn.SwitchToggleState(src);
src.UserData.on_gui.Status = true;


end % end LoadFunction

