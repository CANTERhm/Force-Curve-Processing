function UpdatePopupMenuCallback(src, evt, handles)
%UPDATECURVESEGMENTSPOPUPCALLBACK update the curve segments popupmenu based
% on the chosen value from the curve parts popupmenu
% connected: proplistener

curve_segments_popup = handles.guiprops.Features.curve_segments_popup;
curve_parts_popup = handles.guiprops.Features.curve_parts_popup;
xchannel_popup = handles.guiprops.Features.curve_xchannel_popup;
ychannel_popup = handles.guiprops.Features.curve_ychannel_popup;
table = handles.guiprops.Features.edit_curve_table;
table_userdata = get(table, 'UserData');
chosen_curvepart_idx = curve_parts_popup.Value;

if ~isempty(table_userdata)
    curvename = table_userdata.CurrentCurveName;
    curve = handles.curveprops.(curvename);
    special_info = curve.RawData.SpecialInformation;
    
    % special_info = [] if EsyImport true or afm couldn't apply SearchQuery
    if ~isempty(special_info)
        segments = fieldnames(curve.RawData.SpecialInformation);
    else
        segments = [];
    end
    mask = false(length(segments), 1);
    switch chosen_curvepart_idx
        case 1
            curve_segments = cell(length(segments), 1);

            for i = 1:length(segments)
                curve_segments{i} = curve.RawData.SpecialInformation.(segments{i}).SegmentIdentifierName;
            end
            if ~isempty(curve_segments)
                curve_parts_popup.String = {'All', 'Trace', 'Retrace'};
                curve_segments = ['All'; curve_segments];
                curve_segments_popup.String = curve_segments;
            else
                curve_parts_popup.String = 'All';
                curve_segments_popup.String = 'All';
%                 note = 'no segments or segment-names has been found';
%                 HelperFcn.ShowNotification(note);
            end
        otherwise
            if chosen_curvepart_idx == 2
                start = handles.curveprops.CurvePartIndex.trace(1);
                stop = handles.curveprops.CurvePartIndex.trace(2);
            end
            if chosen_curvepart_idx == 3
                start = handles.curveprops.CurvePartIndex.retrace(1);
                stop = handles.curveprops.CurvePartIndex.retrace(2);
            end
            for i = start:stop
                mask(i) = 1;
            end

            segments = segments(mask);
            curve_segments = cell(length(segments), 1);

            for i = 1:length(segments)
                curve_segments{i} = curve.RawData.SpecialInformation.(segments{i}).SegmentIdentifierName;
            end
            curve_segments = ['All'; curve_segments];
            
            if ~isempty(curve_segments)
                curve_parts_popup.String = {'All', 'Trace', 'Retrace'};
                curve_segments_popup.Value = 1;
                curve_segments_popup.String = curve_segments;
            else
                curve_parts_popup.String = 'All';
                curve_segments_popup.String = 'All';
                note = 'no segments or segment-names has been found';
                HelperFcn.ShowNotification(note);
            end
            
    end % switch
    
    % update xchannel- and ychannel-popup-menus
    if ~isempty(special_info)
        channels = fieldnames(curve.RawData.CurveData.Segment1);
        
        % xchannel
        xchannel_popup.String = channels;
        if xchannel_popup.UserData.HasDefaultValue == 0
            value = find(strcmp(channels, 'verticalTipPosition'));
            if ~isempty(value)
                xchannel_popup.Value = value;
                xchannel_popup.UserData.HasDefaultValue = 1;
            end
        end
        
        % ychannel
        ychannel_popup.String = channels;
        if ychannel_popup.UserData.HasDefaultValue == 0
            value = find(strcmp(channels, 'vDeflection'));
            if ~isempty(value)
                ychannel_popup.Value = value;
                ychannel_popup.UserData.HasDefaultValue = 1;
            end
        end

    else
        sz = size(curve.RawData.CurveData); 
        channels = cell(sz(2), 1);
        for i = 1:length(channels)
            channels{i} = ['channel ' num2str(i)];
        end
        xchannel_popup.String = channels;
        ychannel_popup.String = channels;
        curve_parts_popup.String = 'All';
    end
    
end % if
guidata(handles.figure1, handles);