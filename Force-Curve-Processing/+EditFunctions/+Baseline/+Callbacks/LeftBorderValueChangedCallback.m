function LeftBorderValueChangedCallback(src, evt)
% LEFTBORDERVALUECHANGEDCALLBACK updates the selection border property of
% the results-object according to the left border edit field value

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    right_border = handles.curveprops.(curvename).Results.Baseline.gui_elements.setting_right_border;
    
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
    
    %% check the order of left and right border values
    if src.Value < right_border.Value
        small_value = src.Value;
        big_value = right_border.Value;
    else
        small_value = right_border.Value;
        big_value = src.Value;
    end
    src.Value = small_value;
    src.String = num2str(small_value);
    right_border.Value = big_value;
    right_border.String = num2str(big_value);
    
    %% update handles-struct
    handles.curveprops.(curvename).Results.Baseline.selection_borders(1) = small_value;
    handles.curveprops.(curvename).Results.Baseline.selection_borders(2) = big_value;
    guidata(handles.figure1, handles);
end

