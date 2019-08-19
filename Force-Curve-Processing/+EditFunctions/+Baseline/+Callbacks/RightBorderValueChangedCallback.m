function RightBorderValueChangedCallback(src, evt)
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
    
    %% update handles-struct
    handles.curveprops.(curvename).Results.Baseline.selection_borders(2) = src.Value;
    guidata(handles.figure1, handles);
end

