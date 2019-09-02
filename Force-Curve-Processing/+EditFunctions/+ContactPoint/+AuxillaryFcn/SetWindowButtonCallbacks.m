function handles = SetWindowButtonCallbacks(handles)
% SETWINDOWBUTTONCALLBACKS set the window button callbacks properly in order
% to ensure correct behavior for the EditFunction: Baseline
    handles.guiprops.MainFigure.WindowButtonDownFcn = @WindowButtonDownCallback;
end

%% used Callbacks
function WindowButtonDownCallback(src, evt)
% WBDCB window button down callback

    % check wich mousebutton was pressed
    selection_type = src.SelectionType;
    
    if strcmp(selection_type, 'normal')
        go_on = true;
    elseif strcmp(selection_type, 'alt')
        go_on = false;
    elseif strcmp(selection_type, 'open')
        go_on = false;
    else
        return
    end
    
    if ~go_on
        return
    end 

    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    results = handles.curveprops.(curvename).Results.ContactPoint;

    cp = handles.guiprops.MainAxes.CurrentPoint;
    results.offset = cp(1, 1);

    % refresh results object and handles
    guidata(handles.figure1, handles);
    
end % WindowsButtonDownCallback