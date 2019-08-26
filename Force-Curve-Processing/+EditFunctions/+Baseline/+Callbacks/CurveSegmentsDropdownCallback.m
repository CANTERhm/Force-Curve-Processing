function CurveSegmentsDropdownCallback(src, evt, parts_index, segments_index)
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
    curve_parts_index = handles.curveprops.(curvename).Results.Baseline.(parts_index);
    
    %% update the curve-parts-property
    if curve_parts_index >= 3
        seg_index = src.Value + 2;
    else
        seg_index = src.Value;
    end
    handles.curveprops.(curvename).Results.Baseline.(segments_index) = seg_index;
    
    %% update handles-struct
    guidata(handles.figure1, handles);
end

