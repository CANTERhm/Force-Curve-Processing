function DeleteListenerCallback(src, evt, EditFunction)
%DELETELISTENERCALLBACK Summary of this function goes here

    if EditFunction.UserData.on_gui.Status == false
        UtilityFcn.DeleteListener('EditFunction', EditFunction.Tag);
    end

end % DeleteListenerCallback

