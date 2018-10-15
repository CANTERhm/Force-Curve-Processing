function UpdateSaveCurveStatusCallback(src, evt, handles)
%UPDATESAVECURVESTATUS update save_curve_status label

if ~isempty(handles.guiprops.SavePathObject.path) & (handles.guiprops.SavePathObject.path ~= 0)
    handles.guiprops.Features.save_curve_status.BackgroundColor = 'green';
    handles.guiprops.Features.save_curve_status.TooltipString = handles.guiprops.SavePathObject.path;
    
    % add a context menu for deletion
    cm = uicontextmenu(handles.figure1);
    handles.guiprops.Features.save_curve_status.UIContextMenu = cm;
    uimenu(cm, 'Label', 'clear save path', 'Callback', {@DeleteSavepathCallback, handles});
else
    handles.guiprops.Features.save_curve_status.BackgroundColor = 'red';
   
end
guidata(handles.figure1, handles);

    function DeleteSavepathCallback(src, evt, handles)
        handles.guiprops.SavePathObject.path = [];
        delete(src);
    end

end