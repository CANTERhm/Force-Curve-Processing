function fixed_column_checkbox_callback(src, evt, object1, object2)
% FIXED_COLUMN_CHECKBOX_CALLBACK processes the value change from
% fixed_column_checkbox

% obtain mainHandle-struct
main = findobj(allchild(groot), 'Type', 'Figure', 'Name', 'Import Settings');
mainHandles = guidata(main);


% obtain importand handles to affected uicontrols
checkbox = evt.AffectedObject;
col_specifier = object1; % column_specifier_edit
fixed_col = object2; % fixed_column_eidt

if checkbox.Value == checkbox.Max
    col_specifier.Enable = 'off';
    fixed_col.Enable = 'on';
    
    % delete disabled handle form mainHandles-struct
    names = fieldnames(mainHandles.settings);
    if any(ismember(names, 'column_specifier_edit'))
        mainHandles.settings = rmfield(mainHandles.settings, 'column_specifier_edit');
    end
else
    col_specifier.Enable = 'on';
    fixed_col.Enable = 'off';
    
    % delete disabled handle form mainHandles-struct
    names = fieldnames(mainHandles.settings);
    if any(ismember(names, 'fixed_column_eidt'))
        mainHandles.settings = rmfield(mainHandles.settings, 'fixed_column_eidt');
    end
end

% update mianHandles-struct
guidata(mainHandles.mainDialog, mainHandles)

end % fixed_column_checkbox_callback

