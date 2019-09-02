function handles = SwitchDisplayStatus(handles)
% SWITCHDISPLAYSTATUS turns the AlreadyDisplayed property of the
% EditFunctions which are not active to "false"

    %% create variabless
    edit_functions = fieldnames(handles.procedure.DynamicProps);
    edit_buttons = flipud(allchild(handles.guiprops.Panels.processing_panel));
    
    % delete proc_root_button from edit_buttons
    mask = arrayfun(@maskfun, edit_buttons);
    edit_buttons = edit_buttons(mask);
    
    %% update AlreadyDisplayed property
    for i = 1:length(edit_buttons)
        if edit_buttons(i).Value == 0
            handles.procedure.(edit_functions{i}).AlreadyDisplayed = false;
        end
    end
end

function y = maskfun(btn)
    if strcmp(btn.Tag, 'procedure_root_btn')
        y = false;
    else
        y = true;
    end
end

