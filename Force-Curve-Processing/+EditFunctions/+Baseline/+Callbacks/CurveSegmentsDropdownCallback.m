function CurveSegmentsDropdownCallback(src, evt)
% CURVESEGMENTSDROPDOWNCALLBACK update the curve-segments-property of the
% results-object of the baseline-editfunction. 

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    curve_parts_index = handles.curveprops.(curvename).Results.Baseline.curve_parts_index;
    
    %% update the curve-parts-property
    if curve_parts_index >= 3
        segments_index = src.Value + 2;
    else
        segments_index = src.Value;
    end
    handles.curveprops.(curvename).Results.Baseline.curve_segments_index = segments_index;
    
    %% update handles-struct
    guidata(handles.figure1, handles);
end

