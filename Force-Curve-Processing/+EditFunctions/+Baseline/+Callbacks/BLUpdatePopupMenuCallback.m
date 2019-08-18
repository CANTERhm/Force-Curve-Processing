function BLUpdatePopupMenuCallback(src, evt)
% BLUPDATEPOPUPMENUCALLBACK keeping the baseline_..._dropdown strig up to
% date, based on the choice made for baseline_parts_dropdown

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    curve = handles.curveprops.(curvename).RawData;
    parts_dropdown = handles.curveprops.(curvename).Results.Baseline.gui_elements.setting_parts_dropdown;
    segments_dropdown = handles.curveprops.(curvename).Results.Baseline.gui_elements.setting_segments_dropdown;
    xchannel_dropdown = handles.curveprops.(curvename).Results.Baseline.gui_elements.setting_xchannel_dropdown;
    ychannel_dropdown = handles.curveprops.(curvename).Results.Baseline.gui_elements.setting_ychannel_dropdown;
    part_index = handles.curveprops.(curvename).Results.Baseline.curve_parts_index;
    segment_index = handles.curveprops.(curvename).Results.Baseline.curve_segments_index;
    xchannel_index = handles.curveprops.(curvename).Results.Baseline.xchannel_index;
    ychannel_index = handles.curveprops.(curvename).Results.Baseline.ychannel_index;
    
    %% update curve segments popup depending on curve part index
        % special_info = [] if EsyImport true or afm couldn't apply SearchQuery
    if ~isempty(curve.SpecialInformation)
        segments = fieldnames(curve.SpecialInformation);
    else
        segments = [];
    end
    mask = false(length(segments), 1);
    
    switch part_index
        case 1
            curve_segments = cell(length(segments), 1);

            for i = 1:length(segments)
                curve_segments{i} = curve.SpecialInformation.(segments{i}).SegmentIdentifierName;
            end
            
            if ~isempty(curve_segments)
                parts_dropdown.String = {'All', 'Trace', 'Retrace'};
                curve_segments = ['All'; curve_segments];
                segments_dropdown.String = curve_segments;
            else
                parts_dropdown.String = 'All';
                segments_dropdown.String = 'All';
                note = 'no segments or segment-names has been found';
                HelperFcn.ShowNotification(note);
            end
        otherwise
            if part_index == 2
                start = handles.curveprops.CurvePartIndex.trace(1);
                stop = handles.curveprops.CurvePartIndex.trace(2);
            end
            if part_index == 3
                start = handles.curveprops.CurvePartIndex.retrace(1);
                stop = handles.curveprops.CurvePartIndex.retrace(2);
            end
            
            mask(start:stop) = true;
            segments = segments(mask);
            curve_segments = cell(length(segments), 1);

            for i = 1:length(segments)
                curve_segments{i} = curve.SpecialInformation.(segments{i}).SegmentIdentifierName;
            end
            curve_segments = ['All'; curve_segments];
            
            if ~isempty(curve_segments)
                parts_dropdown.String = {'All', 'Trace', 'Retrace'};
                segments_dropdown.String = curve_segments;
            else
                parts_dropdown.String = 'All';
                segments_dropdown.String = 'All';
                note = 'no segments or segment-names has been found';
                HelperFcn.ShowNotification(note);
            end
            
    end
   
    %% update handles-struct
    guidata(handles.figure1, handles);
end

