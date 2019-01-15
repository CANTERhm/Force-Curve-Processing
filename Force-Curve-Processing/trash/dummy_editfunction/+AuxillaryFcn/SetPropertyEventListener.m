function SetPropertyEventListener(varargin)
%SETPROPERTYEVENTLISTENER PropertyEventListener for results-object
%   Sets the property event listener neccessary to keep the graphical input
%   and output elemnts updated. This Listener objects listen to changes of
%   properties in the results-object of each editfunction.
%
%   Don´t forget to replace all occurances from EditFunction with the
%   current EditFunction name!!

    %% handles and results-object
    [~, handles, results] = GetCommonVariables('EditFunction');

    %% general listeners 
    % if results_listener property has been removed 
    if ~isprop(results, 'property_event_listener')
        results.addproperty('property_event_listener');
        results.property_event_listener = PropListener();
    end

    % delete all listeners, if EditFunction is not acitve
    editfunctions = handles.guiprops.Features.edit_buttons;
    EditFunctionFcn = editfunctions.EditFunction;
    results.property_event_listener.addListener(EditFunctionFcn.UserData.on_gui, 'Status', 'PostSet',...
        {@Callbacks.DeleteListenerCallback, EditFunctionFcn}); 
    
    % event listener to update handles.curveprops.curvename.Results.Baseline
    % This step is important, because it update the handles-struct; it is
    % kind of an output from EditFunction
    results.property_event_listener.addListener(results, 'UpdateObject',...
    @EditFunctions.EditFunction.Callbacks.UpdateResultsToMain);
    
    %% specific listeners
    % do stuff

    %% update handles and results-object
    PublishResults('EditFunction', handles, results);

end % SetPropertyEventListener

