function BLUpdatePopupMenuCallback(src, evt)
% BLUPDATEPOPUPMENUCALLBACK keeping the baseline_..._dropdown strig up to
% date, based on the choice made for baseline_parts_dropdown

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    if isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    curve = handles.curveprops.(curvename).RawData;
    parts_dropdown = handles.curveprops.(curvename).Results.Baseline.gui_elements.setting_parts_dropdown;
    segments_dropdown = handles.curveprops.(curvename).Results.Baseline.gui_elements.setting_segments_dropdown;
    xchannel_dropdown = handles.curveprops.(curvename).Results.Baseline.gui_elements.setting_xchannel_dropdown;
    ychannel_dropdown = handles.curveprops.(curvename).Results.Baseline.gui_elements.setting_ychannel_dropdown;
    parts_index = handles.curveprops.(curvename).Results.Baseline.curve_part_index;
    
    %% update curve segments popup depending on curve part index
        % special_info = [] if EsyImport true or afm couldn't apply SearchQuery
    if ~isempty(special_info)
        segments = fieldnames(curve.RawData.SpecialInformation);
    else
        segments = [];
    end
    mask = false(length(segments), 1);

end

