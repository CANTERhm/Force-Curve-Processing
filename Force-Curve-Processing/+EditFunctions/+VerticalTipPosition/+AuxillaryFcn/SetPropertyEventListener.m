function SetPropertyEventListener(varargin)
%SETPROPERTYEVENTLISTENER PropertyEventListener for results-object
%   Sets the property event listener neccessary to keep the graphical input
%   and output elemnts updated. This Listener objects listen to changes of
%   properties in the results-object of each editfunction.

    % handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'VerticalTipPosition');
    
    % if results_listener property has been removed 
    if ~isprop(results, 'property_event_listener')
        results.addproperty('property_event_listener');
        results.property_event_listener = PropListener();
    end

    % delete all listeners, if Baseline is not acitve
    editfunctions = handles.guiprops.Features.edit_buttons;
    VerticalTipPositionFcn = editfunctions.VerticalTipPosition;
    results.property_event_listener.addListener(VerticalTipPositionFcn.UserData.on_gui, 'Status', 'PostSet',...
        {@Callbacks.DeleteListenerCallback, VerticalTipPositionFcn}); 
    
    
    % settings xchannel popup
    results.property_event_listener.addListener(results, 'settings_xchannel_popup_value', 'PostSet',...
        @EditFunctions.VerticalTipPosition.Callbacks.ElementCallbacks.XChannelValueChanged); 
        
    % settings ychannel popup
    results.property_event_listener.addListener(results, 'settings_ychannel_popup_value', 'PostSet',...
        @EditFunctions.VerticalTipPosition.Callbacks.ElementCallbacks.YChannelValueChanged); 
        
    % settings springconstant checkbox
    results.property_event_listener.addListener(results, 'settings_springconstant_checkbox_value', 'PostSet',...
        @EditFunctions.VerticalTipPosition.Callbacks.ElementCallbacks.SpringConstantValueChanged); 
        
    % settings sensitivity checkbox
    results.property_event_listener.addListener(results, 'settings_sensitivity_checkbox_value', 'PostSet',...
        @EditFunctions.VerticalTipPosition.Callbacks.ElementCallbacks.SensitivityValueChanged); 
        
    % event listener to update handles.curveprops.curvename.Results.Baseline
    % This step is important, because it update the handles-struct; it is
    % kind of an output from Baseline
    results.property_event_listener.addListener(results, 'UpdateObject',...
    @EditFunctions.VerticalTipPosition.Callbacks.UpdateResultsToMain);
    
    % update handles and results-object
    setappdata(handles.figure1, 'VerticalTipPosition', results);
    guidata(handles.figure1, handles);

end % SetPropertyEventListener

