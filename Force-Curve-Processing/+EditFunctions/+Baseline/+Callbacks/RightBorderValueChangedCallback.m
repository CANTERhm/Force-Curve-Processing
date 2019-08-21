function RightBorderValueChangedCallback(src, evt, property)
%RIGHTBORDERVALUECHANGEDCALLBACK updates the selection border property of
% the results-object according to the right border edit field value

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    selection_borders = handles.curveprops.(curvename).Results.Baseline.(property);
    
    %% evaluate input
    input = src.String;
    old_num = src.Value;
    new_num = str2double(input);
    if ~isnan(new_num)
        src.Value = new_num;
    else
        src.String = num2str(old_num);
        return
    end
    selection_borders(2) = src.Value;
    
    %% update handles-struct
    handles.curveprops.(curvename).Results.Baseline.(property) = selection_borders;
    guidata(handles.figure1, handles);
end

