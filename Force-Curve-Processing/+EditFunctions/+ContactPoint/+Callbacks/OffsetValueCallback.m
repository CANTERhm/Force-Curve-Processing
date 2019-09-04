function OffsetValueCallback(src, evt)
% OFFSETVALUECALLBACK executes if the value of offset_value has been
% changed in the EditFunction: ContactPoint

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    cp = handles.curveprops.(curvename).Results.ContactPoint;
    
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
    cp.offset = src.Value;
    
    %% update handles-struct
    handles.curveprops.(curvename).Results.ContactPoint = cp;
    guidata(handles.figure1, handles);
end

