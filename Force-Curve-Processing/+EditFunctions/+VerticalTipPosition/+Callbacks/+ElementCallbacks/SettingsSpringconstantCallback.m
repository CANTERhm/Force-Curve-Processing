function SettingsSpringconstantCallback(src, evt, obj_list)
    % handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'VerticalTipPosition');
    
    EditFunctions.Baseline.AuxillaryFcn.UserDefined.SwitchCheckboxes(src, obj_list);
    if src.Value == 1
        results.settings_springconstant_checkbox_value = 1;
        results.settings_sensitivity_checkbox_value = 0;
    else 
        results.settings_springconstant_checkbox_value = 0;
        results.settings_sensitivity_checkbox_value = 1;
    end
%     results.settings_springconstant_checkbox_value = src.Value;
    
    % write handles and results
    setappdata(handles.figure1, 'VerticalTipPosition', results);
    guidata(handles.figure1, handles);
    results.FireEvent('UpdateObject');
end % SettingsSpringconstantCallback

