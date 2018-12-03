function UpdateCorrectionTypeCallback(src, evt)
%UPDATECORRECTIONTYPECALLBACK update the correction_type property 

    % get latest references to handles and result
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    if ~isempty(main)
        handles = guidata(main);
        results = getappdata(handles.figure1, 'Baseline');
    else
        % abort, no open fcp-app
        return
    end
    
    xch_idx = results.input_elements.input_xchannel_popup.Value;
    ych_idx = results.input_elements.input_ychannel_popup.Value;
    part = results.input_elements.input_parts_popup.Value;
    segment = results.input_elements.input_segments_popup.Value;
    UtilityFcn.RefreshGraph([], [],...
        xch_idx,...
        ych_idx,...
        'EditFunction', 'Baseline',...
        'RefreshAll', true);
    EditFunctions.Baseline.AuxillaryFcn.UserDefined.MarkupData([], [],...
        xch_idx,...
        ych_idx,...
        part,...
        segment);
end % UpdateCorrectionTypeCallback

