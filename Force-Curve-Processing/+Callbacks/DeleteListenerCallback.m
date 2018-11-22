function DeleteListenerCallback(src, evt, EditFunction)
%DELETELISTENERCALLBACK Summary of this function goes here

%     % get latest references to handles
%     main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
%     if ~isempty(main)
%         handles = guidata(main);
%     end
%     
%     editfunctions = allchild(handles.guiprops.Panels.processing_panel);
%     edit_function = findobj(editfunctions, 'Tag', EditFunction);
%     
%     if isempty(edit_function)
%         % no editfunctions have been loaded
%         return
%     end
%     
%     if edit_function.Value == 0
%         UtilityFcn.DeleteListener('EditFunction', EditFunction);
%     end
    if EditFunction.UserData.on_gui.Status == false
        UtilityFcn.DeleteListener('EditFunction', EditFunction.Tag);
    end
    
end % DeleteListenerCallback

