function EditProcBtnCallback(src, evt, handles)
%EDITPROCBTNCALLBACK Callback for buttons on edit procedure list

% behavior for Togglebuttons
HelperFcn.SwitchToggleState(src);

%% execute edit function
name = src.Tag;
UtilityFcn.ResetMainFigureCallbacks();
try
    EditFunctions.(name).main();
catch ME
    switch ME.identifier
        case 'MATLAB:subscripting:classHasNoPropertyOrMethod'
            % message: 'The class EditFunctions has no Constant property or Static method named 'SomeFunction'.'
            % reason: the editfunction specified by "name" does not exist
            % solution: move on
        case 'MATLAB:structRefFromNonStruct'
            % message: 'Dot indexing is not supported for variables of this type.'
            % reasion: not sure
            % solution: move on
        otherwise
            rethrow(ME);
    end
    note = sprintf('Error invoking "%s": No such EditFunction', name);
    HelperFcn.ShowNotification(note);
end
