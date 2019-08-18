function CurvePartsDropdownCallback(src, evt)
% CURVEPARTSDROPDOWNCALLBACK update the curvepart property in the
% results-object of the baseline-editfunction

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    
    %% update curveparts property
    handles.curveprops.(curvename).Results.Baseline.curve_parts_index = src.Value;
    
    %% update handles-struct
    guidata(handles.figure1, handles);

end

