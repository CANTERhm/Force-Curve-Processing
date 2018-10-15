function handles = SaveCurveSubmenuFcn(handles)
%SAVECURVESUBMENUFCN Executes at save_curve_submenu_callback evaluation

% Save Path Dialog
d = dialog('Name', 'Change Save Path',...
    'Units', 'normalized',...
    'Position', [0.3 0.5 0.2 0.13]);

save_vbox = uix.VBox('Parent', d,...
   'Padding', 10);
uicontrol('Parent', save_vbox,...
    'Style', 'text',...
    'HorizontalAlignment', 'left',...
    'String', 'Current Save Path:');
path = uicontrol('Parent', save_vbox,...
    'Style', 'edit',...
    'HorizontalAlignment', 'left',...
    'String', handles.guiprops.SavePathObject.path);

save_BtnGroup = uix.HButtonBox('Parent', save_vbox,...
    'HorizontalAlignment', 'right',...
    'Spacing', 10);
uicontrol('Parent', save_BtnGroup,...
    'Style', 'pushbutton',...
    'String', 'Browse',...
    'Callback', @save_browse_button_callback);
uicontrol('Parent', save_BtnGroup,...
    'Style', 'pushbutton',...
    'String', 'Ok',...
    'Callback', @save_ok_button_callback)
uicontrol('Parent', save_BtnGroup,...
    'Style', 'pushbutton',...
    'String', 'Clear',...
    'Callback', @save_clear_button_callback);

save_vbox.Heights = [20 30 100];
save_BtnGroup.ButtonSize = [75, 25];

handles.listeners.addListener(handles.guiprops.SavePathObject, 'path', 'PostSet',...
    @update_path_callback);

    function save_ok_button_callback(src, evt)
        save = path.String;
        status = exist(save, 'file');
        if status ~= 0
            handles.guiprops.SavePathObject.path = save;
            guidata(handles.figure1, handles);
            delete(d);
        else
            path.String = [];
            note = sprintf('Input was not a vild Path: \n"%s"', save);
            HelperFcn.ShowNotification(note)
        end
    end
        
    function save_clear_button_callback(src, evt)
        handles.guiprops.SavePathObject.path = [];
        guidata(handles.figure1, handles);
        delete(handles.guiprops.Features.save_curve_status.UIContextMenu);
    end
        
    function save_browse_button_callback(src, evt)
        handles = UtilityFcn.UISetSavepath(handles);
        guidata(handles.figure1, handles);
    end
        
    function update_path_callback(src, evt)
        try
            path.String = handles.guiprops.SavePathObject.path;
        catch ME % if you can
            switch ME.identifier
                case 'MATLAB:class:InvalidHandle'
                    return
                otherwise
                    rethrow(ME)
            end
        end
    end

end