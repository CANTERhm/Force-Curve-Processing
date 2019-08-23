function UpdateGraph(src, evt)
% UPDATEGRAPH update the graph after calculated_data has been updated

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    
    xchannel_value = handles.guiprops.Features.curve_xchannel_popup.Value;
    ychannel_value = handles.guiprops.Features.curve_ychannel_popup.Value;
    
    %% updating
    UtilityFcn.RefreshGraph([], [],...
        'xchannel_idx', xchannel_value,...
        'ychannel_idx', ychannel_value,...
        'EditFunction', 'Baseline',...
        'RefreshAll', false);
    
    %% update handles-struct
    guidata(handles.figure1, handles);
end

