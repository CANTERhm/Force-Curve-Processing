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
        case 'MATLAB:undefinedVarOrClass'
            % message: 'Undefined variable "EditFunctions" or class "EditFunctions.<SomeFunction>.main".'
            % reason: The editfunction specified by "name" does not exist
            % solution: Leave a note and move on
            note = sprintf('Error invoking "%s": No such EditFunction', name);
            HelperFcn.ShowNotification(note);
        otherwise
            rethrow(ME);
    end
end
