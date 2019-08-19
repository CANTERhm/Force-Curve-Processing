function CurveYchannelDropdownCallback(src, evt)
%CURVEYCHANNELDROPDOWNCALLBACK update the ychannel-property of the
% results-object stored in handles.curveprops.(curvename).Results.Baseline
%
% Note:
%   - 'evt' is not used

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    
    %% update results-object
    handles.curveprops.(curvename).Results.Baseline.ychannel_index = src.Value;
    
    %% update handles-struct
    guidata(handles.figure1, handles);
end

