function YChannelValueChanged(src, evt)

    % refresh results object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'VerticalTipPosition');
    
    % apply vertical tip position on data
    EditFunctions.VerticalTipPosition.AuxillaryFcn.UserDefined.ApplyVerticalTipPosition();

    % refresh graph
    UtilityFcn.RefreshGraph([], [],...
        results.settings_xchannel_popup_value,...
        results.settings_ychannel_popup_value,...
        'EditFunction', 'VerticalTipPosition',...
        'RefreshAll', true);

    % update results object
    setappdata(handles.figure1, 'VerticalTipPosition', results);
    guidata(handles.figure1, handles);
    results.FireEvent('UpdateObject');

end % YChannelValueChanged

